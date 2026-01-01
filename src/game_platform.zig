const std = @import("std");
const assert = std.debug.assert;

pub const GameMemory = struct {
    state: GameState,
    storage: []u8,
    transient_start: usize,

    // TODO:(Dean): Redesign memory when we know what we're doing --- we probably want a centralized memory allocation process
    pub fn init(self: *GameMemory, allocator: std.mem.Allocator, permanent_storage_size: usize, transient_storage_size: usize) !void {
        const storage_size = permanent_storage_size + transient_storage_size;

        self.*.state = .{ .blue_offset = 0, .green_offset = 0, .tone_hz = 256 };
        self.*.storage = try allocator.alloc(u8, storage_size);
        self.*.transient_start = permanent_storage_size; // NOTE:(Dean): storage: {[ permanent storage ][ transient storage ]}
    }
};

pub const GameState = struct {
    blue_offset: i32,
    green_offset: i32,
    tone_hz: i32,
};

pub const GameClocks = struct {
    // TODO:(Dean): what else should be passed here?
    seconds_elapsed: f32,
};

pub const GameInput = struct {
    controllers: [4]GameControllerInput,

    pub fn init(self: *GameInput) void {
        for (0..self.*.controllers.len) |i| {
            var controller = self.*.controllers[i];
            controller.is_analog = false;
            controller.start_x = 0.0;
            controller.start_y = 0.0;
            controller.end_x = 0.0;
            controller.end_y = 0.0;
            controller.max_x = 0.0;
            controller.max_y = 0.0;
            controller.min_x = 0.0;
            controller.min_y = 0.0;
            for (0..controller.buttons.len) |j| {
                var buttons_state = controller.buttons[j];
                buttons_state.is_down = false;
                buttons_state.state_transition_count = 0;
            }
        }
    }
};

pub const GameControllerInput = struct {
    is_analog: bool,
    start_x: f32,
    start_y: f32,
    end_x: f32,
    end_y: f32,
    max_x: f32,
    max_y: f32,
    min_x: f32,
    min_y: f32,
    buttons: [8]GameButtonState,
};

pub const GameButtons = enum(u3) {
    Start, // XBox: Start  |  PlayStation: Start
    Back, // XBox: Back  |  PlayStation: Select
    North, // XBox: Y  |  PlayStation: Triangle
    East, // XBox: B  |  PlayStation: Circle
    South, // XBox: A  |  PlayStation: X
    West, // XBox: X  |  PlayStation: Square
    LeftShoulder, // XBox: Left Bumper  |  PlayStation: L1
    RightShoulder, // XBox: Right Bumper |  PlayStation: R1
};

pub const GameButtonState = struct {
    is_down: bool,
    state_transition_count: u32, // NOTE:(Dean): half transitions --- key up -> key down || key down -> key up
};

pub const GameOutputSoundBuffer = struct {
    samples_per_second: i32,
    samples: []u8,
    // samples: [3][]u8,
};

pub const GameOffscreenBuffer = struct {
    memory: []u8,
    width: i32,
    height: i32,
    bytes_per_pixel: i32,
};

pub fn kilobytesToBytes(comptime kilobytes: usize) usize {
    return 1024 * kilobytes;
}

pub fn megabytesToBytes(comptime megabytes: usize) usize {
    return 1024 * kilobytesToBytes(megabytes);
}

pub fn gigabytesToBytes(comptime gigabytes: usize) usize {
    return 1024 * megabytesToBytes(gigabytes);
}

pub fn terabytesToBytes(comptime terabytes: usize) usize {
    return 1024 * gigabytesToBytes(terabytes);
}

// TODO:(Dean): Fix the audio artifacts in the tone that plays
pub fn outputSound(sound_buffer: *GameOutputSoundBuffer, tone_hz: i32) void {
    const volume: f32 = 0.25;
    const wave_period: i32 = @divFloor(sound_buffer.*.samples_per_second, tone_hz);
    var buffer_index: u32 = 0;
    var phase: f32 = 0;

    while (buffer_index < sound_buffer.*.samples.len) : (buffer_index = buffer_index + 2) {
        const period: f32 = @floatFromInt(wave_period);
        phase += (2 * std.math.pi) / period;

        const sample: f32 = std.math.sin(phase) * 0xffff * volume;
        const sample_value: i16 = @intFromFloat(sample);

        const bits: u16 = @bitCast(sample_value);
        const low_bits: u8 = @truncate(bits);
        const high_bits: u8 = @truncate((0xFF00 & bits) >> 8);
        sound_buffer.*.samples[buffer_index] = low_bits;
        sound_buffer.*.samples[buffer_index + 1] = high_bits;
        // sound_buffer.*.samples[0][buffer_index] = low_bits;
        // sound_buffer.*.samples[0][buffer_index + 1] = high_bits;
    }
}

pub fn renderWeirdGradient(buffer: *GameOffscreenBuffer, x_offset: i32, y_offset: i32) void {
    // _ = x_offset;
    // _ = y_offset;

    if (buffer.*.width == 0 or buffer.*.height == 0) {
        std.debug.print("renderWeirdGradient: buffer is length 0\n", .{});
        return;
    }

    const window_width = buffer.*.width;
    const pitch: usize = @intCast(window_width * buffer.*.bytes_per_pixel);

    std.debug.assert(pitch > 0);
    std.debug.assert(buffer.*.memory.len > 0);

    var pixel: usize = 0;
    var col: i32 = 0;
    while (pixel < buffer.*.memory.len) : ({
        col += 1;
        pixel += @intCast(buffer.*.bytes_per_pixel);
    }) {
        //  NOTE: Microsoft uses Little Endian Architecture
        //  Engineers there wanted RGB to appear in order so they defined
        //  rgb encoding to be reverse-order so that it shows up nicely in the
        //  registers
        //  - - - -
        //  Memory: BB GG RR xx
        //  Register: xx RR GG BB

        const blue_pixel: usize = pixel;
        const green_pixel: usize = pixel + 1;
        const red_pixel: usize = pixel + 2;

        // TODO:(Dean): When window is resized, new part of buffer is set to 10101010

        const pixel_row: c_int = @intCast(pixel / pitch);
        const pixel_col: c_int = @mod(col, buffer.*.width);

        buffer.*.memory[blue_pixel] = @intCast(@mod(pixel_col + x_offset, std.math.maxInt(u8)));
        buffer.*.memory[green_pixel] = @intCast(@mod(pixel_row + y_offset, std.math.maxInt(u8)));
        buffer.*.memory[red_pixel] = 0;
    }

    // std.debug.print("{d} pixels updated\n", .{pixel});
}

pub fn updateAndRender(memory: *GameMemory, input: *GameInput, screen: *GameOffscreenBuffer, audio: *GameOutputSoundBuffer) void {
    var state: GameState = memory.*.state;

    const input0: GameControllerInput = input.*.controllers[0];
    if (input0.is_analog) {
        const new_hz: i32 = @intFromFloat(128.0 * input0.end_y);

        state.tone_hz = 256 + new_hz;
        state.blue_offset += @intFromFloat(128.0 * input0.end_x);
    } else {
        // TODO:(Dean): Use digital tuning
    }

    if (input0.buttons[@intFromEnum(GameButtons.South)].is_down) {
        // TODO:(Dean): make sure it wraps?
        std.debug.print("updateAndRender: A button\n", .{});
        state.green_offset += 1;
    }

    if (input0.buttons[@intFromEnum(GameButtons.North)].is_down) {
        std.debug.print("updateAndRender: Y button\n", .{});
        state.green_offset -= 1;
    }

    // TODO:(Dean): Allow sample offsets here for more robust platform options?
    outputSound(audio, state.tone_hz);
    // std.debug.print("blue_offset: {d} -- green_offset: {d}\n", .{ state.blue_offset, state.green_offset });
    renderWeirdGradient(screen, state.blue_offset, state.green_offset);
}
