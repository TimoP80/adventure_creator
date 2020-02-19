{ BASS_FX.DLL 2.0 Multimedia Library, header file date 12.03.03
  Requires BASS 2.0 - available from www.un4seen.com
  -----------------------------
  Please report bugs/suggestions/etc... to wtgdana@aol.com
  -----------------------------
  1) Dynamically load and unload multiple instances of BassFx.Dll

  2) LoadModule reference indexing supported

  The contents of this header file were built upon an original header file
  furnished with BassFx.dll from http://www.un4seen.com/music

  Original copyrights
    Copyright (c) 2002-2003 JOBnik! [Arthur Aminov, ISRAEL]
    Copyright (c) 2002 Roger Johansson. w1dg3r@yahoo.com

  !! CAVEAT !!

  The calling convention for all procedures and functions follow the calling
  conventions defined in BassFx original header files, with one major exception...

    You must use an instance indexing reference.  Example...

    ( This is defined in the bass_dynamic.pas header file )
    type
      TBassInstance = (hBassCD, hBass1, hBass2);

    ( Your code might look something like this... )  
    var
      fPlayer: TBassInstance;
    begin
      fPlayer := hBass1;
      LoadBassDll(fPlayer);
      LoadBassFxDll(fPlayer);
      BASS_Init[fPlayer](idx, fWaveFreq, BASS_DEVICE_LEAVEVOL, fAppHWND);
      BASS_Start[fPlayer]();
        ( ...Do sum stuff... )
      Bass_Stop[fPlayer];
      Bass_Free[fPlayer];
      UnloadBassFxDll(fPlayer);
      UnloadBassDll(fPlayer);
      end;      }

Unit BassFx_Dynamic;

Interface

uses Windows, SysUtils, Classes, Bass_Dynamic;

// defined in Bass_Dynamic.pas...
{$ifdef VER90}
  {$define USE_64_ASM}
{$endif VER90}
{$ifdef VER100}
  {$define USE_64_ASM}
{$endif VER100}
{$ifdef VER110}
  {$define USE_64_ASM}
{$endif VER110}

Type
  EBassFx = class(Exception);
  // defined in Bass_Dynamic.pas...
  DWORD = Cardinal;
  BOOL = LongBool;
  FLOAT = Single;
  QWORD = {$ifdef USE_64_ASM} Comp; {$else} int64; {$endif}  // 64-bit

Const
  // Error codes returned by BASS_FX_ErrorGetCode()
  BASS_FX_OK			= 0;	// All is OK
  BASS_FX_ERROR_MALLOC		= 1;	// Memory allocation error
  BASS_FX_ERROR_FREED		= 2;	// BASS_FX was freed
  BASS_FX_ERROR_BPMINUSE	= 3;	// BPM detection is in use
  BASS_FX_ERROR_BPMX2		= 4;	// BPM has been already mult by 2
  BASS_FX_ERROR_HANDLE		= 5;	// Invalid handle
  BASS_FX_ERROR_FREQ		= 6;	// Illegal sample rate
  BASS_FX_ERROR_NODECODE	= 7;	// Not a decoding channel
  BASS_FX_ERROR_FORMAT		= 8;	// File format is not supported
  BASS_FX_ERROR_STEREO		= 9;	// Only for stereo
  BASS_FX_ERROR_MODLEN		= 10;	// Music loaded without BASS_MUSIC_CALCLEN flag
  BASS_FX_ERROR_BASS20		= 11;	// at least BASS 2.0

type
  TBASS_FX_GetVersion = function: DWORD; stdcall;
var
  BASS_FX_GetVersion: array[TBassInstance] of TBASS_FX_GetVersion;
{
	Retrieve the version number of BASS_FX that is loaded.
	RETURN : The BASS_FX version (LOWORD.HIWORD)
}

type
  TBASS_FX_Free = procedure; stdcall;
var
  BASS_FX_Free: array[TBassInstance] of TBASS_FX_Free;
{
	Free all resources used BASS_FX, including: DSP, TEMPO, REVERSE & BPM.
	[Once this function called, you won't be able to set any FX!]
}

type
  TBASS_FX_ErrorGetCode = function: DWORD; stdcall;
var
  BASS_FX_ErrorGetCode: array[TBassInstance] of TBASS_FX_ErrorGetCode;
{
	Get the BASS_FX_ERROR_xxx error code. Use this function to get the
	reason for an error.
}

{=============================================================================================
	D S P (Digital Signal Processing)
==============================================================================================}

// DSP effects
Const
  BASS_FX_DSPFX_SWAP            = 0;	// Swap channels: left<=>right : for STEREO Only!
  BASS_FX_DSPFX_ROTATE          = 1;	// A channels volume ping-pong : for STEREO Only!
  BASS_FX_DSPFX_ECHO            = 2;    // Echo
  BASS_FX_DSPFX_FLANGER         = 3;    // Flanger
  BASS_FX_DSPFX_VOLUME          = 4;    // Volume Amplifier : L/R for STEREO, L for MONO
  BASS_FX_DSPFX_PEAKEQ          = 5;    // Peaking Equalizer
  BASS_FX_DSPFX_REVERB          = 6;    // Reverb
  BASS_FX_DSPFX_LPF             = 7;    // Low Pass Filter
  BASS_FX_DSPFX_CUT             = 8;    // Sound Cutter
  BASS_FX_DSPFX_FLANGER2        = 9;    // Flanger 2.0!

  // New DSP effects v1.2
  BASS_FX_DSPFX_S2M             = 10;	// Stereo 2 Mono : for STEREO Only!
  BASS_FX_DSPFX_DAMP            = 11;	// Dynamic Amplification
  BASS_FX_DSPFX_AUTOWAH         = 12;	// Auto Wah
  BASS_FX_DSPFX_ECHO2           = 13;	// Echo 2.0!
  BASS_FX_DSPFX_PHASER          = 14;	// Phaser
  BASS_FX_DSPFX_ECHO21          = 15;	// Echo 2.1!


Type
// Flanger
  BASS_FX_DSPFLANGER = Record
    fWetDry : FLOAT;			// [0.........1]
    fSpeed : FLOAT;			// [0.........n]
  end;

// Echo
  BASS_FX_DSPECHO = Record
    fLevel : FLOAT;			// [0.........1]
    lDelay : Integer;			// [1200..30000]
  end;

// Reverb
  BASS_FX_DSPREVERB = Record
    fbLevel : FLOAT;			// [0.........1]
    lbDelay : Integer;			// [1200..10000]
  end;

// Volume
  BASS_FX_DSPVOLUME = Record		// L/R for STEREO, L for MONO for both channels
    fLeft : FLOAT;			// [0....1....n]
    fRight : FLOAT;			// [0....1....n]
  end;

// Peaking Equalizer
  BASS_FX_DSPPEAKEQ = Record
    lBand : Integer;			// [0..n] more bands => more memory & cpu usage
    lFreq : DWORD;			// current sample rate of a stream/music
    fBandwidth : FLOAT;			// in octaves [0..4] - Q is not in use
    fQ : FLOAT;                       	// the EE kinda definition [0..1] - Bandwidth is not in use
    fCenter : FLOAT;			// eg. 1000Hz
    fGain : FLOAT;			// in dB. eg. [-10..0..+10]
  end;

// Low Pass Filter
  BASS_FX_DSPLPF = Record
    lFreq : DWORD;			// current samplerate of stream/music
    fResonance : FLOAT;			// [2..........10]
    fCutOffFreq : FLOAT;		// [200Hz..5000Hz]
  end;

// Cutter
  BASS_FX_DSPCUT = Record
    lCutsPerBeat : Integer;		// [0..n] number of cuts per beat
    fBPM : FLOAT;			// [1..n]
    lFreq : DWORD;			// current samplerate of a stream/music
  end;

// Flanger v2.0!
  BASS_FX_DSPFLANGER2 = Record
    fDelay : FLOAT;		       	// [1.1..3.1] in ms.
    lFreq : DWORD;         		// current samplerate of a stream/music
    fBPM : FLOAT;  	  	    	// [1......n]
    fWetDry : FLOAT;       		// [0.....10]
  end;

// Dynamic Amplification
  BASS_FX_DSPDAMP = Record
    lTarget : Integer;			// target level			e.g: [30000]
    lQuiet : Integer; 			// quiet level			e.g: [  800]
    fRate : FLOAT;			// amp adjustment rate		e.g: [ 0.02]
    fGain : FLOAT;			// amplification level
    lDelay : Integer;			// delay before increasing level
  end;

// Auto WAH
  BASS_FX_DSPAUTOWAH = Record
    dDryMix : FLOAT;			// dry (unaffected) signal mix         [-2.....2]
    dWetMix : FLOAT;			// wet (affected) signal mix           [-2.....2]
    dFeedback : FLOAT;			// feedback                            [-1.....1]
    dRate : FLOAT;			// rate of sweep in cycles per second  [0<...<10]
    dRange : FLOAT;			// sweep range in octaves              [0<...<10]
    dFreq : FLOAT;			// base frequency of sweep Hz          [0<..1000]
  end;

// Echo 2.0!
  BASS_FX_DSPECHO2 = Record
    dDryMix : FLOAT;			// dry (unaffected) signal mix         [-2.....2]
    dWetMix : FLOAT;			// wet (affected) signal mix           [-2.....2]
    dFeedback : FLOAT;			// feedback                            [-1.....1]
    dDelay : FLOAT;			// delay sec                           [0<.....6]
  end;

// Phaser
  BASS_FX_DSPPHASER = Record
    dDryMix : FLOAT;			// dry (unaffected) signal mix         [-2.....2]
    dWetMix : FLOAT;			// wet (affected) signal mix           [-2.....2]
    dFeedback : FLOAT;			// feedback                            [-1.....1]
    dRate : FLOAT;			// rate of sweep in cycles per second  [0<...<10]
    dRange : FLOAT;			// sweep range in octaves              [0<...<10]
    dFreq : FLOAT;			// base frequency of sweep             [0<..1000]
  end;

// Echo 2.1!
  BASS_FX_DSPECHO21 = Record
    dDryMix : FLOAT;			// dry (unaffected) signal mix         [-2.....2]
    dWetMix : FLOAT;			// wet (affected) signal mix           [-2.....2]
    dDelay : FLOAT;			// delay sec                           [0<.....6]
  end;

type
  TBASS_FX_DSP_Set = function(handle: DWORD; dsp_fx: Integer; priority: Integer): BOOL; stdcall;
var
  BASS_FX_DSP_Set: array[TBassInstance] of TBASS_FX_DSP_Set;
{
	Set any chosen DSP FX to any Handle.
	handle   : stream/music/wma/cd
	dsp_fx   : FX you wish to use
	priority : The priority of the new DSP, which determines it's position in the DSP chain
		   DSPs with higher priority are called before those with lower.
	RETURN   : TRUE if created (0=error!)
}

type
  TBASS_FX_DSP_Remove = function(handle: DWORD; dsp_fx: Integer): BOOL; stdcall;
var
  BASS_FX_DSP_Remove: array[TBassInstance] of TBASS_FX_DSP_Remove;
{
	Remove chosen DSP FX.
	handle : stream/music/wma/cd
	dsp_fx : FX you wish to remove
	RETURN : TRUE if removed (0=error!)
}

type
  TBASS_FX_DSP_SetParameters = function(handle: DWORD; dsp_fx: Integer; par: Pointer): BOOL; stdcall;
var
  BASS_FX_DSP_SetParameters: array[TBassInstance] of TBASS_FX_DSP_SetParameters;
{
	Set the parameters of a DSP effect.
	handle : stream/music/wma/cd
	dsp_fx : FX you wish to set parameters to
	par    : Pointer to the parameter type
}

type
  TBASS_FX_DSP_GetParameters = function(handle: DWORD; DSP_FX: Integer; par: Pointer): BOOL; stdcall;
var
  BASS_FX_DSP_GetParameters: array[TBassInstance] of TBASS_FX_DSP_GetParameters;
{
	Set the parameters of a DSP effect.
	handle : stream/music/wma/cd
	dsp_fx : FX you wish to get parameters to
	par    : Pointer to the parameter type
}

type
  TBASS_FX_DSP_Reset = function(handle: DWORD; dsp_fx: Integer): BOOL; stdcall;
var
  BASS_FX_DSP_Reset: array[TBassInstance] of TBASS_FX_DSP_Reset;
{
	Call this function before changing position to avoid *clicks*
	handle : stream/music/wma/cd
	dsp_fx : FX you wish to reset parameters of
	RETURN : TRUE if ok (0=error!)
}

{=============================================================================================
	TEMPO / PITCH SCALING / SAMPLERATE
==============================================================================================}

// tempo flags
Const BASS_FX_TEMPO_QUICKSEEK = 512;     // If you use quicker tempo change algorithm (gain speed, lose quality)

type
  TBASS_FX_TempoCreate = function(chan, flags: DWORD): DWORD; stdcall;
var
  BASS_FX_TempoCreate: array[TBassInstance] of TBASS_FX_TempoCreate;
{
	Creates a Resampling stream from a decoding channel.
	chan   : a Handle returned by:
        		BASS_StreamCreateFile     : flags = BASS_STREAM_DECODE ...
			BASS_MusicLoad            : flags = BASS_MUSIC_DECODE ...
			BASS_WMA_StreamCreateFile : flags = BASS_STREAM_DECODE ...
	        	BASS_CD_StreamCreate      : flags = BASS_STREAM_DECODE ...
	flags  : BASS_SAMPLE_xxx / BASS_SPEAKER_xxx / BASS_FX_TEMPO_QUICKSEEK
	RETURN : the resampled handle (0=error!)
}

type
  TBASS_FX_TempoSet = function(chan: DWORD; tempo: FLOAT; samplerate: Integer; pitch: FLOAT): BOOL; stdcall;
var
  BASS_FX_TempoSet: array[TBassInstance] of TBASS_FX_TempoSet;
{
	Set new values to tempo/rate/pitch to change it's speed.
	chan       : stream/music/wma/cd
	tempo      : in Percents  [-95%..0..+5000%]   			(-100.0 if not in use)
	samplerate : in Hz, but calculates by the same % as tempo	(-1     if not in use)
	pitch      : in Semitones [-60....0....+60]   			(-100.0 if not in use)
	RETURN     : TRUE if ok (0=error!)
}

type
  TBASS_FX_TempoGet = function(chan: DWORD; var tempo: FLOAT; var samplerate: DWORD; var pitch: FLOAT): BOOL; stdcall;
var
  BASS_FX_TempoGet: array[TBassInstance] of TBASS_FX_TempoGet;
{
	Get tempo/rate/pitch values.
        chan       : stream/music/wma/cd
        tempo      : current tempo         (NULL if not in use)
        samplerate : current samplerate    (NULL if not in use)
        pitch      : current pitch         (NULL if not in use)
	RETURN     : TRUE if ok (0=error!)
}

type
  TBASS_FX_TempoGetApproxSeconds = function(chan: DWORD; sec: FLOAT): FLOAT; stdcall;
var
  BASS_FX_TempoGetApproxSeconds: array[TBassInstance] of TBASS_FX_TempoGetApproxSeconds;
{
	Get the approximate seconds from given seconds after changing Tempo or Rate.
        chan   : stream/music/wma/cd
        sec    : seconds to convert
	RETURN : new calculated length in seconds (-1=error!)
}

type
  TBASS_FX_TempoGetApproxPercents = function(chan: DWORD): FLOAT; stdcall;
var
  BASS_FX_TempoGetApproxPercents: array[TBassInstance] of TBASS_FX_TempoGetApproxPercents;
{
	Get the approximate percents of changed Tempo/Rate after changing Tempo or Rate.
        chan   : stream/music/wma/cd
	RETURN : the percents (-1=error!)
}

type
  TBASS_FX_TempoGetResampledHandle = function(chan: DWORD): DWORD; stdcall;
var
  BASS_FX_TempoGetResampledHandle: array[TBassInstance] of TBASS_FX_TempoGetResampledHandle;
{
	Get the resampled handle from a decoding handle.
        chan   : stream/music/wma/cd
	RETURN : the resampled handle (0=error!)
}

type
  TBASS_FX_TempoStopAndFlush = function(chan: DWORD): BOOL; stdcall;
var
  BASS_FX_TempoStopAndFlush: array[TBassInstance] of TBASS_FX_TempoStopAndFlush;
{
	Stop a stream and clear it's buffer.
        chan   : stream/music/wma/cd
	RETURN : TRUE if ok (0=error!)
}

type
  TBASS_FX_TempoFree = procedure(chan: DWORD); stdcall;
var
  BASS_FX_TempoFree: array[TBassInstance] of TBASS_FX_TempoFree;
{
	Free all the resources used by a given handle.
        chan : stream/music/wma/cd
}

{=============================================================================================
	R E V E R S E
==============================================================================================}

//        NOTE: Reverse will NOT work with MOD formats!

type
  TBASS_FX_ReverseCreate = function(chan: DWORD; dec_block: FLOAT; decode: BOOL; flags: DWORD): DWORD; stdcall;
var
  BASS_FX_ReverseCreate: array[TBassInstance] of TBASS_FX_ReverseCreate;
{
	Creates a Reversed stream from a decoding channel.
	chan      : a Handle returned by:
                       BASS_StreamCreateFile     : flags = BASS_STREAM_DECODE
                       BASS_WMA_StreamCreateFile : flags = BASS_STREAM_DECODE ...
                       BASS_CD_StreamCreate      : flags = BASS_STREAM_DECODE ...
		       * For better MP3/2/1 Reverse playback use: BASS_MP3_SETPOS flag
	dec_block : decode in # of seconds blocks...
				larger blocks = less seeking overhead but larger spikes.
	decode	  : allow (TRUE/FALSE) the reversed stream to be created as a decoding channel.
	flags	  : BASS_SAMPLE_xxx / BASS_SPEAKER_xxx
	RETURN    : The reversed handle (0=error!)
}

type
  TBASS_FX_ReverseGetReversedHandle = function(chan: DWORD): DWORD; stdcall;
var
  BASS_FX_ReverseGetReversedHandle: array[TBassInstance] of TBASS_FX_ReverseGetReversedHandle;
{
	Get the reversed handle from a decoding channel.
	chan   : stream handle
	RETURN : The reversed handle (0=error!)
}

type
  TBASS_FX_ReverseSetPosition = function(chan: DWORD; pos: QWORD): BOOL; stdcall;
var
  BASS_FX_ReverseSetPosition: array[TBassInstance] of TBASS_FX_ReverseSetPosition;
{
	Change the playing position of a decoding channel.
	chan   : stream handle
	pos    : the position (in bytes)
	RETURN : TRUE if ok (0=error!)
}

type
  TBASS_FX_ReverseFree = procedure(chan: DWORD); stdcall;
var
  BASS_FX_ReverseFree: array[TBassInstance] of TBASS_FX_ReverseFree;
{
	Free all resources used by a given handle.
	chan : stream handle
}


{=============================================================================================
	B P M (Beats Per Minute)
=============================================================================================}

// bpm flags
Const
  BASS_FX_BPM_BKGRND = 1;   // If in use, then you can do other processing while detecting
  BASS_FX_BPM_MULT2 = 2;    // If in use, then will auto multiple bpm by 2 (if BPM < MinBPM*2)

//-----------
// Option - 1 - Get BPM from a Decoded Channel
//-----------

Type BPMPROCESSPROC = procedure(chan: DWORD; percent: FLOAT); stdcall;
{
	Get the detection process in percents of a channel.
	chan    : channel that the BASS_FX_BPM_GetDecode is being applied to
	percent : the process in percents [0%..100%]
}

type
  TBASS_FX_BPM_DecodeGet = function(chan: DWORD; StartSec, EndSec: FLOAT; MinMaxBPM, flags: DWORD; proc: BPMPROCESSPROC): FLOAT; stdcall;
var
  BASS_FX_BPM_DecodeGet: array[TBassInstance] of TBASS_FX_BPM_DecodeGet;
{
	Get the original BPM of a decoding channel with original frequency
	chan      : a Handle returned by:
			BASS_StreamCreateFile     : flags = BASS_STREAM_DECODE ...
			BASS_MusicLoad            : flags = BASS_MUSIC_DECODE Or BASS_MUSIC_CALCLEN ...
   		        BASS_WMA_StreamCreateFile : flags = BASS_STREAM_DECODE ...
			BASS_CD_StreamCreate      : flags = BASS_STREAM_DECODE ...
	StartSec  : start detecting position in seconds
	EndSec    : end detecting position in seconds - 0 = full length
	MinMaxBPM : set min & max bpm, e.g: MAKELONG(LOWORD.HIWORD), LO=Min, HI=Max. 0 = defaults 45/230
	flags	  : BASS_FX_BPM_xxx
	proc      : user defined function to receive the process in percents, use NULL if not in use
	RETURN    : the original BPM value (-1=error!)
}

//-----------
// Option - 2 - Auto Get BPM by Period of time in seconds.
//-----------

Type BPMPROC = procedure(handle: DWORD; bpm: FLOAT); stdcall;
{
	Get the BPM after period of time in seconds.
	handle : handle that the BASS_FX_BPM_CallbackSet is being applied to
	bpm    : the new original bpm value
}

type
  TBASS_FX_BPM_CallbackSet = function(handle: DWORD; proc: BPMPROC; period: FLOAT; MinMaxBPM, flags: DWORD): BOOL; stdcall;
var
  BASS_FX_BPM_CallbackSet: array[TBassInstance] of TBASS_FX_BPM_CallbackSet;
{
	Enable getting BPM value by period of time in seconds.
	handle    : stream/music/wma/cd
	proc      : user defined function to receive the bpm value
	period	  : detection period in seconds
	MinMaxBPM : set min & max bpm, e.g: MAKELONG(LOWORD.HIWORD), LO=Min, HI=Max. 0 = defaults 45/230
	flags     : only BASS_FX_BPM_MULT2 flag is used
}

type
  TBASS_FX_BPM_CallbackReset = function(handle: DWORD): BOOL; stdcall;
var
  BASS_FX_BPM_CallbackReset: array[TBassInstance] of TBASS_FX_BPM_CallbackReset;
{
	Reset the buffers. Call this function after changing position.
	handle : stream/music/wma/cd
}

{-------------------------------------------------------
   Functions to use with Both options.
	NOTE: These functions will not detect the BPM,
              they will just calculate the detected
              original BPM value of a given handle.
-------------------------------------------------------}

type
  TBASS_FX_BPM_X2 = function(handle: DWORD): FLOAT; stdcall;
var
  BASS_FX_BPM_X2: array[TBassInstance] of TBASS_FX_BPM_X2;
{
	Multiple the original BPM value by 2 (may be called only once).
	handle : stream/music/wma/cd/decoding channel
	RETURN : New BPM value * 2 (-1=error!)
}

type
  TBASS_FX_BPM_Frequency2BPM = function(handle: DWORD; freq: DWORD): FLOAT; stdcall;
var
  BASS_FX_BPM_Frequency2BPM: array[TBassInstance] of TBASS_FX_BPM_Frequency2BPM;
{
	Convert Frequency to BPM value.
	handle : stream/music/wma/cd/decoding channel
	freq   : frequency (e.g 44100).
	RETURN : New BPM value for that handle (-1=error!)
}

type
  TBASS_FX_BPM_2Frequency = function(handle: DWORD; bpm: FLOAT): DWORD; stdcall;
var
  BASS_FX_BPM_2Frequency: array[TBassInstance] of TBASS_FX_BPM_2Frequency;
{
	Convert BPM value to Frequency.
	handle : stream/music/wma/cd/decoding channel
	bpm    : a bpm value (e.g 140.32).
	RETURN : New Frequency for that handle (-1=error!)
}

type
  TBASS_FX_BPM_Percents2BPM = function(handle: DWORD; per: FLOAT): FLOAT; stdcall;
var
  BASS_FX_BPM_Percents2BPM: array[TBassInstance] of TBASS_FX_BPM_Percents2BPM;
{
	Convert Percents to BPM value.
	handle : stream/music/wma/cd/decoding channel
	per    : percent
	RETURN : New BPM value for that handle (-1=error!)
}

type
  TBASS_FX_BPM_2Percents = function(handle: DWORD; bpm: FLOAT): FLOAT; stdcall;
var
  BASS_FX_BPM_2Percents: array[TBassInstance] of TBASS_FX_BPM_2Percents;
{
	Convert BPM to Percents.
	handle : stream/music/wma/cd/decoding channel
	bpm    : a bpm value
	RETURN : New Percents for that handle (-1=error!)
}

type
  TBASS_FX_BPM_Free = procedure(chan: DWORD); stdcall;
var
  BASS_FX_BPM_Free: array[TBassInstance] of TBASS_FX_BPM_Free;
{
	Free all resources used by a given handle.
	chan : stream/music/wma/cd/decoding channel
}

function IsBassFxDllLoaded(hBass: TBassInstance): boolean;
procedure LoadBassFxDll(hBass: TBassInstance);
procedure UnloadBassFxDll(hBass: TBassInstance);
procedure CheckBassFxVersion(hBass: TBassInstance);

var
  BASSFX_Handle: array[TBassInstance] of  Thandle;

implementation

const
  BassFxDll = 'bass_fx.dll' + #0;
  NO_ERROR = 0;
  ERROR_PROC_LOAD = 1;
var
  RefCount: array[TBassInstance] of  Longint;
  doLoad_BASSFX: array[TBassInstance] of  boolean;
  TryAgain: array[TBassInstance] of boolean;
  TempLibNames: TStringList;

procedure InitProcPointers(hBass: TBassInstance);
    procedure doNil(var Ptr);
      begin
        DWord(Ptr) := 0;
        end;
  begin
  BASSFX_Handle[hBass] := 0;
  doNil(BASS_FX_GetVersion[hBass]);
  doNil(BASS_FX_Free[hBass]);
  doNil(BASS_FX_ErrorGetCode[hBass]);
  doNil(BASS_FX_DSP_Set[hBass]);
  doNil(BASS_FX_DSP_Remove[hBass]);
  doNil(BASS_FX_DSP_SetParameters[hBass]);
  doNil(BASS_FX_DSP_GetParameters[hBass]);
  doNil(BASS_FX_DSP_Reset[hBass]);
  doNil(BASS_FX_TempoCreate[hBass]);
  doNil(BASS_FX_TempoSet[hBass]);
  doNil(BASS_FX_TempoGet[hBass]);
  doNil(BASS_FX_TempoGetApproxSeconds[hBass]);
  doNil(BASS_FX_TempoGetApproxPercents[hBass]);
  doNil(BASS_FX_TempoGetResampledHandle[hBass]);
  doNil(BASS_FX_TempoStopAndFlush[hBass]);
  doNil(BASS_FX_TempoFree[hBass]);
  doNil(BASS_FX_ReverseCreate[hBass]);
  doNil(BASS_FX_ReverseGetReversedHandle[hBass]);
  doNil(BASS_FX_ReverseSetPosition[hBass]);
  doNil(BASS_FX_ReverseFree[hBass]);
  doNil(BASS_FX_BPM_DecodeGet[hBass]);
  doNil(BASS_FX_BPM_CallbackSet[hBass]);
  doNil(BASS_FX_BPM_CallbackReset[hBass]);
  doNil(BASS_FX_BPM_X2[hBass]);
  doNil(BASS_FX_BPM_Frequency2BPM[hBass]);
  doNil(BASS_FX_BPM_2Frequency[hBass]);
  doNil(BASS_FX_BPM_Percents2BPM[hBass]);
  doNil(BASS_FX_BPM_2Percents[hBass]);
  doNil(BASS_FX_BPM_Free[hBass]);
  end;

var hBassProcInst: TBassInstance;

function SetInst(hBass: TBassInstance): TBassInstance;
  begin
    hBassProcInst := hBass;
    Result := hBass;
    end;

function ProcLoad(var Proc; ProcName: string): integer;
  begin
    Result := NO_ERROR;
    DWord(Proc) := DWord(GetProcAddress(BASSFX_Handle[hBassProcInst], PChar(ProcName)));
    if (DWord(Proc) = 0) then
      Result := ERROR_PROC_LOAD;
    end;

function GetProcPointers(hBass: TBassInstance): integer;
  begin
    Result :=
      ProcLoad(DWord(@BASS_FX_GetVersion[SetInst(hBass)]), 'BASS_FX_GetVersion' + #0) +
      ProcLoad(DWord(@BASS_FX_Free[hBass]), 'BASS_FX_Free' + #0) +
      ProcLoad(DWord(@BASS_FX_ErrorGetCode[hBass]), 'BASS_FX_ErrorGetCode' + #0) +
      ProcLoad(DWord(@BASS_FX_DSP_Set[hBass]), 'BASS_FX_DSP_Set' + #0) +
      ProcLoad(DWord(@BASS_FX_DSP_Remove[hBass]), 'BASS_FX_DSP_Remove' + #0) +
      ProcLoad(DWord(@BASS_FX_DSP_SetParameters[hBass]), 'BASS_FX_DSP_SetParameters' + #0) +
      ProcLoad(DWord(@BASS_FX_DSP_GetParameters[hBass]), 'BASS_FX_DSP_GetParameters' + #0) +
      ProcLoad(DWord(@BASS_FX_DSP_Reset[hBass]), 'BASS_FX_DSP_Reset' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoCreate[hBass]), 'BASS_FX_TempoCreate' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoSet[hBass]), 'BASS_FX_TempoSet' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoGet[hBass]), 'BASS_FX_TempoGet' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoGetApproxSeconds[hBass]), 'BASS_FX_TempoGetApproxSeconds' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoGetApproxPercents[hBass]), 'BASS_FX_TempoGetApproxPercents' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoGetResampledHandle[hBass]), 'BASS_FX_TempoGetResampledHandle' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoStopAndFlush[hBass]), 'BASS_FX_TempoStopAndFlush' + #0) +
      ProcLoad(DWord(@BASS_FX_TempoFree[hBass]), 'BASS_FX_TempoFree' + #0) +
      ProcLoad(DWord(@BASS_FX_ReverseCreate[hBass]), 'BASS_FX_ReverseCreate' + #0) +
      ProcLoad(DWord(@BASS_FX_ReverseGetReversedHandle[hBass]), 'BASS_FX_ReverseGetReversedHandle' + #0) +
      ProcLoad(DWord(@BASS_FX_ReverseSetPosition[hBass]), 'BASS_FX_ReverseSetPosition' + #0) +
      ProcLoad(DWord(@BASS_FX_ReverseFree[hBass]), 'BASS_FX_ReverseFree' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_DecodeGet[hBass]), 'BASS_FX_BPM_DecodeGet' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_CallbackSet[hBass]), 'BASS_FX_BPM_CallbackSet' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_CallbackReset[hBass]), 'BASS_FX_BPM_CallbackReset' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_X2[hBass]), 'BASS_FX_BPM_X2' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_Frequency2BPM[hBass]), 'BASS_FX_BPM_Frequency2BPM' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_2Frequency[hBass]), 'BASS_FX_BPM_2Frequency' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_Percents2BPM[hBass]), 'BASS_FX_BPM_Percents2BPM' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_2Percents[hBass]), 'BASS_FX_BPM_2Percents' + #0) +
      ProcLoad(DWord(@BASS_FX_BPM_Free[hBass]), 'BASS_FX_BPM_Free' + #0);
      end;

procedure UnloadBassFXDll(hBass: TBassInstance);
  begin
  { Decrement module reference counter }
  if (BASSFX_Handle[hBass] <> 0) and FreeLibrary(BASSFX_Handle[hBass]) then
    Dec(RefCount[hBass]);
  if (BASSFX_Handle[hBass] <> 0) and (RefCount[hBass] > 0) then exit;
  BASSFX_Handle[hBass] := 0;
  doLoad_BASSFX[hBass] := True;
  RefCount[hBass] := 0;
  InitProcPointers(hBass);
  end;

function GetLibraryName(hBass: TBassInstance; CanCreate: boolean): string;
  var
    s: string;
    temppath, tempfile: array[0..MAX_PATH] of Char;
  begin
    if integer(hBass) = 0 then Result := BASS_Path + BassFxDll
    else begin
      GetTempPath(MAX_PATH, temppath);
      s := ChangeFileExt(BassFxDll, '') + IntToStr(integer(hBass)) + ExtractFileExt(BassFxDll);
      StrCopy(tempfile, temppath);
      StrCat(tempfile, PChar(s));
      Result := StrPas(tempfile);
      if (not FileExists(StrPas(tempfile))) and CanCreate then begin
        s := BASS_Path + BassFxDll;
        CopyFile(PChar(s), PChar(Result), False);
        if TempLibNames = nil then TempLibNames := TStringList.Create;
        TempLibNames.Add(Result);
        end;
      end;
    end;

{ A simple check to be sure everything is behaving as expected }
function IsBassFxDllLoaded(hBass: TBassInstance): boolean;
  begin
    Result := ((not doLoad_BASSFX[hBass]) and (BASSFX_Handle[hBass] <> 0) and
              (GetModuleHandle(PChar(GetLibraryName(hBass, False))) <> 0) and
              (RefCount[hBass] > 0));
    end;

procedure LoadBassFxDll(hBass: TBassInstance);
  var
    s: string;
    Count: integer;
    hTemp: THandle;
  begin
    CheckBassVersion(hBass);
    { Increment module reference counter }
    hTemp := LoadLibrary(PChar(GetLibraryName(hBass, True)));
    if hTemp <> 0 then begin
      if doLoad_BASSFX[hBass] or (BASSFX_Handle[hBass] <> hTemp) then begin
        BASSFX_Handle[hBass] := hTemp;
        Count := GetProcPointers(hBass);
        if Count > 0 then raise EBassFx.Create('Load BassFx error count = ' + IntToStr(Count));
        end;
      doLoad_BASSFX[hBass] := False;
      Inc(RefCount[hBass]);
      end;
    if (BASSFX_Handle[hBass] = 0) or doLoad_BASSFX[hBass] then begin
      if (GetLastError = ERROR_NOACCESS) and TryAgain[hBass] then begin
        TryAgain[hBass] := False;
        s := GetLibraryName(hBass, False);
        if DeleteFile(s) then begin
          LoadBassFxDll(hBass);
          exit;
          end;
        end;
      raise EBassFx.Create('Library not loaded : ' + GetLibraryName(hBass, False));
      end;
    end;

procedure CheckBassFxVersion;
  var
    dwVer: DWord;
  begin
    CheckBassVersion(hBass);
    dwVer := BASS_FX_GetVersion[hBass];
    If dwVer < MAKELONG(2,0) then
      raise EBassFx.CreateFmt('Incorrect BassFx.dll version loaded : %d.%d', [LoWord(dwVer), HiWord(dwVer)]);
    end;

var
  i: integer;

Initialization

  TempLibNames := nil;
  for i := integer(Low(TBassInstance)) to integer(High(TBassInstance)) do
    InitProcPointers(TBassInstance(i)); { Initialize proc pointers }
  FillChar(RefCount, SizeOf(RefCount), 0);
  FillChar(doLoad_BASSFx, SizeOf(doLoad_BASSFx), 1);
  FillChar(BASSFX_Handle, SizeOf(BASSFX_Handle), 0);
  FillChar(TryAgain, SizeOf(TryAgain), 1);

Finalization

  if TempLibNames <> nil then begin
    while TempLibNames.Count > 0 do begin
      if FileExists(TempLibNames[TempLibNames.Count - 1]) then
        DeleteFile(TempLibNames[TempLibNames.Count - 1]);
      TempLibNames.Delete(TempLibNames.Count - 1);
      end;
    TempLibNames.Free;
    end;

end.

