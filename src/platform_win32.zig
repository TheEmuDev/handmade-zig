const std = @import("std");
const game = @import("game_platform.zig");
const wasapi = @import("bindings/wasapi.zig");
const win_ext = @import("bindings/windows.zig");
const xa2 = @import("bindings/xaudio2.zig");
const xinput = @import("bindings/xinput.zig");

const winapi = std.builtin.CallingConvention.winapi;
const win = std.os.windows;
const log = std.log;

// Windows Type Aliases
const ATOM = win.ATOM;
const BOOL = win.BOOL;
const BYTE = win.BYTE;
const DWORD = win.DWORD;
const FARPROC = win.FARPROC;
const GUID = win.GUID;
const HANDLE = win.HANDLE;
const HBRUSH = win.HBRUSH;
const HCURSOR = win.HCURSOR;
const HDC = win.HDC;
const HICON = win.HICON;
const HINSTANCE = win.HINSTANCE;
const HMENU = win.HMENU;
const HMODULE = win.HMODULE;
const HRESULT = win.HRESULT;
const HWND = win.HWND;
const LONG = win.LONG;
const LPARAM = win.LPARAM;
const LPCSTR = win.LPCSTR;
const LPCWSTR = win.LPCWSTR;
const LPVOID = win.LPVOID;
const LRESULT = win.LRESULT;
const SHORT = win.SHORT;
const UINT = win.UINT;
const UINT32 = win.UINT;
const UINT64 = win_ext.UINT64;
const ULONG = win.ULONG;
const WORD = win.WORD;
const WPARAM = win.WPARAM;

// Windows Structs
const BITMAPINFOHEADER = win_ext.BITMAPINFOHEADER;
const BITMAPINFO = win_ext.BITMAPINFO;

const BUFFER = xa2.XAUDIO2_BUFFER;
const FLAGS = xa2.FLAGS;

// Interfaces
const IUnknown = win_ext.IUnknown;

const IEngineCallback = xa2.IEngineCallback;
const IMasteringVoice = xa2.IMasteringVoice;
const ISourceVoice = xa2.ISourceVoice;
const ISubmixVoice = xa2.ISubmixVoice;
const IVoice = xa2.IVoice;
const IVoiceCallback = xa2.IVoiceCallback;
const IXAudio2 = xa2.IXAudio2;

const MSG = win_ext.MSG;
const PAINTSTRUCT = win_ext.PAINTSTRUCT;
const POINT = win_ext.POINT;
const RECT = win.RECT;
const RGBQUAD = win_ext.RGBQUAD;
const WNDCLASSEXA = win_ext.WNDCLASSEXA;

const WAVEFORMATEX = wasapi.WAVEFORMATEX;
const WNDPROC = win_ext.WNDPROC; // function pointer

const GAMEPAD = xinput.XINPUT_GAMEPAD;
const XINPUT_STATE = xinput.XINPUT_STATE;
const XINPUT_VIBRATION = xinput.XINPUT_VIBRATION;

//Constants
const MEM_COMMIT = win.MEM_COMMIT;
const MEM_RELEASE = win.MEM_RELEASE;
const MEM_RESERVE = win.MEM_RESERVE;
const PAGE_READWRITE = win.PAGE_READWRITE;

const S_OK = win.S_OK;
const E_ABORT = win.E_ABORT;
const E_ACCESSDENIED = win.E_ACCESSDENIED;
const E_FAIL = win.E_FAIL;
const E_HANDLE = win.E_HANDLE;
const E_INVALIDARG = win.E_INVALIDARG;
const E_NOINTERFACE = win.E_NOINTERFACE;
const E_NOTIMPL = win.E_NOTIMPL;
const E_OUTOFMEMORY = win.E_OUTOFMEMORY;
const E_POINTER = win.E_POINTER;
const E_UNEXPECTED = win.E_UNEXPECTED;

const ERROR_SUCCESS = win_ext.ERROR_SUCCESS;

// XInput Constants
const GAMEPAD_DPAD_UP = xinput.XINPUT_GAMEPAD_DPAD_UP;
const GAMEPAD_DPAD_DOWN = xinput.XINPUT_GAMEPAD_DPAD_DOWN;
const GAMEPAD_DPAD_LEFT = xinput.XINPUT_GAMEPAD_DPAD_LEFT;
const GAMEPAD_DPAD_RIGHT = xinput.XINPUT_GAMEPAD_DPAD_RIGHT;
const GAMEPAD_START = xinput.XINPUT_GAMEPAD_START;
const GAMEPAD_BACK = xinput.XINPUT_GAMEPAD_BACK;
const GAMEPAD_LEFT_THUMB = xinput.XINPUT_GAMEPAD_LEFT_THUMB;
const GAMEPAD_RIGHT_THUMB = xinput.XINPUT_GAMEPAD_RIGHT_THUMB;
const GAMEPAD_LEFT_SHOULDER = xinput.XINPUT_GAMEPAD_LEFT_SHOULDER;
const GAMEPAD_RIGHT_SHOULDER = xinput.XINPUT_GAMEPAD_RIGHT_SHOULDER;
const GAMEPAD_A = xinput.XINPUT_GAMEPAD_A;
const GAMEPAD_B = xinput.XINPUT_GAMEPAD_B;
const GAMEPAD_X = xinput.XINPUT_GAMEPAD_X;
const GAMEPAD_Y = xinput.XINPUT_GAMEPAD_Y;
const XUSER_MAX_COUNT = xinput.XUSER_MAX_COUNT;

// Per WinUser.h
const BI_RGB = win_ext.BI_RGB;

const CS_VREDRAW = win_ext.CS_VREDRAW;
const CS_HREDRAW = win_ext.CS_HREDRAW;

const CW_USEDEFAULT = win_ext.CW_USEDEFAULT;

const DIB_RGB_COLORS = win_ext.DIB_RGB_COLORS;
const PM_REMOVE = win_ext.PM_REMOVE;
const SRCCOPY = win_ext.SRCCOPY;

const VK_ESCAPE = win_ext.VK_ESCAPE;
const VK_SPACE = win_ext.VK_SPACE;
const VK_LEFT = win_ext.VK_LEFT;
const VK_UP = win_ext.VK_UP;
const VK_RIGHT = win_ext.VK_RIGHT;
const VK_DOWN = win_ext.VK_DOWN;

const WM_DESTROY = win_ext.WM_DESTROY;
const WM_SIZE = win_ext.WM_SIZE;
const WM_PAINT = win_ext.WM_PAINT;
const WM_CLOSE = win_ext.WM_CLOSE;
const WM_QUIT = win_ext.WM_QUIT;
const WM_ACTIVATEAPP = win_ext.WM_ACTIVATEAPP;
const WM_KEYUP = win_ext.WM_KEYUP;
const WM_KEYDOWN = win_ext.WM_KEYDOWN;
const WM_SYSKEYUP = win_ext.WM_SYSKEYUP;
const WM_SYSKEYDOWN = win_ext.WM_SYSKEYDOWN;

const WS_EX_TOPMOST = win_ext.WS_EX_TOPMOST;
const WS_VISIBLE = win_ext.WS_VISIBLE;
const WS_OVERLAPPEDWINDOW = win_ext.WS_OVERLAPPEDWINDOW;

// Windows API globals
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Handmade Hero globals

var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
const allocator = arena.allocator();

var game_memory: game.GameMemory = undefined;
var offscreen_buffer: OffscreenBuffer = undefined;

var xinput_get_state_ptr: ?*const fn (DWORD, *XINPUT_STATE) callconv(winapi) DWORD = xInputGetStateStub;
var xinput_set_state_ptr: ?*const fn (DWORD, *XINPUT_VIBRATION) callconv(winapi) DWORD = xInputSetStateStub;
var xaudio2_create_ptr: ?*const fn (*?*IXAudio2, FLAGS, UINT32) callconv(winapi) HRESULT = xAudio2CreateStub;

var running: bool = undefined;

const default_pixel_size_in_bytes: c_int = 4;
const default_sound_channels: u32 = 2;
// const default_sound_buffers: usize = 3;

// NOTE:(Dean): Pixels are always 32-bits wide, memory order: BB GG RR XX
const OffscreenBuffer = struct {
    info: BITMAPINFO,
    memory: []u8,
    window_dimensions: WindowDimensions,
    bytes_per_pixel: c_int,

    pub fn init(self: *OffscreenBuffer, alloc: std.mem.Allocator, window_dimensions: WindowDimensions, bytes_per_pixel: c_int) !void {
        const width = window_dimensions.width;
        const height = window_dimensions.height;
        const buffer_size: usize = @intCast(width * height * bytes_per_pixel);

        self.*.memory = try alloc.alloc(u8, buffer_size);
        self.*.window_dimensions = window_dimensions;
        self.*.bytes_per_pixel = bytes_per_pixel;
        self.*.info.bmiHeader.biSize = @sizeOf(BITMAPINFOHEADER);
        self.*.info.bmiHeader.biWidth = width;
        self.*.info.bmiHeader.biHeight = -height; // NOTE:(Dean) This is negative so that the origin is the top left corner. A positive value puts the origin in the bottom left corner.
        self.*.info.bmiHeader.biPlanes = 1;
        self.*.info.bmiHeader.biBitCount = 32;
        self.*.info.bmiHeader.biCompression = BI_RGB;
        self.*.info.bmiHeader.biSizeImage = 0;
        self.*.info.bmiHeader.biXPelsPerMeter = 0;
        self.*.info.bmiHeader.biYPelsPerMeter = 0;
        self.*.info.bmiHeader.biClrUsed = 0;
        self.*.info.bmiHeader.biClrImportant = 0;
        self.*.info.bmiColors[0].rgbBlue = 0;
        self.*.info.bmiColors[0].rgbGreen = 0;
        self.*.info.bmiColors[0].rgbRed = 0;
        self.*.info.bmiColors[0].rgbReserved = 0;
    }

    pub fn resize(self: *OffscreenBuffer, alloc: std.mem.Allocator, new_dimensions: WindowDimensions) !void {
        const new_width = new_dimensions.width;
        const new_height = new_dimensions.height;
        const new_buffer_size: usize = @intCast(new_width * new_height * self.*.bytes_per_pixel);

        alloc.free(self.*.memory);

        self.*.memory = try alloc.alloc(u8, new_buffer_size);
        self.*.window_dimensions = new_dimensions;
        self.*.info.bmiHeader.biWidth = new_width;
        self.*.info.bmiHeader.biHeight = -new_height; // NOTE:(Dean) See Note from init()
    }

    pub fn toGameOffscreenBuffer(self: *OffscreenBuffer) game.GameOffscreenBuffer {
        return game.GameOffscreenBuffer{
            .memory = self.*.memory,
            .width = self.*.window_dimensions.width,
            .height = self.*.window_dimensions.height,
            .bytes_per_pixel = self.*.bytes_per_pixel,
        };
    }
};

const SoundBuffer = struct {
    // buffers: [default_sound_buffers][]u8,
    buffer: []u8,
    num_channels: i32,
    samples_per_second: i32,
    tone_hz: i32,
    volume: f32,

    pub fn init(self: *SoundBuffer, alloc: std.mem.Allocator, num_channels: i32, samples_per_second: i32, tone_hz: i32, volume: f32) !void {
        self.*.num_channels = num_channels;
        self.*.samples_per_second = samples_per_second;
        self.*.tone_hz = tone_hz;
        self.*.volume = volume;

        const buffer_size: usize = @intCast(self.*.samples_per_second * self.*.num_channels * @sizeOf(i16));
        // self.*.buffers = try alloc.alloc([]u8, default_sound_buffers);
        self.*.buffer = try alloc.alloc(u8, buffer_size);

        // for (self.*.buffers) |*buf| {
        //     buf.* = try alloc.alloc(u8, buffer_size);
        // }
    }

    pub fn toGameOutputSoundBuffer(self: SoundBuffer) game.GameOutputSoundBuffer {
        return .{
            // .samples = self.buffers,
            .samples = self.buffer,
            .samples_per_second = self.samples_per_second,
        };
    }
};

const WindowDimensions = struct {
    width: i32,
    height: i32,
};

pub fn loadXInput() void {
    const xinput_library: ?HMODULE = win_ext.LoadLibraryA("xinput1_3.dll");

    if (xinput_library != null) {
        std.debug.print("XInput Library loaded\n", .{});
        xinput_get_state_ptr = @ptrCast(win_ext.GetProcAddress(xinput_library.?, "XInputGetState"));
        if (xinput_get_state_ptr == null) {
            std.debug.print("XInputGetState function not found\n", .{});
            xinput_get_state_ptr = &xInputGetStateStub;
        } else {
            std.debug.print("XInputGetState function loaded successfully\n", .{});
        }

        xinput_set_state_ptr = @ptrCast(win_ext.GetProcAddress(xinput_library.?, "XInputSetState"));
        if (xinput_set_state_ptr == null) {
            std.debug.print("XInputSetState function not found\n", .{});
            xinput_set_state_ptr = &xInputSetStateStub;
        } else {
            std.debug.print("XInputSetState function loaded successfully\n", .{});
        }
    } else {
        std.debug.print("XInput Library failed to load\n", .{});
    }
}

pub fn loadXAudio2() void {
    const xaudio2_library: ?HMODULE = win_ext.LoadLibraryA("xaudio2_9.dll");

    if (xaudio2_library != null) {
        std.debug.print("XAudio2 Library loaded\n", .{});
        xaudio2_create_ptr = @ptrCast(win_ext.GetProcAddress(xaudio2_library.?, "XAudio2Create"));
        if (xaudio2_create_ptr == null) {
            std.debug.print("XAudio2Create function not found\n", .{});
            xaudio2_create_ptr = &xAudio2CreateStub;
        } else {
            std.debug.print("XAudio2Create function loaded successfully\n", .{});
        }
    } else {
        std.debug.print("XAudio2 Library failed to load\n", .{});
    }
}

// Stub Functions
pub fn xInputGetStateStub(dwUserIndex: DWORD, pInputState: *XINPUT_STATE) callconv(winapi) DWORD {
    _ = dwUserIndex;
    _ = pInputState;
    std.debug.print("XInputGetState - Stub\n", .{});
    return 0;
}

pub fn xInputSetStateStub(dwUserIndex: DWORD, pVibration: *XINPUT_VIBRATION) callconv(winapi) DWORD {
    _ = dwUserIndex;
    _ = pVibration;
    std.debug.print("XInputSetState - Stub\n", .{});
    return 0;
}

pub fn xAudio2CreateStub(instance: *?*IXAudio2, flags: FLAGS, processor: UINT32) callconv(winapi) HRESULT {
    _ = instance;
    _ = flags;
    _ = processor;

    std.debug.print("XAudio2Create - Stub\n", .{});
    return 0;
}

// Utility Functions
pub fn getWindowDimensions(window: win.HWND) WindowDimensions {
    var result: WindowDimensions = undefined;
    var client_rect: RECT = undefined;
    _ = win_ext.GetClientRect(window, &client_rect);

    result.width = client_rect.right - client_rect.left;
    result.height = client_rect.bottom - client_rect.top;
    return result;
}

pub fn copyBufferToWindow(ctx: HDC, window_dimensions: WindowDimensions, buffer: OffscreenBuffer) void {
    _ = win_ext.StretchDIBits(ctx, 0, 0, window_dimensions.width, window_dimensions.height, 0, 0, buffer.window_dimensions.width, buffer.window_dimensions.height, buffer.memory.ptr, &buffer.info, DIB_RGB_COLORS, SRCCOPY);
}

pub fn windowCallback(window: HWND, message: UINT, w_param: WPARAM, l_param: LPARAM) callconv(winapi) LRESULT {
    var result: LRESULT = 0;

    switch (message) {
        WM_ACTIVATEAPP => {
            std.debug.print("WM_ACTIVATEAPP\n", .{});
        },
        WM_CLOSE => {
            std.debug.print("WM_CLOSE\n", .{});
            running = false;
        },
        WM_DESTROY => {
            std.debug.print("WM_DESTROY\n", .{});
            running = false;
        },
        WM_SIZE => {
            std.debug.print("WM_SIZE\n", .{});
            const window_dimensions = getWindowDimensions(window);
            offscreen_buffer.resize(allocator, window_dimensions) catch blk: {
                result = win.E_OUTOFMEMORY;
                break :blk;
            };
        },
        WM_PAINT => {
            std.debug.print("WM_PAINT\n", .{});
            var paint: PAINTSTRUCT = undefined;
            const device_ctx: HDC = win_ext.BeginPaint(window, &paint);
            defer _ = win_ext.EndPaint(window, &paint);

            const window_dimensions = getWindowDimensions(window);
            copyBufferToWindow(device_ctx, window_dimensions, offscreen_buffer);

            // NOTE:(Dean): all new memory is set to 0xAA -- this turns the window white until another render pass happens.
        },
        WM_KEYUP, WM_KEYDOWN, WM_SYSKEYUP, WM_SYSKEYDOWN => {
            // TODO:(Dean): log message

            const vk_code: usize = w_param;
            const is_down: bool = ((l_param & (1 << 30)) != 0);
            const was_down: bool = ((l_param & (1 << 31)) == 0);

            if (is_down != was_down) {
                if (vk_code == 'W') {} else if (vk_code == 'A') {} else if (vk_code == 'S') {} else if (vk_code == 'D') {} else if (vk_code == 'Q') {} else if (vk_code == 'E') {} else if (vk_code == VK_UP) {} else if (vk_code == VK_DOWN) {} else if (vk_code == VK_LEFT) {} else if (vk_code == VK_RIGHT) {} else if (vk_code == VK_SPACE) {} else if (vk_code == VK_ESCAPE) {}
            }
        },
        else => {
            result = win_ext.DefWindowProcA(window, message, w_param, l_param);
        },
    }

    return result;
}

// TODO:(Dean): Implement this --- method inside game struct?
fn processDigitalButton(prev_state: *game.GameButtonState, new_state: *game.GameButtonState, xinput_button_state: DWORD, button_bit: DWORD) void {
    new_state.*.is_down = (xinput_button_state & button_bit) == button_bit;
    new_state.*.state_transition_count = if (prev_state.*.is_down != new_state.*.is_down) 1 else 0;
}

pub fn main() !void {
    defer arena.deinit();
    std.log.debug("main: start\n", .{});

    loadXInput();
    std.debug.print("main: XInput library loaded\n", .{});

    loadXAudio2();
    std.debug.print("main: XAudio2 library loaded\n", .{});

    var window_class = WNDCLASSEXA{ .cbSize = @sizeOf(WNDCLASSEXA), .style = CS_HREDRAW | CS_VREDRAW, .lpfnWndProc = windowCallback, .hInstance = @as(HINSTANCE, @ptrCast(win_ext.GetModuleHandleA(null))), .hIcon = null, .hIconSm = null, .hCursor = null, .hbrBackground = null, .lpszMenuName = null, .lpszClassName = "HandmadeHeroWindowClass" };

    if (win_ext.RegisterClassExA(&window_class) != 0) {
        std.debug.print("main: window class registered\n", .{});

        const window_handle: HWND = win_ext.CreateWindowExA(WS_EX_TOPMOST, window_class.lpszClassName, "Handmade Hero: Zig Edition", WS_OVERLAPPEDWINDOW | WS_VISIBLE, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, null, null, window_class.hInstance, null).?;

        const default_window_dimensions = WindowDimensions{ .width = 1280, .height = 720 };

        try offscreen_buffer.init(allocator, default_window_dimensions, default_pixel_size_in_bytes);

        var sound_buffer: SoundBuffer = undefined;
        const samples_per_second: u32 = 48000;
        const tone_hz: u32 = 256;
        const volume: f32 = 0.25;

        try sound_buffer.init(allocator, default_sound_channels, samples_per_second, tone_hz, volume);
        try game_memory.init(allocator, game.megabytesToBytes(64), game.gigabytesToBytes(4));

        var xaudio2_instance: ?*IXAudio2 = undefined;
        var mastering_voice: ?*IMasteringVoice = undefined;
        var source_voice: ?*ISourceVoice = undefined;

        const flags = FLAGS{};

        if (win_ext.FAILED(win_ext.CoInitializeEx(null, win_ext.COINIT_MULTITHREADED))) {
            std.debug.print("CoInitializeEx failed\n", .{});
        }

        if (win_ext.SUCCEEDED(xaudio2_create_ptr.?(&xaudio2_instance, flags, xa2.XAUDIO2_DEFAULT_PROCESSOR))) {
            std.debug.print("XAudio2Create successful\n", .{});
            if (win_ext.SUCCEEDED(xaudio2_instance.?.CreateMasteringVoice(&mastering_voice, xa2.XAUDIO2_DEFAULT_CHANNELS, xa2.XAUDIO2_DEFAULT_SAMPLERATE, .{}, null, null, .GameEffects))) {
                const cbSize: WORD = 0;
                const nChannels: WORD = 2;
                const wBitsPerSample: WORD = 16;
                const nSamplesPerSec: DWORD = @intCast(sound_buffer.samples_per_second);
                const nBlockAlign: WORD = (nChannels * wBitsPerSample) / 8;
                const nAvgBytesPerSec: DWORD = nSamplesPerSec * nBlockAlign;

                var wave_format = WAVEFORMATEX{
                    .wFormatTag = wasapi.WAVE_FORMAT_PCM,
                    .cbSize = cbSize,
                    .nChannels = nChannels,
                    .wBitsPerSample = wBitsPerSample,
                    .nSamplesPerSec = nSamplesPerSec,
                    .nBlockAlign = nBlockAlign,
                    .nAvgBytesPerSec = nAvgBytesPerSec,
                };

                if (win_ext.SUCCEEDED(xaudio2_instance.?.CreateSourceVoice(&source_voice, &wave_format, .{}, xa2.XAUDIO2_DEFAULT_FREQ_RATIO, null, null, null))) {
                    std.debug.print("Source Voice created -- filling buffer\n", .{});
                    var game_sound_output_buffer = sound_buffer.toGameOutputSoundBuffer();
                    game.outputSound(&game_sound_output_buffer, sound_buffer.tone_hz);

                    const xaudio2_buffer = BUFFER{
                        .Flags = .{ .END_OF_STREAM = true },
                        .AudioBytes = @intCast(sound_buffer.buffer.len),
                        .pAudioData = sound_buffer.buffer.ptr,
                        // .AudioBytes = @intCast(sound_buffer.buffers[0].len),
                        // .pAudioData = sound_buffer.buffers[0].ptr,
                        .PlayBegin = 0,
                        .PlayLength = 0,
                        .LoopBegin = 0,
                        .LoopLength = 0,
                        .LoopCount = xa2.XAUDIO2_INFINITE_LOOP,
                        .pContext = null,
                    };

                    if (win_ext.SUCCEEDED(source_voice.?.SubmitSourceBuffer(&xaudio2_buffer, null))) {
                        _ = source_voice.?.Start(.{}, 0);
                    } else {
                        std.debug.print("SubmitSourceBuffer failed\n", .{});
                    }
                } else {
                    std.debug.print("CreateSourceVoice failed\n", .{});
                }
            } else {
                std.debug.print("CreateMasteringVoice failed\n", .{});
            }
        } else {
            std.debug.print("XAudio2Create failed\n", .{});
        }

        running = true;

        var xinput_first_pass: bool = true;
        var input: [2]game.GameInput = undefined;
        var new_input = &input[0]; // TODO:(Dean): double check this as update and render stuff
        var old_input = &input[1];
        new_input.*.init();
        old_input.*.init();

        while (running) {
            var msg: MSG = undefined;
            while (win_ext.PeekMessageA(&msg, null, 0, 0, PM_REMOVE) != 0) {
                if (msg.message == WM_QUIT) {
                    running = false;
                }

                _ = win_ext.TranslateMessage(&msg);
                _ = win_ext.DispatchMessageA(&msg);
            }

            var controller_index: DWORD = 0;

            while (controller_index < XUSER_MAX_COUNT) : (controller_index += 1) {
                const new_controller = &new_input.*.controllers[controller_index];
                const old_controller = &old_input.*.controllers[controller_index];
                var controller_state: XINPUT_STATE = undefined;

                const xinput_response: DWORD = xinput_get_state_ptr.?(controller_index, &controller_state);
                if (xinput_response == ERROR_SUCCESS) {
                    if (xinput_first_pass == true) {
                        std.debug.print("Controller {d} is detected\n", .{controller_index});
                    }

                    // NOTE:(Dean): Controller is plugged in
                    // TODO:(Dean): See if ControllerState.dwPacketNumber increments too rapidly

                    const pad: *GAMEPAD = &controller_state.Gamepad;

                    const dpad_up: BOOL = (pad.*.wButtons & GAMEPAD_DPAD_UP);
                    const dpad_down: BOOL = (pad.*.wButtons & GAMEPAD_DPAD_DOWN);
                    const dpad_left: BOOL = (pad.*.wButtons & GAMEPAD_DPAD_LEFT);
                    const dpad_right: BOOL = (pad.*.wButtons & GAMEPAD_DPAD_RIGHT);

                    new_controller.*.is_analog = true;
                    new_controller.*.start_x = old_controller.*.end_x;
                    new_controller.*.start_y = old_controller.*.end_y;

                    var thumb_x: f32 = undefined;
                    const f_thumblx: f32 = @floatFromInt(pad.*.sThumbLX);

                    if (pad.*.sThumbLX < 0) {
                        thumb_x = f_thumblx / 32768.0;
                    } else {
                        thumb_x = f_thumblx / 32767.0;
                    }

                    var thumb_y: f32 = undefined;
                    const f_thumbly: f32 = @floatFromInt(pad.*.sThumbLY);

                    if (pad.*.sThumbLY < 0) {
                        thumb_y = f_thumbly / 32768.0;
                    } else {
                        thumb_y = f_thumbly / 32767.0;
                    }

                    new_controller.*.min_x = thumb_x;
                    new_controller.*.max_x = thumb_x;
                    new_controller.*.end_x = thumb_x;

                    new_controller.*.min_y = thumb_y;
                    new_controller.*.max_y = thumb_y;
                    new_controller.*.end_y = thumb_y;

                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.Start)], &new_controller.buttons[@intFromEnum(game.GameButtons.Start)], pad.*.wButtons, GAMEPAD_START);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.Back)], &new_controller.buttons[@intFromEnum(game.GameButtons.Back)], pad.*.wButtons, GAMEPAD_BACK);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.LeftShoulder)], &new_controller.buttons[@intFromEnum(game.GameButtons.LeftShoulder)], pad.*.wButtons, GAMEPAD_LEFT_SHOULDER);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.RightShoulder)], &new_controller.buttons[@intFromEnum(game.GameButtons.RightShoulder)], pad.*.wButtons, GAMEPAD_RIGHT_SHOULDER);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.South)], &new_controller.buttons[@intFromEnum(game.GameButtons.South)], pad.*.wButtons, GAMEPAD_A);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.East)], &new_controller.buttons[@intFromEnum(game.GameButtons.East)], pad.*.wButtons, GAMEPAD_B);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.West)], &new_controller.buttons[@intFromEnum(game.GameButtons.West)], pad.*.wButtons, GAMEPAD_X);
                    processDigitalButton(&old_controller.buttons[@intFromEnum(game.GameButtons.North)], &new_controller.buttons[@intFromEnum(game.GameButtons.North)], pad.*.wButtons, GAMEPAD_Y);

                    if (dpad_up != 0) {
                        std.debug.print("UP pressed on D-Pad of Controller {d}\n", .{controller_index});
                    }
                    if (dpad_down != 0) {
                        std.debug.print("DOWN pressed on D-Pad of Controller {d}\n", .{controller_index});
                    }
                    if (dpad_left != 0) {
                        std.debug.print("LEFT pressed on D-Pad of Controller {d}\n", .{controller_index});
                    }
                    if (dpad_right != 0) {
                        std.debug.print("RIGHT pressed on D-Pad of Controller {d}\n", .{controller_index});
                    }
                } else {
                    // NOTE:(Dean): Controller is unavailable
                    if (xinput_first_pass == true) {
                        std.debug.print("XInputGetState returned with {X}\n", .{xinput_response});
                        std.debug.print("Controller {d} is not available\n", .{controller_index});
                    }
                }
            }

            xinput_first_pass = false;

            // TODO:(Dean): Need to rethink how the platform layer and game layer are passing info back and forth
            // var game_offscreen_buffer = offscreen_buffer.toGameOffscreenBuffer();

            var game_offscreen_buffer = game.GameOffscreenBuffer{
                .memory = offscreen_buffer.memory,
                .height = offscreen_buffer.window_dimensions.height,
                .width = offscreen_buffer.window_dimensions.width,
                .bytes_per_pixel = offscreen_buffer.bytes_per_pixel,
            };

            var game_sound_buffer = sound_buffer.toGameOutputSoundBuffer();

            game.updateAndRender(&game_memory, new_input, &game_offscreen_buffer, &game_sound_buffer);

            const device_context: HDC = win_ext.GetDC(window_handle);
            defer _ = win_ext.ReleaseDC(window_handle, device_context);
            const window_dimensions = getWindowDimensions(window_handle);
            copyBufferToWindow(device_context, window_dimensions, offscreen_buffer);

            const temp_input = new_input;
            new_input = old_input;
            old_input = temp_input;
        }
    }
    std.debug.print("Program Closing: Success\n", .{});
    return;
}
