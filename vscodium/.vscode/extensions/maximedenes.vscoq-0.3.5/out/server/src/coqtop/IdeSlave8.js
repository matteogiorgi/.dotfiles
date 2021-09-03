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
const util = require("util");
const coqXml = require("./xml-protocol/coq-xml");
const coqProto = require("./coq-proto");
const xmlTypes = require("./xml-protocol/CoqXmlProtocolTypes");
const deserialize_1 = require("./xml-protocol/deserialize");
const coqtop = require("./CoqTop");
const CoqTop_1 = require("./CoqTop");
const Timer_1 = require("../util/Timer");
const QUIT_MESSAGE_TIMEOUT_MS = 1000;
var IdeSlaveState;
(function (IdeSlaveState) {
    IdeSlaveState[IdeSlaveState["Disconnected"] = 0] = "Disconnected";
    IdeSlaveState[IdeSlaveState["Connected"] = 1] = "Connected";
    IdeSlaveState[IdeSlaveState["Error"] = 2] = "Error";
    IdeSlaveState[IdeSlaveState["Shutdown"] = 3] = "Shutdown";
})(IdeSlaveState = exports.IdeSlaveState || (exports.IdeSlaveState = {}));
class InternalError extends Error {
}
exports.InternalError = InternalError;
class IdeSlaveNotConnectedError extends Error {
    constructor() {
        super("IdeSlave is not connected to coqtop");
    }
}
class IdeSlave extends coqtop.IdeSlave {
    constructor(console) {
        super();
        this.parser = null;
        this.coqResultValueListener = null;
        this.state = IdeSlaveState.Disconnected;
        this.useInterruptMessage = false;
        this.console = console;
    }
    connect(version, mainR, mainW, controlR, controlW) {
        this.mainChannelR = mainR;
        this.mainChannelW = mainW;
        this.controlChannelW = controlW;
        this.state = IdeSlaveState.Connected;
        const deserializer = deserialize_1.createDeserializer(version);
        this.parser = new coqXml.XmlStream(this.mainChannelR, deserializer, {
            onFeedback: (feedback) => this.doOnFeedback(feedback),
            onMessage: (msg, routeId, stateId) => this.doOnMessage(msg, routeId, stateId),
            onOther: (tag, x) => this.doOnOther(tag, x),
            onError: (x) => this.doOnSerializationError(x)
        });
        this.parser.on('error', err => {
            if (this.coqResultValueListener)
                this.coqResultValueListener.onError(err);
        });
        this.parser.on('response: value', value => {
            if (this.coqResultValueListener)
                this.coqResultValueListener.onValue(value);
        });
        // this.mainChannelR.on('data', (data) => this.onMainChannelR(data));
        // this.controlChannelR.on('data', (data) => this.onControlChannelR(data));
        mainR.setEncoding('utf8');
        if (mainR == mainW) {
            this.setupChannel(mainR, "main channel", (data) => this.onMainChannelR(data));
        }
        else {
            this.setupChannel(mainR, "main channel (R)", (data) => this.onMainChannelR(data));
            this.setupChannel(mainR, "main channel (W)");
        }
        controlR.setEncoding('utf8');
        if (controlR === controlW) {
            this.setupChannel(controlR, "control channel", (data) => this.onControlChannelR(data));
        }
        else {
            this.setupChannel(controlR, "control channel (R)", (data) => this.onControlChannelR(data));
            this.setupChannel(controlR, "control channel (W)");
        }
    }
    setupChannel(channel, name, dataHandler) {
        if (dataHandler)
            channel.on('data', (data) => dataHandler(data));
        channel.on('error', (err) => this.onCoqTopError(err, name));
    }
    writeMain(message) {
        this.mainChannelW.write(message, 'utf8');
    }
    dispose() {
        this.callbacks = {};
        this.state = IdeSlaveState.Shutdown;
        // if (this.mainChannelR)
        //   this.mainChannelR.end();
        if (this.mainChannelW)
            this.mainChannelW.end();
        // if (this.controlChannelR)
        //   this.controlChannelR.end();
        if (this.controlChannelW)
            this.controlChannelW.end();
        this.mainChannelR = undefined;
        this.mainChannelW = undefined;
        this.controlChannelW = undefined;
    }
    isConnected() {
        return this.state === IdeSlaveState.Connected;
    }
    onCoqTopError(error, channelName) {
        try {
            const message = typeof error === "string" ? error : error.message;
            if (this.state !== IdeSlaveState.Connected)
                return;
            this.console.error(`Error on ${channelName}: ` + message);
            // if(this.callbacks.onClosed)
            //   this.callbacks.onClosed(true, message);
        }
        finally {
            this.dispose();
            this.state = IdeSlaveState.Error;
        }
    }
    onMainChannelR(data) {
    }
    onControlChannelR(data) {
        this.console.log('control-channelR: ' + data);
    }
    doOnFeedback(feedback) {
        if (this.callbacks.onFeedback)
            this.callbacks.onFeedback(feedback);
    }
    doOnMessage(msg, routeId, stateId) {
        if (this.callbacks.onMessage)
            this.callbacks.onMessage(msg, routeId, stateId);
    }
    doOnOther(tag, x) {
        // this.console.log("reponse: " + tag + ": " + util.inspect(x));
    }
    doOnSerializationError(x) { }
    validateValue(value, logIdent) {
        if (value.message === 'User interrupt.')
            throw new CoqTop_1.Interrupted(value.stateId);
        else {
            let error = new CoqTop_1.CallFailure(value.message, value.stateId);
            if (value.location)
                error.range = value.location;
            // this.console.log(`ERROR ${logIdent || ""}: ${value.stateId} --> ${value.error.message} ${value.error.range ? `@ ${value.error.range.start}-${value.error.range.stop}`: ""}`);
            throw error;
        }
    }
    /**
     * Note: this needs to be called before this.mainChannelW.write to ensure that the handler for 'response: value'
     * is installed on time
     */
    coqGetResultOnce(logIdent) {
        if (this.coqResultValueListener)
            new InternalError('Multiple handlers are being registered for the same response value from Coqtop.');
        return new Promise((resolve, reject) => {
            this.coqResultValueListener = {
                onValue: (value) => {
                    this.coqResultValueListener = null;
                    try {
                        if (value.status === 'good')
                            resolve(value);
                        else
                            this.validateValue(value, logIdent);
                    }
                    catch (error) {
                        reject(error);
                    }
                },
                onError: err => {
                    this.coqResultValueListener = null;
                    reject(new CoqTop_1.CommunicationError(err));
                }
            };
        });
    }
    /** @returns true if an interrupt message was sent via the xml protocol */
    coqInterrupt() {
        return __awaiter(this, void 0, void 0, function* () {
            return false;
        });
    }
    checkState() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isConnected())
                throw new IdeSlaveNotConnectedError();
        });
    }
    coqInit() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkState();
            const coqResult = this.coqGetResultOnce('Init');
            this.console.log('--------------------------------');
            this.console.log('Call Init()');
            this.writeMain('<call val="Init"><option val="none"/></call>');
            const value = coqProto.GetValue('Init', yield coqResult);
            const result = { stateId: value };
            this.console.log(`Init: () --> ${result.stateId}`);
            return result;
        });
    }
    coqQuit() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isConnected())
                return;
            try {
                const coqResult = this.coqGetResultOnce('Quit');
                this.console.log('--------------------------------');
                this.console.log('Call Quit()');
                this.writeMain('<call val="Quit"><unit/></call>');
                try {
                    yield Timer_1.timeout(coqResult, QUIT_MESSAGE_TIMEOUT_MS, "timeout");
                    this.console.log(`Quit: () --> ()`);
                }
                catch (err) {
                    if (err instanceof CoqTop_1.CommunicationError)
                        this.console.log('Communication error: ' + err.message);
                    else
                        this.console.log(`Forced Quit (timeout).`);
                }
            }
            catch (error) {
                this.console.log(`Forced Quit.`);
            }
            finally {
                this.dispose();
            }
        });
    }
    coqGoal() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkState();
            const coqResult = this.coqGetResultOnce('Goal');
            this.console.log('--------------------------------');
            this.console.log('Call Goal()');
            this.writeMain('<call val="Goal"><unit/></call>');
            const value = coqProto.GetValue('Goal', yield coqResult);
            if (value !== null) {
                const result = {
                    goals: value.goals,
                    backgroundGoals: value.backgroundGoals,
                    shelvedGoals: value.shelvedGoals,
                    abandonedGoals: value.abandonedGoals
                };
                // this.console.log(`Goal: () --> focused: ${result.goals.length}, unfocused: ${this.countBackgroundGoals(result.backgroundGoals)}, shelved: ${result.shelvedGoals.length}, abandoned: ${result.abandonedGoals.length}`);
                return Object.assign(result, { mode: 'proof' });
            }
            else {
                // this.console.log(`Goal: () --> No Proof`);
                return { mode: 'no-proof' };
            }
            // this.console.log(`Goal: -->`);
            // if (result.goals && result.goals.length > 0) {
            //   this.console.log("Current:");
            //   result.goals.forEach((g, i) => this.console.log(`    ${i + 1}:${g.id}= ${g.goal}`));
            // }
            // if (result.backgroundGoals) {
            //   this.console.log("Background: ...");
            //   // result.backgroundGoals.forEach((g, i) => this.console.log(`    ${i + 1}) ${util.inspect(g, false, null)}`));
            // }
            // if (result.shelvedGoals && result.shelvedGoals.length > 0) {
            //   this.console.log("Shelved:");
            //   result.shelvedGoals.forEach((g, i) => this.console.log(`    ${i + 1}) ${util.inspect(g, false, null)}`));
            // }
            // if (result.abandonedGoals && result.abandonedGoals.length > 0) {
            //   this.console.log("Abandoned:");
            //   result.abandonedGoals.forEach((g, i) => this.console.log(`    ${i + 1}) ${util.inspect(g, false, null)}`));
            // }
        });
    }
    getStatus(force) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkState();
            const coqResult = this.coqGetResultOnce('Status');
            // const verboseStr = verbose===true ? "true" : "false";
            this.console.log('--------------------------------');
            this.console.log(`Call Status(force: ${force})`);
            this.writeMain(`<call val="Status"><bool val="${force ? "true" : "false"}" /></call>`);
            return coqProto.GetValue('Status', yield coqResult);
        });
    }
    coqAddCommand(command, editId, stateId, verbose) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkState();
            const coqResult = this.coqGetResultOnce('Add');
            // const verboseStr = verbose===true ? "true" : "false";
            const verboseStr = verbose === false ? "false" : "true";
            this.console.log('--------------------------------');
            this.console.log(`Call Add("${command.trim().substr(0, 20) + (command.trim().length > 20 ? "..." : "")}", editId: ${editId}, stateId: ${stateId}, verbose: ${verboseStr})`);
            this.writeMain(`<call val="Add"><pair><pair><string>${coqXml.escapeXml(command)}</string><int>${editId}</int></pair><pair><state_id val="${stateId}"/><bool val="${verboseStr}"/></pair></pair></call>`);
            const value = coqProto.GetValue('Add', yield coqResult);
            let result = {
                stateId: value.assignedState,
                message: value.message,
                unfocusedStateId: value.nextFocusState,
            };
            if (result.stateId === undefined)
                this.console.log(`UNDEFINED Add: ` + util.inspect(value, false, undefined));
            this.console.log(`Add:  ${stateId} --> ${result.stateId} ${result.unfocusedStateId ? `(unfocus ${result.unfocusedStateId})` : ""} "${result.message || ""}"`);
            return result;
        });
    }
    coqEditAt(stateId) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkState();
            const coqResult = this.coqGetResultOnce('EditAt');
            this.console.log('--------------------------------');
            this.console.log(`Call EditAt(stateId: ${stateId})`);
            this.writeMain(`<call val="Edit_at"><state_id val="${stateId}"/></call>`);
            const value = coqProto.GetValue('Edit_at', yield coqResult);
            let result;
            if (value) {
                // Jumping inside another proof; create a new tip
                result = { enterFocus: {
                        stateId: value.focusedState,
                        qedStateId: value.focusedQedState,
                        oldStateIdTip: value.oldFocusedState,
                    } };
            }
            else {
                result = {};
            }
            this.console.log(`EditAt: ${stateId} --> ${result.enterFocus ? `{newTipId: ${result.enterFocus.stateId}, qedId: ${result.enterFocus.qedStateId}, oldId: ${result.enterFocus.oldStateIdTip}}` : "{}"}`);
            return result;
        });
    }
    coqLtacProfilingResults(stateId, routeId) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.checkState();
            stateId = stateId || 0;
            routeId = routeId || 0;
            const coqResult = this.coqGetResultOnce('Query');
            this.console.log('--------------------------------');
            this.console.log(`Call Query(query: "Show Ltac Profile.", stateId: ${stateId}, routeId: ${routeId})`);
            this.writeMain(`<call val="Query"><pair><route_id val="${routeId}"/><pair><string>Show Ltac Profile.</string><state_id val="${stateId}"/></pair></pair></call>`);
            coqProto.GetValue('Query', yield coqResult);
        });
    }
    coqResizeWindow(columns) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.isConnected())
                return;
            const coqResult = this.coqGetResultOnce('SetOptions');
            this.console.log('--------------------------------');
            this.console.log(`Call ResizeWindow(columns: ${columns})`);
            this.writeMain(`<call val="SetOptions"><list><pair><list><string>Printing</string><string>Width</string></list><option_value val="intvalue"><option val="some"><int>${columns}</int></option></option_value></pair></list></call>`);
            coqProto.GetValue('SetOptions', yield coqResult);
            this.console.log(`ResizeWindow: ${columns} --> ()`);
        });
    }
    coqQuery(query, stateId, routeId) {
        return __awaiter(this, void 0, void 0, function* () {
            this.checkState();
            routeId = routeId || 1;
            const coqResult = this.coqGetResultOnce('Query');
            this.console.log('--------------------------------');
            this.console.log(`Call Query(stateId: ${stateId}, ${routeId !== undefined ? "routeId: " + routeId + ", " : ""}query: ${query})`);
            this.writeMain(`<call val="Query"><pair><route_id val="${routeId}"/><pair><string>${coqXml.escapeXml(query)}</string><state_id val="${stateId}"/></pair></pair></call>`);
            coqProto.GetValue('Query', yield coqResult);
            this.console.log(`Query: ${stateId} --> ...`);
        });
    }
    coqGetOptions(options) {
        return __awaiter(this, void 0, void 0, function* () {
            this.checkState();
            const coqResult = this.coqGetResultOnce('GetOptions');
            // const coqMessageResult = this.coqGetMessageOnce();
            this.console.log('--------------------------------');
            this.console.log(`Call GetOptions()`);
            this.writeMain(`<call val="GetOptions"><unit/></call>`);
            coqProto.GetValue('GetOptions', yield coqResult);
            this.console.log(`GetOptions: () --> ...`);
        });
    }
    coqSetOptions(options) {
        return __awaiter(this, void 0, void 0, function* () {
            this.checkState();
            let xmlOptions = [];
            for (let optionKey in options) {
                const rawOptionsName = CoqOptionsMapping[optionKey];
                const rawOptionsValue = options[optionKey];
                if (rawOptionsValue !== undefined && typeof rawOptionsName === 'string') {
                    const optionName = rawOptionsName.split(' ');
                    xmlOptions.push(new xmlTypes.Pair(optionName, new xmlTypes.OptionValue(rawOptionsValue)));
                }
            }
            const coqResult = this.coqGetResultOnce('SetOptions');
            // const coqMessageResult = this.coqGetMessageOnce();
            this.console.log('--------------------------------');
            this.console.log(`Call SetOptions(...)`);
            // this.console.log(`Call SetOptions(${xmlTypes.encode(xmlOptions)})`);
            this.writeMain(`<call val="SetOptions">${xmlTypes.encode(xmlOptions)}</call>`);
            coqProto.GetValue('SetOptions', yield coqResult);
            this.console.log(`SetOptions: (...) --> ...`);
        });
    }
}
exports.IdeSlave = IdeSlave;
const CoqOptionsMapping = {
    asymmetricPatterns: "Asymmetric Patterns",
    atomicLoad: "Atomic Load",
    automaticCoercionsImport: "Automatic Coercions Import",
    automaticIntroduction: "Automatic Introduction",
    booleanEqualitySchemes: "Boolean Equality Schemes",
    bracketingLastIntroductionPattern: "Bracketing Last Introduction Pattern",
    bulletBehavior: "Bullet Behavior",
    subproofsCaseAnalysisSchemes: "Subproofs Case Analysis Schemes",
    compatNotations: "Compat Notations",
    congruenceDepth: "Congruence Depth",
    congruenceVerbose: "Congruence Verbose",
    contextualImplicit: "Contextual Implicit",
    debugAuto: "Debug Auto",
    debugEauto: "Debug Eauto",
    debugRAKAM: "Debug Rakam",
    debugTacticUnification: "Debug Tactic Unification",
    debugTrivial: "Debug Trivial",
    debugUnification: "Debug Unification",
    decidableEqualitySchemes: "Decidable Equality Schemes",
    defaultClearingUsedHypotheses: "Default Clearing Used Hypotheses",
    defaultGoalSelector: "Default Goal Selector",
    defaultProofMode: "Default Proof Mode",
    defaultProofUsing: "Default Proof Using",
    defaultTimeout: "Default Timeout",
    dependentPropositionsElimination: "Dependent Propositions Elimination",
    discriminateIntroduction: "Discriminate Introduction",
    dumpBytecode: "Dump Bytecode",
    eliminationSchemes: "Elimination Schemes",
    equalityScheme: "Equality Scheme",
    extractionAutoInline: "Extraction Auto Inline",
    extractionConservativeTypes: "Extraction Conservative Types",
    extractionFileComment: "Extraction File Comment",
    extractionFlag: "Extraction Flag",
    extractionKeepSingleton: "Extraction Keep Singleton",
    extractionOptimize: "Extraction Optimize",
    extractionSafeImplicits: "Extraction Safe Implicits",
    extractionTypeExpand: "Extraction Type Expand",
    firstorderDepth: "Firstorder Depth",
    hideObligations: "Hide Obligations",
    implicitArguments: "Implicit Arguments",
    infoAuto: "Info Auto",
    infoEauto: "Info Eauto",
    infoLevel: "Info Level",
    infoTrivial: "Info Trivial",
    injectionL2RPatternOrder: "Injection L2 Rpattern Order",
    injectionOnProofs: "Injection On Proofs",
    inlineLevel: "Inline Level",
    intuitionIffUnfolding: "Intuition Iff Unfolding",
    intuitionNegationUnfolding: "Intuition Negation Unfolding",
    kernelTermSharing: "Kernel Term Sharing",
    keyedUnification: "Keyed Unification",
    looseHintBehavior: "Loose Hint Behavior",
    maximalImplicitInsertion: "Maximal Implicit Insertion",
    nonrecursiveEliminationSchemes: "Nonrecursive Elimination Schemes",
    parsingExplicit: "Parsing Explicit",
    primitiveProjections: "Primitive Projections",
    printingAll: "Printing All",
    printingCoercions: "Printing Coercions",
    printingDepth: "Printing Depth",
    printingExistentialInstances: "Printing Existential Instances",
    printingImplicit: "Printing Implicit",
    printingImplicitDefensive: "Printing Implicit Defensive",
    printingMatching: "Printing Matching",
    printingNotations: "Printing Notations",
    printingPrimitiveProjectionCompatibility: "Printing Primitive Projection Compatibility",
    printingPrimitiveProjectionParameters: "Printing Primitive Projection Parameters",
    printingProjections: "Printing Projections",
    printingRecords: "Printing Records",
    printingSynth: "Printing Synth",
    printingUniverses: "Printing Universes",
    printingWidth: "Printing Width",
    printingWildcard: "Printing Wildcard",
    programMode: "Program Mode",
    proofUsingClearUnused: "Proof Using Clear Unused",
    recordEliminationSchemes: "Record Elimination Schemes",
    regularSubstTactic: "Regular Subst Tactic",
    reversiblePatternImplicit: "Reversible Pattern Implicit",
    rewritingSchemes: "Rewriting Schemes",
    shortModulePrinting: "Short Module Printing",
    shrinkObligations: "Shrink Obligations",
    simplIsCbn: "Simpl Is Cbn",
    standardPropositionEliminationNames: "Standard Proposition Elimination Names",
    strictImplicit: "Strict Implicit",
    strictProofs: "Strict Proofs",
    strictUniverseDeclaration: "Strict Universe Declaration",
    stronglyStrictImplicit: "Strongly Strict Implicit",
    suggestProofUsing: "Suggest Proof Using",
    tacticCompatContext: "Tactic Compat Context",
    tacticEvarsPatternUnification: "Tactic Evars Pattern Unification",
    transparentObligations: "Transparent Obligations",
    typeclassResolutionAfterApply: "Typeclass Resolution After Apply",
    typeclassResolutionForConversion: "Typeclass Resolution For Conversion",
    typeclassesDebug: "Typeclasses Debug",
    typeclassesDependencyOrder: "Typeclasses Dependency Order",
    typeclassesDepth: "Typeclasses Depth",
    typeclassesModuloEta: "Typeclasses Modulo Eta",
    typeclassesStrictResolution: "Typeclasses Strict Resolution",
    typeclassesUniqueInstances: "Typeclasses Unique Instances",
    typeclassesUniqueSolutions: "Typeclasses Unique Solutions",
    universalLemmaUnderConjunction: "Universal Lemma Under Conjunction",
    universeMinimizationToSet: "Universe Minimization To Set",
    universePolymorphism: "Universe Polymorphism",
    verboseCompatNotations: "Verbose Compat Notations",
};
//# sourceMappingURL=IdeSlave8.js.map