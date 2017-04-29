______________________________________________________________________

 SNES - Wrecking Crew '98 (Japan) Text Dumper & Inserter
 Version 1.10 April 29, 2017

 BATCH Scripts by DarkHunter
______________________________________________________________________

 CONTENTS:
______________________________________________________________________

 1. Rom Information
 2. Dumping Text
 3. Inserting Text
 4. Video Overview
 5. Version History
 6. Credits

______________________________________________________________________

 1. ROM INFORMATION:
______________________________________________________________________

 These scripts were written based off the NO-INTRO dump.

 Header     - No
 CRC32      - A24F85FF
 MD5        - 94B140BF2AA47D0A8E1663ABD4B256D6
 SHA-1      - 0221237F39F26C776C5488AB7C61B8C72BFBA3A9
 SHA-256    - 84D115F665DFEE43781F3FFBE7C5985E664490C01427FF93532CFB9F37ECFF0D

______________________________________________________________________

 2. DUMPING TEXT:
______________________________________________________________________

 Setup:
 - Place the rom file (sfc/smc extension) in the folder \game.

 Running dump_text.bat will dump all the tutorial & story text from the rom file in the folder \game.
 The folder \output\translate is created (the translated text and table files go here for insertion).
 All output (text files) is placed in the subfolders of \output\dump.
 If an error is detected it will stop processing and display an error message (for details check the log file in the folder \output).

______________________________________________________________________

 3. INSERTING TEXT:
______________________________________________________________________

 Setup:
 - Place the rom file (sfc/smc extension) in the folder \game.
 - Place the text files in the appropriate subfolder in \output\translate.
 - Place the tutorial & story table files in the folder \output\translate.

 Running insert_text.bat will insert all the tutorial & story text from the text files in the subfolders of \output\translate.
 After the text is finished being inserted, 2 ASM patches will be applied to the rom file:
   - bankswap:  Changes the bank text is loaded from & removes the old text.
   - boxexpandh: Expands the tutorial text box horizontally to 13+ characters.
     NOTE: The script will ask for the number of characters to expand the tutorial text box [13-14] (the game normally uses 13 chars).
   - boxexpandv: Expands the tutorial text box vertically to 4+ lines.
     NOTE: The script will ask for the number of lines to expand the tutorial text box [4-6] (the game normally uses 4 lines).
 All output (modified rom, text, and table files) is placed in the folder \output\insert.
 If an error is detected it will stop processing and display an error message (for details check the log file in the folder \output).

______________________________________________________________________

 4. VIDEO OVERVIEW:
______________________________________________________________________

In case you find the documentation is lacking, here's a quick video overview of the text editing process:

https://www.youtube.com/watch?v=bVsj9GKdquo

______________________________________________________________________

 5. VERSION HISTORY:
______________________________________________________________________

 Version 1.10 April 29, 2017
 - Added missing tutorial text pointers.
 - Updated the panels/rules tutorial text dumping command files.
 - Updated the control codes in the tutorial table file.
 - Updated filenames.txt with new file names.
 - Updated bankswap.asm to create freespace by removing both the old tutorial/story text.
 - Added new ASM file boxexpandh.asm (changes xPos & max character length per line).
 - Added user input for modifying the char length of tutorial text lines during insertion & tweaked
   the error checking of the dump script.
 - Scripts no longer reqire ROM to be named a certain way, it only needs to have a sfc/smc extension.
 - Added more decriptive information to this readme, including a video link of the scripts in action.


 Version 1.00 April 14, 2017
 - First release.

______________________________________________________________________

 6. CREDITS:
______________________________________________________________________

 Klarth      - Atlas & TableLib
 RedComet    - Cartographer
 Revenant    - xkas-plus
 Benham      - JREPL.BAT
