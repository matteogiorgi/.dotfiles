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
const proto = require("./protocol");
const CoqProject_1 = require("./CoqProject");
const snippets = require("./Snippets");
const Decorations_1 = require("./Decorations");
const editorAssist = require("./EditorAssist");
const psm = require("./prettify-symbols-mode");
vscode.Range.prototype.toString = function rangeToString() { return `[${this.start.toString()},${this.end.toString()})`; };
vscode.Position.prototype.toString = function positionToString() { return `{${this.line}@${this.character}}`; };
console.log(`Coq Extension: process.version: ${process.version}, process.arch: ${process.arch}}`);
let project;
function activate(context) {
    console.log(`execArgv: ${process.execArgv.join(' ')}`);
    console.log(`argv: ${process.argv.join(' ')}`);
    exports.extensionContext = context;
    // Indentation rules
    vscode.languages.setLanguageConfiguration("coq", {
        // @Note Literal whitespace in below regexps is removed
        onEnterRules: [
            {
                beforeText: new RegExp(String.raw `
          ^\s*
          (
            (\|) .+
          )
          \s*$
          `.replace(/\s+?/g, "")),
                action: {
                    indentAction: vscode.IndentAction.None
                }
            },
            {
                beforeText: new RegExp(String.raw `
          ^\s*
          (
            (Definition|Fixpoint|Record|Ltac|Let|Notation|Program Definition) .+:=
          )
          \s*$
          `.replace(/\s+?/g, "")),
                action: {
                    indentAction: vscode.IndentAction.Indent
                }
            }
        ]
    });
    project = CoqProject_1.CoqProject.create(context);
    context.subscriptions.push(project);
    function regTCmd(command, callback) {
        context.subscriptions.push(vscode.commands.registerTextEditorCommand('extension.coq.' + command, callback));
    }
    function regCmd(command, callback, thisArg) {
        context.subscriptions.push(vscode.commands.registerCommand('extension.coq.' + command, callback, thisArg));
    }
    function regProjectCmd(command, callback, thisArg) {
        context.subscriptions.push(vscode.commands.registerCommand('extension.coq.' + command, callback, project));
    }
    Decorations_1.initializeDecorations(context);
    regProjectCmd('quit', project.quitCoq);
    regProjectCmd('reset', project.resetCoq);
    regProjectCmd('interrupt', project.interruptCoq);
    regProjectCmd('finishComputations', project.finishComputations);
    regProjectCmd('stepForward', project.stepForward);
    regProjectCmd('stepBackward', project.stepBackward);
    regProjectCmd('interpretToPoint', project.interpretToPoint);
    regProjectCmd('interpretToPointSynchronous', () => project.interpretToPoint({ synchronous: true }));
    regProjectCmd('interpretToEnd', project.interpretToEnd);
    regProjectCmd('interpretToEndSynchronous', () => project.interpretToEnd({ synchronous: true }));
    regProjectCmd('moveCursorToFocus', project.setCursorToFocus);
    regTCmd('query.check', check);
    regTCmd('query.locate', locate);
    regTCmd('query.search', search);
    regTCmd('query.about', about);
    regTCmd('query.searchAbout', searchAbout);
    regTCmd('query.print', print);
    regTCmd('query.prompt.check', queryCheck);
    regTCmd('query.prompt.locate', queryLocate);
    regTCmd('query.prompt.search', querySearch);
    regTCmd('query.prompt.about', queryAbout);
    regTCmd('query.prompt.searchAbout', querySearchAbout);
    regTCmd('query.prompt.print', queryPrint);
    regTCmd('proofView.viewStateAt', viewProofStateAt);
    regTCmd('proofView.open', viewCurrentProofState);
    regProjectCmd('ltacProf.getResults', project.ltacProfGetResults);
    regCmd('display.toggle.implicitArguments', () => project.setDisplayOption(proto.DisplayOption.ImplicitArguments, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.coercions', () => project.setDisplayOption(proto.DisplayOption.Coercions, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.rawMatchingExpressions', () => project.setDisplayOption(proto.DisplayOption.RawMatchingExpressions, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.notations', () => project.setDisplayOption(proto.DisplayOption.Notations, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.allBasicLowLevelContents', () => project.setDisplayOption(proto.DisplayOption.AllBasicLowLevelContents, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.existentialVariableInstances', () => project.setDisplayOption(proto.DisplayOption.ExistentialVariableInstances, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.universeLevels', () => project.setDisplayOption(proto.DisplayOption.UniverseLevels, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle.allLowLevelContents', () => project.setDisplayOption(proto.DisplayOption.AllLowLevelContents, proto.SetDisplayOption.Toggle));
    regCmd('display.toggle', () => project.setDisplayOption());
    context.subscriptions.push(editorAssist.reload());
    snippets.setupSnippets(context.subscriptions);
    context.subscriptions.push(psm.load());
}
exports.activate = activate;
function withDocAsync(editor, callback) {
    return __awaiter(this, void 0, void 0, function* () {
        const doc = editor ? project.getOrCurrent(editor.document.uri.toString()) || null : null;
        if (doc)
            yield callback(doc);
    });
}
function coqIdOrNotationFromPosition(editor) {
    let range = editor.selection;
    if (range.isEmpty)
        range = editor.document.getWordRangeAtPosition(editor.selection.active);
    let regExpCoqNotation = /[^\p{Z}\p{C}"]+/u;
    if (range == undefined)
        range = editor.document.getWordRangeAtPosition(editor.selection.active, regExpCoqNotation);
    let text = editor.document.getText(range);
    if (new RegExp("\^" + regExpCoqNotation.source + "\$", regExpCoqNotation.flags).test(text)
        && !new RegExp("\^" + editorAssist.regExpQualifiedCoqIdent.source + "\$", regExpCoqNotation.flags).test(text))
        return "\"" + text + "\"";
    return text;
}
function queryStringFromPlaceholder(prompt, editor) {
    return __awaiter(this, void 0, void 0, function* () {
        return yield vscode.window.showInputBox({
            prompt: prompt,
            value: coqIdOrNotationFromPosition(editor)
        });
    });
}
function queryStringFromPosition(prompt, editor) {
    return __awaiter(this, void 0, void 0, function* () {
        let query = coqIdOrNotationFromPosition(editor);
        if (query.trim() === "")
            return yield vscode.window.showInputBox({
                prompt: prompt,
                value: undefined
            });
        else
            return query;
    });
}
function queryCheck(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("check", yield queryStringFromPlaceholder("Check:", editor)); }));
}
function queryLocate(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("locate", yield queryStringFromPlaceholder("Locate:", editor)); }));
}
function querySearch(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("search", yield queryStringFromPlaceholder("Search:", editor)); }));
}
function queryAbout(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("about", yield queryStringFromPlaceholder("Search:", editor)); }));
}
function querySearchAbout(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("searchAbout", yield queryStringFromPlaceholder("Search About:", editor)); }));
}
function queryPrint(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("print", yield queryStringFromPlaceholder("Print:", editor)); }));
}
function check(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("check", yield queryStringFromPosition("Check:", editor)); }));
}
function locate(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("locate", yield queryStringFromPosition("Locate:", editor)); }));
}
function search(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("search", yield queryStringFromPosition("Search:", editor)); }));
}
function about(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("about", yield queryStringFromPosition("Search:", editor)); }));
}
function searchAbout(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("searchAbout", yield queryStringFromPosition("Search About:", editor)); }));
}
function print(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.query("print", yield queryStringFromPosition("Search About:", editor)); }));
}
function viewProofStateAt(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.viewGoalAt(editor); }));
}
function viewCurrentProofState(editor, edit) {
    return withDocAsync(editor, (doc) => __awaiter(this, void 0, void 0, function* () { return doc.viewGoalState(editor); }));
}
//# sourceMappingURL=extension.js.map