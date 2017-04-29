=======================================================
SNES - Wrecking Crew '98 (Japan) Text Dumper & Inserter
=======================================================

Directory overview:

+-- bin:
	- Atlas          (Klarth) = inserting text
	- Cartographer (RedComet) = dumping text
	- xkas-plus    (Revenant) = asm patching
	- JREPL     (Dave Benham) = search&replace

+-- cmd
	- asm patches/text tables/command files for text operations

+-- game
	- place rom file here
	- by default the batch scripts expect the rom to be named "Wrecking Crew '98 (Japan).sfc"
	- if you want, change SET "ROM=game\Wrecking Crew '98 (Japan).sfc" to SET "ROM=game\YourRomName" under variables in both BAT files
	- ROM Info:
		CRC32:   A24F85FF
		MD5:     94B140BF2AA47D0A8E1663ABD4B256D6
		SHA-1:   0221237F39F26C776C5488AB7C61B8C72BFBA3A9
		SHA-256: 84D115F665DFEE43781F3FFBE7C5985E664490C01427FF93532CFB9F37ECFF0D
		Header:  No

+-- output
	- created during text dumping
	+-- dump
		- the dumped text
	+-- translate
		- place the translated text & table files here
	+-- insert
		- created during text inserting
		- the rom/table/script files are copied here and modified for inserting

NOTE: The text inserting script will ask for the number of lines to expand the tutorial text box [4-6]. The game normally uses 4 lines.