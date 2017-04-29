//============================================================================
// Wrecking Crew '98 (Japan) - Expand the tutorial text box horizonatally
// to 13+ characters
//============================================================================

arch snes.cpu; hirom

//============================================================================

// Top-right corner
org $C3024A
    sta $5EFC,x  //13
	sta $5EFE,x  //14

// Middle-right edge
org $C30265
    sta $5EFC,x  //13
	sta $5EFE,x  //14

// Bottom-right corner
org $C30280
    sta $5EFC,x  //13
	sta $5EFE,x  //14

// Top & bottom edges
org $C303AC
    sta $5EFA,x  //13
	sta $5EFC,x  //14

// Box is on right side of screen (xPos, yPos)
org $838000
	db $10, $04  //13
	db $0F, $04  //14

// Box is on left side of screen (xPos, yPos)
org $838004
	db $01, $04  //13
	db $01, $04  //14