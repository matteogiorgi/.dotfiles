'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const net = require("net");
const path = require("path");
const semver = require("semver");
const child_process_1 = require("child_process");
const coqtop = require("./CoqTop");
var CoqTop_1 = require("./CoqTop");
exports.Interrupted = CoqTop_1.Interrupted;
exports.CoqtopSpawnError = CoqTop_1.CoqtopSpawnError;
exports.CallFailure = CoqTop_1.CallFailure;
const CoqTop_2 = require("./CoqTop");
const IdeSlave8_1 = require("./IdeSlave8");
class CoqTop extends IdeSlave8_1.IdeSlave {
    constructor(settings, scriptFile, projectRoot, console) {
        super(console);
        this.coqtopProc = null;
        this.sockets = [];
        this.settings = settings;
        this.scriptFile = scriptFile;
        this.projectRoot = projectRoot;
        this.mainChannelServer = net.createServer();
        this.mainChannelServer2 = net.createServer();
        this.controlChannelServer = net.createServer();
        this.controlChannelServer2 = net.createServer();
        this.mainChannelServer.maxConnections = 1;
        this.mainChannelServer2.maxConnections = 1;
        this.controlChannelServer.maxConnections = 1;
        this.controlChannelServer2.maxConnections = 1;
        this.readyToListen = [
            this.startListening(this.mainChannelServer),
            this.startListening(this.mainChannelServer2),
            this.startListening(this.controlChannelServer),
            this.startListening(this.controlChannelServer2)
        ];
    }
    dispose() {
        if (this.isRunning() && this.callbacks.onClosed) {
            this.callbacks.onClosed(false);
        }
        super.dispose();
        this.sockets.forEach(s => s.destroy());
        this.sockets = [];
        if (this.coqtopProc) {
            try {
                this.coqtopProc.kill();
                if (this.coqtopProc.connected)
                    this.coqtopProc.disconnect();
            }
            catch (e) { }
            this.coqtopProc = null;
        }
        this.coqtopProc = null;
    }
    isRunning() {
        return this.coqtopProc != null;
    }
    startCoq() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.state !== IdeSlave8_1.IdeSlaveState.Disconnected)
                throw new CoqTop_2.CoqtopSpawnError(this.coqtopBin, "coqtop is already started");
            this.console.log('starting coqtop');
            let coqtopVersion = yield coqtop.detectVersion(this.coqtopBin, this.projectRoot, this.console);
            if (coqtopVersion)
                this.console.log(`Detected coqtop version ${coqtopVersion}`);
            else {
                let fallbackVersion = "8.10"; //no changed behaviour in vscoq since this version
                this.console.warn(`Could not detect coqtop version, defaulting to >= ${fallbackVersion}.`);
                coqtopVersion = fallbackVersion;
            }
            this.coqtopVersion = semver.coerce(coqtopVersion);
            this.console.log(`Coqtop version parsed into semver version ${this.coqtopVersion.format()}`);
            yield this.setupCoqTopReadAndWritePorts();
            return yield this.coqInit();
        });
    }
    checkState() {
        const _super = Object.create(null, {
            checkState: { get: () => super.checkState }
        });
        return __awaiter(this, void 0, void 0, function* () {
            if (this.coqtopProc === null)
                this.startCoq();
            _super.checkState.call(this);
        });
    }
    startListening(server) {
        const port = 0;
        const host = 'localhost';
        return new Promise((resolve, reject) => {
            server.on('error', (err) => reject(err));
            server.listen({ port: port, host: host }, () => {
                const serverAddress = server.address();
                this.console.log(`Listening at ${serverAddress.address}:${serverAddress.port}`);
                resolve();
            });
        });
    }
    acceptConnection(server, name) {
        return new Promise((resolve) => {
            server.once('connection', (socket) => {
                this.sockets.push(socket);
                this.console.log(`Client connected on ${name} (port ${socket.localPort})`);
                // socket.setEncoding('utf8');
                // // if (dataHandler)
                //   socket.on('data', (data:string) => dataHandler(data));
                // socket.on('error', (err:any) => this.onCoqTopError(err.toString() + ` (${name})`));
                resolve(socket);
            });
        });
    }
    getVersion() {
        return this.coqtopVersion;
    }
    /** Start coqtop.
     * Use two ports: one for reading & one for writing; i.e. HOST:READPORT:WRITEPORT
     */
    setupCoqTopReadAndWritePorts() {
        return __awaiter(this, void 0, void 0, function* () {
            yield Promise.all(this.readyToListen);
            var mainAddr = this.mainChannelServer.address();
            var mainPortW = this.mainChannelServer2.address().port;
            var controlAddr = this.controlChannelServer.address();
            var controlPortW = this.controlChannelServer2.address().port;
            var mainAddressArg = mainAddr.address + ':' + mainAddr.port + ':' + mainPortW;
            var controlAddressArg = controlAddr.address + ':' + controlAddr.port + ':' + controlPortW;
            try {
                this.startCoqTop(this.spawnCoqTop(mainAddressArg, controlAddressArg));
            }
            catch (error) {
                this.console.error('Could not spawn coqtop: ' + error);
                throw new CoqTop_2.CoqtopSpawnError(this.coqtopBin, error);
            }
            let channels = yield Promise.all([
                this.acceptConnection(this.mainChannelServer, 'main channel R'),
                this.acceptConnection(this.mainChannelServer2, 'main channel W'),
                this.acceptConnection(this.controlChannelServer, 'control channel R'),
                this.acceptConnection(this.controlChannelServer2, 'control channel W'),
            ]);
            this.connect(this.coqtopVersion.format(), channels[0], channels[1], channels[2], channels[3]);
        });
    }
    startCoqTop(process) {
        this.coqtopProc = process;
        this.console.log(`coqtop started with pid ${this.coqtopProc.pid}`);
        this.coqtopProc.stdout.on('data', (data) => this.coqtopOut(data));
        this.coqtopProc.on('exit', (code) => {
            this.console.log('coqtop exited with code: ' + code);
            if (this.isRunning() && this.callbacks.onClosed)
                this.callbacks.onClosed(false, 'coqtop closed with code: ' + code);
            this.dispose();
        });
        this.coqtopProc.stderr.on('data', (data) => {
            this.console.log('coqtop-stderr: ' + data);
        });
        this.coqtopProc.on('close', (code) => {
            this.console.log('coqtop closed with code: ' + code);
            if (this.isRunning() && this.callbacks.onClosed)
                this.callbacks.onClosed(false, 'coqtop closed with code: ' + code);
            this.dispose();
        });
        this.coqtopProc.on('error', (code) => {
            this.console.log('coqtop could not be started: ' + code);
            if (this.isRunning() && this.callbacks.onClosed)
                this.callbacks.onClosed(true, 'coqtop closed with code: ' + code);
            this.dispose();
        });
        // this.coqtopProc.stdin.write('\n');
    }
    coqtopOut(data) {
        this.console.log('coqtop-stdout:' + data);
    }
    get coqtopBin() {
        return path.join(this.settings.binPath.trim(), this.settings.coqtopExe);
    }
    get coqidetopBin() {
        return path.join(this.settings.binPath.trim(), this.settings.coqidetopExe);
    }
    spawnCoqTop(mainAddr, controlAddr) {
        var topfile = [];
        if (semver.satisfies(this.coqtopVersion, ">= 8.10")) {
            topfile = ['-topfile', this.scriptFile];
        }
        if (semver.satisfies(this.coqtopVersion, ">= 8.9")) {
            var coqtopModule = this.coqidetopBin;
            // var coqtopModule = 'cmd';
            var args = [
                // '/D /C', this.coqPath + '/coqtop.exe',
                '-main-channel', mainAddr,
                '-control-channel', controlAddr,
                '-async-proofs', 'on'
            ].concat(this.settings.args).concat(topfile);
        }
        else {
            var coqtopModule = this.coqtopBin;
            // var coqtopModule = 'cmd';
            var args = [
                // '/D /C', this.coqPath + '/coqtop.exe',
                '-main-channel', mainAddr,
                '-control-channel', controlAddr,
                '-ideslave',
                '-async-proofs', 'on'
            ].concat(this.settings.args);
        }
        this.console.log('exec: ' + coqtopModule + ' ' + args.join(' '));
        return child_process_1.spawn(coqtopModule, args, { detached: false, cwd: this.projectRoot });
    }
    coqInterrupt() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.coqtopProc)
                return false;
            else {
                this.console.log('--------------------------------');
                this.console.log('Sending SIGINT');
                this.coqtopProc.kill("SIGINT");
                return true;
            }
        });
    }
}
exports.CoqTop = CoqTop;
//# sourceMappingURL=CoqTop8.js.map