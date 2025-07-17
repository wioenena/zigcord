const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const websocket = b.dependency("websocket", .{
        .target = target,
        .optimize = optimize,
    });

    const zigcord_mod = b.addModule("zigcord", .{
        .root_source_file = b.path("./src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zigcord_gateway_mod = b.addModule("zigcord-gateway", .{
        .root_source_file = b.path("libs/gateway/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zigcord_ws_mod = b.addModule("zigcord-ws", .{
        .root_source_file = b.path("libs/ws/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zigcord_logger_mod = b.addModule("zigcord-logger", .{
        .root_source_file = b.path("libs/logger/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    zigcord_ws_mod.addImport("websocket", websocket.module("websocket"));
    zigcord_ws_mod.addImport("zigcord-gateway", zigcord_gateway_mod);
    zigcord_ws_mod.addImport("zigcord-logger", zigcord_logger_mod);

    zigcord_mod.addImport("zigcord-gateway", zigcord_gateway_mod);
    zigcord_mod.addImport("zigcord-ws", zigcord_ws_mod);
    zigcord_mod.addImport("zigcord-logger", zigcord_logger_mod);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "zigcord",
        .root_module = zigcord_mod,
    });

    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{ .root_module = zigcord_mod });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
