
; ===============================================================
; Mega PCM Driver Include File
; (c) 2012, Vladikcomper
; ===============================================================

; ---------------------------------------------------------------
; Variables used in DAC table
; ---------------------------------------------------------------

; flags
panLR	= $C0
panL	= $80
panR	= $40
pcm	= 0
dpcm	= 4
loop	= 2
pri	= 1

; ---------------------------------------------------------------
; Macros
; ---------------------------------------------------------------

z80word macro Value
	dc.w	((\Value)&$FF)<<8|((\Value)&$FF00)>>8
	endm

DAC_Entry macro Pitch,Offset,Flags
	dc.b	\Flags			; 00h	- Flags
	dc.b	\Pitch			; 01h	- Pitch
	dc.b	(\Offset>>15)&$FF	; 02h	- Start Bank
	dc.b	(\Offset\_End>>15)&$FF	; 03h	- End Bank
	z80word	(\Offset)|$8000		; 04h	- Start Offset (in Start bank)
	z80word	(\Offset\_End-1)|$8000	; 06h	- End Offset (in End bank)
	endm
	
IncludeDAC macro Name,Extension
\Name:
	if strcmp('\extension','wav')
		incbin	'dac/\Name\.\Extension\',$3A
	else
		incbin	'dac/\Name\.\Extension\'
	endc
\Name\_End:
	endm

; ---------------------------------------------------------------
; Driver's code
; ---------------------------------------------------------------

MegaPCM:
	incbin	'MegaPCM.z80'

; ---------------------------------------------------------------
; DAC Samples Table
; ---------------------------------------------------------------

	DAC_Entry	$06, Kick, pcm			; $81	- Kick
	DAC_Entry	$02, Snare, pcm		    ; $82	- Snare
	DAC_Entry	$1B, Timpani, dpcm		; $83	- Timpani
	DAC_Entry	$08, Clap, dpcm		; $84	- Clap
	DAC_Entry	$08, Cymbal, dpcm	; $85	- Cymbal
	DAC_Entry	$08, Ride_Cymbal, dpcm	; $86	- Ride Cymbal
	DAC_Entry	$07, SCD_PCM_04, pcm+pri		; $87
	DAC_Entry	$04, TOM01, pcm		    ; $88	- Hi-Timpani
	DAC_Entry	$04, TOM02, pcm		    ; $89	- Mid-Timpani
	DAC_Entry	$04, TOM03, pcm		    ; $8A	- Mid-Low-Timpani
	DAC_Entry	$04, TOM04, pcm		    ; $8B	- Low-Timpani
    DAC_Entry	$0E, Go, dpcm	; $8C	- GO! Sound
	DAC_Entry   	$07, ow, pcm+pri    			; $8D   - ow sound
	DAC_Entry   	$07, SEGApiano, pri, pcm    			; $8E
MegaPCM_End:

; ---------------------------------------------------------------
; DAC Samples Files
; ---------------------------------------------------------------

	IncludeDAC	Kick, bin
	IncludeDAC	Snare, bin
	IncludeDAC	Timpani, bin
	IncludeDAC	Clap, bin
	IncludeDAC	Cymbal, bin
	IncludeDAC	Ride_Cymbal, bin
	IncludeDAC	TOM01, bin
	IncludeDAC	TOM02, bin
	IncludeDAC	TOM03, bin
	IncludeDAC	TOM04, bin
	IncludeDAC Go, bin
	IncludeDAC  ow, wav
	IncludeDAC  SCD_PCM_04, wav
	IncludeDAC  SEGApiano, wav
	even

