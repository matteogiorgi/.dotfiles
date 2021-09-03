"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var protocol_1 = require("./protocol");
exports.HypothesisDifference = protocol_1.HypothesisDifference;
function isScopedText(text) {
    return text.hasOwnProperty('scope');
}
exports.isScopedText = isScopedText;
function isTextAnnotation(text) {
    return typeof text.text === 'string';
}
exports.isTextAnnotation = isTextAnnotation;
function textToString(text) {
    if (typeof text === 'string') {
        return text;
    }
    else if (text instanceof Array) {
        return text.map(textToString).join('');
    }
    else if (isScopedText(text)) {
        return textToString(text.text);
    }
    else { // TextAnnotation
        return textToString(text.text);
    }
}
exports.textToString = textToString;
function textToDisplayString(text) {
    if (typeof text === 'string') {
        return text;
    }
    else if (text instanceof Array) {
        return text.map(textToDisplayString).join('');
    }
    else if (isScopedText(text)) {
        return textToDisplayString(text.text);
    }
    else if (text.substitution) { // TextAnnotation
        return textToDisplayString(text.substitution);
    }
    else { // TextAnnotation
        return text.substitution ? text.substitution : text.text;
    }
}
exports.textToDisplayString = textToDisplayString;
//# sourceMappingURL=AnnotatedText.js.map