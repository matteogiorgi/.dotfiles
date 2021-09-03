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
const vscode = require("vscode");
const extension_1 = require("./extension");
const path = require("path");
const docs = require("./CoqProject");
const psm = require("./prettify-symbols-mode");
const mustache = require("mustache");
const VIEW_PATH = 'html_views';
function proofViewFile(file = "") {
    return vscode.Uri.file(extension_1.extensionContext.asAbsolutePath(path.join('out', VIEW_PATH, file)));
}
function proofViewHtmlPath() {
    return proofViewFile('Coq.html');
}
/**
 * Displays a Markdown-HTML file which contains javascript to connect to this view
 * and update the goals and show other status info
 */
class HtmlCoqView {
    constructor(uri, context) {
        this.currentSettings = {};
        this.visible = false;
        this.panel = null;
        this.resizeEvent = new vscode.EventEmitter();
        context.subscriptions.push(vscode.workspace.onDidChangeConfiguration(() => this.updateSettings()));
        this.docUri = uri;
        psm.onEnabledChange((enabled) => {
            this.currentSettings.prettifySymbolsMode = enabled;
            this.sendMessage(Object.assign({ prettifySymbolsMode: enabled }, { command: 'settings-update' }));
        });
    }
    get resize() { return this.resizeEvent.event; }
    handleClientResize(event) {
        this.resizeEvent.fire(event.columns);
    }
    handleClientMessage(event) {
        const message = JSON.parse(event);
        switch (message.eventName) {
            case 'resize':
                this.handleClientResize(message.params);
                return;
            case 'focus':
                docs.getProject().setActiveDoc(this.docUri);
                return;
            case 'getInitialGoal':
                if (this.initialState)
                    this.update(this.initialState);
                return;
        }
    }
    createBuffer() {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                this.coqViewUri = vscode.Uri.parse(`file://${proofViewHtmlPath().path.replace(/%3A/, ':')}`);
                console.log("Goals: " + decodeURIComponent(this.coqViewUri.with({ scheme: 'file' }).toString()));
            }
            catch (err) {
                vscode.window.showErrorMessage(err.toString());
            }
        });
    }
    getUri() {
        return this.coqViewUri;
    }
    isVisible() {
        return this.visible;
    }
    initializePanel(pane) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.panel === null) {
                this.panel = vscode.window.createWebviewPanel('html_coq', "ProofView: " + path.basename(this.docUri.fsPath), {
                    preserveFocus: true,
                    viewColumn: pane,
                }, {
                    enableScripts: true,
                    localResourceRoots: [vscode.Uri.file(path.join(extension_1.extensionContext.extensionPath, 'out', VIEW_PATH))]
                });
                this.panel.onDidDispose(() => {
                    this.visible = false;
                    this.panel = null;
                });
                let doc = yield vscode.workspace.openTextDocument(this.coqViewUri);
                let csspath = path.join(extension_1.extensionContext.extensionPath, 'out', VIEW_PATH, 'proof-view.css');
                let csspasthAsVscodeResource = this.panel.webview.asWebviewUri(vscode.Uri.file(csspath));
                let jspath = path.join(extension_1.extensionContext.extensionPath, 'out', VIEW_PATH, 'goals.js');
                let jspathAsVscodeResource = this.panel.webview.asWebviewUri(vscode.Uri.file(jspath));
                this.panel.webview.html = mustache.render(doc.getText(), {
                    jsPath: jspathAsVscodeResource,
                    cssPath: csspasthAsVscodeResource
                });
                this.panel.webview.onDidReceiveMessage(message => this.handleClientMessage(message));
                yield this.updateSettings();
            }
        });
    }
    show(pane, state) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.coqViewUri)
                yield this.createBuffer();
            this.initialState = state;
            this.initializePanel(pane);
            this.visible = true;
        });
    }
    dispose() {
        if (this.panel !== null)
            this.panel.dispose();
    }
    sendMessage(message) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.panel !== null)
                this.panel.webview.postMessage(message);
        });
    }
    updateClient(state) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.sendMessage({ command: 'goal-update', goal: state });
        });
    }
    update(state) {
        this.updateClient(state);
    }
    updateSettings() {
        return __awaiter(this, void 0, void 0, function* () {
            this.currentSettings.fontFamily = vscode.workspace.getConfiguration("editor").get("fontFamily");
            this.currentSettings.fontSize = `${vscode.workspace.getConfiguration("editor").get("fontSize")}pt`;
            this.currentSettings.fontWeight = vscode.workspace.getConfiguration("editor").get("fontWeight");
            this.currentSettings.proofViewDiff = vscode.workspace.getConfiguration("coq").get("proofViewDiff");
            this.currentSettings.prettifySymbolsMode = psm.isEnabled();
            yield this.sendMessage(Object.assign(this.currentSettings, { command: 'settings-update' }));
        });
    }
}
exports.HtmlCoqView = HtmlCoqView;
//# sourceMappingURL=HtmlCoqView.js.map