import { CommandResult } from './protocol';
export declare class StateModel {
    constructor();
    private setMessage;
    private setErrorMessage;
    private clearErrorMessage;
    updateState(state: CommandResult): void;
}
