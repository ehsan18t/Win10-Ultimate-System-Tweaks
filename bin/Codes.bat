@ECHO OFF
IF NOT DEFINED Current_Dir (
	ECHO.
	ECHO  YOU'VE RUN THE WRONG FILE! PLEASE FOLLOW THE INSTRUCTIONS!
	ECHO.
	ECHO  Press any key to exit...
	PAUSE >NUL 2>&1
	EXIT
)

ECHO.
ECHO  -^> Creating Restore Point
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description "MagicXMod" -RestorePointType 'MODIFY_SETTINGS'"
ECHO.
ECHO.

ECHO  -^> Copying Necessary Programs to "Windows" Dir
XCOPY /S /Y "%Programs_Dir%\Windows" "%SystemRoot%"

ECHO  -^> Removing Unnecessary Files
ECHO.
ECHO       - Changing Permission of HelpPane.exe
SetACL.exe -on "%WinDir%\HelpPane.exe" -ot file -actn setowner -ownr "n:Administrators"
SetACL.exe -on "%WinDir%\HelpPane.exe" -ot file -actn ace -ace "n:Administrators;p:full"
ECHO.
ECHO       - Removing HelpPane.exe
DEL "%WinDir%\HelpPane.exe"


ECHO  -^> Cleaning Up Context Menu
CALL :Clean_Context

ECHO  -^> Applying Context Menu Tweaks
CALL :Context_Tweaks

ECHO  -^> Importing Console Tweaks to NUTUSER
REGEDIT /S "%Bin_Dir%\Console.reg"

ECHO  -^> Importing Current User Tweaks to NUTUSER
REGEDIT /S "%Bin_Dir%\Current_User.reg"

ECHO  -^> Applying System Tweaks
CALL :System_Tweaks

ECHO  -^> Applying User Tweaks
CALL :User_Tweaks


IF EXIST "%SYSTEMDRIVE%\Program Files\7-Zip" (
	REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip" >nul 2>&1
	IF %ERRORLEVEL% EQU 0 (CALL :7zip)
)

IF EXIST "%SYSTEMDRIVE%\Program Files\WinRAR" (
	REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR archiver" >nul 2>&1
	IF %ERRORLEVEL% EQU 0 (CALL :Winrar)
)



EXIT

:Clean_Context
ECHO.
ECHO       - Taking Ownership of Display Settings (Desktop)
SetACL.exe -on "HKCR\DesktopBackground\Shell\Display" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\DesktopBackground\Shell\Display" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\DesktopBackground\Shell\Display\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\DesktopBackground\Shell\Display\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO.
ECHO       - Deleting Display Setting (Desktop)
REG DELETE "HKCR\DesktopBackground\Shell\Display" /f

ECHO.
ECHO       - Taking Ownership of Personalize (Desktop)
SetACL.exe -on "HKCR\DesktopBackground\Shell\Personalize" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\DesktopBackground\Shell\Personalize" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\DesktopBackground\Shell\Personalize\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\DesktopBackground\Shell\Personalize\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO.
ECHO       - Delete Default Personalize (Desktop)
REG DELETE "HKCR\DesktopBackground\Shell\Personalize" /f



ECHO.
ECHO       - Taking Permission of Powershell Context menu

ECHO            - Desktop
SetACL.exe -on "HKCR\Directory\Background\shell\Powershell" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\Background\shell\Powershell" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\Directory\Background\shell\Powershell\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\Background\shell\Powershell\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO            - Directory
SetACL.exe -on "HKCR\Directory\shell\Powershell" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\shell\Powershell" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\Directory\shell\Powershell\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\shell\Powershell\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO            - Drive
SetACL.exe -on "HKCR\Drive\shell\Powershell" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Drive\shell\Powershell" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\Drive\shell\Powershell\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Drive\shell\Powershell\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO            - Library
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\Powershell" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\Powershell" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\Powershell\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\Powershell\command" -ot reg -actn ace -ace "n:Administrators;p:full"


ECHO.
ECHO       - Removing Powershell From Context menu
REG DELETE "HKCR\Directory\Background\shell\Powershell" /f
REG DELETE "HKCR\Directory\shell\Powershell" /f
REG DELETE "HKCR\Drive\shell\Powershell" /f
REG DELETE "HKCR\LibraryFolder\Background\shell\Powershell" /f




ECHO.
ECHO       - Taking Permission of cmd Context menu

ECHO            - Desktop
SetACL.exe -on "HKCR\Directory\Background\shell\cmd" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\Background\shell\cmd" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\Directory\Background\shell\cmd\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\Background\shell\cmd\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO            - Directory
SetACL.exe -on "HKCR\Directory\shell\cmd" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\shell\cmd" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\Directory\shell\cmd\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Directory\shell\cmd\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO            - Drive
SetACL.exe -on "HKCR\Drive\shell\cmd" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Drive\shell\cmd" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\Drive\shell\cmd\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\Drive\shell\cmd\command" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO            - Library
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\cmd" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\cmd" -ot reg -actn ace -ace "n:Administrators;p:full"
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\cmd\command" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\LibraryFolder\Background\shell\cmd\command" -ot reg -actn ace -ace "n:Administrators;p:full"


ECHO.
ECHO       - Removing CMD From Context menu
REG DELETE "HKCR\Directory\Background\shell\cmd" /f
REG DELETE "HKCR\Directory\shell\cmd" /f
REG DELETE "HKCR\Drive\shell\cmd" /f
REG DELETE "HKCR\LibraryFolder\Background\shell\cmd" /f



ECHO.
ECHO       - Remove Network from Windows Explorer
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn ace -ace "n:Administrators;p:full"
REG ADD "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2954100836" /f
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn ace -ace "n:Administrators;p:read"
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn setowner -ownr "n:nt service\trustedinstaller"



ECHO.
ECHO       - Taking Ownership of Shell
SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell" -ot reg -actn ace -ace "n:Administrators;p:full"

ECHO.
ECHO       - Taking Ownership of Shell for Manage
SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage" -ot reg -actn setowner -ownr "n:Administrators"
SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage" -ot reg -actn ace -ace "n:Administrators;p:full"




ECHO.
ECHO       - Removing Print
REG ADD "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\batfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\cmdfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\docxfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\fonfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\htmlfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\inffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\inifile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\JSEFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\otffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\pfmfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\regfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\rtffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\ttcfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\ttffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\txtfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\VBEFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\VBSFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
REG ADD "HKCR\WSFFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f


ECHO.
ECHO       - Removing BitLocker Options
REG DELETE "HKCR\Drive\shell\suspend-bde" /f
REG DELETE "HKCR\Drive\shell\decrypt-bde" /f
REG DELETE "HKCR\Drive\shell\lock-bde" /f
REG ADD "HKCR\Drive\shell\change-passphrase" /v "LegacyDisable" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\manage-bde" /v "LegacyDisable" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\resume-bde" /v "LegacyDisable" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\resume-bde-elev" /v "LegacyDisable" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\encrypt-bde" /v "LegacyDisable" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\encrypt-bde-elev" /v "LegacyDisable" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\unlock-bde" /v "LegacyDisable" /t REG_SZ /d "" /f


ECHO.
ECHO       - Removing Scan With Windows Defender
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\EPP" /f
REG DELETE "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
REG DELETE "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /f
REG DELETE "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /f

ECHO.
ECHO       - Removing Give Access
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Directory\shellex\CopyHookHandlers\Sharing" /f
REG DELETE "HKCR\Directory\shellex\PropertySheetHandlers\Sharing" /f
REG DELETE "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Drive\shellex\PropertySheetHandlers\Sharing" /f
REG DELETE "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f

ECHO.
ECHO       - Removing Include in Library
REG DELETE "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f
REG DELETE "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f

ECHO.
ECHO       - Removing Open as Portable Devices
REG DELETE "HKLM\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\{D6791A63-E7E2-4fee-BF52-5DED8E86E9B8}" /f

ECHO.
ECHO       - Removing Restore Previous Versions
REG DELETE "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f
REG DELETE "HKCU\Software\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f

ECHO.
ECHO       - Removing Burn Disc Image
REG DELETE "HKCR\Windows.IsoFile\shell\burn" /f

ECHO.
ECHO       - Removing Cast to Device
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /V {7AD84985-87B4-4a16-BE58-8B72A5B390F7} /T REG_SZ /D "Play to Menu" /F

ECHO.
ECHO       - Removing Share
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f

ECHO.
ECHO       - Removing Shortcut Prefix
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f

ECHO.
ECHO       - Removing Troubleshoot Compatibility
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f

ECHO.
ECHO       -  Removing Unnecessary File Types
REG DELETE "HKCR\.bmp\ShellNew" /f
REG DELETE "HKCR\.zip\CompressedFolder\ShellNew" /f
REG DELETE "HKCR\.contact\ShellNew" /f
REG DELETE "HKCR\.library-ms\ShellNew" /f
REG DELETE "HKCR\.rar\ShellNew" /f
REG DELETE "HKCR\.rtf\ShellNew" /f
REG DELETE "HKCR\.zip\ShellNew" /f

EXIT /B


:Context_Tweaks
ECHO.
ECHO       -  Adding PS1 to Run as administrator
REGEDIT /S "%Bin_Dir%\PS1 to Run as administrator.reg"

ECHO.
ECHO       -  Adding Toolbox (Desktop)
REGEDIT /S "%Bin_Dir%\Toolbox.reg"

ECHO.
ECHO       -  Adding Extra File Types
REG ADD "HKCR\.bat\ShellNew" /v "FileName" /t REG_SZ /d "bat.bat" /f
REG ADD "HKCR\.c" /ve /t REG_SZ /d "c" /f
REG ADD "HKCR\.c\ShellNew" /v "FileName" /t REG_SZ /d "c.c" /f
REG ADD "HKCR\c" /ve /t REG_SZ /d "C Programming File" /f
REG ADD "HKCR\.cmd\ShellNew" /v "Filename" /t REG_SZ /d "cmd.cmd" /f
REG ADD "HKCR\.cpp" /ve /t REG_SZ /d "cpp" /f
REG ADD "HKCR\.cpp\ShellNew" /v "FileName" /t REG_SZ /d "cpp.cpp" /f
REG ADD "HKCR\cpp" /ve /t REG_SZ /d "C++ Programming File" /f
REG ADD "HKCR\.html\ShellNew" /v "FileName" /t REG_SZ /d "html.html" /f
REG ADD "HKCR\.js\ShellNew" /v "FileName" /t REG_SZ /d "" /f
REG ADD "HKCR\.ps1\ShellNew" /v "Filename" /t REG_SZ /d "" /f
REG ADD "HKCR\.py" /ve /t REG_SZ /d "py" /f
REG ADD "HKCR\.py\ShellNew" /v "FileName" /t REG_SZ /d "" /f
REG ADD "HKCR\py" /ve /t REG_SZ /d "Python Script File" /f
REG ADD "HKCR\.reg\ShellNew" /v "FileName" /t REG_SZ /d "reg.reg" /f
REG ADD "HKCR\.vbs\ShellNew" /v "Filename" /t REG_SZ /d "" /f
REG ADD "HKCR\.xml\ShellNew" /v "FileName" /t REG_SZ /d "" /f


ECHO.
ECHO       -  Adding Special Menus
ECHO            -  Control Pane - Personalize
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}" /ve /t REG_SZ /d "@%%SystemRoot%%\System32\themecpl.dll,-1#immutable1" /f
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}" /v "InfoTip" /t REG_SZ /d "@%%SystemRoot%%\System32\themecpl.dll,-2#immutable1" /f
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}" /v "System.ApplicationName" /t REG_SZ /d "Microsoft.Personalization" /f
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}" /v "System.ControlPanel.Category" /t REG_DWORD /d "1" /f
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}" /v "System.Software.TasksFileUrl" /t REG_SZ /d "Internal" /f
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\themecpl.dll,-1" /f
REG ADD "HKCR\CLSID\{8a235e4c-9199-4fab-8bcb-806a0601d915}\Shell\Open\command" /ve /t REG_SZ /d "explorer ms-settings:themes" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{8a235e4c-9199-4fab-8bcb-806a0601d915}" /ve /t REG_SZ /d "Personalization" /f

ECHO            -  Add - Custom CMD - NirCMD
REG ADD "HKCR\Directory\Background\shell\OpenCMD" /v "MUIVerb" /t REG_SZ /d "Open Command Prompt" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\cmd.exe" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\1_OpenHere\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\Directory\Background\shell\OpenCMD\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\Directory\shell\OpenCMD" /v "MUIVerb" /t REG_SZ /d "Open Command Prompt" /f
REG ADD "HKCR\Directory\shell\OpenCMD" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\cmd.exe" /f
REG ADD "HKCR\Directory\shell\OpenCMD" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\OpenCMD" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\1_OpenHere\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\Directory\shell\OpenCMD\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\Drive\shell\OpenCMD" /v "MUIVerb" /t REG_SZ /d "Open Command Prompt" /f
REG ADD "HKCR\Drive\shell\OpenCMD" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\cmd.exe" /f
REG ADD "HKCR\Drive\shell\OpenCMD" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\OpenCMD" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\1_OpenHere\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\Drive\shell\OpenCMD\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD" /v "MUIVerb" /t REG_SZ /d "Open Command Prompt" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\cmd.exe" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\1_OpenHere\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "cmd.exe" /f
REG ADD "HKCR\LibraryFolder\Background\shell\OpenCMD\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate cmd.exe /s /k pushd \"%%V\" && TITLE Command Prompt && CMD" /f

ECHO            -  Add - Custom PWShell - NirCMD
REG ADD "HKCR\Directory\Background\shell\PWShell" /v "MUIVerb" /t REG_SZ /d "Open PowerShell Window" /f
REG ADD "HKCR\Directory\Background\shell\PWShell" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe" /f
REG ADD "HKCR\Directory\Background\shell\PWShell" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\PWShell" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\1_OpenHere\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\Directory\Background\shell\PWShell\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\Directory\shell\PWShell" /v "MUIVerb" /t REG_SZ /d "Open PowerShell Window" /f
REG ADD "HKCR\Directory\shell\PWShell" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe" /f
REG ADD "HKCR\Directory\shell\PWShell" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\PWShell" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\1_OpenHere\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\Directory\shell\PWShell\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\Drive\shell\PWShell" /v "MUIVerb" /t REG_SZ /d "Open PowerShell Window" /f
REG ADD "HKCR\Drive\shell\PWShell" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe" /f
REG ADD "HKCR\Drive\shell\PWShell" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\PWShell" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\1_OpenHere\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\Drive\shell\PWShell\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell" /v "MUIVerb" /t REG_SZ /d "Open PowerShell Window" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell" /v "Extended" /t REG_SZ /d "" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\1_OpenHere" /v "MUIVerb" /t REG_SZ /d "Open here" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\1_OpenHere" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\1_OpenHere\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\2_OpenAsAdmin" /v "MUIVerb" /t REG_SZ /d "Open here as Administrator" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\2_OpenAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\2_OpenAsAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
REG ADD "HKCR\LibraryFolder\Background\shell\PWShell\shell\2_OpenAsAdmin\command" /ve /t REG_SZ /d "nircmd elevate powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f

ECHO            -  Desktop - Boost
REG ADD "HKCR\Directory\Background\shell\MagicXBoost" /v "MUIVerb" /t REG_SZ /d "Boost" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost" /v "Position" /t REG_SZ /d "Middle" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\Boost\Boost.ico" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\01_Lite" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\Boost\Lite.ico" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\01_Lite" /v "MUIVerb" /t REG_SZ /d "Boost" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\01_Lite" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\01_Lite\command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%SystemRoot%%\MagicX\Boost\Boost.vbs Lite" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\02_Aggressive" /v "MUIVerb" /t REG_SZ /d "Aggressive Boost" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\02_Aggressive" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\Boost\Aggressive.ico" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\02_Aggressive" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\Background\shell\MagicXBoost\shell\02_Aggressive\command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%SystemRoot%%\MagicX\Boost\Boost.vbs Aggressive" /f

ECHO            -  Desktop - Personalize
REG ADD "HKCR\DesktopBackground\Shell\Personalize" /v "Icon" /t REG_SZ /d "themecpl.dll" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize" /v "MUIVerb" /t REG_SZ /d "Personalize" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\01 Windows Settings" /v "MUIVerb" /t REG_SZ /d "Windows Settings" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\01 Windows Settings" /v "Icon" /t REG_SZ /d "SystemSettingsBroker.exe" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\01 Windows Settings" /v "SettingsURI" /t REG_SZ /d "ms-settings:" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\01 Windows Settings\command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\02 Display Settings" /v "Icon" /t REG_SZ /d "shell32.dll,-35" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\02 Display Settings" /v "MUIVerb" /t REG_SZ /d "Display Settings" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\02 Display Settings" /v "SettingsURI" /t REG_SZ /d "ms-settings:display" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\02 Display Settings\command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\03 Personalization" /v "Icon" /t REG_SZ /d "themecpl.dll" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\03 Personalization" /v "MUIVerb" /t REG_SZ /d "Personalization" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\03 Personalization" /v "SettingsURI" /t REG_SZ /d "ms-settings:personalization-background" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\03 Personalization\command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\04 Time & Language" /v "Icon" /t REG_SZ /d "shell32.dll,-276" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\04 Time & Language" /v "MUIVerb" /t REG_SZ /d "Time && Language" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\04 Time & Language" /v "SettingsURI" /t REG_SZ /d "ms-settings:dateandtime" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\04 Time & Language\command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\05 God Mode" /v "Icon" /t REG_SZ /d "shell32.dll,-137" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\05 God Mode" /v "MUIVerb" /t REG_SZ /d "God Mode" /f
REG ADD "HKCR\DesktopBackground\Shell\Personalize\shell\05 God Mode\command" /ve /t REG_SZ /d "explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f

ECHO            -  Desktop - System Tools
REG ADD "HKCR\Directory\background\shell\Z008AAD" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD" /v "MUIVerb" /t REG_SZ /d "System Tools" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,13" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z009AEA" /v "MUIVerb" /t REG_SZ /d "Computer Management" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z009AEA" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z009AEA\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\mmc.exe\" /s %%SystemRoot%%\system32\compmgmt.msc" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z010AEB" /v "MUIVerb" /t REG_SZ /d "Task Manager" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z010AEB" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\taskmgr.exe" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z010AEB\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\taskmgr.exe\"" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z011AEC" /v "MUIVerb" /t REG_SZ /d "Local Group Policy Editor" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z011AEC" /ve /t REG_EXPAND_SZ /d "Local Group Policy Editor" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z011AEC" /v "Icon" /t REG_EXPAND_SZ /d "gpedit.dll" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z011AEC\command" /ve /t REG_SZ /d "mmc.exe /s gpedit.msc" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z012AED" /v "MUIVerb" /t REG_SZ /d "Registry Editor" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z012AED" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z012AED\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\regedit.exe\"" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z013AEE" /v "MUIVerb" /t REG_SZ /d "Run" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z013AEE" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\shell32.dll,24" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z013AEE\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\explorer.exe\" shell:::{2559A1F3-21D7-11D4-BDAF-00C04F60B9F0}" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z014AEH" /v "MUIVerb" /t REG_SZ /d "Programs and Features" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z014AEH" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\appwiz.cpl" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z014AEH\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\control.exe\" appwiz.cpl" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z015AEP" /v "MUIVerb" /t REG_SZ /d "Msconfig" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z015AEP" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z015AEP\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\msconfig.exe\"" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z016AEK" /v "MUIVerb" /t REG_SZ /d "Device Manager" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z016AEK" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\devmgr.dll,4" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z016AEK\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\mmc.exe\" /s %%SystemRoot%%\system32\devmgmt.msc" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z017AEL" /v "MUIVerb" /t REG_SZ /d "Services" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z017AEL" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SHELL32.dll,90" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z017AEL\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\mmc.exe\" /s %%SystemRoot%%\system32\services.msc" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z018AEN" /v "MUIVerb" /t REG_SZ /d "Control Panel" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z018AEN" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\shell32.dll,21" /f
REG ADD "HKCR\Directory\background\shell\Z008AAD\shell\Z018AEN\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\control.exe\"" /f

ECHO            -  Desktop - Tools
REG ADD "HKCR\Directory\background\shell\Z002AAC" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC" /v "MUIVerb" /t REG_SZ /d "Tools" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,12" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\KillNotResponding" /v "icon" /t REG_SZ /d "taskmgr.exe,-30651" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\KillNotResponding" /v "MUIverb" /t REG_SZ /d "Kill not responding tasks" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\KillNotResponding" /v "Position" /t REG_SZ /d "Top" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\KillNotResponding\command" /ve /t REG_SZ /d "nircmd elevate cmd.exe /K taskkill.exe /F /FI \"status eq NOT RESPONDING\" && exit" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z003ACA" /v "MUIVerb" /t REG_SZ /d "Delete Temporary Files" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z003ACA" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,22" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z003ACA\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /TempClean" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACA" /v "MUIVerb" /t REG_SZ /d "Clean RAM Memory" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACA" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,24" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACA\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /ReduceMemory" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACB" /ve /t REG_SZ /d "Edit HOSTS File" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACB" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACB\command" /ve /t REG_EXPAND_SZ /d "WScript \"%%WinDir%%\MagicX\Utills\OpenHere.vbs\" notepad admin \"%%WinDir%%\System32\drivers\etc\hosts\"" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACC" /v "MUIVerb" /t REG_SZ /d "Restart Windows Explorer" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACC" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,23" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z005ACC\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /ReExplorer" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACF" /v "MUIVerb" /t REG_SZ /d "Show/Hide Hidden Items" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACF" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,26" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACF\command" /ve /t REG_EXPAND_SZ /d "WScript C:\\Windows\\MagicX\\ShowHide\\HideToggle.vbs" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACFF" /v "MUIVerb" /t REG_SZ /d "Show/Hide All Hidden Items" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACFF" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACFF" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,26" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z006ACFF\command" /ve /t REG_EXPAND_SZ /d "WScript %%WinDir%%\MagicX\ShowHide\SuperHideToggle.vbs" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACG" /v "MUIVerb" /t REG_SZ /d "Show or Hide File Extensions" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACG" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,27" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACG\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /HideFileExt" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACGG" /v "MUIVerb" /t REG_SZ /d "Clear Clipboard" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACGG" /v "Icon" /t REG_SZ /d "shell32.dll,-16763" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACGG\command" /ve /t REG_SZ /d "nircmd clipboard clear" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z019AEO" /v "MUIVerb" /t REG_SZ /d "Empty Recycle Bin" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z019AEO" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\shell32.dll,31" /f
REG ADD "HKCR\Directory\background\shell\Z002AAC\shell\Z019AEO\command" /ve /t REG_EXPAND_SZ /d "\"%%ProgramFiles%%\Easy Context Menu\Files\nircmd\nircmd_X64.exe\" emptybin" /f

ECHO            -  Drive - Change Icon
REG ADD "HKCR\Drive\shell\Z003AAK" /v "MUIVerb" /t REG_SZ /d "Change Icon" /f
REG ADD "HKCR\Drive\shell\Z003AAK" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,32" /f
REG ADD "HKCR\Drive\shell\Z003AAK\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /ChangeIcon \"%%1\"" /f

ECHO            -  Drive - Disk CleanUp
REG ADD "HKCR\Drive\shell\Z002AAI" /v "MUIVerb" /t REG_SZ /d "Disk Cleanup" /f
REG ADD "HKCR\Drive\shell\Z002AAI" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f
REG ADD "HKCR\Drive\shell\Z002AAI\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\cleanmgr.exe\" /d %%1" /f

ECHO            -  EXE - Add To Firewall
REG ADD "HKCR\exefile\shell\Z001AAU" /v "MUIVerb" /t REG_SZ /d "Add To Firewall" /f
REG ADD "HKCR\exefile\shell\Z001AAU" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,100" /f
REG ADD "HKCR\exefile\shell\Z001AAU" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\exefile\shell\Z001AAU\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /firewall_add \"%%1\"" /f

ECHO            -  EXE - Delete From Firewall
REG ADD "HKCR\exefile\shell\Z002AAV" /v "MUIVerb" /t REG_SZ /d "Delete From Firewall" /f
REG ADD "HKCR\exefile\shell\Z002AAV" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,101" /f
REG ADD "HKCR\exefile\shell\Z002AAV" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\exefile\shell\Z002AAV\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /firewall_del \"%%1\"" /f

ECHO            -  Files - Block Access
REG ADD "HKCR\*\shell\Z002AAM" /v "MUIVerb" /t REG_SZ /d "Block Access" /f
REG ADD "HKCR\*\shell\Z002AAM" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,15" /f
REG ADD "HKCR\*\shell\Z002AAM" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\*\shell\Z002AAM\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /BlockAccess \"%%1\"" /f

ECHO            -  Files - Permanent Delete
REG ADD "HKCR\*\shell\Z003AAO" /v "MUIVerb" /t REG_SZ /d "Permanently Delete" /f
REG ADD "HKCR\*\shell\Z003AAO" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\shell32.dll,131" /f
REG ADD "HKCR\*\shell\Z003AAO" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\*\shell\Z003AAO\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /PermanentlyDelete \"%%1\"" /f

ECHO            -  Files - Take Ownership
REG ADD "HKCR\*\shell\Z001AAL" /v "MUIVerb" /t REG_SZ /d "Take Ownership" /f
REG ADD "HKCR\*\shell\Z001AAL" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,31" /f
REG ADD "HKCR\*\shell\Z001AAL" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\*\shell\Z001AAL\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /takeown \"%%1\"" /f

ECHO            -  Folder - Block Access
REG ADD "HKCR\Directory\shell\Z003AAM" /v "MUIVerb" /t REG_SZ /d "Block Access" /f
REG ADD "HKCR\Directory\shell\Z003AAM" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,15" /f
REG ADD "HKCR\Directory\shell\Z003AAM" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\Directory\shell\Z003AAM" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"C:\Users\" OR System.ItemPathDisplay:=\"C:\ProgramData\" OR System.ItemPathDisplay:=\"C:\Windows\" OR System.ItemPathDisplay:=\"C:\Windows\System32\" OR System.ItemPathDisplay:=\"C:\Program Files\" OR System.ItemPathDisplay:=\"C:\Program Files (x86)\")" /f
REG ADD "HKCR\Directory\shell\Z003AAM\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /BlockAccess \"%%1\"" /f

ECHO            -  Folder - Change Icon
REG ADD "HKCR\Directory\shell\Z004AAK" /v "MUIVerb" /t REG_SZ /d "Change Icon" /f
REG ADD "HKCR\Directory\shell\Z004AAK" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,32" /f
REG ADD "HKCR\Directory\shell\Z004AAK" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\Directory\shell\Z004AAK\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /ChangeIcon \"%%1\"" /f

ECHO            -  Folder - Copy Folder Content List
REG ADD "HKCR\Directory\shell\Z005AAN" /v "MUIVerb" /t REG_SZ /d "Copy Folder Contents List" /f
REG ADD "HKCR\Directory\shell\Z005AAN" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,33" /f
REG ADD "HKCR\Directory\shell\Z005AAN" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\Directory\shell\Z005AAN\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /CopyFolderContents \"%%1\"" /f

ECHO            -  Folder - Permanent Delete
REG ADD "HKCR\Directory\shell\Z006AAO" /v "MUIVerb" /t REG_SZ /d "Permanently Delete" /f
REG ADD "HKCR\Directory\shell\Z006AAO" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\shell32.dll,131" /f
REG ADD "HKCR\Directory\shell\Z006AAO" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\Directory\shell\Z006AAO" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"C:\Users\" OR System.ItemPathDisplay:=\"C:\ProgramData\" OR System.ItemPathDisplay:=\"C:\Windows\" OR System.ItemPathDisplay:=\"C:\Windows\System32\" OR System.ItemPathDisplay:=\"C:\Program Files\" OR System.ItemPathDisplay:=\"C:\Program Files (x86)\")" /f
REG ADD "HKCR\Directory\shell\Z006AAO\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /PermanentlyDelete \"%%1\"" /f

ECHO            -  Folder - Take Ownership
REG ADD "HKCR\Directory\shell\Z002AAL" /v "MUIVerb" /t REG_SZ /d "Take Ownership" /f
REG ADD "HKCR\Directory\shell\Z002AAL" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,31" /f
REG ADD "HKCR\Directory\shell\Z002AAL" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\Directory\shell\Z002AAL" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"C:\Users\" OR System.ItemPathDisplay:=\"C:\Windows\" OR System.ItemPathDisplay:=\"C:\Windows\System32\")" /f
REG ADD "HKCR\Directory\shell\Z002AAL\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /takeown \"%%1\"" /f

ECHO            -  This PC - Administrative Tools
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\AdministrativeTools" /ve /t REG_EXPAND_SZ /d "Administrative Tools" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\AdministrativeTools" /v "Icon" /t REG_EXPAND_SZ /d "Imageres.dll,109" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\AdministrativeTools\command" /ve /t REG_SZ /d "control.exe /name Microsoft.AdministrativeTools" /f

ECHO            -  This PC - ControlPanel
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\ControlPanel" /ve /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\shell32.dll,-30488" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\ControlPanel" /v "Icon" /t REG_EXPAND_SZ /d "control.exe" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\ControlPanel\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL" /f

ECHO            -  This PC - DeviceManager
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DeviceManager" /ve /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\devmgr.dll,-4" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DeviceManager" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DeviceManager" /v "Icon" /t REG_SZ /d "devmgr.dll,4" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DeviceManager" /v "SuppressionPolicy" /t REG_DWORD /d "1073741884" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DeviceManager\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\devmgmt.msc" /f

ECHO            -  This PC - DiskManagement
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DiskManagement" /ve /t REG_SZ /d "Disk Management" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DiskManagement" /v "Icon" /t REG_SZ /d "dmdskres.dll" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DiskManagement\command" /ve /t REG_SZ /d "mmc.exe /s diskmgmt.msc" /f

ECHO            -  This PC - LocalGroupPolicyEditor
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\LocalGroupPolicyEditor" /ve /t REG_EXPAND_SZ /d "Local Group Policy Editor" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\LocalGroupPolicyEditor" /v "Icon" /t REG_EXPAND_SZ /d "gpedit.dll" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\LocalGroupPolicyEditor\command" /ve /t REG_SZ /d "mmc.exe /s gpedit.msc" /f

ECHO            -  This PC - Manage (Position)
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage" /ve /t REG_EXPAND_SZ /d "@%%systemroot%%\system32\mycomput.dll,-400" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage" /v "MUIVerb" /t REG_EXPAND_SZ /d "@%%systemroot%%\system32\mycomput.dll,-400" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage" /v "SuppressionPolicy" /t REG_DWORD /d "1073741884" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage" /v "Position" /t REG_SZ /d "Top" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\CompMgmtLauncher.exe" /f

ECHO            -  This PC - ProgramsAndFeatures
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\ProgramsAndFeatures" /ve /t REG_EXPAND_SZ /d "Programs and Features" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\ProgramsAndFeatures" /v "Icon" /t REG_EXPAND_SZ /d "appwiz.cpl,4" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\ProgramsAndFeatures\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl" /f

ECHO            -  This PC - Reboot Menu - This PC
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH" /v "MUIVerb" /t REG_SZ /d "Turn Off Options" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,14" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z016ADA" /v "MUIVerb" /t REG_SZ /d "Turn Off Menu" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z016ADA" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,12" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z016ADA\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /M" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z017ADB" /v "MUIVerb" /t REG_SZ /d "Lock User" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z017ADB" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,15" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z017ADB\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /UL" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z018ADC" /v "MUIVerb" /t REG_SZ /d "Switch User" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z018ADC" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,16" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z018ADC\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /US" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z019ADD" /v "MUIVerb" /t REG_SZ /d "Log Off" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z019ADD" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,17" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z019ADD\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /L" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z020ADE" /v "MUIVerb" /t REG_SZ /d "Sleep" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z020ADE" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,18" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z020ADE\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /SM" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z021ADF" /v "MUIVerb" /t REG_SZ /d "Hibernate" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z021ADF" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,20" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z021ADF\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /H" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z022ADG" /v "MUIVerb" /t REG_SZ /d "Restart" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z022ADG" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,19" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z022ADG\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /R" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z022ADGG" /v "MUIVerb" /t REG_SZ /d "Restart to Recovery" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z022ADGG" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,19" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z022ADGG\command" /ve /t REG_SZ /d "shutdown.exe /r /o /f /t 00" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z023ADH" /v "MUIVerb" /t REG_SZ /d "Shut Down" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z023ADH" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,14" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z023ADH\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /S" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z024ADI" /v "MUIVerb" /t REG_SZ /d "Shut Down Force" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z024ADI" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,14" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z015AAH\shell\Z024ADI\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Shutdown /S /F" /f

ECHO            -  This PC -Registry.reg
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegRegistry" /ve /t REG_EXPAND_SZ /d "Registry" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegRegistry" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegRegistry" /v "Icon" /t REG_EXPAND_SZ /d "regedit.exe" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegRegistry\command" /ve /t REG_EXPAND_SZ /d "%%systemroot%%\regedit.exe" /f

ECHO            -  This PC -Services.reg
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegServices" /ve /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\shell32.dll,-22059" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegServices" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegServices" /v "Icon" /t REG_EXPAND_SZ /d "filemgmt.dll" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegServices" /v "SuppressionPolicy" /t REG_DWORD /d "1073741884" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\RegServices\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\services.msc" /f

ECHO            -  This PC - SafeMode
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\SafeMode" /v "Icon" /t REG_SZ /d "Imageres.dll,184" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\SafeMode" /v "MUIVerb" /t REG_SZ /d "Safe Mode" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\SafeMode" /v "SubCommands" /t REG_SZ /d "NormalReboot;SafeMode;SafeModeCMD;SafeModeNetwork" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NormalReboot" /ve /t REG_SZ /d "Normal Mode" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NormalReboot" /v "Icon" /t REG_SZ /d "Imageres.dll,184" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NormalReboot" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NormalReboot\command" /ve /t REG_EXPAND_SZ /d "WScript %%WinDir%%\MagicX\SafeMode\NormalReboot.vbs" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeMode" /ve /t REG_SZ /d "Safe Mode" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeMode" /v "Icon" /t REG_SZ /d "Imageres.dll,184" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeMode" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeMode\command" /ve /t REG_EXPAND_SZ /d "WScript %%WinDir%%\MagicX\SafeMode\SafeMode.vbs" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeCMD" /ve /t REG_SZ /d "Safe Mode with Command Window" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeCMD" /v "Icon" /t REG_SZ /d "Imageres.dll,184" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeCMD" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeCMD\command" /ve /t REG_EXPAND_SZ /d "WScript %%WinDir%%\MagicX\SafeMode\SafeModeCMD.vbs" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeNetwork" /ve /t REG_SZ /d "Safe Mode with Network" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeNetwork" /v "Icon" /t REG_SZ /d "Imageres.dll,184" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeNetwork" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\SafeModeNetwork\command" /ve /t REG_EXPAND_SZ /d "WScript %%WinDir%%\MagicX\SafeMode\SafeModeNetwork.vbs" /f

ECHO            -  This PC - System Tools
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG" /v "MUIVerb" /t REG_SZ /d "System Tools" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,13" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z010AEA" /v "MUIVerb" /t REG_SZ /d "Computer Management" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z010AEA" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z010AEA" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z010AEA\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\mmc.exe\" /s %%SystemRoot%%\system32\compmgmt.msc" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z011AEB" /v "MUIVerb" /t REG_SZ /d "Task Manager" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z011AEB" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\taskmgr.exe" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z011AEB\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\taskmgr.exe\"" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z012AEE" /v "MUIVerb" /t REG_SZ /d "Run" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z012AEE" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\shell32.dll,24" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z012AEE\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\explorer.exe\" shell:::{2559A1F3-21D7-11D4-BDAF-00C04F60B9F0}" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z013AEI" /v "MUIVerb" /t REG_SZ /d "All Tasks" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z013AEI" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\control.exe" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z013AEI\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\explorer.exe\" shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z014AEP" /v "MUIVerb" /t REG_SZ /d "Msconfig" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z014AEP" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z009AAG\shell\Z014AEP\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\msconfig.exe\"" /f

ECHO            -  This PC - Tools
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF" /v "MUIVerb" /t REG_SZ /d "Tools" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,12" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z002ACA" /v "MUIVerb" /t REG_SZ /d "Delete Temporary Files" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z002ACA" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,22" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z002ACA\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /TempClean" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z003ACB" /v "MUIVerb" /t REG_SZ /d "Restart Windows Explorer" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z003ACB" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,23" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z003ACB\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /ReExplorer" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z004ACC" /v "MUIVerb" /t REG_SZ /d "Clean RAM Memory" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z004ACC" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,24" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z004ACC\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /Admin /ReduceMemory" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z005ACF" /v "MUIVerb" /t REG_SZ /d "Show or Hide Hidden Files and Folders" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z005ACF" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,26" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z005ACF\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /HiddenFile" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z006ACG" /v "MUIVerb" /t REG_SZ /d "Show or Hide File Extensions" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z006ACG" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,27" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z006ACG\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /HideFileExt" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z007ACH" /v "MUIVerb" /t REG_SZ /d "Rebuild Shell Icon Cache" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z007ACH" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,28" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z007ACH\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /ReIconCache" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z008ACJ" /v "MUIVerb" /t REG_SZ /d "Copy IP" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z008ACJ" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe,30" /f
REG ADD "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Z001AAF\shell\Z008ACJ\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\MagicX\NecessaryLib\EcMenu.exe\" /CopyIP" /f


EXIT /B

:System_Tweaks
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexOnBattery" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingOutlook" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingEmailAttachments" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d "3" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t REG_DWORD /d "3" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventRemoteQueries" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SYSTEM\ControlSet001\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f
REG ADD "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "CallLegacyWCMPolicies" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Peernet" /v "Disabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge" /v "PreventFirstRunPage" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Security" /v "FlashClickToRunMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\TPM" /v "OSManagedAuthLevel" /t REG_DWORD /d "4" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f
EXIT /B


:User_Tweaks
ECHO       -  Disable Apps and Icons Auto Update
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
 
ECHO       -  Disable include drivers in Windows Update
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f


ECHO       -  Disable GameBar
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f

ECHO       -  Disable MAP Data Auto Download
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f
 
ECHO       -  Disable Reserved_Storage
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f
 
ECHO       -  Disable UAC
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
 
ECHO       -  Disable WD Smart Screen
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f
 
ECHO       -  Disable Web or Being Search
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
 
ECHO       -  EDGE Patches
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge" /v "PreventFirstRunPage" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Security" /v "FlashClickToRunMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f

ECHO       -  Other Patches
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Narrator\NoRoam" /v "WinEnterLaunchEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "OnlineServicesEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common" /v "sendcustomerdata" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common\Feedback" /v "enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common\Feedback" /v "includescreenshot" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common" /v "qmenable" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common" /v "updatereliabilitydata" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common\General" /v "shownfirstrunoptin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common\General" /v "skydrivesigninoption" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common\ptwatson" /v "ptwoptin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Firstrun" /v "disablemovie" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM" /v "Enablelogging" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "accesssolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "olksolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "onenotesolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "pptsolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "projectsolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "publishersolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "visiosolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "wdsolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "xlsolution" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "agave" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "appaddins" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "comaddins" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "documentfiles" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "templatefiles" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "BackupPolicy" /t REG_DWORD /d "60" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "DeviceMetadataUploaded" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SettingsVersion" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "PriorLogons" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableThumbsDBOnNetworkFolders" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AutoCheckSelect" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "2" /f
REG ADD "HKCU\SOFTWARE\Sysinternals\SDelete" /v "EulaAccepted" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "ConfirmationCheckBoxDoForAll" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexOnBattery" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingOutlook" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingEmailAttachments" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d "3" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t REG_DWORD /d "3" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventRemoteQueries" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SYSTEM\ControlSet001\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f
REG ADD "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "CallLegacyWCMPolicies" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Peernet" /v "Disabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge" /v "PreventFirstRunPage" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Security" /v "FlashClickToRunMode" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\TPM" /v "OSManagedAuthLevel" /t REG_DWORD /d "4" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "BackupPolicy" /t REG_DWORD /d "60" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "DeviceMetadataUploaded" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SettingsVersion" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "PriorLogons" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "SettingsVersion" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f


REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f


REG ADD "HKCR\Directory\shell\Z003AAM" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"%SystemDrive%\Users\" OR System.ItemPathDisplay:=\"%UserProfile%\" OR System.ItemPathDisplay:=\"%SystemDrive%\ProgramData\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\System32\" OR System.ItemPathDisplay:=\"%SystemDrive%\Program Files\" OR System.ItemPathDisplay:=\"%SystemDrive%\Program Files (x86)\")" /f
REG ADD "HKCR\Directory\shell\Z006AAO" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"%SystemDrive%\Users\" OR System.ItemPathDisplay:=\"%UserProfile%\" OR System.ItemPathDisplay:=\"%SystemDrive%\ProgramData\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\System32\" OR System.ItemPathDisplay:=\"%SystemDrive%\Program Files\" OR System.ItemPathDisplay:=\"%SystemDrive%\Program Files (x86)\")" /f
REG ADD "HKCR\Directory\shell\Z002AAL" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"%SystemDrive%\Users\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\System32\")" /f

FOR /F "DELIMS=%%L" %%A IN ('"POWERCFG /L | FINDSTR /I "^(Ultimate""') DO (GOTO :BREAK_POWER_ADD)
POWERCFG -DUPLICATESCHEME e9a42b02-d5df-448d-aa00-03f14749eb61
:BREAK_POWER_ADD

FOR /F "DELIMS=%%L" %%A IN ('"POWERCFG /L | FINDSTR /I "^(Ultimate""') DO (SET "Power_ID=%%A" && GOTO :BREAK_POWER_SEARCH)
:BREAK_POWER_SEARCH
IF DEFINED Power_ID SET "Power_ID=%Power_ID:~19, 36%"

FOR /F "DELIMS=%%L" %%A IN ('"POWERCFG /getactivescheme | FINDSTR /I "^(Ultimate""') DO (GOTO :BREAK_POWER_SELECTION)
POWERCFG /S %Power_ID%
:BREAK_POWER_SELECTION

sc.exe config BDESVC start= Disabled
sc.exe config CscService start= Disabled
sc.exe config dmwappushservice start= Disabled
sc.exe config Fax start= Disabled
sc.exe config FrameServer start= Disabled
sc.exe config HvHost start= Disabled
sc.exe config lfsvc start= Disabled
sc.exe config lmhosts start= Disabled
sc.exe config MSiSCSI start= Disabled
sc.exe config PcaSvc start= Disabled
sc.exe config PeerDistSvc start= Disabled
sc.exe config PhoneSvc start= Disabled
sc.exe config RpcLocator start= Disabled
sc.exe config SCardSvr start= Disabled
sc.exe config ScDeviceEnum start= Disabled
sc.exe config SCPolicySvc start= Disabled
sc.exe config SEMgrSvc start= Disabled
sc.exe config SensorDataService start= Disabled
sc.exe config SensorService start= Disabled
sc.exe config SensrSvc start= Disabled
sc.exe config SharedAccess start= Disabled
sc.exe config SmsRouter start= Disabled
sc.exe config SNMPTRAP start= Disabled
sc.exe config TabletInputService start= Disabled
sc.exe config TrkWks start= Disabled
sc.exe config vmicguestinterface start= Disabled
sc.exe config vmicheartbeat start= Disabled
sc.exe config vmickvpexchange start= Disabled
sc.exe config vmicrdv start= Disabled
sc.exe config vmicshutdown start= Disabled
sc.exe config vmictimesync start= Disabled
sc.exe config vmicvmsession start= Disabled
sc.exe config vmicvss start= Disabled
sc.exe config WinRM start= Disabled
sc.exe config XboxGipSvc start= Disabled

net stop BDESVC /y
net stop CscService /y
net stop dmwappushservice /y
net stop Fax /y
net stop FrameServer /y
net stop HvHost /y
net stop lfsvc /y
net stop lmhosts /y
net stop MSiSCSI /y
net stop PcaSvc /y
net stop PeerDistSvc /y
net stop PhoneSvc /y
net stop RpcLocator /y
net stop SCardSvr /y
net stop ScDeviceEnum /y
net stop SCPolicySvc /y
net stop SEMgrSvc /y
net stop SensorDataService /y
net stop SensorService /y
net stop SensrSvc /y
net stop SharedAccess /y
net stop SmsRouter /y
net stop SNMPTRAP /y
net stop TabletInputService /y
net stop TrkWks /y
net stop vmicguestinterface /y
net stop vmicheartbeat /y
net stop vmickvpexchange /y
net stop vmicrdv /y
net stop vmicshutdown /y
net stop vmictimesync /y
net stop vmicvmsession /y
net stop vmicvss /y
net stop WinRM /y
net stop XboxGipSvc /y
EXIT /B




:Winrar
REG ADD "HKCU\Software\WinRAR" /v "ExportedSettings" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Compression" /v "DefFolder" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Extraction" /v "DefFolder" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Extraction" /v "AppendName" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Extraction" /v "RemoveRedundantFolder" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Extraction" /v "UseExclNames" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Extraction" /v "ExclNames" /t REG_SZ /d "*.exe *.com *.pif *.scr *.bat *.cmd *.lnk" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "Detailed" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "ArchivesFirst" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "ColorAttr" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "AllVolumes" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "ShowSeconds" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "ExactSizes" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "ShowGrid" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "FullRow" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "Checkboxes" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "SingleClick" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "Underline" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\FileList" /v "ArcSort" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\FileList\ArcColumnWidths" /v "name" /t REG_DWORD /d "328" /f
REG ADD "HKCU\Software\WinRAR\FileList\ArcColumnWidths" /v "size" /t REG_DWORD /d "80" /f
REG ADD "HKCU\Software\WinRAR\FileList\ArcColumnWidths" /v "psize" /t REG_DWORD /d "80" /f
REG ADD "HKCU\Software\WinRAR\FileList\ArcColumnWidths" /v "type" /t REG_DWORD /d "120" /f
REG ADD "HKCU\Software\WinRAR\FileList\ArcColumnWidths" /v "mtime" /t REG_DWORD /d "124" /f
REG ADD "HKCU\Software\WinRAR\FileList\ArcColumnWidths" /v "crc" /t REG_DWORD /d "70" /f
REG ADD "HKCU\Software\WinRAR\FileList\FileColumnWidths" /v "name" /t REG_DWORD /d "322" /f
REG ADD "HKCU\Software\WinRAR\FileList\FileColumnWidths" /v "size" /t REG_DWORD /d "129" /f
REG ADD "HKCU\Software\WinRAR\FileList\FileColumnWidths" /v "type" /t REG_DWORD /d "147" /f
REG ADD "HKCU\Software\WinRAR\FileList\FileColumnWidths" /v "mtime" /t REG_DWORD /d "131" /f
REG ADD "HKCU\Software\WinRAR\General" /v "VerInfo" /t REG_BINARY /d "000006006206aa0986d0d601" /f
REG ADD "HKCU\Software\WinRAR\General" /v "Priority" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "SMP" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "History" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "DlgHistory" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "WizardMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "OnTop" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "ShowComment" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "Log" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "LimitLog" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "LogSize" /t REG_DWORD /d "1000" /f
REG ADD "HKCU\Software\WinRAR\General" /v "ReuseWindow" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "Sound" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "RestoreFolder" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General" /v "WipeTemp" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "Threads" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General" /v "LastFolder" /t REG_SZ /d "C:\Users\Ahsan\Desktop" /f
REG ADD "HKCU\Software\WinRAR\General\Toolbar" /v "Size" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\General\Toolbar" /v "ButtonsText" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\General\Toolbar" /v "Lock" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\General\Toolbar\Layout" /v "Band76_0" /t REG_BINARY /d "4c000000730100000402000000000000f0f0f0000000000000000000000000000000000000000000c00202000000000000000000370000000002000000000000000000000000000001000000" /f
REG ADD "HKCU\Software\WinRAR\General\Toolbar\Layout" /v "Band76_1" /t REG_BINARY /d "4c000000730100000500000000000000f0f0f0000000000000000000000000000000000000000000d40202000000000000000000180000002a00000000000000000000000000000002000000" /f
REG ADD "HKCU\Software\WinRAR\General\Toolbar\Layout" /v "Band76_2" /t REG_BINARY /d "4c000000730100000400000000000000f0f0f0000000000000000000000000000000000000000000240017000000000000000000180000006400000000000000000000000000000003000000" /f
REG ADD "HKCU\Software\WinRAR\Interface" /v "FullPathsTitle" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Interface" /v "SystemProgressBar" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Interface" /v "TaskbarProgressBar" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Interface" /v "AsArchives" /t REG_SZ /d "*.exe" /f
REG ADD "HKCU\Software\WinRAR\Interface" /v "ShowPassword" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Interface\Comment" /v "LeftBorder" /t REG_DWORD /d "453" /f
REG ADD "HKCU\Software\WinRAR\Interface\MainWin" /v "Placement" /t REG_BINARY /d "2c0000000000000001000000ffffffffffffffffffffffffffffffff600000004d000000aa0300009c020000" /f
REG ADD "HKCU\Software\WinRAR\Interface\Themes" /v "ShellExtIcon" /t REG_SZ /d "C:\Users\Ahsan\AppData\Roaming\WinRAR\Themes\Win20_JonDemon_32x32\Rar.ico" /f
REG ADD "HKCU\Software\WinRAR\Interface\Themes" /v "ActivePath" /t REG_SZ /d "Win20_JonDemon_32x32" /f
REG ADD "HKCU\Software\WinRAR\Interface\Themes" /v "ShellExtBMP" /t REG_SZ /d "C:\Users\Ahsan\AppData\Roaming\WinRAR\Themes\Win20_JonDemon_32x32\RarSmall.bmp" /f
REG ADD "HKCU\Software\WinRAR\Paths" /v "TempRemovableOnly" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Paths" /v "StartFolder" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Name" /t REG_SZ /d "Default Profile" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Default" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ImmExec" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ExclNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "StoreNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "UseRAR" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "RAR5" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SFXModule" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SFXIcon" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SFXLogo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SFXElevate" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "CmtFile" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "CmtDataWide" /t REG_BINARY /d "0000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "VolumeSize" /t REG_SZ /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "VolSizeMod" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "VolPause" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "OldVolNames" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "RecVolNumber" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Update" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Fresh" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SyncFiles" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Overwrite" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Move" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ArcRecBin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ArcWipe" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "WipeIfPassword" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Solid" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Test" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "RecEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "RecSize" /t REG_DWORD /d "4294967293" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "EraseDest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "AddArcOnly" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ClearArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Lock" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Method" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "DictSizeLZ" /t REG_DWORD /d "4194304" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "DictSize" /t REG_DWORD /d "33554432" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Background" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "WaitForOther" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "Shutdown" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "PasswordData" /t REG_BINARY /d "00" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "EncryptHeaders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ZipLegacyEncrypt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "OpenShared" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ProcessOwners" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SaveStreams" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SaveSymLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SaveHardLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "GenerateArcName" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "VersionControl" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "BLAKE2" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "FileCopies" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "QuickOpen" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "GenerateMask" /t REG_SZ /d "yyyymmddhhmmss" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "FileTimeMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "FileDays" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "FileHours" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "FileMinutes" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ArcTimeOriginal" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ArcTimeLatest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "mtime" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "ctime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "atime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "PreserveAtime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "PathsAbs" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "PathsNone" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "PathsAbsDrive" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SeparateArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SeparateArcDoubleExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "SeparateArcSubfolders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "EmailArcTo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\0" /v "PackDetails" /t REG_BINARY /d "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Name" /t REG_SZ /d "Create e-mail attachment" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Default" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ImmExec" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ExclNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "StoreNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "UseRAR" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "RAR5" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SFXModule" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SFXIcon" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SFXLogo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SFXElevate" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "CmtFile" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "CmtDataWide" /t REG_BINARY /d "0000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "VolumeSize" /t REG_SZ /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "VolSizeMod" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "VolPause" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "OldVolNames" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "RecVolNumber" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Update" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Fresh" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SyncFiles" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Overwrite" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Move" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ArcRecBin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ArcWipe" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "WipeIfPassword" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Solid" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Test" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "RecEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "RecSize" /t REG_DWORD /d "4294967293" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "EraseDest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "AddArcOnly" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ClearArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Lock" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Method" /t REG_DWORD /d "5" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "DictSizeLZ" /t REG_DWORD /d "33554432" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "DictSize" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Background" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "WaitForOther" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "Shutdown" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "PasswordData" /t REG_BINARY /d "00" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "EncryptHeaders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ZipLegacyEncrypt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "OpenShared" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ProcessOwners" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SaveStreams" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SaveSymLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SaveHardLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "GenerateArcName" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "VersionControl" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "BLAKE2" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "FileCopies" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "QuickOpen" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "GenerateMask" /t REG_SZ /d "yyyymmddhhmmss" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "FileTimeMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "FileDays" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "FileHours" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "FileMinutes" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ArcTimeOriginal" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ArcTimeLatest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "mtime" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "ctime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "atime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "PreserveAtime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "PathsAbs" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "PathsNone" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "PathsAbsDrive" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SeparateArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SeparateArcDoubleExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "SeparateArcSubfolders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "EmailArcTo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\1" /v "PackDetails" /t REG_BINARY /d "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Name" /t REG_SZ /d "Backup selected files" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Default" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ImmExec" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ExclNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "StoreNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "UseRAR" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "RAR5" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SFXModule" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SFXIcon" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SFXLogo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SFXElevate" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "CmtFile" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "CmtDataWide" /t REG_BINARY /d "0000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "VolumeSize" /t REG_SZ /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "VolSizeMod" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "VolPause" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "OldVolNames" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "RecVolNumber" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Update" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Fresh" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SyncFiles" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Overwrite" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Move" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ArcRecBin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ArcWipe" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "WipeIfPassword" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Solid" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Test" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "RecEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "RecSize" /t REG_DWORD /d "4294967293" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "EraseDest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "AddArcOnly" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ClearArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Lock" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Method" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "DictSizeLZ" /t REG_DWORD /d "33554432" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "DictSize" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Background" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "WaitForOther" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "Shutdown" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "PasswordData" /t REG_BINARY /d "00" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "EncryptHeaders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ZipLegacyEncrypt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "OpenShared" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ProcessOwners" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SaveStreams" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SaveSymLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SaveHardLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "GenerateArcName" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "VersionControl" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "BLAKE2" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "FileCopies" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "QuickOpen" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "GenerateMask" /t REG_SZ /d "yyyymmddhhmmss" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "FileTimeMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "FileDays" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "FileHours" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "FileMinutes" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ArcTimeOriginal" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ArcTimeLatest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "mtime" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "ctime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "atime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "PreserveAtime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "PathsAbs" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "PathsNone" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "PathsAbsDrive" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SeparateArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SeparateArcDoubleExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "SeparateArcSubfolders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "EmailArcTo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\2" /v "PackDetails" /t REG_BINARY /d "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Name" /t REG_SZ /d "Create 10 MB volumes" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Default" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ImmExec" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ExclNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "StoreNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "UseRAR" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "RAR5" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SFXModule" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SFXIcon" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SFXLogo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SFXElevate" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "CmtFile" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "CmtDataWide" /t REG_BINARY /d "0000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "VolumeSize" /t REG_SZ /d "10485760" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "VolSizeMod" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "VolPause" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "OldVolNames" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "RecVolNumber" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Update" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Fresh" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SyncFiles" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Overwrite" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Move" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ArcRecBin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ArcWipe" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "WipeIfPassword" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Solid" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Test" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "RecEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "RecSize" /t REG_DWORD /d "4294967293" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "EraseDest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "AddArcOnly" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ClearArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Lock" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Method" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "DictSizeLZ" /t REG_DWORD /d "33554432" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "DictSize" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Background" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "WaitForOther" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "Shutdown" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "PasswordData" /t REG_BINARY /d "00" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "EncryptHeaders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ZipLegacyEncrypt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "OpenShared" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ProcessOwners" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SaveStreams" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SaveSymLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SaveHardLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "GenerateArcName" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "VersionControl" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "BLAKE2" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "FileCopies" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "QuickOpen" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "GenerateMask" /t REG_SZ /d "yyyymmddhhmmss" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "FileTimeMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "FileDays" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "FileHours" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "FileMinutes" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ArcTimeOriginal" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ArcTimeLatest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "mtime" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "ctime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "atime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "PreserveAtime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "PathsAbs" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "PathsNone" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "PathsAbsDrive" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SeparateArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SeparateArcDoubleExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "SeparateArcSubfolders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "EmailArcTo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\3" /v "PackDetails" /t REG_BINARY /d "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Name" /t REG_SZ /d "ZIP archive (low compression)" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Default" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ImmExec" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ExclNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "StoreNames" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "UseRAR" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "RAR5" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SFXModule" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SFXIcon" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SFXLogo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SFXElevate" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "CmtFile" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "CmtDataWide" /t REG_BINARY /d "0000" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "VolumeSize" /t REG_SZ /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "VolSizeMod" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "VolPause" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "OldVolNames" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "RecVolNumber" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Update" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Fresh" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SyncFiles" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Overwrite" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Move" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ArcRecBin" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ArcWipe" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "WipeIfPassword" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Solid" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Test" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "RecEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "RecSize" /t REG_DWORD /d "4294967293" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "EraseDest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "AddArcOnly" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ClearArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Lock" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Method" /t REG_DWORD /d "3" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Background" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "WaitForOther" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "Shutdown" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "PasswordData" /t REG_BINARY /d "00" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "EncryptHeaders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ZipLegacyEncrypt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "OpenShared" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ProcessOwners" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SaveStreams" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SaveSymLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SaveHardLinks" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "GenerateArcName" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "VersionControl" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "BLAKE2" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "FileCopies" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "QuickOpen" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "GenerateMask" /t REG_SZ /d "yyyymmddhhmmss" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "FileTimeMode" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "FileDays" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "FileHours" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "FileMinutes" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ArcTimeOriginal" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ArcTimeLatest" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "mtime" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "ctime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "atime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "PreserveAtime" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "PathsAbs" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "PathsNone" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "PathsAbsDrive" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SeparateArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SeparateArcDoubleExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "SeparateArcSubfolders" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "EmailArcTo" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Profiles\4" /v "PackDetails" /t REG_BINARY /d "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
REG ADD "HKCU\Software\WinRAR\Setup" /v "ShellExt" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup" /v "CascadedMenu" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup" /v "MenuIcons" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup" /v "CustomExt" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.001" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.001" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.001" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.001" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.7z" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.7z" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.7z" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.7z" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.arj" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.arj" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.arj" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.arj" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz2" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz2" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz2" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.bz2" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.cab" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.cab" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.cab" /v "Type" /t REG_SZ /d "CABFolder" /f
REG ADD "HKCU\Software\WinRAR\Setup\.cab" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.gz" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.gz" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.gz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.gz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.iso" /v "Set" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.jar" /v "Set" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lha" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lha" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lha" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lz" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lzh" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lzh" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lzh" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.lzh" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.rar" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.rar" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.rar" /v "Type" /t REG_SZ /d "VLC.rar" /f
REG ADD "HKCU\Software\WinRAR\Setup\.rar" /v "ShellNew" /t REG_SZ /d "C:\Program Files\WinRAR\rarnew.dat" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tar" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tar" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tar" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tar" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.taz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.taz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.taz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tbz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tbz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tbz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tbz2" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tbz2" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tbz2" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tgz" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tgz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tgz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tlz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tlz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.tlz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.txz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.txz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.txz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uu" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uu" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uu" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uue" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uue" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uue" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.uue" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xxe" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xxe" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xxe" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xz" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xz" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xz" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.xz" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.z" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.z" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.z" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.z" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zip" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zip" /v "Exist" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zip" /v "Type" /t REG_SZ /d "VLC.zip" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zip" /v "ShellNew" /t REG_SZ /d "C:\Program Files\WinRAR\zipnew.dat" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zipx" /v "Set" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zipx" /v "Exist" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zipx" /v "Type" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\.zipx" /v "ShellNew" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Setup\Links" /v "Desktop" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\Links" /v "StartMenu" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\Links" /v "Programs" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "ExtrTo" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "ExtrHere" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "Extr" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "ExtrSep" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "OpenSFX" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "OpenArc" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "AddTo" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "AddArc" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "EmailArc" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "EmailOpt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "Test" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "Convert" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "SFXLocal" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "SFXNetwork" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "SFXOther" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "DragAdd" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "DragExtr" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Setup\MenuItems" /v "AlwaysArc" /t REG_SZ /d "*.iso" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "Type" /t REG_DWORD /d "2" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "Autodetect" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "ReuseWindow" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "Wrap" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "ViewerUnpackAll" /t REG_SZ /d "*.exe *.msi *.htm *.html *.part*.rar" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "ViewerIgnoreModifications" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\Viewer" /v "ExternalViewer" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\WinRAR\VirusScan" /v "Prompt" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\WinRAR" /v "exe64" /t REG_SZ /d "C:\Program Files\WinRAR\WinRAR.exe" /f
REG ADD "HKLM\Software\WinRAR\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".rar" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".zip" /t REG_SZ /d "WinRAR.ZIP" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".cab" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".arj" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".lz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".tlz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".lzh" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".lha" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".7z" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".tar" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".gz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".tgz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".uue" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".xxe" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".uu" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".bz2" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".tbz2" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".bz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".tbz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".jar" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".iso" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".z" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".taz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".xz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".txz" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".zipx" /t REG_SZ /d "WinRAR" /f
REG ADD "HKLM\Software\WinRAR\Capabilities\FileAssociations" /v ".001" /t REG_SZ /d "WinRAR" /f
REG DELETE "HKCR\lnkfile\shellex\ContextMenuHandlers\WinRAR32" /f
REG DELETE "HKCR\lnkfile\shellex\ContextMenuHandlers\WinRAR" /f
EXIT /B


:7zip
REG ADD "HKCU\Software\7-Zip" /v "Path64" /t REG_SZ /d "C:\Program Files\7-Zip\\" /f
REG ADD "HKCU\Software\7-Zip" /v "Path" /t REG_SZ /d "C:\Program Files\7-Zip\\" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "FolderShortcuts" /t REG_BINARY /d "" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "FolderHistory" /t REG_BINARY /d "43003a005c00550073006500720073005c00410064006d0069006e006900730074007200610074006f0072005c004400650073006b0074006f0070005c0037007a0031003900300032002d007800360034002e006500780065005c0000000000" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "PanelPath0" /t REG_SZ /d "C:\Users\Administrator\Desktop\\" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "FlatViewArc0" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "PanelPath1" /t REG_SZ /d "" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "FlatViewArc1" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "ListMode" /t REG_DWORD /d "771" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "Position" /t REG_BINARY /d "4e0000002f000000cb0300004002000000000000" /f
REG ADD "HKCU\Software\7-Zip\FM" /v "Panels" /t REG_BINARY /d "0100000000000000b4010000" /f
REG ADD "HKCU\Software\7-Zip\FM\Columns" /v "RootFolder" /t REG_BINARY /d "0100000000000000010000000400000001000000a0000000" /f
REG ADD "HKCU\Software\7-Zip\FM\Columns" /v "7-Zip.7z" /t REG_BINARY /d "0100000004000000010000000400000001000000e20000000700000001000000560000000c000000010000006400000009000000010000004b0000000f00000001000000510000002000000001000000640000001f00000001000000640000000800000001000000640000001300000000000000640000001600000000000000640000001b0000000000000064000000" /f
REG ADD "HKCU\Software\7-Zip\Options" /v "MenuIcons" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "2147488615" /f
EXIT /B
