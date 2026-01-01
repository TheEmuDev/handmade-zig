const std = @import("std");
const wasapi = @import("./wasapi.zig");
const win_ext = @import("./windows.zig");
const win = std.os.windows;

const BOOL = win.BOOL;
const BYTE = win.BYTE;
const DWORD = win.DWORD;
const HRESULT = win.HRESULT;
const LPCWSTR = win.LPCWSTR;
const UINT32 = win.UINT;
const WINAPI = std.builtin.CallingConvention.winapi;

const UINT64 = win_ext.UINT64;
const IUnknown = win_ext.IUnknown;

const WAVEFORMATEX = wasapi.WAVEFORMATEX;

pub const XAUDIO2_DEFAULT_PROCESSOR = 0x0000_0001;
pub const XAUDIO2_DEFAULT_SAMPLERATE: c_int = 0;
pub const XAUDIO2_DEFAULT_CHANNELS: c_int = 0;
pub const XAUDIO2_DEFAULT_FREQ_RATIO: f32 = 2.0;
pub const XAUDIO2_INFINITE_LOOP: c_int = 255;

pub const AUDIO_STREAM_CATEGORY = enum(UINT32) {
    Other = 0,
    ForegroundOnlyMedia = 1,
    Communications = 3,
    Alerts = 4,
    SoundEffects = 5,
    GameEffects = 6,
    GameMedia = 7,
    GameChat = 8,
    Speech = 9,
    Movie = 10,
    Media = 11,
};

pub const FILTER_TYPE = enum(UINT32) {
    LowPassFilter,
    BandPassFilter,
    HighPassFilter,
    NotchFilter,
    LowPassOnePoleFilter,
    HighPassOnePoleFilter,
};

pub const DEBUG_CONFIGURATION = extern struct {
    TraceMask: LOG_FLAGS align(1),
    BreakMask: LOG_FLAGS align(1),
    LogThreadID: BOOL align(1),
    LogFileline: BOOL align(1),
    LogFunctionName: BOOL align(1),
    LogTiming: BOOL align(1),
};

pub const EFFECT_CHAIN = extern struct {
    EffectCount: UINT32 align(1),
    pEffectDescriptors: [*]EFFECT_DESCRIPTOR align(1),
};

pub const EFFECT_DESCRIPTOR = extern struct {
    pEffect: *IUnknown align(1),
    InitialState: BOOL align(1),
    OutputChannels: UINT32 align(1),
};

pub const FILTER_PARAMETERS = extern struct {
    Type: FILTER_TYPE align(1),
    Frequency: f32 align(1),
    OneOverQ: f32 align(1),
};

pub const FLAGS = packed struct(UINT32) {
    DEBUG_ENGINE: bool = false,
    VOICE_NOPITCH: bool = false,
    VOICE_NOSRC: bool = false,
    VOICE_USEFILTER: bool = false,
    __unused4: bool = false,
    PLAY_TAILS: bool = false,
    END_OF_STREAM: bool = false,
    SEND_USEFILTER: bool = false,
    VOICE_NOSAMPLESPLAYED: bool = false,
    __unused9: bool = false,
    __unused10: bool = false,
    __unused11: bool = false,
    __unused12: bool = false,
    STOP_ENGINE_WHEN_IDLE: bool = false,
    __unused14: bool = false,
    @"1024_QUANTUM": bool = false,
    NO_VIRTUAL_AUDIO_CLIENT: bool = false,
    __unused15: u15 = 0,
};

pub const LOG_FLAGS = packed struct {
    ERRORS: bool = false,
    WARNINGS: bool = false,
    INFO: bool = false,
    DETAIL: bool = false,
    API_CALLS: bool = false,
    FUNC_CALLS: bool = false,
    TIMING: bool = false,
    LOCKS: bool = false,
    MEMORY: bool = false,
    __unused9: bool = false,
    __unused10: bool = false,
    __unused11: bool = false,
    STREAMING: bool = false,
    __unused: u19 = 0,
};

pub const PERFORMANCE_DATA = extern struct {
    AudioCyclesSinceLastQuery: UINT64 align(1),
    TotalCyclesSinceLastQuery: UINT64 align(1),
    MinimumCyclesPerQuantum: UINT32 align(1),
    MaximumCyclesPerQuantum: UINT32 align(1),
    MemoryUsageInBytes: UINT32 align(1),
    CurrentLatencyInSamples: UINT32 align(1),
    GlitchesSinceEngineStarted: UINT32 align(1),
    ActiveSourceVoiceCount: UINT32 align(1),
    TotalSourceVoiceCount: UINT32 align(1),
    ActiveSubmixVoiceCount: UINT32 align(1),
    ActiveResamplerCount: UINT32 align(1),
    ActiveMatrixMixCount: UINT32 align(1),
    ActiveXmaSourceVoices: UINT32 align(1),
    ActiveXmaStreams: UINT32 align(1),
};

pub const SEND_DESCRIPTOR = extern struct {
    Flags: FLAGS align(1),
    pOutputVoice: *IVoice align(1),
};

pub const VOICE_DETAILS = extern struct {
    CreationFlags: FLAGS align(1),
    ActiveFlags: FLAGS align(1),
    InputChannels: UINT32 align(1),
    InputSampleRate: UINT32 align(1),
};

pub const VOICE_SENDS = extern struct {
    SendCount: UINT32 align(1),
    pSends: [*]SEND_DESCRIPTOR align(1),
};

pub const VOICE_STATE = extern struct {
    pCurrentBufferContext: ?*anyopaque align(1),
    BuffersQueued: UINT32 align(1),
    SamplesPlayed: UINT64 align(1),
};

pub const XAUDIO2_BUFFER = extern struct {
    Flags: FLAGS align(1),
    AudioBytes: UINT32 align(1),
    pAudioData: [*]const BYTE align(1),
    PlayBegin: UINT32 align(1),
    PlayLength: UINT32 align(1),
    LoopBegin: UINT32 align(1),
    LoopLength: UINT32 align(1),
    LoopCount: UINT32 align(1),
    pContext: ?*anyopaque align(1),
};

pub const XAUDIO2_BUFFER_WMA = extern struct {
    pDecodedPacketCumulativeBytes: *const UINT32 align(1),
    PacketCount: UINT32 align(1),
};

pub const IEngineCallback = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());

    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub inline fn OnProcessingPassStart(self: *T) void {
    //             @as(*const IEngineCallback.VTable, @ptrCast(self.__v))
    //                 .OnProcessingPassStart(@as(*IEngineCallback, @ptrCast(self)));
    //         }
    //         pub inline fn OnProcessingPassEnd(self: *T) void {
    //             @as(*const IEngineCallback.VTable, @ptrCast(self.__v))
    //                 .OnProcessingPassEnd(@as(*IEngineCallback, @ptrCast(self)));
    //         }
    //         pub inline fn OnCriticalError(self: *T, err: HRESULT) void {
    //             @as(*const IEngineCallback.VTable, @ptrCast(self.__v))
    //                 .OnCriticalError(@as(*IEngineCallback, @ptrCast(self)), err);
    //         }
    //     };
    // }

    pub inline fn OnProcessingPassStart(self: *IEngineCallback) void {
        self.__v.OnProcessingPassStart(self);
    }

    pub inline fn OnProcessingPassEnd(self: *IEngineCallback) void {
        self.__v.OnprocessingPassEnd(self);
    }

    pub inline fn OnCriticalError(self: *IEngineCallback, err: HRESULT) void {
        self.__v.OnCriticalError(self, err);
    }

    pub const VTable = extern struct {
        OnProcessingPassStart: *const fn (*IEngineCallback) callconv(WINAPI) void,
        OnProcessingPassEnd: *const fn (*IEngineCallback) callconv(WINAPI) void,
        OnCriticalError: *const fn (*IEngineCallback, HRESULT) callconv(WINAPI) void,
    };

    pub const default_vtable: VTable = .{
        .OnProcessingPassStart = _onProcessingPassStart,
        .OnProcessingPassEnd = _onProcessingPassEnd,
        .OnCriticalError = _onCriticalError,
    };
};

pub const IVoiceCallback = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());
    //
    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub inline fn OnVoiceProcessingPassStart(self: *T, bytes_required: UINT32) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnVoiceProcessingPassStart(@as(*IVoiceCallback, @ptrCast(self)), bytes_required);
    //         }
    //         pub inline fn OnVoiceProcessingPassEnd(self: *T) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnVoiceProcessingPassEnd(@as(*IVoiceCallback, @ptrCast(self)));
    //         }
    //         pub inline fn OnStreamEnd(self: *T) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnStreamEnd(@as(*IVoiceCallback, @ptrCast(self)));
    //         }
    //         pub inline fn OnBufferStart(self: *T, context: ?*anyopaque) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnBufferStart(@as(*IVoiceCallback, @ptrCast(self)), context);
    //         }
    //         pub inline fn OnBufferEnd(self: *T, context: ?*anyopaque) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnBufferEnd(@as(*IVoiceCallback, @ptrCast(self)), context);
    //         }
    //         pub inline fn OnLoopEnd(self: *T, context: ?*anyopaque) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnLoopEnd(@as(*IVoiceCallback, @ptrCast(self)), context);
    //         }
    //         pub inline fn OnVoiceError(self: *T, context: ?*anyopaque, err: HRESULT) void {
    //             @as(*const IVoiceCallback.VTable, @ptrCast(self.__v))
    //                 .OnBufferEnd(@as(*IVoiceCallback, @ptrCast(self)), context, err);
    //         }
    //     };
    // }

    pub inline fn OnVoiceProcessingPassStart(self: *IVoiceCallback, bytes_required: UINT32) void {
        self.__v.OnVoiceProcessingPassStart(self, bytes_required);
    }

    pub inline fn OnVoiceProcessingPassEnd(self: *IVoiceCallback) void {
        self.__v.OnVoiceProcessingPassEnd(self);
    }

    pub inline fn OnStreamEnd(self: *IVoiceCallback) void {
        self.__v.OnStreamEnd(self);
    }

    pub inline fn OnBufferStart(self: *IVoiceCallback, context: ?*anyopaque) void {
        self.__v.OnBufferStart(self, context);
    }

    pub inline fn OnBufferEnd(self: *IVoiceCallback, context: ?*anyopaque) void {
        self.__v.OnBufferEnd(self, context);
    }

    pub inline fn OnLoopEnd(self: *IVoiceCallback, context: ?*anyopaque) void {
        self.__v.OnLoopEnd(self, context);
    }

    pub inline fn OnVoiceError(self: *IVoiceCallback, context: ?*anyopaque, err: HRESULT) void {
        self.__v.OnVoiceError(self, context, err);
    }

    pub const VTable = extern struct {
        const T = IVoiceCallback;
        OnVoiceProcessingPassStart: *const fn (*T, UINT32) callconv(WINAPI) void,
        OnVoiceProcessingPassEnd: *const fn (*T) callconv(WINAPI) void,
        OnStreamEnd: *const fn (*T) callconv(WINAPI) void,
        OnBufferStart: *const fn (*T, ?*anyopaque) callconv(WINAPI) void,
        OnBufferEnd: *const fn (*T, ?*anyopaque) callconv(WINAPI) void,
        OnLoopEnd: *const fn (*T, ?*anyopaque) callconv(WINAPI) void,
        OnVoiceError: *const fn (*T, ?*anyopaque, HRESULT) callconv(WINAPI) void,
    };

    pub const default_vtable: VTable = .{
        .OnVoiceProcessingPassStart = _onVoiceProcessingPassStart,
        .OnVoiceProcessingPassEnd = _onVoiceProcessingPassEnd,
        .OnStreamEnd = _onStreamEnd,
        .OnBufferStart = _onBufferStart,
        .OnBufferEnd = _onBufferEnd,
        .OnLoopEnd = _onLoopEnd,
        .OnVoiceError = _onVoiceError,
    };
};

pub const IVoice = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());
    //
    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub inline fn GetVoiceDetails(self: *T, details: *VOICE_DETAILS) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetVoiceDetails(@as(*IVoice, @ptrCast(self)), details);
    //         }
    //         pub inline fn SetOutputVoices(self: *T, send_list: ?*const VOICE_SENDS) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetOutputVoices(@as(*IVoice, @ptrCast(self)), send_list);
    //         }
    //         pub inline fn SetEffectChain(self: *T, effect_index: ?*const EFFECT_CHAIN) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetEffectChain(@as(*IVoice, @ptrCast(self)), effect_index);
    //         }
    //         pub inline fn EnableEffect(self: *T, effect_index: UINT32, operation_set: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .EnableEffect(@as(*IVoice, @ptrCast(self)), effect_index, operation_set);
    //         }
    //         pub inline fn DisableEffect(self: *T, effect_index: UINT32, operation_set: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .DisableEffect(@as(*IVoice, @ptrCast(self)), effect_index, operation_set);
    //         }
    //         pub inline fn GetEffectState(self: *T, effect_index: UINT32, enabled: *BOOL) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetEffectState(@as(*IVoice, @ptrCast(self)), effect_index, enabled);
    //         }
    //         pub inline fn SetEffectParameters(self: *T, effect_index: UINT32, params: *const anyopaque, params_size: UINT32, operation_set: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetEffectParameters(@as(*IVoice, @ptrCast(self)), effect_index, params, params_size, operation_set);
    //         }
    //         pub inline fn GetEffectParameters(self: *T, effect_index: UINT32, params: *anyopaque, params_size: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetEffectParameters(@as(*IVoice, @ptrCast(self)), effect_index, params, params_size);
    //         }
    //         pub inline fn SetFilterParameters(self: *T, params: *const FILTER_PARAMETERS, operation_set: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetFilterParameters(@as(*IVoice, @ptrCast(self)), params, operation_set);
    //         }
    //         pub inline fn GetFilterParameters(self: *T, params: *FILTER_PARAMETERS) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetFilterParameters(@as(*IVoice, @ptrCast(self)), params);
    //         }
    //         pub inline fn SetOutputFilterParameters(self: *T, dst_voice: ?*IVoice, params: *const FILTER_PARAMETERS, operation_set: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetOutputFilterParameters(@as(*IVoice, @ptrCast(self)), dst_voice, params, operation_set);
    //         }
    //         pub inline fn GetOutputFilterParameters(self: *T, dst_voice: ?*IVoice, params: *FILTER_PARAMETERS) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetOutputFilterParameters(@as(*IVoice, @ptrCast(self)), dst_voice, params);
    //         }
    //         pub inline fn SetVolume(self: *T, volume: f32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetVolume(@as(*IVoice, @ptrCast(self)), volume);
    //         }
    //         pub inline fn GetVolume(self: *T, volume: *f32) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetVolume(@as(*IVoice, @ptrCast(self)), volume);
    //         }
    //         pub inline fn SetChannelVolumes(self: *T, num_channels: UINT32, volumes: [*]const f32, operation_set: UINT32) HRESULT {
    //             return @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .SetChannelVolumes(@as(*IVoice, @ptrCast(self)), num_channels, volumes, operation_set);
    //         }
    //         pub inline fn GetChannelVolumes(self: *T, num_channels: UINT32, volumes: [*]f32) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .GetChannelVolumes(@as(*IVoice, @ptrCast(self)), num_channels, volumes);
    //         }
    //         pub inline fn DestroyVoice(self: *T) void {
    //             @as(*IVoice.VTable, @ptrCast(self.__v))
    //                 .DestroyVoice(@as(*IVoice, @ptrCast(self)));
    //         }
    //     };
    // }

    pub inline fn GetVoiceDetails(self: *IVoice, details: *VOICE_DETAILS) void {
        self.__v.GetVoiceDetails(self, details);
    }

    pub inline fn SetOutputVoices(self: *IVoice, send_list: ?*const VOICE_SENDS) HRESULT {
        return self.__v.SetOutputVoices(self, send_list);
    }

    pub inline fn SetEffectChain(self: *IVoice, effect_index: ?*const EFFECT_CHAIN) HRESULT {
        return self.__v.SetEffectChain(self, effect_index);
    }

    pub inline fn EnableEffect(self: *IVoice, effect_index: UINT32, operation_set: UINT32) HRESULT {
        return self.__v.EnableEffect(self, effect_index, operation_set);
    }

    pub inline fn DisableEffect(self: *IVoice, effect_index: UINT32, operation_set: UINT32) HRESULT {
        return self.__v.DisableEffect(self, effect_index, operation_set);
    }

    pub inline fn GetEffectState(self: *IVoice, effect_index: UINT32, enabled: *BOOL) void {
        self.__v.GetEffectState(self, effect_index, enabled);
    }

    pub inline fn SetEffectParameters(self: *IVoice, effect_index: UINT32, params: *const anyopaque, params_size: UINT32, operation_set: UINT32) HRESULT {
        return self.__v.SetEffectParameters(self, effect_index, params, params_size, operation_set);
    }

    pub inline fn GetEffectParameters(self: *IVoice, effect_index: UINT32, params: *const anyopaque, params_size: UINT32) HRESULT {
        return self.__v.GetEffectParameters(self, effect_index, params, params_size);
    }

    pub inline fn SetFilterParameters(self: *IVoice, params: *const FILTER_PARAMETERS, operation_set: UINT32) HRESULT {
        return self.__v.SetFilterParameters(self, params, operation_set);
    }

    pub inline fn GetFilterParameters(self: *IVoice, params: *FILTER_PARAMETERS) void {
        self.__v.GetFilterParameters(self, params);
    }

    pub inline fn SetOutputFilterParameters(self: *IVoice, dst_voice: ?*IVoice, params: *const FILTER_PARAMETERS, operation_set: UINT32) HRESULT {
        return self.__v.SetOutputFilterParameters(self, dst_voice, params, operation_set);
    }

    pub inline fn GetOutputFilterParameters(self: *IVoice, dst_voice: ?*IVoice, params: *const FILTER_PARAMETERS) void {
        self.__v.GetOutputFilterParameters(self, dst_voice, params);
    }

    pub inline fn SetVolume(self: *IVoice, volume: f32) HRESULT {
        return self.__v.SetVolume(self, volume);
    }

    pub inline fn GetVolume(self: *IVoice, volume: *f32) void {
        self.__v.GetVolume(self, volume);
    }

    pub inline fn SetChannelVolumes(self: *IVoice, num_channels: UINT32, volumes: [*]const f32, operation_set: UINT32) HRESULT {
        return self.__v.SetChannelVolumes(self, num_channels, volumes, operation_set);
    }

    pub inline fn GetChannelVolumes(self: *IVoice, num_channels: UINT32, volumes: [*]f32) void {
        self.__v.GetVoiceDetails(self, num_channels, volumes);
    }

    pub inline fn DestroyVoice(self: *IVoice) void {
        self.__v.GetVoiceDetails(self);
    }

    pub const VTable = extern struct {
        const T = IVoice;
        GetVoiceDetails: *const fn (*T, *VOICE_DETAILS) callconv(WINAPI) void,
        SetOutputVoices: *const fn (*T, ?*const VOICE_SENDS) callconv(WINAPI) HRESULT,
        SetEffectChain: *const fn (*T, ?*const EFFECT_CHAIN) callconv(WINAPI) HRESULT,
        EnableEffect: *const fn (*T, UINT32, UINT32) callconv(WINAPI) HRESULT,
        DisableEffect: *const fn (*T, UINT32, UINT32) callconv(WINAPI) HRESULT,
        GetEffectState: *const fn (*T, UINT32, *BOOL) callconv(WINAPI) void,
        SetEffectParameters: *const fn (*T, UINT32, *const anyopaque, UINT32, UINT32) callconv(WINAPI) HRESULT,
        GetEffectParameters: *const fn (*T, *FILTER_PARAMETERS) callconv(WINAPI) HRESULT,
        SetFilterParameters: *const fn (*T, *const FILTER_PARAMETERS, UINT32) callconv(WINAPI) HRESULT,
        GetFilterParameters: *const fn (*T, *FILTER_PARAMETERS) callconv(WINAPI) void,
        SetOutputFilterParameters: *const fn (*T, ?*IVoice, *const FILTER_PARAMETERS, UINT32) callconv(WINAPI) HRESULT,
        GetOutputFilterParameters: *const fn (*T, ?*IVoice, *FILTER_PARAMETERS) callconv(WINAPI) void,
        SetVolume: *const fn (*T, f32) callconv(WINAPI) HRESULT,
        GetVolume: *const fn (*T, *f32) callconv(WINAPI) void,
        SetChannelVolumes: *const fn (*T, UINT32, [*]const f32, UINT32) callconv(WINAPI) HRESULT,
        GetChannelVolumes: *const fn (*T, UINT32, [*]f32) callconv(WINAPI) void,
        SetOutputMatrix: *anyopaque,
        GetOutputMatrix: *anyopaque,
        DestroyVoice: *const fn (*T) callconv(WINAPI) void
    };
};

pub const IMasteringVoice = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());
    //
    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub usingnamespace IVoice.Methods(T);
    //
    //         pub inline fn GetChannelMask(self: *T, channel_mask: *DWORD) HRESULT {
    //             return @as(*const IMasteringVoice.VTable, @ptrCast(self.__v))
    //                 .GetChannelMask(@as(*IMasteringVoice, @ptrCast(self)), channel_mask);
    //         }
    //     };
    // }

    pub const GetVoiceDetails = IVoice.GetVoiceDetails;
    pub const SetOutputVoices = IVoice.SetOutputVoices;
    pub const SetEffectChain = IVoice.SetEffectChain;
    pub const EnableEffect = IVoice.EnableEffect;
    pub const DisableEffect = IVoice.DisableEffect;
    pub const GetEffectState = IVoice.GetEffectState;
    pub const SetEffectParameters = IVoice.SetEffectParameters;
    pub const GetEffectParameters = IVoice.GetEffectParameters;
    pub const SetFilterParameters = IVoice.SetFilterParameters;
    pub const GetFilterParameters = IVoice.GetFilterParameters;
    pub const SetOutputFilterParameters = IVoice.SetOutputFilterParameters;
    pub const GetOutputFilterParameters = IVoice.GetOutputFilterParameters;
    pub const SetVolume = IVoice.SetVolume;
    pub const GetVolume = IVoice.GetVolume;
    pub const SetChannelVolumes = IVoice.SetChannelVolumes;
    pub const GetChannelVolumes = IVoice.GetChannelVolumes;
    pub const DestroyVoice = IVoice.DestroyVoice;

    pub inline fn GetChannelMask(self: *IMasteringVoice, channel_mask: *DWORD) HRESULT {
        return self.__v.GetChannelMask(self, channel_mask);
    }

    pub const VTable = extern struct {
        base: IVoice.VTable,
        GetChannelMask: *const fn (*IMasteringVoice, *DWORD) callconv(WINAPI) HRESULT,
    };
};

pub const ISourceVoice = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());
    //
    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub usingnamespace IVoice.Methods(T);
    //
    //         pub inline fn Start(self: *T, flags: FLAGS, operation_set: UINT32) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .Start(@as(*ISourceVoice, @ptrCast(self)), flags, operation_set);
    //         }
    //         pub inline fn Stop(self: *T, flags: FLAGS, operation_set: UINT32) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .Stop(@as(*ISourceVoice, @ptrCast(self)), flags, operation_set);
    //         }
    //         pub inline fn SubmitSourceBuffer(self: *T, buffer: *const XAUDIO2_BUFFER, wmabuffer: ?*const XAUDIO2_BUFFER_WMA) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .SubmitSourceBuffer(@as(*ISourceVoice, @ptrCast(self)), buffer, wmabuffer);
    //         }
    //         pub inline fn FlushSourceBuffers(self: *T) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__V))
    //                 .FlushSourceBuffers(@as(*ISourceVoice, @ptrCast(self)));
    //         }
    //         pub inline fn Discontinuity(self: *T) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__V))
    //                 .Discontinuity(@as(*ISourceVoice, @ptrCast(self)));
    //         }
    //         pub inline fn ExitLoop(self: *T, operation_set: UINT32) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .ExitLoop(@as(*ISourceVoice, @ptrCast(self)), operation_set);
    //         }
    //         pub inline fn GetState(self: *T, state: *VOICE_STATE, flags: FLAGS) void {
    //             @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .GetState(@as(*ISourceVoice, @ptrCast(self)), state, flags);
    //         }
    //         pub inline fn SetFrequencyRatio(self: *T, ratio: f32, operation_set: UINT32) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .SetFrequencyRatio(@as(*ISourceVoice, @ptrCast(self)), ratio, operation_set);
    //         }
    //         pub inline fn GetFrequencyRatio(self: *T, ratio: f32) void {
    //             @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .GetFrequencyRatio(@as(*ISourceVoice, @ptrCast(self)), ratio);
    //         }
    //         pub inline fn SetSourceSampleRate(self: *T, sample_rate: UINT32) HRESULT {
    //             return @as(*const ISourceVoice.VTable, @ptrCast(self.__v))
    //                 .SetSourceSampleRate(@as(*ISourceVoice, @ptrCast(self)), sample_rate);
    //         }
    //     };
    // }

    pub inline fn Start(self: *ISourceVoice, flags: FLAGS, operation_set: UINT32) HRESULT {
        return self.__v.Start(self, flags, operation_set);
    }

    pub inline fn Stop(self: *ISourceVoice, flags: FLAGS, operation_set: UINT32) HRESULT {
        return self.__v.Stop(self, flags, operation_set);
    }

    pub inline fn SubmitSourceBuffer(self: *ISourceVoice, buffer: *const XAUDIO2_BUFFER, wmabuffer: ?*const XAUDIO2_BUFFER_WMA) HRESULT {
        return self.__v.SubmitSourceBuffer(self, buffer, wmabuffer);
    }

    pub inline fn FlushSourceBuffers(self: *ISourceVoice) HRESULT {
        return self.__v.FlushSourceBuffers(self);
    }

    pub inline fn Discontinuity(self: *ISourceVoice) HRESULT {
        return self.__v.Discontinuity(self);
    }

    pub inline fn ExitLoop(self: *ISourceVoice, operation_set: UINT32) HRESULT {
        return self.__v.ExitLoop(self, operation_set);
    }

    pub inline fn GetState(self: *ISourceVoice, state: *VOICE_STATE, flags: FLAGS) void {
        self.__v.GetState(self, state, flags);
    }

    pub inline fn SetFrequencyRatio(self: *ISourceVoice, ratio: f32, operation_set: UINT32) HRESULT {
        return self.__v.SetFrequencyRatio(self, ratio, operation_set);
    }

    pub inline fn GetFrequencyRatio(self: *ISourceVoice, ratio: f32) void {
        self.__v.GetFrequencyRatio(self, ratio);
    }

    pub inline fn SetSourceSampleRate(self: *ISourceVoice, sample_rate: UINT32) HRESULT {
        return self.__v.SetSourceSampleRate(self, sample_rate);
    }

    pub const GetVoiceDetails = IVoice.GetVoiceDetails;
    pub const SetOutputVoices = IVoice.SetOutputVoices;
    pub const SetEffectChain = IVoice.SetEffectChain;
    pub const EnableEffect = IVoice.EnableEffect;
    pub const DisableEffect = IVoice.DisableEffect;
    pub const GetEffectState = IVoice.GetEffectState;
    pub const SetEffectParameters = IVoice.SetEffectParameters;
    pub const GetEffectParameters = IVoice.GetEffectParameters;
    pub const SetFilterParameters = IVoice.SetFilterParameters;
    pub const GetFilterParameters = IVoice.GetFilterParameters;
    pub const SetOutputFilterParameters = IVoice.SetOutputFilterParameters;
    pub const GetOutputFilterParameters = IVoice.GetOutputFilterParameters;
    pub const SetVolume = IVoice.SetVolume;
    pub const GetVolume = IVoice.GetVolume;
    pub const SetChannelVolumes = IVoice.SetChannelVolumes;
    pub const GetChannelVolumes = IVoice.GetChannelVolumes;
    pub const DestroyVoice = IVoice.DestroyVoice;

    pub const VTable = extern struct {
        const T = ISourceVoice;
        base: IVoice.VTable,
        Start: *const fn (*T, FLAGS, UINT32) callconv(WINAPI) HRESULT,
        Stop: *const fn (*T, FLAGS, UINT32) callconv(WINAPI) HRESULT,
        SubmitSourceBuffer: *const fn (*T, *const XAUDIO2_BUFFER, ?*const XAUDIO2_BUFFER_WMA) callconv(WINAPI) HRESULT,
        FlushSourceBuffers: *const fn (*T) callconv(WINAPI) HRESULT,
        Discontinuity: *const fn (*T) callconv(WINAPI) HRESULT,
        ExitLoop: *const fn (*T, UINT32) callconv(WINAPI) HRESULT,
        GetState: *const fn (*T, *VOICE_STATE, FLAGS) callconv(WINAPI) void,
        SetFrequencyRatio: *const fn (*T, f32, UINT32) callconv(WINAPI) HRESULT,
        GetFrequencyRatio: *const fn (*T, f32) callconv(WINAPI) void,
        SetSourceSampleRate: *const fn (*T, UINT32) callconv(WINAPI) HRESULT,
    };
};

pub const ISubmixVoice = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());
    //
    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub usingnamespace IVoice.Methods(T);
    //     };
    // }

    pub const GetVoiceDetails = IVoice.GetVoiceDetails;
    pub const SetOutputVoices = IVoice.SetOutputVoices;
    pub const SetEffectChain = IVoice.SetEffectChain;
    pub const EnableEffect = IVoice.EnableEffect;
    pub const DisableEffect = IVoice.DisableEffect;
    pub const GetEffectState = IVoice.GetEffectState;
    pub const SetEffectParameters = IVoice.SetEffectParameters;
    pub const GetEffectParameters = IVoice.GetEffectParameters;
    pub const SetFilterParameters = IVoice.SetFilterParameters;
    pub const GetFilterParameters = IVoice.GetFilterParameters;
    pub const SetOutputFilterParameters = IVoice.SetOutputFilterParameters;
    pub const GetOutputFilterParameters = IVoice.GetOutputFilterParameters;
    pub const SetVolume = IVoice.SetVolume;
    pub const GetVolume = IVoice.GetVolume;
    pub const SetChannelVolumes = IVoice.SetChannelVolumes;
    pub const GetChannelVolumes = IVoice.GetChannelVolumes;
    pub const DestroyVoice = IVoice.DestroyVoice;

    pub const VTable = extern struct {
        base: IVoice.VTable,
    };
};

pub const IXAudio2 = extern struct {
    __v: *const VTable,

    // pub usingnamespace Methods(@This());
    //
    // pub fn Methods(comptime T: type) type {
    //     return extern struct {
    //         pub usingnamespace IUnknown.Methods(T);
    //
    //         pub inline fn RegisterForCallbacks(self: *T, cb: *IEngineCallback) HRESULT {
    //             return @as(*const IXAudio2.VTable, @ptrCast(self.__v))
    //                 .RegisterForCallbacks(@as(*IXAudio2, @ptrCast(self)), cb);
    //         }
    //         pub inline fn UnregisterForCallbacks(self: *T, cb: *IEngineCallback) void {
    //             @as(*const IXAudio2.VTable, @ptrCast(self.__v))
    //                 .UnregisterForCallbacks(@as(*IXAudio2, @ptrCast(self)), cb);
    //         }
    //         pub inline fn CreateSourceVoice(
    //             self: *T,
    //             source_voice: *?*ISourceVoice,
    //             source_format: *const WAVEFORMATEX,
    //             flags: FLAGS,
    //             max_frequency_ratio: f32,
    //             callback: ?*IVoiceCallback,
    //             send_list: ?*const VOICE_SENDS,
    //             effect_chain: ?*const EFFECT_CHAIN,
    //         ) HRESULT {
    //             return @as(*const IXAudio2.VTable, @ptrCast(self.__v)).CreateSourceVoice(
    //                 @as(*IXAudio2, @ptrCast(self)),
    //                 source_voice,
    //                 source_format,
    //                 flags,
    //                 max_frequency_ratio,
    //                 callback,
    //                 send_list,
    //                 effect_chain,
    //             );
    //         }
    //         pub inline fn CreateSubmixVoice(
    //             self: *T,
    //             submix_voice: *?*ISubmixVoice,
    //             input_channels: UINT32,
    //             input_sample_rate: UINT32,
    //             flags: FLAGS,
    //             processing_stage: UINT32,
    //             send_list: ?*const VOICE_SENDS,
    //             effect_chain: ?*const EFFECT_CHAIN,
    //         ) HRESULT {
    //             return @as(*const IXAudio2.VTable, @ptrCast(self.__v)).CreateSubmixVoice(
    //                 @as(*IXAudio2, @ptrCast(self)),
    //                 submix_voice,
    //                 input_channels,
    //                 input_sample_rate,
    //                 flags,
    //                 processing_stage,
    //                 send_list,
    //                 effect_chain,
    //             );
    //         }
    //         pub inline fn CreateMasteringVoice(
    //             self: *T,
    //             mastering_voice: *?*IMasteringVoice,
    //             input_channels: UINT32,
    //             input_sample_rate: UINT32,
    //             flags: FLAGS,
    //             device_id: ?LPCWSTR,
    //             effect_chain: ?*const EFFECT_CHAIN,
    //             stream_category: AUDIO_STREAM_CATEGORY,
    //         ) HRESULT {
    //             return @as(*const IXAudio2.VTable, @ptrCast(self.__v)).CreateMasteringVoice(
    //                 @as(*IXAudio2, @ptrCast(self)),
    //                 mastering_voice,
    //                 input_channels,
    //                 input_sample_rate,
    //                 flags,
    //                 device_id,
    //                 effect_chain,
    //                 stream_category,
    //             );
    //         }
    //         pub inline fn StartEngine(self: *T) HRESULT {
    //             return @as(*const IXAudio2.VTable, @ptrCast(self.__v))
    //                 .StartEngine(@as(*IXAudio2, @ptrCast(self)));
    //         }
    //         pub inline fn StopEngine(self: *T) void {
    //             @as(*const IXAudio2.VTable, @ptrCast(self.__v)).StopEngine(@as(*IXAudio2, @ptrCast(self)));
    //         }
    //         pub inline fn CommitChanges(self: *T, operation_set: UINT32) HRESULT {
    //             return @as(*const IXAudio2.VTable, @ptrCast(self.__v))
    //                 .CommitChanges(@as(*IXAudio2, @ptrCast(self)), operation_set);
    //         }
    //         pub inline fn GetPerformanceData(self: *T, data: *PERFORMANCE_DATA) void {
    //             @as(*const IXAudio2.VTable, @ptrCast(self.__v))
    //                 .GetPerformanceData(@as(*IXAudio2, @ptrCast(self)), data);
    //         }
    //         pub inline fn SetDebugConfiguration(self: *T, config: ?*const DEBUG_CONFIGURATION, reserved: ?*anyopaque) void {
    //             @as(*const IXAudio2.VTable, @ptrCast(self.__v))
    //                 .SetDebugConfiguration(@as(*IXAudio2, @ptrCast(self)), config, reserved);
    //         }
    //     };
    // }

    pub inline fn RegisterForCallbacks(self: *IXAudio2, cb: *IEngineCallback) HRESULT {
        return self.__v.RegisterForCallbacks(self, cb);
    }

    pub inline fn UnregisterForCallbacks(self: *IXAudio2, cb: *IEngineCallback) void {
        self.__v.UnregisterForCallbacks(self, cb);
    }

    pub inline fn CreateSourceVoice(
        self: *IXAudio2,
        source_voice: *?*ISourceVoice,
        source_format: *const WAVEFORMATEX,
        flags: FLAGS,
        max_frequency_ratio: f32,
        callback: ?*IVoiceCallback,
        send_list: ?*const VOICE_SENDS,
        effect_chain: ?*const EFFECT_CHAIN,
    ) HRESULT {
        return self.__v.CreateSourceVoice(
            self,
            source_voice,
            source_format,
            flags,
            max_frequency_ratio,
            callback,
            send_list,
            effect_chain,
        );
    }

    pub inline fn CreateSubmixVoice(
        self: *IXAudio2,
        submix_voice: *?*ISubmixVoice,
        input_channels: UINT32,
        input_sample_rate: UINT32,
        flags: FLAGS,
        processing_stage: UINT32,
        send_list: ?*const VOICE_SENDS,
        effect_chain: ?*const EFFECT_CHAIN,
    ) HRESULT {
        return self.__v.CreateSubmixVoice(self, submix_voice, input_channels, input_sample_rate, flags, processing_stage, send_list, effect_chain);
    }

    pub inline fn CreateMasteringVoice(
        self: *IXAudio2,
        mastering_voice: *?*IMasteringVoice,
        input_channels: UINT32,
        input_sample_rate: UINT32,
        flags: FLAGS,
        device_id: ?LPCWSTR,
        effect_chain: ?*const EFFECT_CHAIN,
        stream_category: AUDIO_STREAM_CATEGORY,
    ) HRESULT {
        return self.__v.CreateMasteringVoice(self, mastering_voice, input_channels, input_sample_rate, flags, device_id, effect_chain, stream_category);
    }

    pub inline fn StartEngine(self: *IXAudio2) HRESULT {
        return self.__v.StartEngine(self);
    }

    pub inline fn StopEngine(self: *IXAudio2) void {
        self.__v.StopEngine(self);
    }

    pub inline fn CommitChanges(self: *IXAudio2, operation_set: UINT32) HRESULT {
        return self.__v.CommitChanges(self, operation_set);
    }

    pub inline fn GetPerformanceData(self: *IXAudio2, data: *PERFORMANCE_DATA) void {
        self.__v.GetPerformanceData(self, data);
    }

    pub inline fn SetDebugConfiguration(self: *IXAudio2, config: ?*const DEBUG_CONFIGURATION, reserved: ?*anyopaque) void {
        self.__v.SetDebugConfiguration(self, config, reserved);
    }

    pub const QueryInterface = win_ext.IUnknown.QueryInterface;
    pub const AddRef = win_ext.IUnknown.AddRef;
    pub const Release = win_ext.IUnknown.Release;

    pub const VTable = extern struct {
        const T = IXAudio2;
        base: IUnknown.VTable,
        RegisterForCallbacks: *const fn (*T, *IEngineCallback) callconv(WINAPI) HRESULT,
        UnregisterForCallbacks: *const fn (*T, *IEngineCallback) callconv(WINAPI) void,
        CreateSourceVoice: *const fn (
            *T,
            *?*ISourceVoice,
            *const WAVEFORMATEX,
            FLAGS,
            f32,
            ?*IVoiceCallback,
            ?*const VOICE_SENDS,
            ?*const EFFECT_CHAIN,
        ) callconv(WINAPI) HRESULT,
        CreateSubmixVoice: *const fn (
            *T,
            *?*ISubmixVoice,
            UINT32,
            UINT32,
            FLAGS,
            UINT32,
            ?*const VOICE_SENDS,
            ?*const EFFECT_CHAIN,
        ) callconv(WINAPI) HRESULT,
        CreateMasteringVoice: *const fn (
            *T,
            *?*IMasteringVoice,
            UINT32,
            UINT32,
            FLAGS,
            ?LPCWSTR,
            ?*const EFFECT_CHAIN,
            AUDIO_STREAM_CATEGORY,
        ) callconv(WINAPI) HRESULT,
        StartEngine: *const fn (*T) callconv(WINAPI) HRESULT,
        StopEngine: *const fn (*T) callconv(WINAPI) void,
        CommitChanges: *const fn (*T, UINT32) callconv(WINAPI) HRESULT,
        GetPerformanceData: *const fn (*T, *PERFORMANCE_DATA) callconv(WINAPI) void,
        SetDebugConfiguration: *const fn (*T, ?*const DEBUG_CONFIGURATION, ?*anyopaque) callconv(WINAPI) void,
    };
};

// IEngineCallback - private default implementations
fn _onProcessingPassStart(_: *IEngineCallback) callconv(WINAPI) void {}
fn _onProcessingPassEnd(_: *IEngineCallback) callconv(WINAPI) void {}
fn _onCriticalError(_: *IEngineCallback, _: HRESULT) callconv(WINAPI) void {}

// IVoiceCallback - private default implementations
fn _onVoiceProcessingPassStart(_: *IVoiceCallback, _: UINT32) callconv(WINAPI) void {}
fn _onVoiceProcessingPassEnd(_: *IVoiceCallback) callconv(WINAPI) void {}
fn _onStreamEnd(_: *IVoiceCallback) callconv(WINAPI) void {}
fn _onBufferStart(_: *IVoiceCallback, _: ?*anyopaque) callconv(WINAPI) void {}
fn _onBufferEnd(_: *IVoiceCallback, _: ?*anyopaque) callconv(WINAPI) void {}
fn _onLoopEnd(_: *IVoiceCallback, _: ?*anyopaque) callconv(WINAPI) void {}
fn _onVoiceError(_: *IVoiceCallback, _: ?*anyopaque, _: HRESULT) callconv(WINAPI) void {}
