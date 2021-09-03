'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
const AnnotatedText_1 = require("../util/AnnotatedText");
/** Coqtop was interrupted; call cancelled */
class Interrupted {
    constructor(stateId) {
        this.stateId = stateId;
    }
    toString() {
        return 'Coqtop Interrupted';
    }
}
exports.Interrupted = Interrupted;
/** A fatal error of coqtop */
class CoqtopSpawnError {
    constructor(path, message) {
        this.path = path;
        this.message = message;
    }
    get binPath() {
        return this.path;
    }
    toString() {
        return "Could not start coqtop: " + this.path + (this.message ? "\n" + this.message : "");
    }
}
exports.CoqtopSpawnError = CoqtopSpawnError;
/** A call did not succeed; a nonfatal error */
class CallFailure {
    constructor(message, stateId, range) {
        this.message = message;
        this.stateId = stateId;
        this.range = range;
        this.message = AnnotatedText_1.normalizeText(this.message);
    }
    toString() {
        return AnnotatedText_1.textToDisplayString(this.message) +
            (this.range || this.stateId
                ? "  (" +
                    (this.range ? `offsets ${this.range.start}-${this.range.stop}` : (this.stateId ? " " : "")) +
                    (this.stateId ? ` of stateId ${this.stateId}` : "")
                    + ")"
                : "");
    }
}
exports.CallFailure = CallFailure;
function detectVersion(coqtopModule, cwd, console) {
    if (console)
        console.log('exec: ' + coqtopModule + ' -v');
    return new Promise((resolve, reject) => {
        try {
            const coqtop = child_process_1.spawn(coqtopModule, ['-v'], { detached: false, cwd: cwd });
            let result = "";
            coqtop.stdout.on('data', (data) => {
                result += data;
            });
            coqtop.on('close', () => {
                const ver = /^\s*The Coq Proof Assistant, version (.+?)\s/.exec(result);
                // if(!ver)
                //   console.warn('Could not detect coqtop version');
                resolve(!ver ? undefined : ver[1]);
            });
            coqtop.on('error', (code) => {
                // console.warn(`Could not start coqtop; error code: ${code}`)
                reject(new CoqtopSpawnError(coqtopModule, `error code: ${code}`));
            });
        }
        catch (err) {
            reject(new CoqtopSpawnError(coqtopModule, err));
        }
    });
}
exports.detectVersion = detectVersion;
class IdeSlave {
    constructor() {
        this.callbacks = {};
    }
    onFeedback(handler) {
        this.callbacks.onFeedback = handler;
        return { dispose: () => { this.callbacks.onFeedback = undefined; } };
    }
    onMessage(handler) {
        this.callbacks.onMessage = handler;
        return { dispose: () => { this.callbacks.onMessage = undefined; } };
    }
    onClosed(handler) {
        this.callbacks.onClosed = handler;
        return { dispose: () => { this.callbacks.onClosed = undefined; } };
    }
}
exports.IdeSlave = IdeSlave;
class CommunicationError extends Error {
}
exports.CommunicationError = CommunicationError;
class CoqTop extends IdeSlave {
}
exports.CoqTop = CoqTop;
//# sourceMappingURL=CoqTop.js.map