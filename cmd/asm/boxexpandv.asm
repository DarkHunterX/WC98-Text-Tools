//============================================================================
// Wrecking Crew '98 (Japan) - Expand the tutorial text box vertically
// to 4+ lines
//============================================================================

arch snes.cpu; hirom

//============================================================================

// BG tilemap
org $C30223
    ldy #$000A  //4
    ldy #$000C  //5
    ldy #$000E  //6

// Right & left edges
org $C30253
    ldy #$0008  //4
    ldy #$000A  //5
    ldy #$000C  //6

// Cursor
org $C305CC
    adc #$7D27  //4
    adc #$7D67  //5
    adc #$7DA7  //6

// Bottom edge (build)
org $C30294
    pea $0280  //4
    pea $0300  //5
    pea $0380  //6

// Bottom edge (erase)
org $C303CC
    pea $0280  //4
    pea $0300  //5
    pea $0380  //6
