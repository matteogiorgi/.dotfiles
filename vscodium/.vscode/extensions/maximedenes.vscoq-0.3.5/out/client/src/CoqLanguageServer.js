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
const path = require("path");
const vscode = require("vscode");
const proto = require("./protocol");
const vscode_1 = require("vscode");
const vscode_languageclient_1 = require("vscode-languageclient");
// function createServerProcess(serverModule: string, debugOptions: string[]): ServerOptions {
//   let nodejsPath = workspace.getConfiguration('nodejs')['path'] || '';
//   let nodejsCmd = path.join(nodejsPath, 'node');
//   // If the extension is launch in debug mode the debug server options are use
//   // Otherwise the run options are used
//   var args = debugOptions.concat([serverModule]);
//   return {
//     run: { command: nodejsCmd, args: [serverModule] },
//     debug: { command: nodejsCmd, args: debugOptions.concat([serverModule]) }
//   }
// }
function createServerLocalExtension(serverModule, debugOptions) {
    const options = {
        run: { module: serverModule, transport: vscode_languageclient_1.TransportKind.ipc },
        debug: { module: serverModule, transport: vscode_languageclient_1.TransportKind.ipc, options: { execArgv: debugOptions } }
    };
    return options;
}
class CoqLanguageServer {
    constructor(context) {
        this.subscriptions = [];
        this.cancelRequest = new vscode.CancellationTokenSource();
        this.documentCallbacks = new Map();
        // The server is implemented in node
        let serverModule = context.asAbsolutePath(path.join('out', 'server', 'src', 'server.js'));
        // The debug options for the server
        let debugOptions = ["--nolazy", "--inspect=6009"];
        // let serverOptions = createServerProcess(serverModule, debugOptions);
        let serverOptions = createServerLocalExtension(serverModule, debugOptions);
        // Options to control the language client
        let clientOptions = {
            // Register the server for Coq scripts
            documentSelector: ['coq'],
            synchronize: {
                // Synchronize the setting section 'languageServerExample' to the server
                configurationSection: ['coqtop', 'coq', 'prettifySymbolsMode'],
                // Notify the server about file changes to '.clientrc files contain in the workspace
                fileEvents: vscode_1.workspace.createFileSystemWatcher('**/.clientrc')
            }
        };
        // Create the language client and start the client.
        this.server = new vscode_languageclient_1.LanguageClient('Coq Language Server', serverOptions, clientOptions);
        this.server.onReady()
            .then(() => {
            this.server.onNotification(proto.UpdateHighlightsNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onUpdateHighlights.forEach(l => l(p));
                // this.onUpdateHighlightsHandlers.forEach((h) => h(p))
            });
            this.server.onNotification(proto.CoqMessageNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onMessage.forEach(l => l(p));
                // this.onMessageHandlers.forEach((h) => h(p))
            });
            this.server.onNotification(proto.CoqResetNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onReset.forEach(l => l(p));
                // this.onResetHandlers.forEach((h) => h(p))
            });
            this.server.onNotification(proto.CoqStmFocusNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onUpdateCoqStmFocus.forEach(l => l(p));
                // this.onUpdateCoqStmFocusHandlers.forEach((h) => h(p))
            });
            this.server.onNotification(proto.CoqLtacProfResultsNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onLtacProfResults.forEach(l => l(p.results));
                // this.onLtacProfResultsHandlers.forEach((h) => h(p))
            });
            this.server.onNotification(proto.CoqtopStartNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onCoqtopStart.forEach(l => l(p));
            });
            this.server.onNotification(proto.CoqtopStopNotification.type, (p) => {
                const doc = this.documentCallbacks.get(p.uri);
                if (doc)
                    doc.onCoqtopStop.forEach(l => l(p));
            });
            console.log("Coq language server ready");
        }, (reason) => console.log("Coq language server failed to load: " + reason.toString()));
        this.subscriptions.push(this.server.start());
    }
    static create(context) {
        if (!CoqLanguageServer.instance)
            CoqLanguageServer.instance = new CoqLanguageServer(context);
        return CoqLanguageServer.instance;
    }
    static getInstance() {
        return this.instance;
    }
    dispose() {
        this.server.stop();
        this.subscriptions.forEach((d) => d.dispose());
        this.cancelRequest.dispose();
        this.subscriptions = [];
        this.documentCallbacks.clear();
    }
    registerDocument(uri, doc) {
        if (this.documentCallbacks.has(uri))
            throw "Duplicate Coq document being registered.";
        this.documentCallbacks.set(uri, doc);
    }
    unregisterDocument(uri) {
        this.documentCallbacks.delete(uri);
    }
    // private onUpdateHighlightsHandlers = new Set<(params: proto.NotifyHighlightParams) => void>();
    // public onUpdateHighlights(listener: (params: proto.NotifyHighlightParams) => void) : vscode.Disposable {
    //   this.onUpdateHighlightsHandlers.add(listener);
    //   return { dispose: () => this.onUpdateHighlightsHandlers.delete(listener) }
    // }
    // private onMessageHandlers = new Set<(params: proto.NotifyMessageParams) => void>();
    // public onMessage(listener: (params: proto.NotifyMessageParams) => void) {
    //   this.onMessageHandlers.add(listener);
    //   return { dispose: () => this.onMessageHandlers.delete(listener) }
    // }
    // private onResetHandlers = new Set<(params: proto.NotificationParams) => void>();
    // public onReset(listener: (params: proto.NotificationParams) => void) {
    //   this.onResetHandlers.add(listener);
    //   return { dispose: () => this.onResetHandlers.delete(listener) }
    // }
    // private onUpdateCoqStmFocusHandlers = new Set<(params: proto.DocumentPositionParams) => void>();
    // public onUpdateCoqStmFocus(listener: (params: proto.DocumentPositionParams) => void) {
    //   this.onUpdateCoqStmFocusHandlers.add(listener);
    //   return { dispose: () => this.onUpdateCoqStmFocusHandlers.delete(listener) }
    // }
    // private onLtacProfResultsHandlers = new Set<(params: proto.NotifyLtacProfResultsParams) => void>();
    // public onLtacProfResults(listener: (params: proto.NotifyLtacProfResultsParams) => void) {
    //   this.onLtacProfResultsHandlers.add(listener);
    //   return { dispose: () => this.onLtacProfResultsHandlers.delete(listener) }
    // }
    interruptCoq(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            this.cancelRequest.dispose();
            this.cancelRequest = new vscode.CancellationTokenSource();
            yield this.server.sendRequest(proto.InterruptCoqRequest.type, { uri: uri }, this.cancelRequest.token);
        });
    }
    quitCoq(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return yield this.server.sendRequest(proto.QuitCoqRequest.type, { uri: uri });
        });
    }
    resetCoq(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return yield this.server.sendRequest(proto.ResetCoqRequest.type, { uri: uri });
        });
    }
    getGoal(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return yield this.server.sendRequest(proto.GoalRequest.type, { uri: uri }, this.cancelRequest.token);
        });
    }
    getCachedGoal(uri, pos, direction) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return yield this.server.sendRequest(proto.CachedGoalRequest.type, { uri: uri, position: pos, direction: direction }, this.cancelRequest.token);
        });
    }
    finishComputations(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return yield this.server.sendRequest(proto.FinishComputationsRequest.type, { uri: uri }, this.cancelRequest.token);
        });
    }
    stepForward(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.StepForwardRequest.type, { uri: uri }, this.cancelRequest.token);
        });
    }
    stepBackward(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.StepBackwardRequest.type, { uri: uri }, this.cancelRequest.token);
        });
    }
    interpretToPoint(uri, location, synchronous) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            const params = {
                uri: uri,
                location: location,
                synchronous: synchronous,
            };
            return this.server.sendRequest(proto.InterpretToPointRequest.type, params, this.cancelRequest.token);
        });
    }
    interpretToEnd(uri, synchronous) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.InterpretToEndRequest.type, { uri: uri, synchronous: synchronous }, this.cancelRequest.token);
        });
    }
    resizeView(uri, columns) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.ResizeWindowRequest.type, { uri: uri, columns: columns }, this.cancelRequest.token);
        });
    }
    ltacProfGetResults(uri, offset) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.LtacProfResultsRequest.type, { uri: uri, offset: offset }, this.cancelRequest.token);
        });
    }
    getPrefixText(uri, pos, token) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.GetSentencePrefixTextRequest.type, { uri: uri, position: pos }, token || this.cancelRequest.token);
        });
    }
    query(uri, query, term, routeId) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            const params = {
                uri: uri,
                queryFunction: query,
                query: term,
                routeId
            };
            return this.server.sendRequest(proto.QueryRequest.type, params, this.cancelRequest.token);
        });
    }
    setDisplayOptions(uri, options) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.onReady();
            return this.server.sendRequest(proto.SetDisplayOptionsRequest.type, {
                uri: uri,
                options: options
            }, this.cancelRequest.token);
        });
    }
}
exports.CoqLanguageServer = CoqLanguageServer;
function removeFromArray(arr, item) {
    const idx = arr.findIndex(x => x === item);
    if (idx >= 0)
        arr.splice(idx, 1);
}
function registerCallback(arr, listener) {
    arr.push(listener);
    return { dispose: () => removeFromArray(arr, listener) };
}
class CoqDocumentLanguageServer {
    constructor(uri) {
        this.uri = uri;
        this.server = CoqLanguageServer.getInstance();
        this.callbacks = {
            onUpdateHighlights: [],
            onMessage: [],
            onReset: [],
            onUpdateCoqStmFocus: [],
            onLtacProfResults: [],
            onCoqtopStart: [],
            onCoqtopStop: [],
        };
        this.server.registerDocument(this.uri, this.callbacks);
    }
    dispose() {
        this.callbacks = {
            onUpdateHighlights: [],
            onMessage: [],
            onReset: [],
            onUpdateCoqStmFocus: [],
            onLtacProfResults: [],
            onCoqtopStart: [],
            onCoqtopStop: [],
        };
        this.server.unregisterDocument(this.uri);
    }
    onUpdateHighlights(listener) {
        return registerCallback(this.callbacks.onUpdateHighlights, listener);
    }
    onMessage(listener) {
        return registerCallback(this.callbacks.onMessage, listener);
    }
    onReset(listener) {
        return registerCallback(this.callbacks.onReset, listener);
    }
    onUpdateCoqStmFocus(listener) {
        return registerCallback(this.callbacks.onUpdateCoqStmFocus, listener);
    }
    onLtacProfResults(listener) {
        return registerCallback(this.callbacks.onLtacProfResults, listener);
    }
    onCoqtopStart(listener) {
        return registerCallback(this.callbacks.onCoqtopStart, listener);
    }
    onCoqtopStop(listener) {
        return registerCallback(this.callbacks.onCoqtopStop, listener);
    }
    interruptCoq() {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.server.interruptCoq(this.uri);
        });
    }
    quitCoq() {
        return this.server.quitCoq(this.uri);
    }
    resetCoq() {
        return this.server.resetCoq(this.uri);
    }
    getGoal() {
        return this.server.getGoal(this.uri);
    }
    getCachedGoal(pos, direction) {
        return this.server.getCachedGoal(this.uri, pos, direction);
    }
    finishComputations() {
        return this.server.finishComputations(this.uri);
    }
    stepForward() {
        return this.server.stepForward(this.uri);
    }
    stepBackward() {
        return this.server.stepBackward(this.uri);
    }
    interpretToPoint(offset, synchronous) {
        return this.server.interpretToPoint(this.uri, offset, synchronous);
    }
    interpretToEnd(synchronous) {
        return this.server.interpretToEnd(this.uri, synchronous);
    }
    resizeView(columns) {
        return this.server.resizeView(this.uri, columns);
    }
    ltacProfGetResults(offset) {
        return this.server.ltacProfGetResults(this.uri, offset);
    }
    query(query, term, routeId) {
        return this.server.query(this.uri, query, term, routeId);
    }
    setDisplayOptions(options) {
        return this.server.setDisplayOptions(this.uri, options);
    }
}
exports.CoqDocumentLanguageServer = CoqDocumentLanguageServer;
//# sourceMappingURL=CoqLanguageServer.js.map