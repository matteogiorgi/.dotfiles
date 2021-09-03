'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
var DisplayState;
(function (DisplayState) {
    DisplayState[DisplayState["Proof"] = 0] = "Proof";
    DisplayState[DisplayState["Top"] = 1] = "Top";
    DisplayState[DisplayState["Error"] = 2] = "Error";
})(DisplayState = exports.DisplayState || (exports.DisplayState = {}));
function getDisplayState(state) {
    switch (state.type) {
        case 'failure':
            return DisplayState.Error;
        case 'proof-view':
            return DisplayState.Proof;
        case 'interrupted':
            return DisplayState.Error;
        case 'no-proof':
        case 'not-running':
        case 'busy':
            return DisplayState.Top;
    }
}
exports.getDisplayState = getDisplayState;
function countUnfocusedGoalStack(u) {
    if (u)
        return u.before.length + u.after.length + countUnfocusedGoalStack(u.next);
    else
        return 0;
}
function countAllGoals(state) {
    if (state.type === 'proof-view') {
        const result = state.goals.length
            + countUnfocusedGoalStack(state.backgroundGoals)
            + state.abandonedGoals.length
            + state.shelvedGoals.length;
        return result;
    }
    else
        return 0;
}
exports.countAllGoals = countAllGoals;
function adjacentPane(pane) {
    switch (pane) {
        case vscode.ViewColumn.One: return vscode.ViewColumn.Two;
        case vscode.ViewColumn.Two: return vscode.ViewColumn.Three;
        default: return vscode.ViewColumn.One;
    }
}
exports.adjacentPane = adjacentPane;
//# sourceMappingURL=CoqView.js.map