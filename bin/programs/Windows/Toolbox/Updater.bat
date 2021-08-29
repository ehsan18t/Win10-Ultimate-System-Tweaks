@ECHO OFF

FLTMC >NUL 2>&1 || (
	ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\GetAdmin.vbs"
	ECHO UAC.ShellExecute "%~FS0", "", "", "runas", 1 >> "%TEMP%\GetAdmin.vbs"
	CMD /U /C TYPE "%TEMP%\GetAdmin.vbs">"%TEMP%\GetAdminUnicode.vbs"
	CSCRIPT //NOLOGO "%TEMP%\GetAdminUnicode.vbs"
	DEL /F /Q "%TEMP%\GetAdmin.vbs" >NUL 2>&1
	DEL /F /Q "%TEMP%\GetAdminUnicode.vbs" >NUL 2>&1
	EXIT
)

SET "Current_Dir=%~dp0"
SET "Update_Path=%Current_Dir%\Update"

IF NOT EXIST "%Update_Path%" EXIT
IF EXIST "%Update_Path%\PreUpdater.bat" DEL "%Update_Path%\PreUpdater.bat" >NUL 2>&1

COPY /Y "%Update_Path%\*.*" "%Current_Dir%\*.*" >NUL 2>&1
RMDIR /S /Q "%Update_Path%" >NUL 2>&1
START CALL "%Current_Dir%\Toolbox.bat"
EXIT
