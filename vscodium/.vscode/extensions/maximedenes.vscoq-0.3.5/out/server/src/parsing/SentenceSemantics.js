"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode-languageserver");
const server = require("../server");
const parser = require("./coq-parser");
const textUtil = require("./../util/text-util");
const path = require("path");
const fs = require("fs");
class SentenceSemantics {
}
exports.SentenceSemantics = SentenceSemantics;
class LoadModule {
    constructor(
    /** filename of *.vo file */
    filename, module) {
        this.filename = filename;
        this.module = module;
        this.sourceFile = undefined;
        const file = path.parse(this.filename);
        const source = path.join(file.dir, file.name + ".v");
        fs.exists(source, (fileExists) => {
            if (fileExists)
                this.sourceFile = "file://" + source;
        });
    }
    getSourceFileName() {
        return this.sourceFile;
    }
    getModuleName() {
        return this.module;
    }
    getModuleFileName() {
        return this.filename;
    }
    isEqual(x) {
        return x instanceof LoadModule && x.filename === this.filename;
    }
}
exports.LoadModule = LoadModule;
class Definition {
    constructor(identifier, range) {
        this.identifier = identifier;
        this.range = range;
    }
    isEqual(x) {
        return x instanceof Definition && x.identifier === this.identifier;
    }
}
exports.Definition = Definition;
class Inductive {
    constructor(identifier, range) {
        this.identifier = identifier;
        this.range = range;
    }
    isEqual(x) {
        return x instanceof Inductive && x.identifier === this.identifier;
    }
}
exports.Inductive = Inductive;
var parseAstSymbols;
(function (parseAstSymbols) {
    function identToSymbol(ident, kind, pos) {
        return vscode.SymbolInformation.create(ident.text, vscode.SymbolKind.Variable, textUtil.rangeTranslateRelative(pos, parser.locationRangeToRange(ident.loc)));
    }
    function definition(ast, pos) {
        return [identToSymbol(ast.ident, vscode.SymbolKind.Variable, pos)];
    }
    parseAstSymbols.definition = definition;
    function inductive(ast, pos) {
        return Array.prototype.concat(...ast.bodies.map((indBody) => [identToSymbol(indBody.ident, vscode.SymbolKind.Class, pos),
            ...indBody.constructors
                .map((c) => identToSymbol(c.ident, vscode.SymbolKind.Constructor, pos))
        ]));
    }
    parseAstSymbols.inductive = inductive;
    function ltacDef(ast, pos) {
        return [identToSymbol(ast.ident, vscode.SymbolKind.Function, pos)];
    }
    parseAstSymbols.ltacDef = ltacDef;
    function assumptions(ast, pos) {
        return ast.idents.map((id) => identToSymbol(id, vscode.SymbolKind.Variable, pos));
    }
    parseAstSymbols.assumptions = assumptions;
    function section(ast, pos) {
        return [identToSymbol(ast.ident, vscode.SymbolKind.Namespace, pos)];
    }
    parseAstSymbols.section = section;
    function module(ast, pos) {
        return [ast.ident, ...Array.prototype.concat(...ast.bindings.map((b) => b.idents))]
            .map((id) => identToSymbol(id, vscode.SymbolKind.Module, pos));
    }
    parseAstSymbols.module = module;
    function moduleType(ast, pos) {
        return [ast.ident, ...Array.prototype.concat(...ast.bindings.map((b) => b.idents))]
            .map((id) => identToSymbol(id, vscode.SymbolKind.Module, pos));
    }
    parseAstSymbols.moduleType = moduleType;
    function moduleBind(ast, pos) {
        return [identToSymbol(ast.ident, vscode.SymbolKind.Module, pos)];
    }
    parseAstSymbols.moduleBind = moduleBind;
    function moduleTypeBind(ast, pos) {
        return [identToSymbol(ast.ident, vscode.SymbolKind.Module, pos)];
    }
    parseAstSymbols.moduleTypeBind = moduleTypeBind;
})(parseAstSymbols || (parseAstSymbols = {}));
// export function parseAst(ast: parser.Sentence, pos: vscode.Position) : SentenceSemantics[] {
//   switch(ast.type) {
//   case "definition": return parseAstDefinition(ast,pos);
//   case "inductive": return parseAstInductive(ast,pos);
//   default:
//     return []
//   }
// }
function parseAstForSymbols(ast, pos) {
    try {
        switch (ast.type) {
            case "assumptions": return parseAstSymbols.assumptions(ast, pos);
            case "definition": return parseAstSymbols.definition(ast, pos);
            case "inductive": return parseAstSymbols.inductive(ast, pos);
            case "ltacdef": return parseAstSymbols.ltacDef(ast, pos);
            case "section": return parseAstSymbols.section(ast, pos);
            case "module": return parseAstSymbols.module(ast, pos);
            case "module-bind": return parseAstSymbols.moduleBind(ast, pos);
            case "module-type": return parseAstSymbols.moduleType(ast, pos);
            case "module-type-bind": return parseAstSymbols.moduleTypeBind(ast, pos);
            default:
                return [];
        }
    }
    catch (err) {
        if (err instanceof Error)
            server.connection.console.warn(`Error processing AST of type ${ast.type}: ` + err.message + '\n' + err.stack);
        else
            server.connection.console.warn(`Error processing AST of type ${ast.type}: ` + err.toString());
        return [];
    }
}
exports.parseAstForSymbols = parseAstForSymbols;
//# sourceMappingURL=SentenceSemantics.js.map