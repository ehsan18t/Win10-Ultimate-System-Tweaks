@ECHO OFF
CALL "%WinDir%\Toolbox\Current_Version.bat"
DEL "%WinDir%\Toolbox\Current_Version.bat"
PowerShell -nologo -noprofile -Command wget https://github.com/Ahsan400/MagicX_Mod_Files/raw/master/MagicX_Toolbox/Updater/Toolbox_Update_Info.bat -OutFile %WinDir%\Toolbox\Toolbox_Update_Info.bat >NUL 2>&1
IF EXIST "%WinDir%\Toolbox\Toolbox_Update_Info.bat" (
    CALL "%WinDir%\Toolbox\Toolbox_Update_Info.bat"
    DEL "%WinDir%\Toolbox\Toolbox_Update_Info.bat"
)
IF "%Update_Version%" GTR "%Current_Version%" (
    ECHO Dummy File > "%WinDir%\Toolbox\UpdateAvailable.yes"
)
EXIT
