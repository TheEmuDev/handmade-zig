const std = @import("std");
const win_ext = @import("windows.zig");

const win = std.os.windows;

const DWORD = win.DWORD;
const WORD = win.WORD;

pub const WAVE_FORMAT_PCM: WORD = 0x0001;

pub const WAVEFORMATEX = extern struct {
    wFormatTag: WORD,
    nChannels: WORD,
    nSamplesPerSec: DWORD,
    nAvgBytesPerSec: DWORD,
    nBlockAlign: WORD,
    wBitsPerSample: WORD,
    cbSize: WORD,
};
