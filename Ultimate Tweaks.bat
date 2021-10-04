@ECHO OFF
SET "VERSION=v2.1"
TITLE Ultimate System Tweaks %VERSION% by Ahsan

SET "Current_Dir=%~dp0"
SET "Bin_Dir=%Current_Dir%\bin"
SET "Programs_Dir=%Bin_Dir%\programs"

FLTMC >NUL 2>&1 || (
	ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\GetAdmin.vbs"
	ECHO UAC.ShellExecute "%~FS0", "", "", "runas", 1 >> "%TEMP%\GetAdmin.vbs"
	CMD /U /C TYPE "%TEMP%\GetAdmin.vbs">"%TEMP%\GetAdminUnicode.vbs"
	CSCRIPT /NOLOGO "%TEMP%\GetAdminUnicode.vbs"
	DEL /F /Q "%TEMP%\GetAdmin.vbs" >NUL 2>&1
	DEL /F /Q "%TEMP%\GetAdminUnicode.vbs" >NUL 2>&1
	EXIT
)

COLOR 0A
ECHO.
ECHO  		**********************************************
ECHO  		**********************************************
ECHO  		***                                        ***
ECHO  		*** 	  Ultimate System Tweaks %VERSION%      ***
ECHO  		***                                        ***
ECHO  		**********************************************
ECHO  		**********************************************
ECHO.
ECHO.

IF NOT EXIST "%SystemDrive%\Program Files (x86)" (
	SET "WINVER=(32-BIT)"
	GOTO :TWEAKS_NOT_SUPPORTED
)

FOR /F "TOKENS=2 DELIMS=[]" %%X IN ('ver') DO (SET "WINVER=%%X" && GOTO :WIN_VER_SEARCH_BREAK)
:WIN_VER_SEARCH_BREAK
SET "WINVER=%WINVER:Version =%"
IF %WINVER% NEQ 10 (
	:TWEAKS_NOT_SUPPORTED
	ECHO.
	ECHO  THIS TWEAKS IS NOT SUPPORTED IN THIS WINDOWS %WINVER%!
	ECHO.
	ECHO  Press any key to exit...
	PAUSE >NUL 2>&1
	EXIT
)

FOR /F "TOKENS=3" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId"') DO (SET "WINVER=%%A")
IF %WINVER% LSS 1803 (
	ECHO.
	ECHO  Ultimate System Tweaks %VERSION% HASN'T BEEN TESTED IN THIS VERSION OF WINDOWS! SOME FEATURES MIGHT NOT WORK!
	ECHO.
	CHOICE /N /C YN /M "=> WOULD YOU STILL LIKE TO CONTINUE? (Y/N)"  
	IF ERRORLEVEL 2 EXIT
)

%Bin_Dir%\Codes.bat 2>&1 | %Bin_Dir%\wtee.exe %Current_Dir%\logs.txt

ECHO.
ECHO  		****************************************
ECHO  		****************************************
ECHO  		***                                  ***
ECHO  		*** 	  OPERATION SUCCESSFUL       ***
ECHO  		***                                  ***
ECHO  		****************************************
ECHO  		****************************************
ECHO.
PAUSE
