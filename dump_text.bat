@ECHO off

SETLOCAL EnableDelayedExpansion

::============================================================================
:: Variables
::============================================================================

:: ROM file
SET "ROM=game\Wrecking Crew '98 (Japan).sfc"

:: Script command files
SET "TutorialCmd=cmd\tutorial"
SET "StoryCmd=cmd\story"

:: Input files & CPrompt output
SET "FileNames=cmd\filenames.txt"

:: Sub-directories for dumped text
SET "TutorialText=output\dump\tutorial"
SET "StoryText=output\dump\story"

:: Sub-directories for translated text
SET "TranslTutorial=output\translate\tutorial"
SET "TranslStory=output\translate\story"

:: Log files
SET "LogFile=output\dump.log"
SET "TempFile=output\dump.temp"

:: Batch script variables
SET "ErrorCount=0"
SET NL=^& ECHO(


::============================================================================
:: Main
::============================================================================

ECHO ============================================
ECHO SNES - Wrecking Crew '98 (Japan) Text Dumper
ECHO ============================================ %NL%

CALL :PrepareFiles

ECHO Dumping the tutorial text . . .
ECHO --------------------------------------------
FOR /f "tokens=1,3,5 delims={}" %%a IN (%FileNames%) DO (
	SET /a Counter+=1
	IF !Counter! LEQ 8 (
		SET "CmdFile=%TutorialCmd%\%%a" & SET "OutFile=%TutorialText%\%%b" & SET "CPrompt=%%c"
		bin\cartographer "%ROM%" !CmdFile! !OutFile!  -s >%TempFile%
		CALL :CheckError
	)
)
ECHO --------------------------------------------
ECHO Done^^! %NL% %NL%

SET "Counter=0"

ECHO Dumping the story text . . .
ECHO --------------------------------------------
FOR /f "tokens=1,3,5 delims={}" %%a IN (%FileNames%) DO (
	SET /a Counter+=1
	IF !Counter! GEQ 9 IF !Counter! LEQ 19 (
		SET "CmdFile=%StoryCmd%\%%a" & SET "OutFile=%StoryText%\%%b" & SET "CPrompt=%%c"
		bin\cartographer "%ROM%" !CmdFile! !OutFile!  -s >%TempFile%
		CALL :CheckError
	)
)
ECHO --------------------------------------------
ECHO Done^^! %NL% %NL%

IF NOT %ErrorCount% EQU 0 ECHO %ErrorCount% errors occured, please check the log for details. %NL%

PAUSE & EXIT


::============================================================================
:: Subroutines
::============================================================================

:PrepareFiles
IF EXIST %LogFile% DEL %LogFile%

:: Create output directories
FOR %%f IN (%TutorialText% %StoryText% %TranslTutorial% %TranslStory%) DO IF NOT EXIST %%f MKDIR %%f
GOTO :EOF


:CheckError
SET "ErrorFlag=0"

IF %ErrorFlag% EQU 0 (
	FINDSTR /c:"Failed to open file" "%TempFile%" >NUL && (
		SET /a "ErrorFlag=1"
		SET /a "ErrorCount+=1"
	)
)
IF %ErrorFlag% EQU 0 (
	FINDSTR /c:"Could not open" "%TempFile%" >NUL && (
		SET /a "ErrorFlag=2"
		SET /a "ErrorCount+=1"
	)
)
IF %ErrorFlag% EQU 0 (
	FINDSTR /c:"Missing one or more pointer commands" "%TempFile%" >NUL && (
		SET /a "ErrorFlag=3"
		SET /a "ErrorCount+=1"
	)
)
IF %ErrorFlag% EQU 0 (
	FINDSTR /c:"Failed to open table" "%TempFile%" >NUL && (
		SET /a "ErrorFlag=4"
		SET /a "ErrorCount+=1"
	)
)
IF %ErrorFlag% EQU 0 (
	FOR /f "tokens=1" %%e IN ('FINDSTR /c:"bytes were dumped successfully!" %TempFile%') DO (
		SET "DataLength=%%e"
	)
)

:: Print error message
IF %ErrorFlag% EQU 0 SET "ErrorMsg=!DataLength! bytes"
IF %ErrorFlag% EQU 1 SET "ErrorMsg=Missing rom file^!"
IF %ErrorFlag% EQU 2 SET "ErrorMsg=Missing command file^!"
IF %ErrorFlag% EQU 3 SET "ErrorMsg=Missing or invalid command^!"
IF %ErrorFlag% EQU 4 SET "ErrorMsg=Missing or invalid table file^!"
ECHO !CPrompt! !ErrorMsg!

:: Append to log file
TYPE %TempFile% >> %LogFile% & DEL %TempFile%
GOTO :EOF