"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const text = require("./AnnotatedText");
let enabled = false;
const enabledChangeEvent = new vscode.EventEmitter();
function isEnabled() {
    return enabled;
}
exports.isEnabled = isEnabled;
exports.onEnabledChange = enabledChangeEvent.event;
function onPrettifySymbolsModeEnabledChange(isEnabled) {
    if (enabled === isEnabled)
        return;
    enabled = isEnabled;
    enabledChangeEvent.fire(enabled);
}
function prettyTextToString(txt) {
    const str = enabled ? text.textToDisplayString(txt) : text.textToString(txt);
    // `coqtop` loves outputting non-breaking spaces instead of normal whitespace, so we replace them
    // here with tabs and spaces to allow the user to copy any output and use it directly as input.
    return str.replace(/\u00a0{4}/, "\t").replace(/\u00a0/g, " ");
}
exports.prettyTextToString = prettyTextToString;
function load() {
    const subscriptions = [];
    const psm = vscode.extensions.getExtension('siegebell.prettify-symbols-mode');
    if (psm) {
        psm.activate()
            .then(() => {
            subscriptions.push(psm.exports.onDidEnabledChange(onPrettifySymbolsModeEnabledChange));
            onPrettifySymbolsModeEnabledChange(psm.exports.isEnabled());
            subscriptions.push(psm.exports.registerSubstitutions({ language: 'coq', substitutions: [{ ugly: "COQ", pretty: "⫝" }] }));
        });
    }
    return { dispose: () => { subscriptions.forEach(d => d.dispose); } };
}
exports.load = load;
//# sourceMappingURL=prettify-symbols-mode.js.map