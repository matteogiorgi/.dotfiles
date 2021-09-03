'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_languageserver_1 = require("vscode-languageserver");
const vscode = require("vscode-languageserver");
const coqProto = require("./../coqtop/coq-proto");
const util = require("util");
const proto = require("./../protocol");
const textUtil = require("./../util/text-util");
const coqtop = require("./../coqtop/CoqTop");
const coqParser = require("./../parsing/coq-parser");
const errorParsing = require("../parsing/error-parsing");
const State_1 = require("./State");
const Mutex_1 = require("./../util/Mutex");
const server = require("../server");
const text = require("../util/AnnotatedText");
const GoalsCache_1 = require("./GoalsCache");
var State_2 = require("./State");
exports.StateStatus = State_2.StateStatus;
const dummyCallbacks = {
    sentenceStatusUpdate() { },
    clearSentence() { },
    updateStmFocus() { },
    error() { },
    message() { },
    ltacProfResults() { },
    coqDied() { },
};
class InconsistentState {
    constructor(message) {
        this.message = message;
    }
}
class AddCommandFailure {
    constructor(message, range, sentence) {
        this.message = message;
        this.range = range;
        this.sentence = sentence;
    }
}
var STMStatus;
(function (STMStatus) {
    STMStatus[STMStatus["Ready"] = 0] = "Ready";
    STMStatus[STMStatus["Busy"] = 1] = "Busy";
    STMStatus[STMStatus["Interrupting"] = 2] = "Interrupting";
    STMStatus[STMStatus["Shutdown"] = 3] = "Shutdown";
})(STMStatus || (STMStatus = {}));
/**
 * Manages the parts of the proof script that have been interpreted and processed by coqtop
 *
 * Abstractions:
 * - addCommands(range: Range, commandText: string)
 *    ensures that the as much of commandText has been processed; cancels any previously overlapping sentences as needed
 *    returns the actual range that was accepted
 * - serialization: Coq commands may only run one at a time but are asynchronous. This STM ensures that each command is run one at a time, that edits are applied only when the prior commands are run
 * - interruption: queued may be interrupted; clears the queue of commands, interrupts coq, and applies the queued edits
 */
class CoqStateMachine {
    constructor(project, spawnCoqtop, callbacks) {
        this.project = project;
        this.spawnCoqtop = spawnCoqtop;
        this.callbacks = callbacks;
        this.version = 0;
        // lazy init
        this.root = null;
        // map id to sentence; lazy init
        this.sentences = new Map();
        // The sentence that coqtop considers "focused"; lazy init
        this.focusedSentence = null;
        // The sentence that is closest to the end of the document; lazy init
        this.lastSentence = null;
        // feedback may arrive before a sentence is assigned a stateId; buffer feedback messages for later
        this.bufferedFeedback = [];
        /** The error from the most recent Coq command (`null` if none) */
        this.currentError = null;
        this.status = STMStatus.Ready;
        /** The current state of coq options */
        this.currentCoqOptions = {
            printingCoercions: false,
            printingMatching: false,
            printingNotations: true,
            printingExistentialInstances: false,
            printingImplicit: false,
            printingAll: false,
            printingUniverses: false,
        };
        /** Prevent concurrent calls to coqtop */
        this.coqLock = new Mutex_1.Mutex();
        /** Sequentialize edits */
        this.editLock = new Mutex_1.Mutex();
        /** goals */
        this.goalsCache = new GoalsCache_1.GoalsCache();
        this.routeId = 1;
        this.startFreshCoqtop();
    }
    startFreshCoqtop() {
        this.coqtop = this.spawnCoqtop();
        this.coqtop.onFeedback((x1) => this.onFeedback(x1));
        this.coqtop.onMessage((x1, routeId, stateId) => this.onCoqMessage(x1, routeId, stateId));
        this.coqtop.onClosed((isError, message) => this.onCoqClosed(isError, message));
    }
    dispose() {
        if (this.status === STMStatus.Shutdown)
            return; // already disposed
        this.status = STMStatus.Shutdown;
        this.sentences = undefined;
        this.bufferedFeedback = undefined;
        // this.project = undefined;
        this.setFocusedSentence(undefined);
        this.callbacks = dummyCallbacks;
        if (this.coqtop)
            this.coqtop.dispose();
    }
    shutdown() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.isShutdown())
                return;
            this.status = STMStatus.Shutdown;
            yield this.acquireCoq(() => __awaiter(this, void 0, void 0, function* () { return yield this.coqtop.coqQuit(); }));
            this.dispose();
        });
    }
    get console() { return this.project.console; }
    /**
     *
    */
    interrupt() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isBusy() || this.isShutdown())
                return;
            else
                this.status = STMStatus.Interrupting;
            try {
                yield this.coqtop.coqInterrupt();
            }
            catch (err) {
                // this will fail on user interrupt
                this.console.error('Exception thrown while interrupting Coq: ' + err.toString());
            }
            finally {
                // The command being interrupted should update this.status
                // If not, then it is probably best to kill coqtop via this.shutdown()
                // this.status = STMStatus.Ready
            }
        });
    }
    isRunning() {
        return this.status !== STMStatus.Shutdown && this.root !== null;
    }
    /**
     * @returns the document position that Coqtop considers "focused"; use this to update the cursor position or
     * to determine which commands to add when stepping through a script.
     */
    getFocusedPosition() {
        if (!this.focusedSentence)
            return vscode_languageserver_1.Position.create(0, 0);
        return this.focusedSentence.getRange().end;
    }
    getStatesText() {
        if (!this.isRunning())
            return "";
        const texts = [];
        for (let sent of this.root.descendants())
            texts.push(sent.getText());
        return texts.join('');
    }
    /**
     * Applies the changes to the sentences
     * @return a list of invalidated sentences -- these need to be cancelled
     */
    applyChangesToSentences(sortedChanges, updatedDocumentText) {
        const invalidatedSentences = [];
        try {
            const deltas = sortedChanges.map((c) => textUtil.toRangeDelta(c.range, c.text));
            if (this.currentError && this.currentError.range) {
                for (let idx = 0; idx < sortedChanges.length; ++idx) {
                    this.currentError.range = textUtil.rangeDeltaTranslate(this.currentError.range, deltas[idx]);
                }
            }
            for (let sent of this.lastSentence.backwards()) {
                // // optimization: remove any changes that will no longer overlap with the ancestor sentences
                // while (sortedChanges.length > 0 && textUtil.positionIsAfterOrEqual(sortedChanges[0].range.start, sent.getRange().end)) {
                //   // this change comes after this sentence and all of its ancestors, so get rid of it
                //   sortedChanges.shift();
                // }
                // // If there are no more changes, then we are done adjusting sentences
                // if (sortedChanges.length == 0)
                //   break sent; // sent
                // apply the changes
                const preserved = sent.applyTextChanges(sortedChanges, deltas, updatedDocumentText);
                if (!preserved) {
                    invalidatedSentences.push(sent);
                }
            } // for sent in ancestors of last sentence
            return invalidatedSentences;
        }
        catch (err) {
            this.handleInconsistentState(err);
            return [];
        }
    }
    /** Cancel a list of sentences that have (presumably) been invalidated.
     * This will attempt to place the focus just before the topmost cancellation.
     * @param invalidatedSentences -- assumed to be sorted in descending order (bottom first)
     */
    cancelInvalidatedSentences(invalidatedSentences) {
        return __awaiter(this, void 0, void 0, function* () {
            // Unlink and delete the invalidated sentences before any async operations
            for (let sent of invalidatedSentences) {
                sent.unlink();
                this.deleteSentence(sent);
            }
            if (invalidatedSentences.length <= 0)
                return;
            // Cancel the invalidated sentences
            const releaseLock = yield this.editLock.lock();
            try {
                if (this.status === STMStatus.Busy)
                    yield this.interrupt();
                // now, this.status === STMStatus.Interrupting until the busy task is cancelled, then it will become STMStatus.Ready
                // Cancel sentences in the *forward* direction
                // // E.g. cancelling the first invalidated sentence may cancel all subsequent sentences,
                // // in which case, the remaining cancellations will become NOOPs
                // for(let idx = invalidatedSentences.length - 1; idx >= 0; --idx) {
                //   const sent = invalidatedSentences[idx];
                for (let sent of invalidatedSentences) {
                    yield this.cancelSentence(sent);
                }
                // The focus should be at the topmost cancelled sentences
                this.focusSentence(invalidatedSentences[invalidatedSentences.length - 1].getParent());
            }
            catch (err) {
                this.handleInconsistentState(err);
            }
            finally {
                releaseLock();
            }
        });
    }
    /** Adjust sentence ranges and cancel any sentences that are invalidated by the edit
     * @param sortedChanges -- a list of changes, sorted by their start position in descending order: later change in doc appears first
     * @returns `true` if no sentences were cancelled
    */
    applyChanges(sortedChanges, newVersion, updatedDocumentText) {
        if (!this.isRunning() || sortedChanges.length == 0)
            return true;
        const invalidatedSentences = this.applyChangesToSentences(sortedChanges, updatedDocumentText);
        try {
            if (invalidatedSentences.length === 0) {
                this.callbacks.updateStmFocus(this.getFocusedPosition());
                return true;
            }
            else {
                // We do not bother to await this async function
                this.cancelInvalidatedSentences(invalidatedSentences);
                return false;
            }
        }
        finally {
            this.version = newVersion;
        }
    }
    /** @returns the version of the document that the STM recognizes */
    getDocumentVersion() {
        return this.version;
    }
    /**
     * Adds the next command
     * @param verbose - generate feedback messages with more info
     * @throw proto.FailValue if advancing failed
     */
    stepForward(commandSequence, verbose = false) {
        return __awaiter(this, void 0, void 0, function* () {
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return;
            try {
                yield this.validateState(true);
                const currentFocus = this.getFocusedPosition();
                // Advance one statement: the one that starts at the current focus
                yield this.iterateAdvanceFocus({ iterateCondition: (command) => textUtil.positionIsEqual(command.range.start, currentFocus),
                    commandSequence: commandSequence,
                    verbose: verbose
                });
                return null;
            }
            catch (error) {
                if (error instanceof AddCommandFailure)
                    return Object.assign(Object.assign({}, error), { type: 'failure', focus: this.getFocusedPosition() });
                else if (error instanceof coqtop.CoqtopSpawnError)
                    return { type: "not-running", reason: "spawn-failed", coqtop: error.binPath };
                else
                    throw error;
            }
            finally {
                endCommand();
            }
        });
    }
    /**
     * Steps back from the currently focused sentence
     * @param verbose - generate feedback messages with more info
     * @throws proto.FailValue if advancing failed
     */
    stepBackward() {
        return __awaiter(this, void 0, void 0, function* () {
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return null;
            try {
                yield this.validateState(false);
                if (this.focusedSentence !== this.root)
                    yield this.cancelSentence(this.focusedSentence);
                return null;
            }
            catch (error) {
                if (error instanceof coqtop.CoqtopSpawnError)
                    return { type: "not-running", reason: "spawn-failed", coqtop: error.binPath };
                else
                    throw error;
            }
            finally {
                endCommand();
            }
        });
    }
    convertCoqTopError(err) {
        if (err instanceof coqtop.Interrupted)
            return { type: 'interrupted', range: this.sentences.get(err.stateId).getRange() };
        else if (err instanceof coqtop.CoqtopSpawnError)
            return { type: 'not-running', reason: "spawn-failed", coqtop: err.binPath };
        // else if(err instanceof coqtop.CallFailure) {
        //   const sent = this.sentences.get(err.stateId);
        //   const start = textUtil.positionAtRelative(sent.getRange().start,sent.getText(),err.range.start);
        //   const end = textUtil.positionAtRelative(sent.getRange().start,sent.getText(),err.range.stop);
        //   const range = Range.create(start,end); // err.range
        //   return Object.assign<proto.FailureTag,proto.FailValue>({type: 'failure'}, <proto.FailValue>{message: err.message, range: range, sentence: this.sentences.get(err.stateId).getRange()})
        else
            throw err;
    }
    /**
     * Return the goal for the currently focused state
     * @throws FailValue
     */
    getGoal() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isCoqReady())
                return { type: 'not-running', reason: "not-started" };
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return { type: 'busy' };
            try {
                yield this.refreshOptions();
                const result = yield this.coqtop.coqGoal();
                return this.convertGoals(result);
            }
            catch (error) {
                if (error instanceof coqtop.CallFailure) {
                    const sent = this.focusedSentence;
                    const failure = yield this.handleCallFailure(error, { range: sent.getRange(), text: sent.getText() });
                    return Object.assign(failure, { type: 'failure' });
                }
                else
                    return this.convertCoqTopError(error);
            }
            finally {
                endCommand();
            }
        });
    }
    /**
     * Return the cached goal for the given position
     * @throws FailValue
     */
    getCachedGoal(pos, direction) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const state = (direction === "subsequent" ? this.getStateAt(pos) : null) || this.getPrecedingStateAt(pos);
                if (state && state.hasGoal())
                    return Object.assign({ type: 'proof-view' }, state.getGoal(this.goalsCache));
                else
                    return { type: "no-proof" };
            }
            catch (error) {
                return { type: "no-proof" };
            }
        });
    }
    getPrecedingStateAt(pos) {
        let preceding = this.root;
        for (let s of this.sentences.values()) {
            if (textUtil.positionIsBeforeOrEqual(s.getRange().end, pos) && textUtil.positionIsAfter(s.getRange().start, preceding.getRange().start))
                preceding = s;
            if (s.contains(pos))
                return s.getParent();
        }
        return preceding;
    }
    getStateAt(pos) {
        for (let s of this.sentences.values()) {
            if (s.contains(pos))
                return s;
        }
        return null;
    }
    getStatus(force) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isCoqReady())
                return { type: 'not-running', reason: "not-started" };
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return null;
            try {
            }
            finally {
                endCommand();
            }
            return null;
        });
    }
    finishComputations() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.getStatus(true);
        });
    }
    /** Interpret to point
     * Tell Coq to process the proof script up to the given point
     * This may not fully process everything, or it may rewind the state.
     * @throws proto.FailValue if advancing failed
     */
    interpretToPoint(position, commandSequence, interpretToEndOfSentence, synchronous, token) {
        return __awaiter(this, void 0, void 0, function* () {
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return;
            try {
                yield this.validateState(true);
                // Advance the focus until we reach or exceed the location
                yield this.iterateAdvanceFocus({ iterateCondition: (command) => {
                        return ((!interpretToEndOfSentence && textUtil.positionIsAfterOrEqual(position, command.range.end))
                            || (interpretToEndOfSentence && textUtil.positionIsAfter(position, command.range.start))) &&
                            (!token || !token.isCancellationRequested);
                    },
                    commandSequence: commandSequence,
                    end: interpretToEndOfSentence ? undefined : position,
                    verbose: true,
                    synchronous: synchronous
                });
                if (token && token.isCancellationRequested)
                    throw "operation interrupted";
                if (!interpretToEndOfSentence && textUtil.positionIsBefore(position, this.getFocusedPosition())) {
                    // We exceeded the desired position
                    yield this.focusSentence(this.getParentSentence(position));
                }
                else if (interpretToEndOfSentence && textUtil.positionIsBeforeOrEqual(position, this.focusedSentence.getRange().start)) {
                    yield this.focusSentence(this.getParentSentence(position).getNext());
                }
                return null;
            }
            catch (error) {
                if (error instanceof AddCommandFailure) {
                    return Object.assign(Object.assign({}, error), { type: 'failure', focus: this.getFocusedPosition() });
                }
                else if (error instanceof coqtop.CoqtopSpawnError)
                    return { type: "not-running", reason: "spawn-failed", coqtop: error.binPath };
                else
                    throw error;
            }
            finally {
                endCommand();
            }
        });
    }
    doQuery(query, routeId, position) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isCoqReady())
                return;
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return;
            try {
                let state = undefined;
                state = position ? this.getParentSentence(position).getStateId() : this.focusedSentence.getStateId();
                yield this.refreshOptions();
                yield this.coqtop.coqQuery(query, state, routeId);
                return;
            }
            finally {
                endCommand();
            }
        });
    }
    setWrappingWidth(columns) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isCoqReady())
                return;
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return;
            try {
                this.coqtop.coqResizeWindow(columns);
            }
            catch (error) {
                this.console.warn("error resizing window: " + error.toString());
            }
            finally {
                endCommand();
            }
        });
    }
    requestLtacProfResults(position) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isCoqReady())
                return;
            const endCommand = yield this.startCommand();
            if (!endCommand)
                return;
            try {
                if (position !== undefined) {
                    const sent = this.getSentence(position);
                    if (sent) {
                        yield this.coqtop.coqLtacProfilingResults(sent.getStateId(), this.routeId++);
                        return;
                    }
                }
                else
                    yield this.coqtop.coqLtacProfilingResults(undefined, this.routeId++);
            }
            finally {
                endCommand();
            }
        });
    }
    //     ltacProfResults: (offset?: number) => this.enqueueCoqOperation(async () => {
    //       if(offset) {
    //         const sent = this.sentences.findAtTextPosition(offset);
    //         return this.coqTop.coqLtacProfilingResults(sent===null ? undefined : sent.stateId);
    //       } else
    //         return this.coqTop.coqLtacProfilingResults();
    //     }, true),
    setDisplayOptions(options) {
        return __awaiter(this, void 0, void 0, function* () {
            function set(old, change) {
                switch (change) {
                    case proto.SetDisplayOption.On: return true;
                    case proto.SetDisplayOption.Off: return false;
                    case proto.SetDisplayOption.Toggle: return !old;
                }
            }
            for (let option of options) {
                switch (option.item) {
                    case proto.DisplayOption.AllLowLevelContents: {
                        // for toggle: on-->off iff all are on; off->on iff any are off
                        const value = set(this.currentCoqOptions.printingAll && this.currentCoqOptions.printingExistentialInstances && this.currentCoqOptions.printingUniverses, option.value);
                        this.currentCoqOptions.printingAll = value;
                        this.currentCoqOptions.printingExistentialInstances = value;
                        this.currentCoqOptions.printingUniverses = value;
                        break;
                    }
                    case proto.DisplayOption.AllBasicLowLevelContents:
                        this.currentCoqOptions.printingAll = set(this.currentCoqOptions.printingAll, option.value);
                        break;
                    case proto.DisplayOption.Coercions:
                        this.currentCoqOptions.printingCoercions = set(this.currentCoqOptions.printingCoercions, option.value);
                        break;
                    case proto.DisplayOption.ExistentialVariableInstances:
                        this.currentCoqOptions.printingExistentialInstances = set(this.currentCoqOptions.printingExistentialInstances, option.value);
                        break;
                    case proto.DisplayOption.ImplicitArguments:
                        this.currentCoqOptions.printingImplicit = set(this.currentCoqOptions.printingImplicit, option.value);
                        break;
                    case proto.DisplayOption.Notations:
                        this.currentCoqOptions.printingNotations = set(this.currentCoqOptions.printingNotations, option.value);
                        break;
                    case proto.DisplayOption.RawMatchingExpressions:
                        this.currentCoqOptions.printingMatching = set(this.currentCoqOptions.printingMatching, option.value);
                        break;
                    case proto.DisplayOption.UniverseLevels:
                        this.currentCoqOptions.printingUniverses = set(this.currentCoqOptions.printingUniverses, option.value);
                        break;
                }
            }
            //await this.setCoqOptions(this.currentCoqOptions);
        });
    }
    *getSentences() {
        if (!this.isRunning())
            return;
        for (let sent of this.root.descendants())
            yield { range: sent.getRange(), status: sent.getStatus() };
    }
    *getSentenceDiagnostics() {
        if (!this.isRunning())
            return;
        for (let sent of this.root.descendants()) {
            yield* sent.getDiagnostics();
        }
    }
    *getDiagnostics() {
        if (!this.isRunning())
            return;
        yield* this.getSentenceDiagnostics();
        if (this.currentError !== null)
            yield Object.assign(this.currentError, { severity: vscode_languageserver_1.DiagnosticSeverity.Error });
    }
    getParentSentence(position) {
        for (let sentence of this.root.descendants()) {
            if (!sentence.isBefore(position))
                return sentence.getParent();
        }
        // This should never be reached
        return this.root;
    }
    getSentence(position) {
        for (let sentence of this.root.descendants()) {
            if (sentence.contains(position))
                return sentence;
        }
        // This should never be reached
        return this.root;
    }
    initialize(rootStateId) {
        if (this.root != null)
            throw "STM is already initialized.";
        if (this.isShutdown())
            throw "Cannot reinitialize the STM once it has died; create a new one.";
        this.root = State_1.State.newRoot(rootStateId);
        this.sentences.set(this.root.getStateId(), this.root);
        this.lastSentence = this.root;
        this.setFocusedSentence(this.root);
    }
    /** Assert that we are in a "running"" state
     * @param initialize - initialize Coq if true and Coq has not yet been initialized
     * @returns true if it is safe to communicate with coq
    */
    isCoqReady() {
        return this.isRunning() && this.coqtop.isRunning();
    }
    /** Assert that we are in a "running"" state
     * @param initialize - initialize Coq if true and Coq has not yet been initialized
     * @returns true if it is safe to communicate with coq
    */
    validateState(initialize) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.isShutdown() && initialize)
                throw "Cannot perform operation: coq STM manager has been shut down.";
            else if (this.isShutdown())
                return false;
            else if (this.isCoqReady())
                return true;
            else if (initialize) {
                if (!this.coqtop)
                    this.startFreshCoqtop();
                let value = yield this.coqtop.startCoq();
                this.initialize(value.stateId);
                return true;
            }
            else
                return false;
        });
    }
    /** Continues to add next next command until the callback returns false.
     * Commands are always added from the current focus, which may advance seuqentially or jump around the Coq script document
     *
     * @param params.end: optionally specify and end position to speed up command parsing (for params.commandSequence)
     * */
    iterateAdvanceFocus(params) {
        return __awaiter(this, void 0, void 0, function* () {
            if (params.synchronous === undefined)
                params.synchronous = false;
            // true if the focus has not jumped elsewhere in the document
            let contiguousFocus = true;
            // Start advancing sentences
            let commandIterator = params.commandSequence(this.getFocusedPosition(), params.end)[Symbol.iterator]();
            for (let nextCommand = commandIterator.next(); !nextCommand.done;) {
                const command = nextCommand.value;
                // Do we satisfy the initial condition?
                if (!params.iterateCondition(command, contiguousFocus))
                    return;
                // let the command-parsing iterator that we want the next value *NOW*,
                // before we await the command to be added.
                // This is useful for the caller to provide highlighting feedback to the user
                // while we wait for the command to be parsed by Coq
                nextCommand = commandIterator.next();
                const result = yield this.addCommand(command, params.verbose);
                contiguousFocus = !result.unfocused;
                if (params.synchronous)
                    yield this.coqtop.coqGoal();
                // If we have jumped to a new position, create a new iterator since the next command will not be adjacent
                if (result.unfocused)
                    commandIterator = params.commandSequence(this.getFocusedPosition(), params.end)[Symbol.iterator]();
            } // for
        });
    }
    /**
     * Adds a command; assumes that it is adjacent to the current focus
    */
    addCommand(command, verbose) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                this.currentError = null;
                const startTime = process.hrtime();
                const parent = this.focusedSentence;
                if (!textUtil.positionIsEqual(parent.getRange().end, command.range.start))
                    this.throwInconsistentState("Can only add a comand to the current focus");
                const value = yield this.coqtop.coqAddCommand(command.text, this.version, parent.getStateId(), verbose);
                const newSentence = State_1.State.add(parent, command.text, value.stateId, command.range, startTime);
                this.sentences.set(newSentence.getStateId(), newSentence);
                // some feedback messages may have arrived before we get here
                this.applyBufferedFeedback();
                newSentence.updateStatus(coqProto.SentenceStatus.ProcessingInWorker);
                if (textUtil.positionIsAfterOrEqual(newSentence.getRange().start, this.lastSentence.getRange().end))
                    this.lastSentence = newSentence;
                if (value.unfocusedStateId) {
                    this.setFocusedSentence(this.sentences.get(value.unfocusedStateId));
                    // create a new iterator since the next command will not be adjacent
                }
                else {
                    this.setFocusedSentence(newSentence);
                }
                const result = { sentence: newSentence,
                    unfocused: value.unfocusedStateId == undefined ? false : true
                };
                return result;
            }
            catch (error) {
                if (typeof error === 'string')
                    throw new InconsistentState(error);
                else if (error instanceof coqtop.CallFailure) {
                    const failure = yield this.handleCallFailure(error, { range: command.range, text: command.text });
                    throw new AddCommandFailure(failure.message, failure.range, failure.range);
                }
                else
                    throw error;
            } // try
        });
    }
    /**
     * Converts a CallFailure from coqtop (where ranges are w.r.t. the start of the command/sentence) to a FailValue (where ranges are w.r.t. the start of the Coq script).
     */
    handleCallFailure(error, command) {
        return __awaiter(this, void 0, void 0, function* () {
            let errorRange = undefined;
            if (error.range)
                errorRange = vscode.Range.create(textUtil.positionAtRelativeCNL(command.range.start, command.text, error.range.start), textUtil.positionAtRelativeCNL(command.range.start, command.text, error.range.stop));
            const diffError = errorParsing.parseError(error.message);
            const prettyError = server.project.getPrettifySymbols().prettify(diffError);
            const message = text.normalizeText(prettyError);
            this.currentError = { message: message, range: errorRange, sentence: command.range };
            // Some errors tell us the new state to assume
            if (error.stateId !== undefined && error.stateId != 0)
                yield this.gotoErrorFallbackState(error.stateId);
            return this.currentError;
        });
    }
    parseConvertGoal(goal) {
        return {
            id: goal.id,
            goal: server.project.getPrettifySymbols().prettify(goal.goal),
            hypotheses: goal.hypotheses.map((hyp) => {
                let h = text.textSplit(hyp, /(:=|:)([^]*)/, 2);
                const result = { identifier: text.textToString(h.splits[0]).trim(),
                    relation: text.textToString(h.splits[1]),
                    expression: text.normalizeText(server.project.getPrettifySymbols().prettify(h.rest)) };
                return result;
            })
        };
    }
    convertUnfocusedGoals(focusStack) {
        if (focusStack)
            return {
                before: focusStack.before.map(this.parseConvertGoal),
                next: this.convertUnfocusedGoals(focusStack.next),
                after: focusStack.after.map(this.parseConvertGoal)
            };
        else
            return null;
    }
    convertGoals(goals) {
        switch (goals.mode) {
            case 'no-proof':
                return { type: 'no-proof' };
            case 'proof':
                const pv = this.goalsCache.cacheProofView({
                    goals: goals.goals.map(this.parseConvertGoal),
                    backgroundGoals: this.convertUnfocusedGoals(goals.backgroundGoals),
                    shelvedGoals: (goals.shelvedGoals || []).map(this.parseConvertGoal),
                    abandonedGoals: (goals.abandonedGoals || []).map(this.parseConvertGoal),
                    focus: this.getFocusedPosition()
                });
                this.focusedSentence.setGoal(pv);
                return Object.assign({ type: 'proof-view' }, this.focusedSentence.getGoal(this.goalsCache));
            default:
                this.console.warn("Goal returned an unexpected value: " + util.inspect(goals, false, undefined));
        }
    }
    gotoErrorFallbackState(stateId) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const beforeErrorSentence = this.sentences.get(stateId);
                yield this.coqtop.coqEditAt(stateId);
                this.rewindTo(beforeErrorSentence);
            }
            catch (err) {
                this.handleInconsistentState(err);
            }
        });
    }
    handleInconsistentState(error) {
        this.callbacks.coqDied(proto.CoqtopStopReason.InternalError, "Inconsistent state: " + error.toString());
        this.dispose();
    }
    throwInconsistentState(error) {
        this.callbacks.coqDied(proto.CoqtopStopReason.InternalError, "Inconsistent state: " + error.toString());
        this.dispose();
        throw new InconsistentState(error);
    }
    /**
     * Focuses the sentence; a new sentence may be appended to it.
     * @param sentence -- does nothing if null, already the focus, or its state ID does not exist
     */
    focusSentence(sentence) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!sentence || sentence == this.focusedSentence || !this.sentences.has(sentence.getStateId()))
                return;
            try {
                const result = yield this.coqtop.coqEditAt(sentence.getStateId());
                if (result.enterFocus) {
                    // Jumping inside an existing proof
                    // cancels a range of sentences instead of rewinding everything to this point
                    const endStateId = result.enterFocus.qedStateId;
                    this.rewindRange(sentence, this.sentences.get(endStateId));
                }
                else {
                    // Rewind the entire document to this point
                    this.rewindTo(sentence);
                }
                this.setFocusedSentence(sentence);
            }
            catch (err) {
                const error = err;
                if (error.stateId)
                    yield this.gotoErrorFallbackState(error.stateId);
            }
        });
    }
    cancelSentence(sentence) {
        return __awaiter(this, void 0, void 0, function* () {
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            // if(!this.sentences.has(sentence.getStateId()))
            //   return;
            yield this.focusSentence(sentence.getParent());
        });
    }
    deleteSentence(sent) {
        this.callbacks.clearSentence(sent.getRange());
        this.sentences.delete(sent.getStateId());
    }
    /** Removes sentences from range (start,end), exclusive; assumes coqtop has already cancelled the sentences  */
    rewindRange(start, end) {
        for (let sent of start.removeDescendentsUntil(end))
            this.deleteSentence(sent);
    }
    /** Rewind the entire document to this sentence, range (newLast, ..]; assumes coqtop has already cancelled the sentences  */
    rewindTo(newLast) {
        for (let sent of newLast.descendants())
            this.deleteSentence(sent);
        newLast.truncate();
        this.lastSentence = newLast;
        this.setFocusedSentence(newLast);
    }
    /** Apply buffered feedback to existing sentences, then clear the buffer */
    applyBufferedFeedback() {
        // Process any feedback that we may have seen out of order
        this.bufferedFeedback
            .forEach((feedback) => {
            const sent = this.sentences.get(feedback.stateId);
            if (!sent) {
                this.console.warn("Received buffered feedback for unknown stateId: " + feedback.stateId);
                return;
            }
            if (feedback.type === "status") {
                sent.updateStatus(feedback.status);
                this.callbacks.sentenceStatusUpdate(sent.getRange(), sent.getStatus());
            }
            else if (feedback.type === "fileLoaded") {
                // if(sent.getText().includes(feedback.module))
                //   sent.addSemantics(new LoadModule(feedback.filename, feedback.module));
            }
        });
        this.bufferedFeedback = [];
    }
    setFocusedSentence(sent) {
        if (sent === this.focusedSentence)
            return;
        this.focusedSentence = sent;
        this.callbacks.updateStmFocus(this.getFocusedPosition());
    }
    onCoqMessage(msg, routeId, stateId) {
        const prettyMessage = text.normalizeText(server.project.getPrettifySymbols().prettify(errorParsing.parseError(msg.message)));
        if (msg.level === coqProto.MessageLevel.Error && stateId !== undefined) {
            const sent = this.sentences.get(stateId);
            if (sent) {
                var range = sent.pushDiagnostic(prettyMessage, vscode_languageserver_1.DiagnosticSeverity.Error, msg.location);
                this.callbacks.error(sent.getRange(), range, prettyMessage);
            }
            else {
                this.console.warn(`Error for unknown stateId: ${stateId}; message: ${msg.message}`);
            }
        }
        else if (msg.level === coqProto.MessageLevel.Warning && stateId !== undefined) {
            const sent = this.sentences.get(stateId);
            if (sent) {
                var range = sent.pushDiagnostic(prettyMessage, vscode_languageserver_1.DiagnosticSeverity.Warning, msg.location);
            }
            else {
                this.console.warn(`Warning for unknown stateId: ${stateId}; message: ${msg.message}`);
            }
        }
        else
            this.callbacks.message(msg.level, prettyMessage, routeId);
    }
    onFeedback(feedback) {
        const hasStateId = feedback.objectId.objectKind === 'stateid';
        const stateId = coqProto.hasStateId(feedback.objectId) ? feedback.objectId.stateId : undefined;
        if (!hasStateId) {
            this.console.log("Edit feedback: " + util.inspect(feedback));
        }
        if (feedback.feedbackKind === "ltacprof" && hasStateId) {
            const sent = this.sentences.get(stateId);
            if (sent) {
                this.callbacks.ltacProfResults(sent.getRange(), feedback);
            }
            else {
                this.console.warn(`LtacProf results for unknown stateId: ${stateId}`);
            }
        }
        else if (feedback.feedbackKind === "worker-status" && hasStateId) {
            const sent = this.sentences.get(stateId);
            if (sent)
                sent.updateWorkerStatus(feedback.id, feedback.ident);
        }
        else if (feedback.feedbackKind === "message") {
            // this.console.log("Message feedback: " + util.inspect(feedback));
            this.onCoqMessage(feedback, feedback.route, stateId /* can be undefined */);
        }
        else if (feedback.feedbackKind === "sentence-status" && hasStateId) {
            const sent = this.sentences.get(stateId);
            if (sent) {
                sent.updateStatus(feedback.status);
                this.callbacks.sentenceStatusUpdate(sent.getRange(), sent.getStatus());
            }
            else {
                // Sometimes, feedback will be received before CoqTop has given us the new stateId,
                // So we will buffer these messages until we get the next 'value' response.
                this.bufferedFeedback.push({ stateId: stateId, type: "status", status: feedback.status, worker: feedback.worker });
            }
        }
    }
    /** recieved from coqtop controller */
    onCoqClosed(isError, message) {
        return __awaiter(this, void 0, void 0, function* () {
            this.callbacks.coqDied(isError ? proto.CoqtopStopReason.Anomaly : proto.CoqtopStopReason.UserRequest, message);
            this.console.log(`onCoqClosed(${message})`);
            if (!this.isRunning())
                return;
            this.dispose();
        });
    }
    startCommand() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.isBusy())
                return false;
            if (this.coqLock.isLocked())
                this.console.warn("STM is 'not busy' but lock is still held");
            const release = yield this.coqLock.lock();
            this.status = STMStatus.Busy;
            return () => {
                this.status = STMStatus.Ready;
                release();
                // if()
                //   this.assertSentenceConsistency();
            };
        });
    }
    isBusy() {
        return this.status === STMStatus.Busy || this.status === STMStatus.Interrupting || this.editLock.isLocked();
    }
    isShutdown() {
        return this.status === STMStatus.Shutdown;
    }
    flushEdits() {
        return __awaiter(this, void 0, void 0, function* () {
            // Wait until we can acquire the lock and there is no one else immediately waiting for the lock after us
            while (this.editLock.isLocked()) {
                const releaseLock = yield this.editLock.lock();
                releaseLock();
            }
        });
    }
    acquireCoq(callback) {
        return __awaiter(this, void 0, void 0, function* () {
            const release = yield this.coqLock.lock();
            try {
                return callback();
            }
            finally {
                release();
            }
        });
    }
    debuggingGetSentences(params) {
        let begin, end;
        if (params && params.begin === 'focus')
            begin = this.focusedSentence;
        if (!params || !params.begin || typeof params.begin === 'string')
            begin = this.root;
        else
            begin = params.begin;
        if (params && params.end === 'focus')
            end = this.focusedSentence;
        else if (!params || !params.end || typeof params.end === 'string')
            end = this.lastSentence;
        else
            end = params.end;
        const results = [];
        for (let sent of begin.descendantsUntil(end.getNext())) {
            results.push(createDebuggingSentence(sent));
        }
        Object.defineProperty(this, '__proto__', { enumerable: false });
        return results;
    }
    refreshOptions() {
        return __awaiter(this, void 0, void 0, function* () {
            let options = {};
            options.printingWidth = this.currentCoqOptions.printingWidth;
            options.printingCoercions = this.currentCoqOptions.printingCoercions;
            options.printingMatching = this.currentCoqOptions.printingMatching;
            options.printingNotations = this.currentCoqOptions.printingNotations;
            options.printingExistentialInstances = this.currentCoqOptions.printingExistentialInstances;
            options.printingImplicit = this.currentCoqOptions.printingImplicit;
            options.printingAll = this.currentCoqOptions.printingAll;
            options.printingUniverses = this.currentCoqOptions.printingUniverses;
            yield this.coqtop.coqSetOptions(options);
        });
    }
    /** Check for sentences that
     * - overlap
     * - exist but are unreachable
     * - exist but are invalidated
     * - are out of order (position in text does not agree with linking order)
     * @returns true if everything is seems okay
    */
    assertSentenceConsistency() {
        var success = true;
        const error = (message) => {
            this.console.warn(message);
            success = false;
        };
        if (this.isBusy())
            return;
        let prev = this.root;
        const stateIds = [prev.getStateId()];
        while (prev.getNext()) {
            const st = prev.getNext();
            const range = st.getRange();
            if (textUtil.positionIsBefore(range.start, prev.getRange().end))
                error(`States are out of order: id=${prev.getStateId()} and id=${st.getStateId()}`);
            if (range.start === range.end && st !== this.root)
                error(`Empty state sentence: id=${st.getStateId()}`);
            if (st.isInvalidated())
                error(`State is invalidated but not deleted: id=${st.getStateId()}`);
            if (!this.sentences.has(st.getStateId()))
                error(`State is reachable but not mapped: id=${st.getStateId()}`);
            else if (this.sentences.get(st.getStateId()) !== st)
                error(`State does not map to itself: id=${st.getStateId()}`);
            stateIds.push(st.getStateId());
            prev = st;
        }
        const ids = new Set(stateIds);
        if (ids.size !== stateIds.length)
            error('Reachable states have duplicate IDs');
        for (let id of this.sentences.keys()) {
            if (!ids.has(id))
                error(`State is mapped but unreachable: id=${id}`);
        }
        return success;
    }
    logDebuggingSentences(ds) {
        if (!ds)
            ds = this.debuggingGetSentences();
        this.console.log(ds.map((s, idx) => '  ' + (1 + idx) + ':\t' + s).join('\n'));
    }
}
exports.CoqStateMachine = CoqStateMachine;
// function createDebuggingSentence(sent: Sentence) : {cmd: string, range: string} {
//   const cmd = sent.getText();
//   const range = `${sent.getRange().start.line}:${sent.getRange().start.character}-${sent.getRange().end.line}:${sent.getRange().end.character}`;
//   function DSentence() {
//     this.cmd = cmd;
//     this.range = range;
//     Object.defineProperty(this,'__proto__',{enumerable: false});
//   }
// //  Object.defineProperty(DSentence, "name", { value: cmd });
//   Object.defineProperty(DSentence, "name", { value: "A" });
//   return new DSentence();
// }
function abbrString(s) {
    var s2 = coqParser.normalizeText(s);
    if (s2.length > 80)
        return s2.substr(0, 80 - 3) + '...';
    else
        return s2;
}
function createDebuggingSentence(sent) {
    return `${sent.getRange().start.line}:${sent.getRange().start.character}-${sent.getRange().end.line}:${sent.getRange().end.character} -- ${abbrString(sent.getText().trim())}`;
}
//# sourceMappingURL=STM.js.map