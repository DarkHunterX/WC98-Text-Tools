@ECHO off

SETLOCAL EnableDelayedExpansion

::============================================================================
:: Variables
::============================================================================

:: ROM file
SET "ROM=game\Wrecking Crew '98 (Japan).sfc"

:: Input files & CPrompt output
SET "FileNames=cmd\filenames.txt"

:: Parent directories
SET "InsertText=output\insert"
SET "TranslText=output\translate"

:: Text sub-directories
SET "TutorialText=%InsertText%\tutorial"
SET "StoryText=%InsertText%\story"

:: Text table files
SET "TutorialTable=%InsertText%\WC98_Tutorial.tbl"
SET "StoryTable=%InsertText%\WC98_Story.tbl"

:: Log files
SET "LogFile=output\insert.log"
SET "TempFile=output\insert.temp"

:: Batch script variables
SET "ErrorCount=0"
SET NL=^& ECHO(


::============================================================================
:: Main
::============================================================================

ECHO ==============================================
ECHO SNES - Wrecking Crew '98 (Japan) Text Inserter
ECHO ============================================== %NL%

CALL :PrepareFiles

ECHO Inserting the tutorial text . . .
ECHO ----------------------------------------------
FOR /f "tokens=3,5 delims={}" %%a IN (%FileNames%) DO (
	SET /a "Counter+=1"
	IF !Counter! LEQ 8 (
		SET "InputFile=%TutorialText%\%%a.txt" & SET "CPrompt=%%b"
		IF !Counter! EQU 1 (
			SET "FilePos=$1C0000" & SET "TextType=tutorial" & CALL :GenerateAtlasHeader
			bin\atlas "%ROM%" !InputFile! >%TempFile%
			CALL :CheckError
		) ELSE (
			CALL :GetFilePos & SET "TextType=tutorial" & CALL :GenerateAtlasHeader
			bin\atlas "%ROM%" !InputFile! >%TempFile%
			CALL :CheckError
		)
	)
)
ECHO ----------------------------------------------
ECHO Done^^! %NL% %NL%

SET "Counter=0"

ECHO Inserting the story text . . .
ECHO ----------------------------------------------
FOR /f "tokens=3,5 delims={}" %%a IN (%FileNames%) DO (
	SET /a "Counter+=1"
	IF !Counter! GEQ 9 IF !Counter! LEQ 19 (
		SET "InputFile=%StoryText%\%%a.txt" & SET "CPrompt=%%b"
		CALL :GetFilePos & SET "TextType=story" & CALL :GenerateAtlasHeader & CALL :Edit_ControlCode
		bin\atlas "%ROM%" !InputFile! >%TempFile%
		CALL :CheckError
	)
)
ECHO ----------------------------------------------
ECHO Done^^! %NL% %NL%

SET "Counter=0"

ECHO Applying text asm patches . . .
ECHO ----------------------------------------------
FOR /f "tokens=1,3 delims={}" %%a IN (%FileNames%) DO (
	SET /a "Counter+=1"
	IF !Counter! EQU 20 (
		SET "InputFile=cmd\asm\%%a" & SET "CPrompt=%%b"
		bin\xkas -o "%ROM%" !InputFile! >%TempFile%
		CALL :CheckError
	)
	IF !Counter! EQU 21 (
		ECHO( & SET "InputFile=cmd\asm\%%a" & SET "CPrompt=%%b"
		:GetLineLength
		SET /p "LineLength= Enter tutorial box line length [4-6]: "
		IF "!LineLength!"=="4" SET "Remove=\/\/5 \/\/6" & GOTO :Expand
		IF "!LineLength!"=="5" SET "Remove=\/\/4 \/\/6" & GOTO :Expand
		IF "!LineLength!"=="6" SET "Remove=\/\/4 \/\/5" & GOTO :Expand
		ECHO ERROR: invalid length^! & GOTO :GetLineLength
		:Expand
		ECHO( & FINDSTR /v "%Remove%" !InputFile! > !InputFile!.temp
		bin\xkas -o "%ROM%" !InputFile!.temp >%TempFile%
		CALL :CheckError

	)
)
ECHO ----------------------------------------------
ECHO Done^^! %NL% %NL%

PAUSE & EXIT


::============================================================================
:: Subroutines
::============================================================================

:PrepareFiles
IF EXIST %LogFile% DEL %LogFile%

:: Copy the script & ROM files
ROBOCOPY %TranslText% %InsertText% /mir >NUL
MKDIR "%InsertText%\game\" & COPY "%ROM%" "%InsertText%\game\inserted.sfc" >NUL & SET "ROM=%InsertText%\game\inserted.sfc"

:: Edit the tutorial table file
IF EXIST %TutorialTable% (
	CALL bin\jrepl "F7={line}\n"       "*F7={line}"    /l /f %TutorialTable% /o "-"
	CALL bin\jrepl "$F8={indent},2"    "F8={indent}"   /l /f %TutorialTable% /o "-"
	CALL bin\jrepl "/F9FF={input}\n\n" "/F9FF={input}" /l /f %TutorialTable% /o "-"
	CALL bin\jrepl "$FA={delay},1"     "FA={delay}"    /l /f %TutorialTable% /o "-"
)

:: Edit the story table file
IF EXIST %TutorialTable% ((ECHO /(end^)) >>%StoryTable%)
GOTO :EOF


:Edit_ControlCode
IF EXIST %InputFile% (
	CALL bin\jrepl "{line}" ""     /l /f "!InputFile!" /o "-"
	CALL bin\jrepl "{end}" "(end)" /l /f "!InputFile!" /o "-"
)
GOTO :EOF


:GetFilePos
FOR /f "tokens=7" %%s IN ('findstr /c:"File Position" %LogFile%') DO SET "FilePos=%%s"
GOTO :EOF


:GenerateAtlasHeader
IF %TextType%==tutorial SET "TableFile=%TutorialTable%"
IF %TextType%==story    SET "TableFile=%StoryTable%"

:: Create header
(ECHO #SMA("HIROM"^)%NL%#VAR(%TextType%, TABLE^)%NL%#ADDTBL("%TableFile%", %TextType%^)%NL%#ACTIVETBL(%TextType%^)%NL%#JMP(%FilePos%, $1FFFFF^)%NL%) >%TempFile%

:: Append to script file
IF EXIST %InputFile% (
	TYPE %InputFile% >> %TempFile%
	MOVE /y %TempFile% %InputFile% >NUL
)
GOTO :EOF


:CheckError
SET "ErrorFlag=0"

IF %Counter% LEQ 19 (
	:: Check for errors
	IF %ErrorFlag% EQU 0 (FINDSTR /c:"Unable to open target file" "%TempFile%" >NUL && (SET /a "ErrorFlag=1"))
	IF %ErrorFlag% EQU 0 (FINDSTR /c:"Unable to open script"      "%TempFile%" >NUL && (SET /a "ErrorFlag=2"))
	IF %ErrorFlag% EQU 0 (FINDSTR /c:"Error: The table file"      "%TempFile%" >NUL && (SET /a "ErrorFlag=3"))
	IF %ErrorFlag% EQU 0 (FINDSTR /c:"Error: Character"           "%TempFile%" >NUL && (SET /a "ErrorFlag=4"))
	IF %ErrorFlag% EQU 0 (FINDSTR /c:"Script Overflowed"          "%TempFile%" >NUL && (SET /a "ErrorFlag=5"))
	IF %ErrorFlag% EQU 0 (FOR /f "tokens=4" %%e IN ('FINDSTR /c:"Bytes Inserted" %TempFile%') DO (SET "DataLength=%%e" & Call :DecToHex))

	:: Print error message
	IF !ErrorFlag! EQU 0 SET "ErrorMsg=!DataLength! bytes"
	IF !ErrorFlag! EQU 1 SET "ErrorMsg=Missing rom file^!"
	IF !ErrorFlag! EQU 2 SET "ErrorMsg=Missing script file^!"
	IF !ErrorFlag! EQU 3 SET "ErrorMsg=Missing table file^!"
	IF !ErrorFlag! EQU 4 SET "ErrorMsg=Missing entry in table file^!"
	IF !ErrorFlag! EQU 5 SET "ErrorMsg=Script overflow^!"
	ECHO !CPrompt! !ErrorMsg!
)
IF %Counter% GEQ 20 (
	:: Check for errors
	IF %ErrorFlag% EQU 0 (FINDSTR /c:"xkas error:" "%TempFile%" >NUL && (SET /a "ErrorFlag=1"))

	:: Print error message
	IF !ErrorFlag! EQU 0 IF %Counter% EQU 20 SET "ErrorMsg=Text loading uses bank $DC"
	IF !ErrorFlag! EQU 0 IF %Counter% EQU 21 SET "ErrorMsg=Tutorial expanded to %LineLength% lines"
	IF !ErrorFlag! EQU 1 SET "ErrorMsg=Assembly error^!
	ECHO !CPrompt! !ErrorMsg!
)

:: Append to log file & delete temp files
TYPE %TempFile% >> %LogFile% & DEL %TempFile%
IF %Counter% EQU 21 DEL !InputFile!.temp

:: Stop processing if error occured
IF NOT %ErrorFlag% EQU 0 (
	ECHO ----------------------------------------------
	IF %Counter% LEQ 19 ECHO Insertion failed, please check the log for details. %NL% %NL%
	IF %Counter% GEQ 20 ECHO Patching failed, please check the log for details. %NL% %NL%
	PAUSE & EXIT
)
GOTO :EOF


:DecToHex
CMD /C EXIT %DataLength% & SET "Hex=!=ExitCode!"
FOR /F "tokens=* delims=0" %%h IN ("%Hex%") DO SET "Hex=%%h"
SET "DataLength=$%Hex%"