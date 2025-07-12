const std = @import("std");

const OPCode = @import("opcode.zig").OPCode;

pub fn Event(comptime T: type) type {
    return struct {
        const Self = @This();

        op: OPCode,
        d: T,
        s: ?u32, // TODO: check this is u32
        t: ?[]const u8,

        pub fn fromJsonSlice(allocator: std.mem.Allocator, json: []const u8) !std.json.Parsed(Self) {
            comptime if (T != std.json.Value) unreachable; // Unreachable if this is receive event.
            return try std.json.parseFromSlice(Self, allocator, json, .{});
        }

        pub fn payload(self: Self, comptime P: type, allocator: std.mem.Allocator) !std.json.Parsed(P) {
            comptime if (T != std.json.Value) unreachable; // Unreachable if this is receive event.
            return try std.json.parseFromValue(P, allocator, self.d, .{});
        }

        pub fn toJsonSlice(self: Self, allocator: std.mem.Allocator) ![]const u8 {
            comptime if (T == std.json.Value) unreachable; // Unreachable if this is send event.
            return try std.json.stringifyAlloc(allocator, self, .{});
        }
    };
}

test "fromJsonSlice & payload" {
    const allocator = std.testing.allocator;
    const json =
        \\ {
        \\   "op": 0,
        \\   "d": null,
        \\   "s": 42,
        \\   "t": "GATEWAY_EVENT_NAME"
        \\ }
    ;

    var parsed = try Event(std.json.Value).fromJsonSlice(allocator, json);
    defer parsed.deinit();
    const event = parsed.value;
    try std.testing.expectEqual(.Dispatch, event.op);
    try std.testing.expectEqual(42, event.s);

    try std.testing.expectEqualStrings("GATEWAY_EVENT_NAME", event.t.?);

    var payloadParsed = try event.payload(?std.json.Value, allocator);
    defer payloadParsed.deinit();
    const d = payloadParsed.value;
    try std.testing.expect(d == null);
}

test "toJsonSlice" {
    const allocator = std.testing.allocator;

    const event: Event(struct {
        token: []const u8,
        session_id: []const u8,
        seq: u32,
    }) = .{
        .op = OPCode.Resume,
        .d = .{
            .token = "randomstring",
            .session_id = "evenmorerandomstring",
            .seq = 100,
        },
        .s = null,
        .t = null,
    };

    const json = try event.toJsonSlice(allocator);
    defer allocator.free(json);
    try std.testing.expectEqualStrings(
        \\{"op":6,"d":{"token":"randomstring","session_id":"evenmorerandomstring","seq":100},"s":null,"t":null}
    , json);
}
