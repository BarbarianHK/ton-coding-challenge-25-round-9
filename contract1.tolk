const MY_WORKCHAIN = BASECHAIN;
const OP_INC = stringCrc32("inc"); // 7f56a39b
const OP_DEC = stringCrc32("dec"); // a94df219

var counter: int = 0;

fun routeInternal(`ctx::sender`: slice, `ctx::value`: int, `ctx::fwd_fee`: int, `ctx::body`: slice) {
    var (op: int, queryId: int) = `ctx::body`.loadOpAndQueryId();

    if (op == OP_INC) {
        counter += 1;
        return;
    }

    if (op == OP_DEC) {
        counter -= 1;
        return;
    }

    throw 0xffff;
}

fun main(`ctx::value`: int, inMsgFull: cell, `ctx::body`: slice) {
    var s: slice = inMsgFull.beginParse();
    var flags: int = s.loadMsgFlags();

    if (isBounced(flags)) {
        return;
    }

    var (`ctx::sender`: slice, `ctx::fwd_fee`: int) = s.retrieveCtx(MY_WORKCHAIN);
    routeInternal(`ctx::sender`, `ctx::value`, `ctx::fwd_fee`, `ctx::body`);
}
