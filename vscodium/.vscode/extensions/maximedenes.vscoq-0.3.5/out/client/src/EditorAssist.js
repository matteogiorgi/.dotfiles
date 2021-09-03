"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
let subscriptions = [];
function unload() {
    subscriptions.forEach(x => x.dispose());
    subscriptions = [];
}
exports.unload = unload;
exports.regExpQualifiedCoqIdent = /((\p{L}|[_\u00A0])(\p{L}|[0-9_\u00A0'])*)(\.((\p{L}|[_\u00A0])(\p{L}|[0-9_\u00A0'])*))*/u;
function reload() {
    unload();
    const matchNothing = /a^/;
    const settings = vscode.workspace.getConfiguration("coq");
    const increaseIndentPatternParts = [];
    if (settings.format.indentAfterBullet === "indent")
        increaseIndentPatternParts.push(/\*|\+|\-/.source);
    if (settings.format.indentAfterOpenProof)
        increaseIndentPatternParts.push(/Proof\b/.source);
    const increaseIndentRE = settings.format.enable && increaseIndentPatternParts.length > 0
        ? new RegExp(String.raw `^\s*${increaseIndentPatternParts.join('|')}`)
        : matchNothing;
    subscriptions.push(vscode.languages.setLanguageConfiguration('coq', {
        indentationRules: { increaseIndentPattern: increaseIndentRE, decreaseIndentPattern: matchNothing },
        wordPattern: exports.regExpQualifiedCoqIdent,
    }));
    formatAlignAfterBulletEdits.clear();
    if (settings.format.enable) {
        const editProviders = [];
        if (settings.format.unindentOnCloseProof)
            editProviders.push({ fun: formatCloseProof, trigger: '.' });
        if (settings.format.indentAfterBullet === 'align') {
            editProviders.push({ fun: formatAlignAfterBullet, trigger: '\n' });
            subscriptions.push(vscode.workspace.onDidChangeTextDocument(event => {
                if (formatAlignAfterBulletEdits.size === 0)
                    return;
                const editor = vscode.window.activeTextEditor;
                if (editor) {
                    if (editor.document !== event.document)
                        return;
                    const edit = formatAlignAfterBulletEdits.get(event.document);
                    if (!edit || event.contentChanges.length !== 1)
                        return;
                    const editRange = event.contentChanges[0].range;
                    if (!editRange.isEmpty || edit.edit.newText.substring(editRange.start.character) !== event.contentChanges[0].text)
                        return;
                    formatAlignAfterBulletEdits.delete(event.document);
                    const selectionIdx = editor.selections.findIndex(p => p.active.isEqual(edit.currentPosition));
                    if (selectionIdx >= 0 && editor.selections[selectionIdx].isEmpty)
                        editor.selections = [new vscode.Selection(edit.newPosition, edit.newPosition)];
                }
            }));
        }
        if (editProviders.length > 0)
            subscriptions.push(vscode.languages.registerOnTypeFormattingEditProvider("coq", {
                provideOnTypeFormattingEdits: (document, position, ch, options, token) => {
                    for (let ep of editProviders) {
                        const editors = ep.fun(document, position, ch, options, token);
                        if (editors)
                            return editors;
                    }
                    return [];
                }
            }, editProviders[0].trigger, ...editProviders.map(x => x.trigger)));
    }
    return { dispose: () => unload() };
}
exports.reload = reload;
function makeIndent(indent, options) {
    let columns;
    if (typeof indent === 'string')
        columns = (indent.replace(/\t/g, ' '.repeat(options.tabSize))).length;
    else
        columns = indent;
    if (options.insertSpaces)
        return { indent: ' '.repeat(columns), columns: columns };
    else
        return { indent: '\t'.repeat(Math.floor(columns / options.tabSize)) + ' '.repeat(columns % options.tabSize), columns: columns };
}
function formatCloseProof(doc, pos, ch, options, token) {
    if (ch === '.' && pos.line > 0) {
        const line = doc.lineAt(pos.line);
        let closeMatch;
        if (!(closeMatch = /^(\s*)((?:Qed|Defined|Admitted)\.\s*)$/.exec(line.text)))
            return undefined;
        const prevLine = doc.lineAt(pos.line - 1);
        let alignMatch;
        if (!(alignMatch = (new RegExp(String.raw `^(\s*)(?:\s{${options.tabSize}}|\t)\S`)).exec(prevLine.text)))
            return undefined;
        const { indent: indent } = makeIndent(alignMatch[1], options);
        const edit = new vscode.TextEdit(new vscode.Range(pos.line, 0, pos.line, closeMatch[1].length), indent);
        return [edit];
    }
    return undefined;
}
const formatAlignAfterBulletEdits = new Map();
function formatAlignAfterBullet(doc, pos, ch, options, token) {
    if (ch === '\n' && pos.line > 0) {
        const prevLine = doc.lineAt(pos.line - 1);
        const line = doc.lineAt(pos.line);
        let prevMatch;
        if (!(prevMatch = /^(\s*(?:\*+|\++|\-+)\s*)\S/.exec(prevLine.text)))
            return undefined;
        const { indent: indent, columns: indentColumns } = makeIndent(prevMatch[1], options);
        const edit = new vscode.TextEdit(new vscode.Range(pos.line, 0, pos.line, line.firstNonWhitespaceCharacterIndex), indent);
        const newPosition = new vscode.Position(pos.line, indentColumns);
        formatAlignAfterBulletEdits.set(doc, { edit: edit, newPosition: newPosition, currentPosition: pos });
        return [edit];
    }
    return undefined;
}
//# sourceMappingURL=EditorAssist.js.map