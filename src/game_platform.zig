const std = @import("std");
const assert = std.debug.assert;

pub const GameMemory = struct {
    is_initialized: bool,
    permanent_storage: []u64,
    transient_storage: []u64,
};

pub const GameState = struct {
    blue_offset: i32,
    green_offset: i32,
    tone_hz: u32,
};

pub const GameClocks = struct {
    // TODO:(Dean): what else should be passed here?
    seconds_elapsed: f32,
};

pub const GameInput = struct {
    controllers: [4]GameControllerInput,
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
    samples_per_second: u32,
    samples: []u8,
};

pub const GameOffscreenBuffer = struct {
    memory: []u8,
    width: i32,
    height: i32,
    bytes_per_pixel: i32,
};

pub fn outputSound(sound_buffer: *GameOutputSoundBuffer, tone_hz: u32) void {
    const volume: f32 = 0.25;
    const wave_period: u32 = @divFloor(sound_buffer.*.samples_per_second, tone_hz);
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
    }
}

pub fn renderWeirdGradient(buffer: *GameOffscreenBuffer, x_offset: c_int, y_offset: c_int) void {
    _ = x_offset;
    _ = y_offset;

    if (buffer.*.width == 0 or buffer.*.height == 0) {
        return;
    }

    std.debug.print("renderWeirdGradient: memory buffer size: {d}\n", .{buffer.*.memory.len});

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

        // const pixel_row: c_int = @intCast(pixel / pitch);
        // const pixel_col: c_int = @mod(col, buffer.*.window_dimensions.width);

        // buffer.*.memory[blue_pixel] = @intCast(@mod(pixel_col + x_offset, std.math.maxInt(u8)));
        // buffer.*.memory[green_pixel] = @intCast(@mod(pixel_row + y_offset, std.math.maxInt(u8)));
        buffer.*.memory[blue_pixel] = 0;
        buffer.*.memory[green_pixel] = 255;
        buffer.*.memory[red_pixel] = 0;
    }

    std.debug.print("{d} pixels updated\n", .{pixel});
}

pub fn updateAndRender(memory: *GameMemory, input: *GameInput, screen: *GameOffscreenBuffer, audio: *GameOutputSoundBuffer) void {
    assert(@sizeOf(GameState) <= memory.*.permanent_storage.len);
    var state: *GameState = @ptrCast(memory.permanent_storage.ptr); // TODO:(Dean): Maybe doesn't work
    if (!memory.*.is_initialized) {
        state.*.tone_hz = 256;
        memory.*.is_initialized = true;
    }

    const input0: GameControllerInput = input.*.controllers[0];
    if (input0.is_analog) {
        state.*.tone_hz = 256;
        state.blue_offset = state.blue_offset + 4;
        // TODO:(Dean): convert this to ziglang - GameState->ToneHz = 256 + (int)(128.0f * (Input0->EndY));
        // TODO:(Dean): convert this to ziglang - GameState->BlueOffset += (int)4.0f * (Input0->EndX);
    } else {
        // TODO:(Dean): Use digital tuning
    }

    if (input0.buttons[@intFromEnum(GameButtons.South)].is_down) {
        // TODO:(Dean): make sure it wraps?
        state.green_offset = state.green_offset + 1;
    }

    if (input0.buttons[@intFromEnum(GameButtons.North)].is_down) {
        state.green_offset = state.green_offset - 1;
    }

    outputSound(audio, state.*.tone_hz);
    renderWeirdGradient(screen, state.*.blue_offset, state.*.green_offset);
}
