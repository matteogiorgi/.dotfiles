'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const deserialize_base_1 = require("./deserialize.base");
class Deserialize_8_7 extends deserialize_base_1.Deserialize {
    deserialize(v) {
        const value = v;
        try {
            switch (value.$name) {
                case 'message':
                    return {
                        level: value.$children[0],
                        location: value.$children[1],
                        message: value.$children[2],
                    };
                case 'ltacprof':
                    return {
                        total_time: +value.$.total_time,
                        tactics: value.$children,
                    };
                case 'ltacprof_tactic':
                    return {
                        name: value.$.name,
                        statistics: {
                            total: +value.$.total,
                            local: +value.$.local,
                            num_calls: +value.$.ncalls,
                            max_total: +value.$.max_total
                        },
                        tactics: value.$children
                    };
                default:
                    return super.deserialize(v);
            }
        }
        catch (err) {
            // debugger;
        }
    }
}
exports.Deserialize_8_7 = Deserialize_8_7;
// public deserializeFeedbackContent(v: Node) : any {
//   const value = v as Nodes_8_7.FeedbackContentNode;
//   switch (value.$kind) {
//   default:
//     return super.deserializeFeedbackContent(value);
//   }
// }
Deserialize_8_7.baseVersion = "8.6";
//# sourceMappingURL=deserialize.8.7.js.map