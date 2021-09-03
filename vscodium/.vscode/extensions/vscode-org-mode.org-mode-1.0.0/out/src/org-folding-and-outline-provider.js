"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const utils = require("./utils");
// ChunkType value is used as SymbolKind for outline
var ChunkType;
(function (ChunkType) {
    ChunkType[ChunkType["SECTION"] = 13] = "SECTION";
    ChunkType[ChunkType["BLOCK"] = 15] = "BLOCK";
})(ChunkType || (ChunkType = {}));
class OrgFoldingAndOutlineProvider {
    constructor() {
        this.documentStateRegistry = new WeakMap();
    }
    provideFoldingRanges(document, token) {
        const state = this.getOrCreateDocumentState(document);
        return state.getRanges(document);
    }
    provideDocumentSymbols(document, token) {
        const state = this.getOrCreateDocumentState(document);
        return state.getSymbols(document);
    }
    getOrCreateDocumentState(document) {
        let state = this.documentStateRegistry.get(document);
        if (!state) {
            state = new OrgFoldingAndOutlineDocumentState();
            this.documentStateRegistry.set(document, state);
        }
        return state;
    }
}
exports.OrgFoldingAndOutlineProvider = OrgFoldingAndOutlineProvider;
class OrgFoldingAndOutlineDocumentState {
    constructor() {
        this.computedForDocumentVersion = null;
        this.ranges = [];
        this.symbols = [];
    }
    getRanges(document) {
        this.compute(document);
        return this.ranges;
    }
    getSymbols(document) {
        this.compute(document);
        return this.symbols;
    }
    compute(document) {
        if (document.version === this.computedForDocumentVersion) {
            return;
        }
        this.computedForDocumentVersion = document.version;
        this.ranges = [];
        this.symbols = [];
        const count = document.lineCount;
        const stack = [];
        let inBlock = false;
        for (let lineNumber = 0; lineNumber < count; lineNumber++) {
            const element = document.lineAt(lineNumber);
            const text = element.text;
            if (inBlock) {
                if (utils.isBlockEndLine(text)) {
                    inBlock = false;
                    if (stack.length > 0 && stack[stack.length - 1].type === ChunkType.BLOCK) {
                        const top = stack.pop();
                        this.createSection(top, lineNumber);
                    }
                }
            }
            else if (utils.isBlockStartLine(text)) {
                inBlock = true;
                const title = this.extractBlockTitle(text);
                stack.push({ type: ChunkType.BLOCK, title, level: Number.MAX_SAFE_INTEGER, startLine: lineNumber });
            }
            else if (utils.isHeaderLine(text)) {
                const currentLevel = utils.getStarPrefixCount(text);
                // close previous sections
                while (stack.length > 0 && stack[stack.length - 1].level >= currentLevel) {
                    const top = stack.pop();
                    this.createSection(top, lineNumber - 1);
                }
                const title = utils.getHeaderTitle(text);
                stack.push({ type: ChunkType.SECTION, title, level: currentLevel, startLine: lineNumber });
            }
        }
        let top;
        while ((top = stack.pop()) != null) {
            this.createSection(top, count - 1);
        }
    }
    createSection(chunk, endLine) {
        this.ranges.push(new vscode_1.FoldingRange(chunk.startLine, endLine));
        this.symbols.push(new vscode_1.SymbolInformation(chunk.title, chunk.type.valueOf(), new vscode_1.Range(new vscode_1.Position(chunk.startLine, 0), new vscode_1.Position(endLine, 0))));
    }
    extractBlockTitle(line) {
        let titleStartAt = line.indexOf('_') + 1;
        if (titleStartAt == 0) {
            titleStartAt = line.indexOf(':') + 2;
        }
        return line.substr(titleStartAt);
    }
}
//# sourceMappingURL=org-folding-and-outline-provider.js.map