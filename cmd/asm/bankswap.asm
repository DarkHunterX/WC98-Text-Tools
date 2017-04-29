//============================================================================
// Wrecking Crew '98 (Japan) - Change the bank text is loaded from.
//============================================================================

arch snes.cpu; hirom

//============================================================================
// Tutorial
//============================================================================

// Control codes & text
org $C3046B
	jsl $C09FF0

// $F8 - horizontal indent
org $C30569
	jsl $C09FF0

// $F8 - vertical indent
org $C30576
	jsl $C09FF0

// $FA - delay timer
org $C30588
	jsl $C09FF0

// Load text from bank $DC
org $C09FF0
	phx
	php
	rep #$30
	ldx $32
	lda $DC0000,x
	plp
	plx
	inc $32
	rtl

// Remove old text ($838A83-839E8F)
org $838A83
	fill $140D, $FF


//============================================================================
// Story Mode
//============================================================================

// Load text from bank $DC
org $D45BD3; lda $DC0000,x
org $D45BDD; lda $DC0002,x
org $D45BE6; lda $DC0002,x
org $D45C09; lda $DC0002,x
org $D45C12; lda $DC0002,x
org $D45C4E; lda $DC0000,x
org $D45C66; lda $DC0000,x
org $D45C7C; lda $DC0000,x

// Remove old text ($D42B7D-D452DC)
org $D42B7D
	fill $2760, $FF