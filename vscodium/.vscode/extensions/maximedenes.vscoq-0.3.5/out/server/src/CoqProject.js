"use strict";
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
const document_1 = require("./document");
const path = require("path");
const fs = require("fs");
const PrettifySymbols_1 = require("./util/PrettifySymbols");
const nodeAsync = require("./util/nodejs-async");
const CoqTop8_1 = require("./coqtop/CoqTop8");
const string_argv_1 = require("string-argv");
const coqProjectFileName = '_CoqProject';
class CoqProject {
    constructor(workspaceRoot, connection) {
        this.connection = connection;
        this.coqInstances = new Map();
        this.coqProjectWatcher = null;
        this.loadingCoqProjectInProcess = false;
        this.ready = { event: Promise.resolve({}), signal: () => { } };
        this.psm = new PrettifySymbols_1.PrettifySymbolsMode([]);
        // we independently track the settings contributed by the vscode project settings and _CoqProject
        // so they can be modified seperately
        this.settingsCoqTopArgs = [];
        this.coqProjectArgs = [];
        if (workspaceRoot)
            connection.console.log("Loaded project at " + workspaceRoot);
        else
            connection.console.log("Loading project with no root directory");
        this.coqProjectRoot = workspaceRoot; //default is the workspace root
    }
    get console() {
        return this.connection.console;
    }
    getCoqProjectRoot() {
        return this.coqProjectRoot;
    }
    lookup(uri) {
        var doc = this.coqInstances.get(uri);
        if (!doc)
            throw 'unknown document: ' + uri;
        return doc;
    }
    createCoqTopInstance(scriptFile) {
        return new CoqTop8_1.CoqTop(this.settings.coqtop, scriptFile, this.getCoqProjectRoot(), this.console);
    }
    /** reset the ready promise */
    notReady() {
        this.ready.event = new Promise((resolve) => {
            this.ready.signal = () => {
                this.ready = { event: Promise.resolve({}), signal: () => { } };
                resolve();
            };
        });
    }
    getPrettifySymbols() {
        return this.psm;
    }
    matchesCoq(selector) {
        if (typeof selector === 'string')
            return selector === 'coq';
        else if (selector instanceof Array)
            return selector.some((s) => this.matchesCoq(s));
        else
            return selector.language === 'coq';
    }
    updateSettings(newSettings) {
        return __awaiter(this, void 0, void 0, function* () {
            this.notReady();
            this.settingsCoqTopArgs = newSettings.coqtop.args;
            this.currentSettings = newSettings;
            if (newSettings.coq.coqProjectRoot) {
                this.coqProjectRoot = newSettings.coq.coqProjectRoot;
                this.console.log("Updated project root to " + this.getCoqProjectRoot());
            }
            if (newSettings.coq.loadCoqProject) {
                this.watchCoqProject();
                yield this.loadCoqProject();
            }
            if (newSettings.prettifySymbolsMode && newSettings.prettifySymbolsMode.substitutions) {
                for (let entry of newSettings.prettifySymbolsMode.substitutions) {
                    if (entry.language && entry.substitutions && this.matchesCoq(entry.language)) {
                        this.psm = new PrettifySymbols_1.PrettifySymbolsMode(entry.substitutions);
                        break;
                    }
                }
            }
            else
                this.psm = new PrettifySymbols_1.PrettifySymbolsMode([]);
            this.ready.signal();
        });
    }
    open(textDocument, callbacks) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.ready.event;
            const doc = new document_1.CoqDocument(this, textDocument, this.console, callbacks);
            this.coqInstances.set(doc.uri, doc);
            return doc;
        });
    }
    close(uri) {
        var doc = this.coqInstances.get(uri);
        this.coqInstances.delete(uri);
        if (doc) {
            doc.dispose();
        }
    }
    coqProjectFile() {
        if (this.coqProjectRoot)
            return path.join(this.coqProjectRoot, coqProjectFileName);
        else
            return undefined;
    }
    shutdown() {
        this.coqInstances.forEach((x) => x.dispose());
        this.coqInstances.clear();
    }
    watchCoqProject() {
        if (this.coqProjectWatcher != null)
            this.coqProjectWatcher.close();
        if (!this.coqProjectRoot)
            return;
        this.coqProjectWatcher = fs.watch(this.coqProjectRoot, (event, filename) => __awaiter(this, void 0, void 0, function* () {
            switch (event) {
                case 'change':
                    if ((filename && filename == coqProjectFileName)) {
                        this.console.log(coqProjectFileName + ' changed');
                        yield this.loadCoqProject();
                    }
            }
        }));
    }
    static parseCoqProject(text) {
        const args = [];
        const projectArgs = string_argv_1.default(text);
        for (let idx = 0; idx < projectArgs.length; ++idx) {
            const opt = projectArgs[idx];
            if (opt === '-R')
                args.push('-R', projectArgs[++idx], projectArgs[++idx]);
            else if (opt === '-I')
                args.push('-I', projectArgs[++idx]);
            else if (opt === '-Q')
                args.push('-Q', projectArgs[++idx], projectArgs[++idx]);
            else if (opt === '-arg')
                args.push(...string_argv_1.default(projectArgs[++idx]));
        }
        return args;
    }
    loadCoqProject() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.getCoqProjectRoot)
                return;
            if (this.loadingCoqProjectInProcess)
                return;
            this.loadingCoqProjectInProcess = true;
            try {
                const projectFile = yield nodeAsync.fs.readFile(this.coqProjectFile(), 'utf8');
                this.coqProjectArgs = CoqProject.parseCoqProject(projectFile);
                this.currentSettings.coqtop.args = [...this.coqProjectArgs, ...this.settingsCoqTopArgs];
            }
            catch (err) {
            }
            finally {
                this.loadingCoqProjectInProcess = false;
            }
        });
    }
    get settings() {
        return this.currentSettings;
    }
}
exports.CoqProject = CoqProject;
//# sourceMappingURL=CoqProject.js.map