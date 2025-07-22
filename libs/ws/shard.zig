const std = @import("std");

const Gateway = @import("zigcord-gateway");
const Logger = @import("zigcord-logger").Logger;
const websocket = @import("websocket");
const WebSocketManager = @import("manager.zig").WebSocketManager;

pub const Shard = struct {
    const Self = @This();

    manager: WebSocketManager,
    ws: ?websocket.Client,
    logger: Logger,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, manager: WebSocketManager, logger: Logger) !Self {
        return .{
            .allocator = allocator,
            .manager = manager,
            .logger = logger,
            .ws = try websocket.Client.init(allocator, .{
                .host = Gateway.Constants.WS_HOSTNAME,
                .port = 443,
                .tls = true,
            }),
        };
    }

    pub fn connect(self: *Self) !void {
        if (self.ws) |*ws| {
            try ws.handshake("/", .{
                .headers = "HOST: " ++ Gateway.Constants.WS_HOSTNAME,
            });
            try self.listen();
        } else unreachable;
    }

    fn listen(self: *Self) !void {
        if (self.ws) |*ws| {
            while (true) {
                const message = try ws.read() orelse {
                    self.logger.warn("No message received", @src(), .{});
                    continue;
                };
                switch (message.type) {
                    .text, .binary => {
                        // TODO: is compressed?
                        var parsed = try Gateway.Event(std.json.Value).fromJsonSlice(self.allocator, message.data);
                        defer parsed.deinit();
                        const event: Gateway.Event(std.json.Value) = parsed.value;
                        try self.handleEvent(event);
                    },
                    .ping => unreachable,
                    .pong => unreachable,
                    .close => {
                        try ws.close(.{}); // TODO: move to Shard.close();
                        self.logger.debug("Closed connection", @src(), .{});
                        break;
                    },
                }
            }
        } else unreachable;
    }

    fn handleEvent(self: *Self, event: Gateway.Event(std.json.Value)) !void {
        switch (event.op) {
            .Hello => {
                var payloadParsed = try event.payload(Gateway.Events.HelloEvent.HelloPayload, self.allocator);
                defer payloadParsed.deinit();
                const payload = payloadParsed.value;
                self.logger.debug("heartbeat_interval: {}", @src(), .{payload.heartbeat_interval});
                const thread = try std.Thread.spawn(.{}, Shard.sendHeartbeat, .{ self, payload });
                thread.detach();

                try self.sendIdentify();
            },

            .Dispatch => try self.handleDispatch(event),

            else => |op| {
                self.logger.debug("unimplemented OP: {}", @src(), .{op});
            },
        }
    }

    fn handleDispatch(self: *Self, event: Gateway.Event(std.json.Value)) !void {
        if (event.t) |t| {
            self.logger.debug("Event received: {s}", @src(), .{t});
            if (std.mem.eql(u8, t, "READY")) {
                var parsed = try event.payload(Gateway.Events.ReadyEvent.ReadyPayload, self.allocator);
                defer parsed.deinit();
                const payload = parsed.value;
                self.logger.debug("Ready Payload: {any}", @src(), .{payload});
            } else {
                self.logger.debug("Unimplemented Event: {s}", @src(), .{t});
            }
        } else unreachable;
    }

    fn sendHeartbeat(self: *Self, payload: Gateway.Events.HelloEvent.HelloPayload) !void {
        const random = std.crypto.random;
        const delay = random.intRangeAtMost(u64, 0, payload.heartbeat_interval);
        self.logger.debug("delay: {}", @src(), .{delay});
        while (true) {
            const heartbeatResponse: Gateway.Event(?u32) = Gateway.Events.HeartbeatEvent.HeartbeatEvent(null); // TODO: Implement last seq
            const json = try heartbeatResponse.toJsonSlice(self.allocator);
            defer self.allocator.free(json);
            try self.send(json);
            std.Thread.sleep(std.time.ns_per_ms * delay);
            self.logger.debug("heartbeat sent", @src(), .{});
        }
    }

    fn sendIdentify(self: *Self) !void {
        const identifyResponse = Gateway.Events.IdentifyEvent.IdentifyEvent(.{
            .compress = self.manager.options.compress,
            .intents = self.manager.options.intents,
            .token = self.manager.options.token,
            .large_threshold = self.manager.options.large_threshold,
            .properties = .{
                .os = "zigcord",
                .browser = "zigcord",
                .device = "zigcord",
            },
            .presence = null,
            .shard = null,
        });
        const json = try identifyResponse.toJsonSlice(self.allocator);
        defer self.allocator.free(json);
        try self.send(json);
    }

    fn send(self: *Self, data: []u8) !void {
        if (self.ws) |*ws| {
            try ws.write(data);
        } else unreachable;
    }

    pub fn deinit(self: *Self) void {
        if (self.ws) |*ws| ws.deinit();
    }
};
