"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const nfs = require("fs");
const nzlib = require("zlib");
var fs;
(function (fs) {
    function open(path, flags) {
        return new Promise((resolve, reject) => {
            nfs.open(path, flags, (err, fd) => {
                if (err)
                    reject(err);
                else
                    resolve(fd);
            });
        });
    }
    fs.open = open;
    function writeFile(filename, data, options) {
        return new Promise((resolve, reject) => {
            nfs.writeFile(filename, data, options, (err) => {
                if (err)
                    reject(err);
                else
                    resolve();
            });
        });
    }
    fs.writeFile = writeFile;
    function readFile(filename, options) {
        return new Promise((resolve, reject) => {
            if (typeof options === "string") {
                nfs.readFile(filename, options, (err, data) => {
                    if (err)
                        reject(err);
                    else
                        resolve(data);
                });
            }
            else {
                nfs.readFile(filename, options, (err, data) => {
                    if (err)
                        reject(err);
                    else
                        resolve(data);
                });
            }
        });
    }
    fs.readFile = readFile;
    function exists(path) {
        return new Promise((resolve, reject) => {
            nfs.exists(path, (ex) => resolve(ex));
        });
    }
    fs.exists = exists;
})(fs = exports.fs || (exports.fs = {}));
var zlib;
(function (zlib) {
    function gunzip(data, encoding = 'utf8') {
        return new Promise((resolve, reject) => {
            nzlib.gunzip(data, (err, data) => {
                if (err)
                    reject(err);
                else
                    resolve(data.toString(encoding));
            });
        });
    }
    zlib.gunzip = gunzip;
})(zlib = exports.zlib || (exports.zlib = {}));
//# sourceMappingURL=nodejs-async.js.map