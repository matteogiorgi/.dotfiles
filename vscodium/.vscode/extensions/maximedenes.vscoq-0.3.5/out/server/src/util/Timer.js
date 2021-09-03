"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function timeout(operation, timeMs, ...timeoutData) {
    var timeout = null;
    return Promise.race([
        new Promise((resolve, reject) => timeout = setTimeout(reject, timeMs, ...timeoutData)),
        operation
            .then(v => { clearTimeout(timeout); return v; }),
    ]);
}
exports.timeout = timeout;
//# sourceMappingURL=Timer.js.map