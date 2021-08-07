@ECHO OFF
SET "Check_Update_Dir=%TEMP%\MagicXToolbox_psbdgtx"

IF NOT EXIST "%Check_Update_Dir%" EXIT

CALL "%Check_Update_Dir%\Current_Version.bat"
DEL "%Check_Update_Dir%\Current_Version.bat"
PowerShell -NoLogo -NoProfile -COMMAND WGET https://github.com/Ahsan400/MagicX_Mod_Files/raw/master/MagicX_Toolbox/Updater/Toolbox_Update_Info.bat -OutFile "%Check_Update_Dir%\Toolbox_Update_Info.bat" >NUL 2>&1
IF EXIST "%Check_Update_Dir%\Toolbox_Update_Info.bat" (
    CALL "%Check_Update_Dir%\Toolbox_Update_Info.bat"
    DEL "%Check_Update_Dir%\Toolbox_Update_Info.bat"
)

IF DEFINED Current_Version IF DEFINED Update_Version IF "%Update_Version%" GTR "%Current_Version%" (
    PowerShell -NoLogo -NoProfile -COMMAND WGET https://github.com/Ahsan400/MagicX_Mod_Files/raw/master/MagicX_Toolbox/Updater/Changelogs.zip -OutFile "%Check_Update_Dir%\Changelogs.zip" >NUL 2>&1
    PowerShell -NoLogo -NoProfile -COMMAND "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%Check_Update_Dir%\Changelogs.zip', '%Check_Update_Dir%\Changelogs'); }" >NUL 2>&1
    IF EXIST "%Check_Update_Dir%\Changelogs\Changelogs.bat" (
        ECHO Dummy File > "%Check_Update_Dir%\UpdateAvailable.yes"
        DEL "%Check_Update_Dir%\Changelogs.zip"
        EXIT
    )
)

IF EXIST "%Check_Update_Dir%" RMDIR /S /Q "%Check_Update_Dir%"
EXIT
