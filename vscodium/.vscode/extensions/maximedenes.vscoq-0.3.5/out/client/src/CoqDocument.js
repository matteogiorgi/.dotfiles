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
const fs = require("fs");
const path = require("path");
const os = require("os");
const Decorations_1 = require("./Decorations");
const Highlights_1 = require("./Highlights");
// import {CoqView, SimpleCoqView} from './SimpleCoqView';
// import {MDCoqView} from './MDCoqView';
const HtmlCoqView_1 = require("./HtmlCoqView");
const HtmlLtacProf_1 = require("./HtmlLtacProf");
const proto = require("./protocol");
const textUtil = require("./text-util");
const extension_1 = require("./extension");
const CoqLanguageServer_1 = require("./CoqLanguageServer");
const CoqView_1 = require("./CoqView");
const StatusBar_1 = require("./StatusBar");
const psm = require("./prettify-symbols-mode");
var DisplayOptionPicks;
(function (DisplayOptionPicks) {
    DisplayOptionPicks.ImplicitArguments = { label: "Implicit Arguments", description: "toggle display of *implicit arguments*", detail: "some detail", displayItem: proto.DisplayOption.ImplicitArguments };
    DisplayOptionPicks.Coercions = { label: "Coercions", description: "toggle display of *coercions*", displayItem: proto.DisplayOption.Coercions };
    DisplayOptionPicks.RawMatchingExpressions = { label: "Raw Matching Expressions", description: "toggle display of *raw matching expressions*", displayItem: proto.DisplayOption.RawMatchingExpressions };
    DisplayOptionPicks.Notations = { label: "Notations", description: "toggle display of notations", displayItem: proto.DisplayOption.Notations };
    DisplayOptionPicks.AllBasicLowLevelContents = { label: "All Basic Low Level Contents", description: "toggle display of ", displayItem: proto.DisplayOption.AllBasicLowLevelContents };
    DisplayOptionPicks.ExistentialVariableInstances = { label: "Existential Variable Instances", description: "toggle display of ", displayItem: proto.DisplayOption.ExistentialVariableInstances };
    DisplayOptionPicks.UniverseLevels = { label: "Universe Levels", description: "toggle display of ", displayItem: proto.DisplayOption.UniverseLevels };
    DisplayOptionPicks.AllLowLevelContents = { label: "All Low Level Contents", description: "toggle display of ", displayItem: proto.DisplayOption.AllLowLevelContents };
    DisplayOptionPicks.allPicks = [DisplayOptionPicks.ImplicitArguments, DisplayOptionPicks.Coercions, DisplayOptionPicks.RawMatchingExpressions, DisplayOptionPicks.Notations, DisplayOptionPicks.AllBasicLowLevelContents, DisplayOptionPicks.ExistentialVariableInstances, DisplayOptionPicks.UniverseLevels, DisplayOptionPicks.AllLowLevelContents];
})(DisplayOptionPicks || (DisplayOptionPicks = {}));
class CoqDocument {
    //private coqtopRunning = false;
    constructor(document, project) {
        /** A list of things to dispose */
        this.queryRouteId = 2;
        this.subscriptions = [];
        this.highlights = new Highlights_1.Highlights();
        /** Tracks which editors of this document have not had cursors positions changed since the last call to `rememberCursors()`. When stepping forward, the cursor is advanced for all editors whose cursors have not moved since the previous step. */
        this.cursorUnmovedSinceCommandInitiated = new Set();
        this.currentLtacProfView = null;
        this.statusBar = new StatusBar_1.StatusBar();
        this.document = document;
        this.project = project;
        // this.document = vscode.workspace.textDocuments.find((doc) => doc.uri === uri);
        this.documentUri = document.uri.toString();
        try {
            this.langServer = new CoqLanguageServer_1.CoqDocumentLanguageServer(document.uri.toString());
        }
        catch (err) {
            var x = this.langServer;
            x = x;
        }
        this.view = new HtmlCoqView_1.HtmlCoqView(document.uri, extension_1.extensionContext);
        // this.view = new SimpleCoqView(uri.toString());
        // this.view = new MDCoqView(uri);
        if (this.project.settings.showProofViewOn === "open-script") {
            let viewCol = this.currentViewColumn();
            if (viewCol)
                this.view.show(CoqView_1.adjacentPane(viewCol));
            else
                this.view.show(vscode.ViewColumn.One);
        }
        ;
        this.langServer.onUpdateHighlights((p) => this.onDidUpdateHighlights(p));
        this.langServer.onMessage((p) => this.onCoqMessage(p));
        this.langServer.onReset((p) => this.onCoqReset());
        this.langServer.onUpdateCoqStmFocus((p) => this.updateFocus(p.position));
        this.langServer.onLtacProfResults((p) => this.onLtacProfResults(p));
        this.langServer.onCoqtopStart(p => {
            //this.coqtopRunning = true;
            this.statusBar.setCoqtopStatus(true);
        });
        this.langServer.onCoqtopStop(p => {
            //this.coqtopRunning = false;
            if (p.reason === proto.CoqtopStopReason.Anomaly || p.reason === proto.CoqtopStopReason.InternalError)
                vscode.window.showErrorMessage(p.message || "Coqtop quit for an unknown reason.");
            this.statusBar.setCoqtopStatus(false);
        });
        this.view.resize((columns) => __awaiter(this, void 0, void 0, function* () {
            try {
                yield this.langServer.resizeView(Math.floor(columns));
                yield this.refreshGoal();
            }
            catch (err) { }
        }));
        this.subscriptions.push(vscode.window.onDidChangeTextEditorSelection((e) => {
            if (this.project.settings.autoRevealProofStateAtCursor && e.textEditor.document === this.document && e.selections.length === 1)
                this.viewGoalAt(e.textEditor, e.selections[0].active);
            if (this.cursorUnmovedSinceCommandInitiated.has(e.textEditor))
                this.cursorUnmovedSinceCommandInitiated.delete(e.textEditor);
        }));
        if (vscode.window.activeTextEditor)
            if (vscode.window.activeTextEditor.document.uri.toString() == this.documentUri)
                this.statusBar.focus();
        this.statusBar.setStateReady();
    }
    refreshGoal(e) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!e)
                e = vscode.window.activeTextEditor;
            const value = yield this.langServer.getGoal();
            this.updateView(value, false);
            if (e)
                if (this.project.settings.autoRevealProofStateAtCursor && e.document === this.document && e.selections.length === 1)
                    this.viewGoalAt(e, e.selections[0].active);
        });
    }
    getUri() {
        return this.documentUri;
    }
    getDocument() {
        return this.document;
    }
    dispose() {
        this.quitCoq();
        this.langServer.dispose();
        this.highlights.clearAll(this.allEditors());
        this.statusBar.dispose();
        if (this.view)
            this.view.dispose();
        this.subscriptions.forEach((d) => d.dispose());
    }
    reset() {
        this.highlights.clearAll(this.allEditors());
    }
    rememberCursors() {
        this.cursorUnmovedSinceCommandInitiated.clear();
        for (let editor of this.allEditors()) {
            this.cursorUnmovedSinceCommandInitiated.add(editor);
        }
    }
    onDidUpdateHighlights(params) {
        this.highlights.set(this.allEditors(), params);
    }
    // private onUpdateComputingStatus(params: proto.NotifyComputingStatusParams) {
    //   this.statusBar.setStateComputing(params.status);
    // }
    onCoqMessage(params) {
        if (params.routeId == this.queryRouteId) {
            this.project.queryOut.show(true);
            this.project.queryOut.appendLine(psm.prettyTextToString(params.message));
        }
        else {
            switch (params.level) {
                case 'warning':
                    this.project.infoOut.show(true);
                    this.project.infoOut.appendLine(psm.prettyTextToString(params.message));
                    return;
                case 'info':
                    this.project.infoOut.appendLine(psm.prettyTextToString(params.message));
                    return;
                case 'notice':
                    this.project.noticeOut.show(true);
                    this.project.noticeOut.append(psm.prettyTextToString(params.message));
                    this.project.noticeOut.append("\n");
                    return;
                case 'debug':
                    this.project.debugOut.show(true);
                    this.project.debugOut.appendLine(psm.prettyTextToString(params.message));
                    return;
            }
        }
    }
    onDidChangeTextDocument(params) {
        this.updateFocus(this.focus, false);
    }
    interruptCoq() {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateMessage('Killing CoqTop');
            try {
                yield this.langServer.interruptCoq();
            }
            finally { }
            this.statusBar.setStateReady();
        });
    }
    quitCoq(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateMessage('Killing CoqTop');
            try {
                yield this.langServer.quitCoq();
            }
            finally { }
            this.reset();
            this.statusBar.setStateReady();
        });
    }
    resetCoq(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateMessage('Resetting Coq');
            try {
                yield this.langServer.resetCoq();
            }
            finally { }
            this.reset();
            this.statusBar.setStateReady();
        });
    }
    findEditor() {
        return vscode.window.visibleTextEditors.find((editor, i, a) => editor.document.uri.toString() === this.documentUri);
    }
    allEditors() {
        return vscode.window.visibleTextEditors.filter((editor, i, a) => editor.document.uri.toString() === this.documentUri);
    }
    currentViewColumn() {
        let editor = this.findEditor();
        if (editor)
            return editor.viewColumn;
        else if (vscode.window.activeTextEditor)
            return vscode.window.activeTextEditor.viewColumn;
        else
            return undefined;
    }
    onCoqReset() {
        this.reset();
        this.statusBar.setStateReady();
    }
    /** Bring the focus into the editor's view, but only scroll rightward
     * if the focus is not at the end of a line
     * */
    setCursorToPosition(pos, editor, scroll = true, scrollHorizontal = false) {
        if (!editor || !pos)
            return;
        editor.selections = [new vscode.Selection(pos, pos)];
        if (scroll) {
            if (scrollHorizontal || textUtil.positionIsBefore(pos, this.document.lineAt(pos.line).range.end))
                editor.revealRange(new vscode.Range(pos, pos), vscode.TextEditorRevealType.Default);
            else
                editor.revealRange(new vscode.Range(pos.line, 0, pos.line + 1, 0), vscode.TextEditorRevealType.Default);
        }
    }
    updateFocus(focus, moveCursor = false) {
        if (focus) {
            this.focus = new vscode.Position(focus.line, focus.character);
            if (moveCursor) {
                // adjust the cursor position
                for (let editor of this.cursorUnmovedSinceCommandInitiated)
                    this.setCursorToPosition(this.focus, editor, editor === vscode.window.activeTextEditor);
            }
            // update the focus decoration
            this.showFocusDecorations();
        }
        else {
            for (let editor of this.allEditors())
                editor.setDecorations(Decorations_1.decorations.focus, []);
        }
    }
    userSetCoqtopPath(global = false) {
        return __awaiter(this, void 0, void 0, function* () {
            const current = vscode.workspace.getConfiguration("coqtop").get("binPath", "");
            const coqtopExe = vscode.workspace.getConfiguration("coqtop").get("coqtopExe", "");
            const newPath = yield vscode.window.showInputBox({ ignoreFocusOut: true, value: current, validateInput: (v) => {
                    try {
                        const statDir = fs.statSync(v);
                        if (!statDir.isDirectory())
                            return "not a directory";
                    }
                    catch (err) {
                        return "invalid path";
                    }
                    let stat = undefined;
                    try {
                        stat = fs.statSync(path.join(v, coqtopExe));
                    }
                    catch (_a) {
                        if (os.platform() === 'win32') {
                            try {
                                stat = fs.statSync(path.join(v, coqtopExe, '.exe'));
                            }
                            catch (_b) { }
                        }
                    }
                    if (!stat)
                        return "coqtop not found here";
                    if (!stat.isFile())
                        return "coqtop found here, but is not an executable file";
                    return "";
                } });
            function checkCoqtopExists(newPath) {
                return __awaiter(this, void 0, void 0, function* () {
                    if (!newPath)
                        return false;
                    try {
                        return (yield fs.existsSync(path.join(newPath, coqtopExe))) ||
                            os.platform() === 'win32' && (yield fs.existsSync(path.join(newPath, coqtopExe, '.exe')));
                    }
                    catch (err) {
                        return false;
                    }
                });
            }
            if (newPath)
                if (yield checkCoqtopExists(newPath))
                    yield vscode.workspace.getConfiguration("coqtop").update("binPath", newPath, global);
        });
    }
    handleResult(value) {
        if (value.type === 'busy')
            return false;
        else if (value.type === 'failure' && value.range) {
            this.updateFocus(value.focus, false);
            if (this.project.settings.moveCursorToFocus) {
                for (let editor of this.cursorUnmovedSinceCommandInitiated)
                    this.setCursorToPosition(new vscode.Position(value.range.start.line, value.range.start.character), editor, editor === vscode.window.activeTextEditor);
            }
        }
        else if (value.type === 'not-running') {
            this.updateFocus(undefined, false);
            if (value.reason === 'spawn-failed') {
                const getCoq = { title: "Get Coq", id: 0 };
                const setPathLocal = { title: "Set path for this project", id: 1 };
                const setPathGlobal = { title: "Set path globally", id: 2 };
                vscode.window.showErrorMessage(`Could not start coqtop ${value.coqtop ? ` (${value.coqtop})` : ""}`, getCoq, setPathLocal, setPathGlobal)
                    .then((act) => __awaiter(this, void 0, void 0, function* () {
                    if (act && act.id === getCoq.id) {
                        vscode.commands.executeCommand("vscode.open", vscode.Uri.parse('https://coq.inria.fr/download'));
                    }
                    else if (act && (act.id === setPathLocal.id || act.id === setPathGlobal.id)) {
                        yield this.userSetCoqtopPath(act.id === setPathGlobal.id);
                    }
                }));
            }
        }
        else if (value.type === 'interrupted')
            this.statusBar.setStateComputing(proto.ComputingStatus.Interrupted);
        else
            this.updateFocus(value.focus, this.project.settings.moveCursorToFocus);
        return true;
    }
    updateView(state, interactive = false) {
        if (interactive && !this.view.isVisible() && this.project.settings.showProofViewOn === "first-interaction") {
            let viewCol = this.currentViewColumn();
            if (viewCol)
                this.view.show(CoqView_1.adjacentPane(viewCol), state);
            else
                this.view.show(vscode.ViewColumn.One, state);
        }
        else {
            this.view.update(state);
        }
        this.stateViewFocus = state.type === "proof-view" ? new vscode.Position(state.focus.line, state.focus.character) : undefined;
        this.showFocusDecorations();
    }
    showFocusDecorations() {
        if (!this.focus)
            return;
        const focusRange = new vscode.Range(this.focus.line, 0, this.focus.line, 1);
        if (this.focus.line === 0 && this.focus.character === 0) {
            for (let editor of this.allEditors()) {
                editor.setDecorations(Decorations_1.decorations.focusBefore, [focusRange]);
                editor.setDecorations(Decorations_1.decorations.focus, []);
            }
        }
        else {
            for (let editor of this.allEditors()) {
                editor.setDecorations(Decorations_1.decorations.focusBefore, []);
                editor.setDecorations(Decorations_1.decorations.focus, [focusRange]);
            }
        }
        if (this.stateViewFocus && this.stateViewFocus.line !== this.focus.line) {
            const focusRange = new vscode.Range(this.stateViewFocus.line, 0, this.stateViewFocus.line, 1);
            for (let editor of this.allEditors()) {
                editor.setDecorations(Decorations_1.decorations.proofViewFocus, [focusRange]);
            }
        }
        else {
            for (let editor of this.allEditors()) {
                editor.setDecorations(Decorations_1.decorations.proofViewFocus, []);
            }
        }
    }
    makePreviewOpenedFilePermanent(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            //Make sure that the file is really open instead of preview-open, to avoid accidentaly closing the file
            yield vscode.commands.executeCommand("workbench.action.keepEditor", editor.document.uri);
        });
    }
    stepForward(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateWorking('Stepping forward');
            try {
                this.makePreviewOpenedFilePermanent(editor);
                this.rememberCursors();
                const value = yield this.langServer.stepForward();
                this.updateView(value, true);
                this.handleResult(value);
            }
            catch (err) {
            }
            this.statusBar.setStateReady();
        });
    }
    stepBackward(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateWorking('Stepping backward');
            try {
                this.makePreviewOpenedFilePermanent(editor);
                this.rememberCursors();
                const value = yield this.langServer.stepBackward();
                this.updateView(value, true);
                if (this.handleResult(value))
                    this.statusBar.setStateReady();
                // const range = new vscode.Range(editor.document.positionAt(value.commandStart), editor.document.positionAt(value.commandEnd));
                // clearHighlight(editor, range);
            }
            catch (err) {
            }
        });
    }
    finishComputations(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateWorking('Finishing computations');
            try {
                yield this.langServer.finishComputations();
                this.statusBar.setStateReady();
            }
            catch (err) {
            }
        });
    }
    interpretToCursorPosition(editor, synchronous = false) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateWorking('Interpretting to point');
            try {
                if (!editor || editor.document.uri.toString() !== this.documentUri)
                    return;
                this.makePreviewOpenedFilePermanent(editor);
                const value = yield this.langServer.interpretToPoint(editor.selection.active, synchronous);
                this.updateView(value, true);
                this.handleResult(value);
            }
            catch (err) {
                console.warn("Interpret to point failed: " + err.toString());
                if (err.stack)
                    console.log("Stack: \n" + err.stack);
            }
            this.statusBar.setStateReady();
        });
    }
    interpretToEnd(editor, synchronous = false) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateWorking('Interpreting to end');
            try {
                this.makePreviewOpenedFilePermanent(editor);
                const value = yield this.langServer.interpretToEnd(synchronous);
                this.updateView(value, true);
                this.handleResult(value);
            }
            catch (err) { }
            this.statusBar.setStateReady();
        });
    }
    query(query, term) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                if (term) {
                    this.project.queryOut.clear();
                    this.project.queryOut.show(true);
                    this.langServer.query(query, term, this.queryRouteId);
                }
            }
            catch (err) {
            }
            finally {
                this.statusBar.setStateReady();
            }
        });
    }
    viewGoalState(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                if (editor.viewColumn)
                    yield this.view.show(CoqView_1.adjacentPane(editor.viewColumn));
                else
                    yield this.view.show(vscode.ViewColumn.One);
            }
            catch (err) { }
        });
    }
    ltacProfGetResults(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.setStateWorking('Running query');
            try {
                if (!editor || editor.document.uri.toString() !== this.documentUri)
                    return;
                const offset = editor.document.offsetAt(editor.selection.active);
                this.currentLtacProfView = new HtmlLtacProf_1.HtmlLtacProf({ total_time: 0, tactics: [] });
                this.currentLtacProfView.show(true);
                yield this.langServer.ltacProfGetResults(offset);
                // const view = new HtmlLtacProf(results);
                // const out = vscode.window.createOutputChannel("LtacProfiler");
                // results.forEach((value,key) => {
                //     out.appendLine("-----------------------------------");
                //     this.outputLtacProfTreeNode(out, "", key, value);
                //   });
            }
            catch (err) {
            }
            finally {
                this.statusBar.setStateReady();
            }
        });
    }
    onLtacProfResults(results) {
        if (!this.currentLtacProfView)
            this.currentLtacProfView = new HtmlLtacProf_1.HtmlLtacProf(results);
        else
            this.currentLtacProfView.update(results);
    }
    doOnLostFocus() {
        return __awaiter(this, void 0, void 0, function* () {
            this.statusBar.unfocus();
        });
    }
    doOnFocus(editor) {
        return __awaiter(this, void 0, void 0, function* () {
            this.showFocusDecorations();
            this.highlights.refresh([editor]);
            this.statusBar.focus();
            // await this.view.show(true);
        });
    }
    // public async doOnSwitchActiveEditor(oldEditor: TextEditor, newEditor: TextEditor) {
    //   this.showFocusDecorations();
    //   this.highlights.refresh([newEditor]);
    //   this.statusBar.focus();
    // }
    queryDisplayOptionChange() {
        return __awaiter(this, void 0, void 0, function* () {
            const result = yield vscode.window.showQuickPick(DisplayOptionPicks.allPicks);
            if (result)
                return result.displayItem;
            else
                return null;
        });
    }
    setDisplayOption(item, value) {
        return __awaiter(this, void 0, void 0, function* () {
            if (item === undefined) {
                item = (yield this.queryDisplayOptionChange()) || undefined;
                if (!item)
                    return;
            }
            value = value || proto.SetDisplayOption.Toggle;
            try {
                yield this.langServer.setDisplayOptions([{ item: item, value: value }]);
                yield this.refreshGoal();
            }
            catch (err) { }
        });
    }
    viewGoalAt(editor, pos) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                if (!pos)
                    pos = editor.selection.active;
                const proofview = yield this.langServer.getCachedGoal(pos, this.project.settings.revealProofStateAtCursorDirection);
                if (proofview.type === "proof-view")
                    this.updateView(proofview, false);
            }
            catch (err) { }
        });
    }
    getCurrentFocus() {
        return this.focus;
    }
}
exports.CoqDocument = CoqDocument;
//# sourceMappingURL=CoqDocument.js.map