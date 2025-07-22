const std = @import("std");
const zigcord = @import("zigcord");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var envMap = try std.process.getEnvMap(allocator);
    defer envMap.deinit();
    const token = envMap.get("TOKEN") orelse unreachable;
    const manager = zigcord.WS.WebSocketManager.init(.{
        .token = token,
        .intents = 53608447,
        .logger = zigcord.Logger.init(.Debug),
        .allocator = allocator,
    });

    try manager.connect();
}
