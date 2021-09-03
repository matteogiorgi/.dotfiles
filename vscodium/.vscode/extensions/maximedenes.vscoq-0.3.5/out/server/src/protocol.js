'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_jsonrpc_1 = require("vscode-jsonrpc");
var SetDisplayOption;
(function (SetDisplayOption) {
    SetDisplayOption[SetDisplayOption["On"] = 0] = "On";
    SetDisplayOption[SetDisplayOption["Off"] = 1] = "Off";
    SetDisplayOption[SetDisplayOption["Toggle"] = 2] = "Toggle";
})(SetDisplayOption = exports.SetDisplayOption || (exports.SetDisplayOption = {}));
var DisplayOption;
(function (DisplayOption) {
    DisplayOption[DisplayOption["ImplicitArguments"] = 0] = "ImplicitArguments";
    DisplayOption[DisplayOption["Coercions"] = 1] = "Coercions";
    DisplayOption[DisplayOption["RawMatchingExpressions"] = 2] = "RawMatchingExpressions";
    DisplayOption[DisplayOption["Notations"] = 3] = "Notations";
    DisplayOption[DisplayOption["AllBasicLowLevelContents"] = 4] = "AllBasicLowLevelContents";
    DisplayOption[DisplayOption["ExistentialVariableInstances"] = 5] = "ExistentialVariableInstances";
    DisplayOption[DisplayOption["UniverseLevels"] = 6] = "UniverseLevels";
    DisplayOption[DisplayOption["AllLowLevelContents"] = 7] = "AllLowLevelContents";
})(DisplayOption = exports.DisplayOption || (exports.DisplayOption = {}));
var HypothesisDifference;
(function (HypothesisDifference) {
    HypothesisDifference[HypothesisDifference["None"] = 0] = "None";
    HypothesisDifference[HypothesisDifference["Changed"] = 1] = "Changed";
    HypothesisDifference[HypothesisDifference["New"] = 2] = "New";
    HypothesisDifference[HypothesisDifference["MovedUp"] = 3] = "MovedUp";
    HypothesisDifference[HypothesisDifference["MovedDown"] = 4] = "MovedDown";
})(HypothesisDifference = exports.HypothesisDifference || (exports.HypothesisDifference = {}));
var InterruptCoqRequest;
(function (InterruptCoqRequest) {
    InterruptCoqRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/interrupt');
})(InterruptCoqRequest = exports.InterruptCoqRequest || (exports.InterruptCoqRequest = {}));
var QuitCoqRequest;
(function (QuitCoqRequest) {
    QuitCoqRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/quitCoq');
})(QuitCoqRequest = exports.QuitCoqRequest || (exports.QuitCoqRequest = {}));
var ResetCoqRequest;
(function (ResetCoqRequest) {
    ResetCoqRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/resetCoq');
})(ResetCoqRequest = exports.ResetCoqRequest || (exports.ResetCoqRequest = {}));
var StepForwardRequest;
(function (StepForwardRequest) {
    StepForwardRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/stepForward');
})(StepForwardRequest = exports.StepForwardRequest || (exports.StepForwardRequest = {}));
var StepBackwardRequest;
(function (StepBackwardRequest) {
    StepBackwardRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/stepBackward');
})(StepBackwardRequest = exports.StepBackwardRequest || (exports.StepBackwardRequest = {}));
var InterpretToPointRequest;
(function (InterpretToPointRequest) {
    InterpretToPointRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/interpretToPoint');
})(InterpretToPointRequest = exports.InterpretToPointRequest || (exports.InterpretToPointRequest = {}));
var InterpretToEndRequest;
(function (InterpretToEndRequest) {
    InterpretToEndRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/interpretToEnd');
})(InterpretToEndRequest = exports.InterpretToEndRequest || (exports.InterpretToEndRequest = {}));
var GoalRequest;
(function (GoalRequest) {
    GoalRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/goal');
})(GoalRequest = exports.GoalRequest || (exports.GoalRequest = {}));
var CachedGoalRequest;
(function (CachedGoalRequest) {
    CachedGoalRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/cachedGoal');
})(CachedGoalRequest = exports.CachedGoalRequest || (exports.CachedGoalRequest = {}));
var FinishComputationsRequest;
(function (FinishComputationsRequest) {
    FinishComputationsRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/finishComputations');
})(FinishComputationsRequest = exports.FinishComputationsRequest || (exports.FinishComputationsRequest = {}));
var QueryRequest;
(function (QueryRequest) {
    QueryRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/query');
})(QueryRequest = exports.QueryRequest || (exports.QueryRequest = {}));
var ResizeWindowRequest;
(function (ResizeWindowRequest) {
    ResizeWindowRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/resizeWindow');
})(ResizeWindowRequest = exports.ResizeWindowRequest || (exports.ResizeWindowRequest = {}));
var SetDisplayOptionsRequest;
(function (SetDisplayOptionsRequest) {
    SetDisplayOptionsRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/setDisplayOptions');
})(SetDisplayOptionsRequest = exports.SetDisplayOptionsRequest || (exports.SetDisplayOptionsRequest = {}));
var LtacProfResultsRequest;
(function (LtacProfResultsRequest) {
    LtacProfResultsRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/ltacProfResults');
})(LtacProfResultsRequest = exports.LtacProfResultsRequest || (exports.LtacProfResultsRequest = {}));
var GetSentencePrefixTextRequest;
(function (GetSentencePrefixTextRequest) {
    GetSentencePrefixTextRequest.type = new vscode_jsonrpc_1.RequestType('coqtop/getSentencePrefixText');
})(GetSentencePrefixTextRequest = exports.GetSentencePrefixTextRequest || (exports.GetSentencePrefixTextRequest = {}));
var HighlightType;
(function (HighlightType) {
    HighlightType[HighlightType["StateError"] = 0] = "StateError";
    HighlightType[HighlightType["Parsing"] = 1] = "Parsing";
    HighlightType[HighlightType["Processing"] = 2] = "Processing";
    HighlightType[HighlightType["Incomplete"] = 3] = "Incomplete";
    HighlightType[HighlightType["Processed"] = 4] = "Processed";
    HighlightType[HighlightType["Axiom"] = 5] = "Axiom";
})(HighlightType = exports.HighlightType || (exports.HighlightType = {}));
var UpdateHighlightsNotification;
(function (UpdateHighlightsNotification) {
    UpdateHighlightsNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/updateHighlights');
})(UpdateHighlightsNotification = exports.UpdateHighlightsNotification || (exports.UpdateHighlightsNotification = {}));
var CoqMessageNotification;
(function (CoqMessageNotification) {
    CoqMessageNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/message');
})(CoqMessageNotification = exports.CoqMessageNotification || (exports.CoqMessageNotification = {}));
var CoqResetNotification;
(function (CoqResetNotification) {
    CoqResetNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/wasReset');
})(CoqResetNotification = exports.CoqResetNotification || (exports.CoqResetNotification = {}));
var CoqtopStartNotification;
(function (CoqtopStartNotification) {
    CoqtopStartNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/coqtopStarted');
})(CoqtopStartNotification = exports.CoqtopStartNotification || (exports.CoqtopStartNotification = {}));
var CoqtopStopReason;
(function (CoqtopStopReason) {
    CoqtopStopReason[CoqtopStopReason["UserRequest"] = 0] = "UserRequest";
    CoqtopStopReason[CoqtopStopReason["Anomaly"] = 1] = "Anomaly";
    CoqtopStopReason[CoqtopStopReason["InternalError"] = 2] = "InternalError";
})(CoqtopStopReason = exports.CoqtopStopReason || (exports.CoqtopStopReason = {}));
var CoqtopStopNotification;
(function (CoqtopStopNotification) {
    CoqtopStopNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/coqtopStopped');
})(CoqtopStopNotification = exports.CoqtopStopNotification || (exports.CoqtopStopNotification = {}));
var CoqStmFocusNotification;
(function (CoqStmFocusNotification) {
    CoqStmFocusNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/stmFocus');
})(CoqStmFocusNotification = exports.CoqStmFocusNotification || (exports.CoqStmFocusNotification = {}));
var ComputingStatus;
(function (ComputingStatus) {
    ComputingStatus[ComputingStatus["Finished"] = 0] = "Finished";
    ComputingStatus[ComputingStatus["Computing"] = 1] = "Computing";
    ComputingStatus[ComputingStatus["Interrupted"] = 2] = "Interrupted";
})(ComputingStatus = exports.ComputingStatus || (exports.ComputingStatus = {}));
var CoqLtacProfResultsNotification;
(function (CoqLtacProfResultsNotification) {
    CoqLtacProfResultsNotification.type = new vscode_jsonrpc_1.NotificationType('coqtop/ltacProfResults');
})(CoqLtacProfResultsNotification = exports.CoqLtacProfResultsNotification || (exports.CoqLtacProfResultsNotification = {}));
//# sourceMappingURL=protocol.js.map