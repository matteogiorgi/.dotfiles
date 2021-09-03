"use strict";
// If you can, you obviously should.
Object.defineProperty(exports, "__esModule", { value: true });
exports.Err = exports.Ok = exports.Result = exports.None = exports.Some = exports.Option = exports.constant = exports.id = void 0;
function id(value) {
    return value;
}
exports.id = id;
function constant(value) {
    return () => value;
}
exports.constant = constant;
// Option<A>
class Option {
    constructor(value) {
        this.option = value;
    }
    static try(m) {
        return m.then(Some, constant(exports.None));
    }
    match(onSome, onNone) {
        if (this.option === undefined) {
            return onNone();
        }
        else {
            return onSome(this.option);
        }
    }
    isSome() {
        return this.option !== undefined;
    }
    isNone() {
        return this.option === undefined;
    }
    ifSome(onSome) {
        this.match(onSome, constant({}));
    }
    ifNone(onNone) {
        this.match(constant({}), onNone);
    }
    andThen(f) {
        return this.match(f, constant(exports.None));
    }
    orElse(f) {
        return this.match(Some, f);
    }
    map(f) {
        return this.andThen((v) => Some(f(v)));
    }
    and(option) {
        return this.andThen(constant(option));
    }
    or(option) {
        return this.orElse(constant(option));
    }
    getOr(defaultValue) {
        return this.match(id, constant(defaultValue));
    }
    getOrElse(f) {
        return this.match(id, f);
    }
    okOr(error) {
        return this.match(Ok, () => Err(error));
    }
    okOrElse(f) {
        return this.match(Ok, () => Err(f()));
    }
    unwrap() {
        return this.option;
    }
}
exports.Option = Option;
function Some(value) {
    return new Option(value);
}
exports.Some = Some;
exports.None = new Option(undefined);
class Result {
    constructor(value) {
        this.result = value;
    }
    static try(m) {
        return m.then(Ok, Err);
    }
    match(onOk, onErr) {
        if (this.result.tag === "ok") {
            return onOk(this.result.value);
        }
        else {
            return onErr(this.result.value);
        }
    }
    isOk() {
        return this.result.tag === "ok";
    }
    isErr() {
        return this.result.tag === "err";
    }
    ifOk(onOk) {
        this.match(onOk, constant({}));
    }
    ifErr(onErr) {
        this.match(constant({}), onErr);
    }
    andThen(f) {
        return this.match(f, Err);
    }
    orElse(f) {
        return this.match(Ok, f);
    }
    map(f) {
        return this.andThen((value) => Ok(f(value)));
    }
    mapErr(f) {
        return this.orElse((value) => Err(f(value)));
    }
    and(result) {
        return this.andThen(constant(result));
    }
    or(result) {
        return this.orElse(constant(result));
    }
    getOr(defaultValue) {
        return this.match(id, constant(defaultValue));
    }
    getOrElse(f) {
        return this.match(id, f);
    }
    unwrap() {
        return this.result.tag === "ok" ? this.result.value : undefined;
    }
    unwrapErr() {
        return this.result.tag === "err" ? this.result.value : undefined;
    }
}
exports.Result = Result;
function Ok(value) {
    return new Result({ tag: "ok", value });
}
exports.Ok = Ok;
function Err(value) {
    return new Result({ tag: "err", value });
}
exports.Err = Err;
//# sourceMappingURL=fp.js.map