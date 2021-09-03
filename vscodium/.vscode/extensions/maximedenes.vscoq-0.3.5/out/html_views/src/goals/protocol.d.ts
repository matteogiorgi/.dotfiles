export interface ControllerEvent {
    eventName: string;
    params: ResizeEvent;
}
export interface ResizeEvent {
    columns: number;
}
interface GoalUpdate {
    command: 'goal-update';
    goal: CommandResult;
}
interface SettingsUpdate extends SettingsState {
    command: 'settings-update';
}
export interface ProofViewDiffSettings {
    addedTextIsItalic: boolean;
    removedTextIsStrikedthrough: boolean;
}
export interface SettingsState {
    fontFamily?: string;
    fontSize?: string;
    fontWeight?: string;
    prettifySymbolsMode?: boolean;
    proofViewDiff?: ProofViewDiffSettings;
}
export declare type ProofViewProtocol = GoalUpdate | SettingsUpdate;
export declare type TextDifference = "added" | "removed";
interface TextAnnotation {
    /** the relationship this text has to the text of another state */
    diff?: TextDifference;
    /** what to display instead of this text */
    substitution?: string;
    /** the underlying text, possibly with more annotations */
    text: string;
}
export interface ScopedText {
    /** A scope identifier */
    scope: string;
    /** the underlying text, possibly with more annotations */
    text: AnnotatedText;
}
export declare type AnnotatedText = string | TextAnnotation | ScopedText | (string | TextAnnotation | ScopedText)[];
export declare enum HypothesisDifference {
    None = 0,
    Changed = 1,
    New = 2,
    MovedUp = 3,
    MovedDown = 4
}
export interface Hypothesis {
    identifier: string;
    relation: string;
    expression: AnnotatedText;
    diff: HypothesisDifference;
}
export interface Goal {
    id: number;
    hypotheses: Hypothesis[];
    goal: AnnotatedText;
}
export interface UnfocusedGoalStack {
    before: Goal[];
    next?: UnfocusedGoalStack;
    after: Goal[];
}
interface FailValue {
    message: AnnotatedText;
    location?: Location;
}
export interface ProofView {
    goals: Goal[];
    backgroundGoals: UnfocusedGoalStack;
    shelvedGoals: Goal[];
    abandonedGoals: Goal[];
}
interface CommandInterrupted {
    range: any;
}
declare type FocusPosition = {
    focus: any;
};
declare type NotRunningTag = {
    type: 'not-running';
};
declare type NoProofTag = {
    type: 'no-proof';
};
declare type FailureTag = {
    type: 'failure';
};
declare type ProofViewTag = {
    type: 'proof-view';
};
declare type InterruptedTag = {
    type: 'interrupted';
};
declare type NoProofResult = NoProofTag;
declare type FailureResult = FailValue & FailureTag;
declare type ProofViewResult = ProofView & ProofViewTag;
declare type InterruptedResult = CommandInterrupted & InterruptedTag;
export declare type CommandResult = NotRunningTag | (FailureResult & FocusPosition) | (ProofViewResult & FocusPosition) | (InterruptedResult & FocusPosition) | (NoProofResult & FocusPosition);
export {};
