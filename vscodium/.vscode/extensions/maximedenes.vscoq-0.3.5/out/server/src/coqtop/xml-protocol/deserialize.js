'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const deserialize_8_7_1 = require("./deserialize.8.7");
const DEFAULT_DESERIALIZER = deserialize_8_7_1.Deserialize_8_7;
function createDeserializer(version) {
    return new DEFAULT_DESERIALIZER();
}
exports.createDeserializer = createDeserializer;
//# sourceMappingURL=deserialize.js.map