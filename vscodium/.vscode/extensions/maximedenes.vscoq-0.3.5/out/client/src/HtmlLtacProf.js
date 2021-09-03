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
const WebSocket = require("ws");
const http = require("http");
const extension_1 = require("./extension");
function coqViewToFileUri(uri) {
    return `file://${uri.path}?${uri.query}#${uri.fragment}`;
}
class IFrameDocumentProvider {
    constructor() {
        this.onDidChangeEmitter = new vscode.EventEmitter();
    }
    provideTextDocumentContent(uri) {
        return `<!DOCTYPE HTML><body style="margin:0px;padding:0px;width:100%;height:100vh;border:none;position:absolute;top:0px;left:0px;right:0px;bottom:0px">
<iframe src="${coqViewToFileUri(uri)}" seamless style="position:absolute;top:0px;left:0px;right:0px;bottom:0px;border:none;margin:0px;padding:0px;width:100%;height:100%" />
</body>`;
    }
    // function () {document.getElementById("box").style.backgroundColor='red'
    get onDidChange() {
        return this.onDidChangeEmitter.event;
    }
}
var coqViewProvider = null;
/**
 * Displays a Markdown-HTML file which contains javascript to connect to this view
 * and update the goals and show other status info
 */
class HtmlLtacProf {
    constructor(results) {
        this.results = results;
        if (coqViewProvider === null) {
            coqViewProvider = new IFrameDocumentProvider();
            this.docRegistration = vscode.workspace.registerTextDocumentContentProvider('coq-ltacprof', coqViewProvider);
        }
        const httpServer = this.httpServer = http.createServer();
        this.serverReady = new Promise((resolve, reject) => {
            httpServer.on('error', (err) => reject(err));
            httpServer.listen(0, 'localhost', undefined, () => {
                resolve();
            });
        });
        this.server = new WebSocket.Server({ server: httpServer });
        this.server.on('connection', (ws) => {
            ws.onmessage = (event) => this.handleClientMessage(event);
            ws.send(JSON.stringify(this.results));
        });
        this.createBuffer();
    }
    handleClientMessage(event) {
    }
    createBuffer() {
        this.bufferReady = new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
            try {
                yield this.serverReady;
                const serverAddress = this.httpServer.address();
                const templateFileName = vscode.Uri.file(extension_1.extensionContext.asAbsolutePath('html_views/ltacprof/LtacProf.html'));
                this.coqViewUri = vscode.Uri.parse(`coq-view://${templateFileName.path.replace(/%3A/, ':')}?host=${serverAddress.address}&port=${serverAddress.port}`);
                console.log("LtacProf: " + decodeURIComponent(this.coqViewUri.with({ scheme: 'file' }).toString()));
                resolve();
                // this.show(true);
            }
            catch (err) {
                vscode.window.showErrorMessage(err.toString());
                reject();
            }
        }));
    }
    update(results) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.bufferReady;
            this.results = results;
            yield Promise.all([...this.server.clients].map((c) => {
                if (c.readyState === c.OPEN)
                    return new Promise((resolve, reject) => c.send(JSON.stringify(this.results), (err) => resolve()));
                else
                    return Promise.resolve();
            }));
        });
    }
    show(preserveFocus) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.bufferReady;
            // const focusedDoc = vscode.window.activeTextEditor ? vscode.window.activeTextEditor.document : null;
            yield vscode.commands.executeCommand('vscode.previewHtml', this.coqViewUri, vscode.ViewColumn.Two, "LtacProf");
            // if(preserveFocus && focusedDoc)
            //   await vscode.window.showTextDocument(focusedDoc);
        });
    }
    dispose() {
        this.docRegistration.dispose();
    }
}
exports.HtmlLtacProf = HtmlLtacProf;
//# sourceMappingURL=HtmlLtacProf.js.map