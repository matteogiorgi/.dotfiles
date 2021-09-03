"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_languageserver_1 = require("vscode-languageserver");
const coqProto = require("./../coqtop/coq-proto");
const parser = require("./../parsing/coq-parser");
const textUtil = require("./../util/text-util");
const diff = require("./DiffProofView");
var StateStatus;
(function (StateStatus) {
    StateStatus[StateStatus["Parsing"] = 0] = "Parsing";
    StateStatus[StateStatus["Processing"] = 1] = "Processing";
    StateStatus[StateStatus["Processed"] = 2] = "Processed";
    StateStatus[StateStatus["Error"] = 3] = "Error";
    StateStatus[StateStatus["Axiom"] = 4] = "Axiom";
    StateStatus[StateStatus["Incomplete"] = 5] = "Incomplete";
})(StateStatus = exports.StateStatus || (exports.StateStatus = {}));
var StateStatusFlags;
(function (StateStatusFlags) {
    StateStatusFlags[StateStatusFlags["Parsing"] = 0] = "Parsing";
    StateStatusFlags[StateStatusFlags["Processing"] = 1] = "Processing";
    StateStatusFlags[StateStatusFlags["Incomplete"] = 2] = "Incomplete";
    StateStatusFlags[StateStatusFlags["Unsafe"] = 4] = "Unsafe";
    StateStatusFlags[StateStatusFlags["Error"] = 8] = "Error";
    StateStatusFlags[StateStatusFlags["Warning"] = 16] = "Warning";
})(StateStatusFlags || (StateStatusFlags = {}));
class State {
    constructor(commandText, stateId, textRange, prev, next) {
        this.commandText = commandText;
        this.stateId = stateId;
        this.textRange = textRange;
        this.prev = prev;
        this.next = next;
        this.diagnostics = [];
        // set to true when a document change has invalidated the meaning of the associated sentence; this state needs to be cancelled
        this.markedInvalidated = false;
        this.goal = null;
        this.status = StateStatusFlags.Parsing;
    }
    static newRoot(stateId) {
        return new State("", stateId, vscode_languageserver_1.Range.create(0, 0, 0, 0), null, null);
    }
    static add(parent, command, stateId, range, computeStart) {
        // This implies a strict order of descendents by document position
        // To support comments that are not added as sentences,
        // this could be loosened to if(textUtil.isBefore(range.start,parent.textRange.end)).
        if (!textUtil.positionIsEqual(range.start, parent.textRange.end))
            throw "New sentence is expected to be adjacent to its parent";
        const result = new State(command, stateId, range, parent, parent.next);
        parent.next = result;
        return result;
    }
    toString() {
        return this.commandText;
    }
    getText() {
        return this.commandText;
    }
    getStateId() {
        return this.stateId;
    }
    /** Iterates all parent states */
    *ancestors() {
        let state = this.prev;
        while (state != null) {
            yield state;
            state = state.prev;
        }
    }
    /** Iterates all decendent states */
    *descendants() {
        let state = this.next;
        while (state != null) {
            yield state;
            state = state.next;
        }
    }
    /** Iterates all decendent states until, and not including, end */
    *descendantsUntil(end) {
        let state = this.next;
        while (state != null && state.stateId !== end && state !== end) {
            yield state;
            state = state.next;
        }
    }
    /** Iterates this and all ancestor states in the order they appear in the document */
    *backwards() {
        yield this;
        yield* this.ancestors();
    }
    /** Iterates this and all decentant states in the order they appear in the document */
    *forwards() {
        yield this;
        yield* this.descendants();
    }
    getParent() {
        return this.prev;
    }
    getNext() {
        return this.next;
    }
    truncate() {
        if (this.next)
            this.next.prev = null;
        this.next = null;
    }
    unlink() {
        if (this.prev)
            this.prev.next = this.next;
        if (this.next)
            this.next.prev = this.prev;
    }
    updateWorkerStatus(workerId, status) {
    }
    /** Handle sentence-status updates as they come from coqtop */
    updateStatus(status) {
        switch (status) {
            case coqProto.SentenceStatus.Parsing:
                this.status = StateStatusFlags.Parsing;
                break;
            case coqProto.SentenceStatus.AddedAxiom:
                this.status &= ~(StateStatusFlags.Processing | StateStatusFlags.Error);
                this.status |= StateStatusFlags.Unsafe;
                break;
            case coqProto.SentenceStatus.Processed:
                if (this.status & StateStatusFlags.Processing) {
                    this.status &= ~StateStatusFlags.Processing;
                }
                break;
            case coqProto.SentenceStatus.ProcessingInWorker:
                if (!(this.status & StateStatusFlags.Processing)) {
                    this.status |= StateStatusFlags.Processing;
                }
                break;
            case coqProto.SentenceStatus.Incomplete:
                this.status |= StateStatusFlags.Incomplete;
                break;
            case coqProto.SentenceStatus.Complete:
                this.status &= ~StateStatusFlags.Incomplete;
                break;
            case coqProto.SentenceStatus.InProgress:
                break;
        }
    }
    getRange() {
        return this.textRange;
    }
    hasGoal() {
        return this.goal !== null;
    }
    setGoal(goal) {
        this.goal = goal;
    }
    getGoal(goalsCache) {
        if (!this.goal)
            return null;
        const newGoals = Object.assign(Object.assign({}, goalsCache.getProofView(this.goal)), { focus: this.textRange.end });
        if (this.prev && this.prev.goal) {
            const oldGoals = goalsCache.getProofView(this.prev.goal);
            return diff.diffProofView(oldGoals, newGoals);
        }
        return newGoals;
    }
    translateDiagnostic(d, delta) {
        if (d.range) {
            d.range = textUtil.rangeDeltaTranslate(d.range, delta);
        }
    }
    /**
     * Applies the textual changes to the sentence
     * @return false if the change has invalidated the sentence; true if preserved
     */
    applyTextChanges(changes, deltas, updatedDocumentText) {
        if (this.isRoot())
            return true;
        let newText = this.commandText;
        let newRange = this.textRange;
        let touchesEnd = false; // indicates whether a change has touched the end of this sentence
        change: for (let idx = 0; idx < changes.length; ++idx) {
            const change = changes[idx];
            const delta = deltas[idx];
            switch (parser.sentenceRangeContainment(newRange, change.range)) {
                case parser.SentenceRangeContainment.Before:
                    newRange = textUtil.rangeDeltaTranslate(newRange, delta);
                    var translate = this.translateDiagnostic;
                    this.diagnostics.forEach(function (d) { translate(d, delta); });
                    continue change;
                case parser.SentenceRangeContainment.After:
                    if (textUtil.positionIsEqual(this.textRange.end, change.range.start))
                        touchesEnd = true;
                    continue change; // ignore this change
                case parser.SentenceRangeContainment.Crosses:
                    return false; // give up; this sentence is toast (invalidated; needs to be cancelled)
                case parser.SentenceRangeContainment.Contains:
                    // the change falls within this sentence
                    const beginOffset = textUtil.relativeOffsetAtAbsolutePosition(newText, newRange.start, change.range.start);
                    if (beginOffset == -1)
                        continue change;
                    newText =
                        newText.substring(0, beginOffset)
                            + change.text
                            + newText.substring(beginOffset + change.rangeLength);
                    // newRange = Range.create(newRange.start,textUtil.positionRangeDeltaTranslateEnd(newRange.end,delta));
                    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    newRange.end = textUtil.positionRangeDeltaTranslateEnd(newRange.end, delta);
                    var translate = this.translateDiagnostic;
                    this.diagnostics.forEach(function (d) { translate(d, delta); });
            } // switch
        } // change: for
        if (touchesEnd) {
            // We need to reparse the sentence to make sure the end of the sentence has not changed
            const endOffset = textUtil.offsetAt(updatedDocumentText, newRange.end);
            // The problem is if a non-blank [ \r\n] is now contacting the end-period of this sentence; we need only check one more character
            const newEnd = parser.parseSentenceLength(newText + updatedDocumentText.substr(endOffset, 1));
            if (newEnd === -1 || newEnd !== newText.length)
                return false; // invalidate: bad or changed syntax
        }
        if (parser.isPassiveDifference(this.commandText, newText)) {
            this.commandText = newText;
            this.textRange = newRange;
            return true;
        }
        else
            return false;
    }
    isRoot() {
        return this.prev === null;
    }
    markInvalid() {
        this.markedInvalidated = true;
    }
    isInvalidated() {
        return this.markedInvalidated;
    }
    /** Removes descendents until (and not including) state end */
    *removeDescendentsUntil(end) {
        for (let state of this.descendantsUntil(end.stateId))
            yield state;
        // unlink the traversed sentences
        this.next = end;
        end.prev = this;
    }
    getStatus() {
        if (this.status & StateStatusFlags.Error)
            return StateStatus.Error;
        else if (this.status & StateStatusFlags.Processing)
            return StateStatus.Processing;
        else if (this.status & StateStatusFlags.Unsafe)
            return StateStatus.Axiom;
        else if (this.status & StateStatusFlags.Incomplete)
            return StateStatus.Incomplete;
        else if (this.status & StateStatusFlags.Parsing)
            return StateStatus.Parsing;
        else
            return StateStatus.Processed;
    }
    /** @returns `true` if this sentence appears strictly before `position` */
    isBefore(position) {
        return textUtil.positionIsBeforeOrEqual(this.textRange.end, position);
    }
    /** @returns `true` if this sentence appears before or contains `position` */
    isBeforeOrAt(position) {
        return textUtil.positionIsBeforeOrEqual(this.textRange.end, position) || textUtil.positionIsBeforeOrEqual(this.textRange.start, position);
    }
    /** @returns `true` if this sentence appears strictly after `position`. */
    isAfter(position) {
        return textUtil.positionIsAfter(this.textRange.start, position);
    }
    /** @returns `true` if this sentence appears after or contains `position`. */
    isAfterOrAt(position) {
        return textUtil.positionIsAfterOrEqual(this.textRange.start, position) ||
            textUtil.positionIsAfter(this.textRange.end, position);
    }
    /** @returns `true` if this sentence contains `position`. */
    contains(position) {
        return textUtil.positionIsBeforeOrEqual(this.textRange.start, position) &&
            textUtil.positionIsAfter(this.textRange.end, position);
    }
    /** This sentence has reached an error state
     * @param location: optional offset range within the sentence where the error occurred
     */
    pushDiagnostic(message, severity, location) {
        var d = { message, severity };
        if (location && location.start !== location.stop) {
            if (severity == vscode_languageserver_1.DiagnosticSeverity.Error) {
                this.status |= StateStatusFlags.Error;
            }
            this.status &= ~StateStatusFlags.Processing;
            const sentRange = this.getRange();
            const sentText = this.getText();
            d.range =
                vscode_languageserver_1.Range.create(textUtil.positionAtRelativeCNL(sentRange.start, sentText, location.start), textUtil.positionAtRelativeCNL(sentRange.start, sentText, location.stop));
        }
        this.diagnostics.push(d);
        return d.range;
    }
    getDiagnostics() {
        const range = this.getRange();
        return this.diagnostics.map(function (d) { return Object.assign(d, { sentence: range }); });
    }
}
exports.State = State;
//# sourceMappingURL=State.js.map