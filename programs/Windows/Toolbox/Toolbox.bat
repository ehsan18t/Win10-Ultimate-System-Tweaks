@ECHO OFF
::mode con:cols=78 lines=28
SET Current_Version=2.0.1
TITLE MagicX Toolbox v%Current_Version% by Ahsan400
SET /a "_rand=(%RANDOM%*6/32768)"
CALL :Check_AU >NUL 2>&1

:Main_Menu
CLS
COLOR 0E
SET Menu_Address=Main_Menu
CALL :Header
ECHO                  [1;31m--------------------------------------
ECHO                  ^|[1;33m  Author: [1;36mAhsan Khan (@Ahsan400)[1;33m    [1;31m^|
ECHO                  ^|[1;33m  Target: [1;36mWindows 10 20H1^/19H2 [1;33m     [1;31m^|
ECHO                  ^|[1;33m  TG Group: [1;34mhttps:\\t.me\MagicXMod[1;33m  [1;31m^|
ECHO                  ^|[1;33m  Website: [1;34mMagicXMod.github.io[1;33m      [1;31m^|
ECHO                  --------------------------------------[1;33m
CALL :TWO_ECHO
ECHO  ***********************
ECHO  ***	Main Menu    ***
ECHO  ***********************
ECHO  1. Appearance
ECHO  2. Context Menu
ECHO  3. System Optimization
ECHO  4. Windows Update Settings
ECHO  5. Download Center
ECHO  U. Check Update
ECHO  R. Report BUGS
ECHO  X. Exit
ECHO [1;37m
CHOICE /C:12345URX /N /M "Enter your choice: "
ECHO [1;33m
IF ERRORLEVEL 8 GOTO Exit
IF ERRORLEVEL 7 CALL EXPLORER "https:\\t.me\MagicXMod" & GOTO Main_Menu
IF ERRORLEVEL 6 GOTO Check_Update
IF ERRORLEVEL 5 GOTO Downloads
IF ERRORLEVEL 4 GOTO Windows_Update
IF ERRORLEVEL 3 GOTO System_Menu
IF ERRORLEVEL 2 GOTO Context_Menu
IF ERRORLEVEL 1 GOTO Appearance



::::::::::::::::::::::::::
::						::
::		Appearance		::
::						::
::::::::::::::::::::::::::
:Appearance
CLS
COLOR 0E
SET Menu_Name=Appearance Menu
SET Menu_Address=Appearance
CALL :Header
ECHO  ============
ECHO  ^|^| Enable ^|^|
ECHO  ============
ECHO  1. Enable Arrow Icon In Shortcut
ECHO  2. Enable Action Center 
ECHO  3. Enable Old Battery Flyout UI
ECHO  4. Enable Old Network Flyout UI
ECHO  5. Enable Old Volume Control Flyout UI
ECHO.
ECHO  =============
ECHO  ^|^| Disable ^|^|
ECHO  =============
ECHO  A. Disable Arrow Icon From Shortcut
ECHO  B. Disable Action Center 
ECHO  C. Disable Old Battery Flyout UI
ECHO  D. Disable Old Network Flyout UI
ECHO  E. Disable Old Volume Control Flyout UI
ECHO.
ECHO [1;36m H. Main Menu [1;33m

ECHO [1;37m
CHOICE /C:12345ABCDEH /N /M "Enter your choice: "
ECHO [1;33m
IF ERRORLEVEL 11 GOTO Main_Menu
IF ERRORLEVEL 10 GOTO ds_old_vol_ctrl
IF ERRORLEVEL 9 GOTO ds_old_net
IF ERRORLEVEL 8 GOTO ds_old_battery
IF ERRORLEVEL 7 GOTO ds_act_cent
IF ERRORLEVEL 6 GOTO ds_arw_shtct
IF ERRORLEVEL 5 GOTO en_old_vol_ctrl
IF ERRORLEVEL 4 GOTO en_old_net
IF ERRORLEVEL 3 GOTO en_old_battery
IF ERRORLEVEL 2 GOTO en_act_cent
IF ERRORLEVEL 1 GOTO en_arw_shtct


:ds_arw_shtct
ECHO [1;33m -^> Disabling Arrow Icon From Shortcut... [1;32m
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "%%systemroot%%\Blank.ico,0" /f
CALL :RSTRT_WIN_EX
CAll :END_LINE

:en_arw_shtct
ECHO [1;33m -^> Enabling Arrow Icon From Shortcut... [1;32m
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /f
CALL :RSTRT_WIN_EX
CAll :END_LINE

:en_act_cent
ECHO [1;33m -^> Enabling Action Center... [1;32m
REG DELETE "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /f
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /f
CALL :RSTRT_WIN_EX
CAll :END_LINE

:ds_act_cent
ECHO [1;33m -^> Disabling Action Center... [1;32m
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
CALL :RSTRT_WIN_EX
CAll :END_LINE

:en_old_battery
ECHO [1;33m -^> Enabling Old Battery Flyout UI... [1;32m
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "UseWin32BatteryFlyout" /t REG_DWORD /d "1" /f
CAll :END_LINE

:ds_old_battery
ECHO [1;33m -^> Disabling Old Battery Flyout UI... [1;32m
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "UseWin32BatteryFlyout" /f
CAll :END_LINE

:en_old_net
CALL :Check_SetACL
ECHO [1;33m -^> Enabling Old Network Flyout UI... [1;32m
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn setowner -ownr "n:Administrators" >NUL 2>&1
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn ace -ace "n:Administrators;p:full" >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" /v "ReplaceVan" /t REG_DWORD /d "2" /f
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn ace -ace "n:Administrators;p:read" >NUL 2>&1
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn setowner -ownr "n:nt service\trustedinstaller" >NUL 2>&1
CAll :END_LINE

:ds_old_net
CALL :Check_SetACL
ECHO [1;33m -^> Disabling Old Network Flyout UI... [1;32m
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn setowner -ownr "n:Administrators" >NUL 2>&1
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn ace -ace "n:Administrators;p:full" >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" /v "ReplaceVan" /t REG_DWORD /d "0" /f
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn ace -ace "n:Administrators;p:read" >NUL 2>&1
SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" -ot reg -actn setowner -ownr "n:nt service\trustedinstaller" >NUL 2>&1
CAll :END_LINE

:en_old_vol_ctrl
ECHO [1;33m -^> Enabling Old Volume Control Flyout UI... [1;32m
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f
CAll :END_LINE

:ds_old_vol_ctrl
ECHO [1;33m -^> Disabling Old Volume Control Flyout UI... [1;32m
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /f
CAll :END_LINE


::::::::::::::::::::::::::::::
::							::
::		Context Menu		::
::							::
::::::::::::::::::::::::::::::
:Context_Menu
CLS
SET Menu_Name=Context Menu
SET Menu_Address=Context_Menu
COLOR 0E
CALL :Header
ECHO  1. Add Something To Context Menu
ECHO  2. Remove Something From Context Menu
ECHO [1;36m H. Main Menu [1;33m

ECHO [1;37m
CHOICE /C:12H /N /M "Enter your choice: "
ECHO [1;33m
IF ERRORLEVEL 3 GOTO Main_Menu
IF ERRORLEVEL 2 GOTO CNTXT_REM
IF ERRORLEVEL 1 GOTO CNTXT_ADD


:CNTXT_ADD
CLS
SET "OPT_AMOUNT=17"
SET "INP_MSG= --> Select Options to Apply: "
SET "CNTXT_OPT1=Add Secure Delete"
SET "CNTXT_OPT2=Add Secure Clean to Recycle Bin"
SET "CNTXT_OPT3=Add Personalize Classic"
SET "CNTXT_OPT4=Add Quick Access to Explorer Navigation Pane"
SET "CNTXT_OPT5=Add Network to Explorer Navigation Pane"
SET "CNTXT_OPT6=Add Print"
SET "CNTXT_OPT7=Add BitLocker Options"
SET "CNTXT_OPT8=Add Scan With Windows Defender"
SET "CNTXT_OPT9=Add Pin to Quick Access"
SET "CNTXT_OPT10=Add Pin to Start"
SET "CNTXT_OPT11=Add Give Access"
SET "CNTXT_OPT12=Add Include in Library"
SET "CNTXT_OPT13=Add Open as Portable Devices"
SET "CNTXT_OPT14=Add Restore Previous Versions"
SET "CNTXT_OPT15=Add Burn Disc Image"
SET "CNTXT_OPT16=Add Cast to Device"
SET "CNTXT_OPT17=Add Share"

SET "OPT_ADRS1=add_sec_del"
SET "OPT_ADRS2=add_sec_cln_rec"
SET "OPT_ADRS3=add_personalize_classic"
SET "OPT_ADRS4=add_quik_acces_nav_pan"
SET "OPT_ADRS5=add_network_nav_pan"
SET "OPT_ADRS6=add_print"
SET "OPT_ADRS7=add_bit_locker"
SET "OPT_ADRS8=add_scan_defneder"
SET "OPT_ADRS9=add_pin_to_Quik"
SET "OPT_ADRS10=add_pin_to_strt"
SET "OPT_ADRS11=add_give_access"
SET "OPT_ADRS12=add_inc_lib"
SET "OPT_ADRS13=add_opn_as_port"
SET "OPT_ADRS14=add_rstr_prev_ver"
SET "OPT_ADRS15=add_brn_dsk_img"
SET "OPT_ADRS16=add_cast_dev"
SET "OPT_ADRS17=add_share"

CALL :Header
CAll :CNTXT_Menu_Fig
CALL :END_LINE



:add_print
ECHO [1;33m -^> Adding Print... [1;32m
REG DELETE "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\batfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\cmdfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\docxfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\fonfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\htmlfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\inffile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\inifile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\JSEFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\otffile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\pfmfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\regfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\rtffile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\ttcfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\ttffile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\txtfile\shell\print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\VBEFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\VBSFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
REG DELETE "HKCR\WSFFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
EXIT /B

:add_bit_locker
ECHO [1;33m -^> Adding BitLocker Options... [1;32m
REG DELETE "HKCR\Drive\shell\change-passphrase" /v "LegacyDisable" /f
REG DELETE "HKCR\Drive\shell\manage-bde" /v "LegacyDisable" /f
REG DELETE "HKCR\Drive\shell\resume-bde" /v "LegacyDisable" /f
REG DELETE "HKCR\Drive\shell\resume-bde-elev" /v "LegacyDisable" /f
REG DELETE "HKCR\Drive\shell\encrypt-bde" /v "LegacyDisable" /f
REG DELETE "HKCR\Drive\shell\encrypt-bde-elev" /v "LegacyDisable" /f
REG DELETE "HKCR\Drive\shell\unlock-bde" /v "LegacyDisable" /f
REG ADD "HKCR\Drive\shell\lock-bde" /v "AppliesTo" /t REG_SZ /d "System.Volume.BitLockerProtection:=1 OR System.Volume.BitLockerProtection:=3 OR System.Volume.BitLockerProtection:=5 NOT %SystemDrive%" /f
REG ADD "HKCR\Drive\shell\lock-bde" /ve /t REG_SZ /d "Lock Drive" /f
REG ADD "HKCR\Drive\shell\lock-bde" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\lock-bde" /v "MultiSelectModel" /t REG_SZ /d "Single" /f
REG ADD "HKCR\Drive\shell\lock-bde\command" /ve /t REG_EXPAND_SZ /d "wscript.exe lock-bde.vbs %%1" /f
REG ADD "HKCR\Drive\shell\suspend-bde" /ve /t REG_SZ /d "Suspend BitLocker protection" /f
REG ADD "HKCR\Drive\shell\suspend-bde" /v "AppliesTo" /t REG_SZ /d "(System.Volume.BitLockerProtection:=System.Volume.BitLockerProtection#On" /f
REG ADD "HKCR\Drive\shell\suspend-bde" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\suspend-bde" /v "MultiSelectModel" /t REG_SZ /d "Single" /f
REG ADD "HKCR\Drive\shell\suspend-bde\command" /ve /t REG_EXPAND_SZ /d "wscript.exe suspend-bde.vbs %%1" /f
REG ADD "HKCR\Drive\shell\decrypt-bde" /ve /t REG_SZ /d "Turn off BitLocker" /f
REG ADD "HKCR\Drive\shell\decrypt-bde" /v "AppliesTo" /t REG_SZ /d "(System.Volume.BitLockerProtection:=System.Volume.BitLockerProtection#On" /f
REG ADD "HKCR\Drive\shell\decrypt-bde" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Drive\shell\decrypt-bde" /v "MultiSelectModel" /t REG_SZ /d "Single" /f
REG ADD "HKCR\Drive\shell\decrypt-bde\command" /ve /t REG_EXPAND_SZ /d "wscript.exe decrypt-bde.vbs %%1" /f
EXIT /B

:add_scan_defneder
ECHO [1;33m -^> Adding Scan With Windows Defender... [1;32m
REG ADD "HKCR\*\shellex\ContextMenuHandlers\EPP" /ve /t REG_SZ /d "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
REG ADD "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /ve /t REG_SZ /d "%SystemDrive%\Program Files\Windows Defender\shellext.dll" /f
REG ADD "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /v "ThreadingModel" /t REG_SZ /d "Apartment" /f
REG ADD "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\Version" /ve /t REG_SZ /d "10.0.18362.1" /f
REG ADD "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /ve /t REG_SZ /d "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
REG ADD "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /ve /t REG_SZ /d "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
EXIT /B

:add_personalize_classic
ECHO [1;33m -^> Adding Personalize Classic... [1;32m
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize" /v "Icon" /t REG_SZ /d "themecpl.dll" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize" /v "MUIVerb" /t REG_SZ /d "Personalize (Classic)" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize" /v "Position" /t REG_SZ /d "Bottom" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize" /v "SubCommands" /t REG_SZ /d "" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\01 Theme Settings" /v "MUIVerb" /t REG_SZ /d "Theme Settings" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\01 Theme Settings" /v "ControlPanelName" /t REG_SZ /d "Microsoft.Personalization" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\01 Theme Settings" /v "Icon" /t REG_SZ /d "themecpl.dll" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\01 Theme Settings\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\02 Desktop Background" /v "Icon" /t REG_SZ /d "imageres.dll,-110" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\02 Desktop Background" /v "MUIVerb" /t REG_SZ /d "Desktop Background" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\02 Desktop Background" /v "CommandFlags" /t REG_DWORD /d "32" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\02 Desktop Background\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageWallpaper" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\03 Color and Appearance" /v "Icon" /t REG_SZ /d "themecpl.dll" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\03 Color and Appearance" /v "MUIVerb" /t REG_SZ /d "Color and Appearance" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\03 Color and Appearance\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageColorization" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\04 Sounds" /v "Icon" /t REG_SZ /d "SndVol.exe,-101" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\04 Sounds" /v "MUIVerb" /t REG_SZ /d "Sounds" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\04 Sounds\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,2" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\05 Screen Saver Settings" /v "Icon" /t REG_SZ /d "PhotoScreensaver.scr" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\05 Screen Saver Settings" /v "MUIVerb" /t REG_SZ /d "Screen Saver Settings" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\05 Screen Saver Settings\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\06 Desktop Icon Settings" /v "Icon" /t REG_SZ /d "desk.cpl" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\06 Desktop Icon Settings" /v "MUIVerb" /t REG_SZ /d "Desktop Icon Settings" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\06 Desktop Icon Settings" /v "CommandFlags" /t REG_DWORD /d "32" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\06 Desktop Icon Settings\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\07 Mouse Pointers" /v "Icon" /t REG_SZ /d "main.cpl" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\07 Mouse Pointers" /v "MUIVerb" /t REG_SZ /d "Mouse Pointers" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\07 Mouse Pointers\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL main.cpl,,1" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\08 Notification Area Icons" /v "Icon" /t REG_SZ /d "taskbarcpl.dll,-1" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\08 Notification Area Icons" /v "MUIVerb" /t REG_SZ /d "Notification Area Icons" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\08 Notification Area Icons" /v "CommandFlags" /t REG_DWORD /d "32" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\08 Notification Area Icons\command" /ve /t REG_SZ /d "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\09 System Icons" /v "Icon" /t REG_SZ /d "taskbarcpl.dll,-1" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\09 System Icons" /v "MUIVerb" /t REG_SZ /d "System Icons" /f
REG ADD "HKCR\DesktopBackground\Shell\ClassicPersonalize\shell\09 System Icons\command" /ve /t REG_SZ /d "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9} \SystemIcons,,0" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /ve /t REG_SZ /d "Personalization (classic)" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /v "InfoTip" /t REG_SZ /d "@%%SystemRoot%%\System32\themecpl.dll,-2#immutable1" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /v "System.ApplicationName" /t REG_SZ /d "Microsoft.Personalization" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /v "System.ControlPanel.Category" /t REG_DWORD /d "1" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /v "System.Software.TasksFileUrl" /t REG_SZ /d "Internal" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\themecpl.dll,-1" /f
REG ADD "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}\Shell\Open\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /ve /t REG_SZ /d "Personalization (classic)" /f
EXIT /B

:add_pin_to_Quik
ECHO [1;33m -^> Adding Pin to Quick Access... [1;32m
REG DELETE "HKCR\Folder\shell\pintohome" /f
REG ADD "HKCR\Folder\shell\pintohome" /v "AppliesTo" /t REG_SZ /d "System.ParsingName:<>\"::{679f85cb-0220-4080-b29b-5540cc05aab6}\" AND System.ParsingName:<>\"::{645FF040-5081-101B-9F08-00AA002F954E}\" AND System.IsFolder:=System.StructuredQueryType.Boolean#True" /f
REG ADD "HKCR\Folder\shell\pintohome" /v "MUIVerb" /t REG_SZ /d "@shell32.dll,-51377" /f
REG ADD "HKCR\Folder\shell\pintohome\command" /v "DelegateExecute" /t REG_SZ /d "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}" /f
REG DELETE "HKLM\SOFTWARE\Classes\Folder\shell\pintohome" /f
REG ADD "HKLM\SOFTWARE\Classes\Folder\shell\pintohome" /v "AppliesTo" /t REG_SZ /d "System.ParsingName:<>\"::{679f85cb-0220-4080-b29b-5540cc05aab6}\" AND System.ParsingName:<>\"::{645FF040-5081-101B-9F08-00AA002F954E}\" AND System.IsFolder:=System.StructuredQueryType.Boolean#True" /f
REG ADD "HKLM\SOFTWARE\Classes\Folder\shell\pintohome" /v "MUIVerb" /t REG_SZ /d "@shell32.dll,-51377" /f
REG ADD "HKLM\SOFTWARE\Classes\Folder\shell\pintohome\command" /v "DelegateExecute" /t REG_SZ /d "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}" /f
EXIT /B

:add_pin_to_strt
ECHO [1;33m -^> Adding Pin to Start... [1;32m
REG ADD "HKCR\Folder\shellex\ContextMenuHandlers\PintoStartScreen" /ve /t REG_SZ /d "{470C0EBD-5D73-4d58-9CED-E91E22E23282}" /f
REG ADD "HKCR\exefile\shellex\ContextMenuHandlers\PintoStartScreen" /ve /t REG_SZ /d "{470C0EBD-5D73-4d58-9CED-E91E22E23282}" /f
REG ADD "HKCR\Microsoft.Website\ShellEx\ContextMenuHandlers\PintoStartScreen" /ve /t REG_SZ /d "{470C0EBD-5D73-4d58-9CED-E91E22E23282}" /f
REG ADD "HKCR\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" /ve /t REG_SZ /d "{470C0EBD-5D73-4d58-9CED-E91E22E23282}" /f
EXIT /B

:add_give_access
ECHO [1;33m -^> Adding Give Access... [1;32m
REG ADD "HKCR\*\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f >NUL 2>&1
REG ADD "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG ADD "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG ADD "HKCR\Directory\shellex\CopyHookHandlers\Sharing" /ve /t REG_SZ /d "{40dd6e20-7c17-11ce-a804-00aa003ca9f6}" /f
REG ADD "HKCR\Directory\shellex\PropertySheetHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG ADD "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG ADD "HKCR\Drive\shellex\PropertySheetHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG ADD "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG ADD "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInplaceSharing" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /f >NUL 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "forceguest" /t REG_DWORD /d "0" /f
EXIT /B

:add_inc_lib
ECHO [1;33m -^> Adding Include in Library... [1;32m
REG ADD "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /ve /t REG_SZ /d "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" /f
REG ADD "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /ve /t REG_SZ /d "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" /f
EXIT /B

:add_sec_del
CALL :Check_SecDel
ECHO [1;33m -^> Adding Secure Delete... [1;32m
REG ADD "HKCR\*\shell\Z007AAO" /ve /t REG_SZ /d "Secure Delete" /f
REG ADD "HKCR\*\shell\Z007AAO" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
REG ADD "HKCR\*\shell\Z007AAO" /v "Position" /t REG_SZ /d "bottom" /f
REG ADD "HKCR\*\shell\Z007AAO" /v "Icon" /t REG_SZ /d "imageres.dll,-5320" /f
REG ADD "HKCR\*\shell\Z007AAO\command" /ve /t REG_SZ /d "sdelete -p 3 \"%%1\"" /f
REG ADD "HKCR\Directory\shell\Z007AAO" /ve /t REG_SZ /d "Secure Delete" /f
REG ADD "HKCR\Directory\shell\Z007AAO" /v "AppliesTo" /t REG_SZ /d "NOT (System.ItemPathDisplay:=\"%SystemDrive%\Users\" OR System.ItemPathDisplay:=\"%SystemDrive%\ProgramData\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows.old\" OR System.ItemPathDisplay:=\"%SystemDrive%\Windows\System32\" OR System.ItemPathDisplay:=\"%SystemDrive%\Program Files\" OR System.ItemPathDisplay:=\"%SystemDrive%\Program Files (x86)\")" /f
REG ADD "HKCR\Directory\shell\Z007AAO" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\Z007AAO" /v "Position" /t REG_SZ /d "bottom" /f
REG ADD "HKCR\Directory\shell\Z007AAO" /v "Icon" /t REG_SZ /d "imageres.dll,-5320" /f
REG ADD "HKCR\Directory\shell\Z007AAO\command" /ve /t REG_SZ /d "sdelete -p 3 -s \"%%1\"" /f
EXIT /B

:add_sec_cln_rec
CALL :Check_SecDel
ECHO [1;33m -^> Adding Secure Clean to Recycle Bin... [1;32m
REG ADD "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean" /ve /t REG_SZ /d "Secure Clean" /f
REG ADD "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean" /v "CommandStateHandler" /t REG_SZ /d "{c9298eef-69dd-4cdd-b153-bdbc38486781}" /f
REG ADD "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean" /v "Icon" /t REG_SZ /d "imageres.dll,-5305" /f
REG ADD "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean\command" /ve /t REG_EXPAND_SZ /d "cmd /c \"for %%%%I in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST \"%%%%I:\$Recycle.Bin\" (sdelete.exe -p 3 -s \"%%%%I:\$Recycle.Bin\*\") ^&^& taskkill /im explorer.exe /f ^& start explorer.exe\"" /f
EXIT /B

:add_opn_as_port
ECHO [1;33m -^> Adding Open as Portable Devices... [1;32m
REG ADD "HKLM\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\{D6791A63-E7E2-4fee-BF52-5DED8E86E9B8}" /v "{D6791A63-E7E2-4fee-BF52-5DED8E86E9B8}" /t REG_SZ /d "Portable Devices Menu" /f
EXIT /B

:add_rstr_prev_ver
ECHO [1;33m -^> Adding Restore Previous Versions... [1;32m
REG ADD "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG ADD "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >NUL 2>&1
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >NUL 2>&1
REG DELETE "HKCU\Software\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >NUL 2>&1
EXIT /B

:add_brn_dsk_img
ECHO [1;33m -^> Adding Burn Disc Image... [1;32m
REG ADD "HKCR\Windows.IsoFile\shell\burn" /v "MUIVerb" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\System32\isoburn.exe,-351" /f
REG ADD "HKCR\Windows.IsoFile\shell\burn\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\isoburn.exe \"%%1\"" /f
EXIT /B

:add_cast_dev
ECHO [1;33m -^> Adding Cast to Device... [1;32m
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /V {7AD84985-87B4-4a16-BE58-8B72A5B390F7} /F
CALL :RSTRT_WIN_EX
EXIT /B

:add_share
ECHO [1;33m -^> Adding Share... [1;32m
REG ADD "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /ve /t REG_SZ /d "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /f
EXIT /B

:add_quik_acces_nav_pan
ECHO [1;33m -^> Adding Quick Access to Explorer Navigation Pane... [1;32m
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /f
EXIT /B

:add_network_nav_pan
CALL :Check_SetACL
ECHO [1;33m -^> Adding Network to Explorer Navigation Pane... [1;32m
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn setowner -ownr "n:Administrators" >NUL 2>&1
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn ace -ace "n:Administrators;p:full" >NUL 2>&1
REG ADD "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2953052260" /f
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn ace -ace "n:Administrators;p:read" >NUL 2>&1
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn setowner -ownr "n:nt service\trustedinstaller" >NUL 2>&1
CALL :RSTRT_WIN_EX
EXIT /B



:CNTXT_REM
CLS
SET "OPT_AMOUNT=17"
SET "INP_MSG= --> Select Options to Apply: "
SET "CNTXT_OPT1=Remove Secure Delete"
SET "CNTXT_OPT2=Remove Secure Clean from Recycle Bin"
SET "CNTXT_OPT3=Remove Personalize Classic"
SET "CNTXT_OPT4=Remove Quick Access from Explorer Navigation Pane"
SET "CNTXT_OPT5=Remove Network from Explorer Navigation Pane"
SET "CNTXT_OPT6=Remove Print"
SET "CNTXT_OPT7=Remove BitLocker Options"
SET "CNTXT_OPT8=Remove Scan With Windows Defender"
SET "CNTXT_OPT9=Remove Pin to Quick Access"
SET "CNTXT_OPT10=Remove Pin to Start"
SET "CNTXT_OPT11=Remove Give Access"
SET "CNTXT_OPT12=Remove Include in Library"
SET "CNTXT_OPT13=Remove Open as Portable Devices"
SET "CNTXT_OPT14=Remove Restore Previous Versions"
SET "CNTXT_OPT15=Remove Burn Disc Image"
SET "CNTXT_OPT16=Remove Cast to Device"
SET "CNTXT_OPT17=Remove Share"

SET "OPT_ADRS1=rmv_sec_del"
SET "OPT_ADRS2=rmv_sec_cln_rec"
SET "OPT_ADRS3=rmv_personalize_classic"
SET "OPT_ADRS4=rmv_quik_acces_nav_pan"
SET "OPT_ADRS5=rmv_network_nav_pan"
SET "OPT_ADRS6=rmv_print"
SET "OPT_ADRS7=rmv_bit_locker"
SET "OPT_ADRS8=rmv_scan_defneder"
SET "OPT_ADRS9=rmv_pin_to_Quik"
SET "OPT_ADRS10=rmv_pin_to_Strt"
SET "OPT_ADRS11=rmv_give_access"
SET "OPT_ADRS12=rmv_inc_lib"
SET "OPT_ADRS13=rmv_opn_as_port"
SET "OPT_ADRS14=rmv_rstr_prev_ver"
SET "OPT_ADRS15=rmv_brn_dsk_img"
SET "OPT_ADRS16=rmv_cast_dev"
SET "OPT_ADRS17=rmv_share"

CALL :Header
CAll :CNTXT_Menu_Fig
CALL :END_LINE



:rmv_print
ECHO [1;33m -^> Removing Print... [1;32m
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
EXIT /B

:rmv_bit_locker
ECHO [1;33m -^> Removing BitLocker Options... [1;32m
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
EXIT /B

:rmv_scan_defender
ECHO [1;33m -^> Removing Scan With Windows Defender... [1;32m
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\EPP" /f
REG DELETE "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
REG DELETE "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /f
REG DELETE "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /f
EXIT /B

:rmv_personalize_classic
ECHO [1;33m -^> Removing Personalize Classic... [1;32m
REG DELETE "HKCR\CLSID\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{580722ff-16a7-44c1-bf74-7e1acd00f4f9}" /f
REG DELETE "HKCR\DesktopBackground\Shell\ClassicPersonalize" /f
EXIT /B

:rmv_pin_to_Quik
ECHO [1;33m -^> Removing Pin to Quick Access... [1;32m
REG DELETE "HKLM\SOFTWARE\Classes\Folder\shell\pintohome" /f
REG DELETE "HKCR\Folder\shell\pintohome" /f >NUL 2>&1
EXIT /B

:rmv_pin_to_Strt
ECHO [1;33m -^> Removing Pin to Start... [1;32m
REG DELETE "HKCR\Folder\shellex\ContextMenuHandlers\PintoStartScreen" /f
REG DELETE "HKCR\exefile\shellex\ContextMenuHandlers\PintoStartScreen" /f
REG DELETE "HKCR\Microsoft.Website\ShellEx\ContextMenuHandlers\PintoStartScreen" /f
REG DELETE "HKCR\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" /f
EXIT /B

:rmv_give_access
ECHO [1;33m -^> Removing Give Access... [1;32m
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Directory\shellex\CopyHookHandlers\Sharing" /f
REG DELETE "HKCR\Directory\shellex\PropertySheetHandlers\Sharing" /f
REG DELETE "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\Drive\shellex\PropertySheetHandlers\Sharing" /f
REG DELETE "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f
REG DELETE "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f
EXIT /B

:rmv_inc_lib
ECHO [1;33m -^> Removing Include in Library... [1;32m
REG DELETE "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f
REG DELETE "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f
EXIT /B

:rmv_sec_del
ECHO [1;33m -^> Removing Secure Delete... [1;32m
REG DELETE "HKCR\*\shell\Z007AAO" /f
REG DELETE "HKCR\Directory\shell\Z007AAO" /f
EXIT /B

:rmv_sec_cln_rec
ECHO [1;33m -^> Removing Secure Clean from Recycle Bin... [1;32m
REG DELETE "HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\SecureClean" /f
EXIT /B

:rmv_opn_as_port
ECHO [1;33m -^> Removing Open as Portable Devices... [1;32m
REG DELETE "HKLM\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\{D6791A63-E7E2-4fee-BF52-5DED8E86E9B8}" /f
EXIT /B

:rmv_rstr_prev_ver
ECHO [1;33m -^> Removing Restore Previous Versions... [1;32m
REG DELETE "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f
REG DELETE "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >NUL 2>&1
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >NUL 2>&1
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >NUL 2>&1
REG DELETE "HKCU\Software\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >NUL 2>&1
EXIT /B

:rmv_brn_dsk_img
ECHO [1;33m -^> Removing Burn Disc Image... [1;32m
REG DELETE "HKCR\Windows.IsoFile\shell\burn" /f
EXIT /B

:rmv_cast_dev
ECHO [1;33m -^> Removing Cast to Device... [1;32m
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /V {7AD84985-87B4-4a16-BE58-8B72A5B390F7} /T REG_SZ /D "Play to Menu" /F
CALL :RSTRT_WIN_EX
EXIT /B

:rmv_share
ECHO [1;33m -^> Removing Share... [1;32m
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f
EXIT /B

:rmv_quik_acces_nav_pan
ECHO [1;33m -^> Removing Quick Access from Explorer Navigation Pane... [1;32m
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f
EXIT /B

:rmv_network_nav_pan
CALL :Check_SetACL
ECHO [1;33m -^> Removing Network from Explorer Navigation Pane... [1;32m
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn setowner -ownr "n:Administrators" >NUL 2>&1
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn ace -ace "n:Administrators;p:full" >NUL 2>&1
REG ADD "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2954100836" /f
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn ace -ace "n:Administrators;p:read" >NUL 2>&1
SetACL.exe -on "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" -ot reg -actn setowner -ownr "n:nt service\trustedinstaller" >NUL 2>&1
CALL :RSTRT_WIN_EX
EXIT /B



::::::::::::::::::::::
::					::
::		System		::
::					::
::::::::::::::::::::::
:System_Menu
CLS
COLOR 0E
SET Menu_Name=System Menu
SET Menu_Address=System_Menu
CALL :Header
ECHO  ============
ECHO  ^|^| Enable ^|^|
ECHO  ============
ECHO  1. Enable Large System Cache (Only for 8GB+ RAM Users)
ECHO  2. Enable Hibernation (Recommended)
ECHO  3. Enable Startup Delay (Recommended for HDD)
ECHO  4. Enable Web/Being Search in Windows Search
ECHO  5. Enable Thumbnails
ECHO  6. Enable Large Icon Cache (4MB)
ECHO  7. Enable Large Icon Cache (8MB)
ECHO.
ECHO  =============
ECHO  ^|^| Disable ^|^|
ECHO  =============
ECHO  A. Disable Large System Cache 
ECHO  B. Disable Hibernation
ECHO  C. Disable Startup Delay (Recommended for SSD)
ECHO  D. Disable Web/Being Search in Windows Search
ECHO  E. Disable Thumbnails
ECHO  F. Disable Large Icon Cache (Default=500KB)
ECHO  G. HELP (Description of All Above Tweaks)
ECHO.
ECHO [1;36m H. Main Menu [1;33m

ECHO [1;37m
CHOICE /C:1234567ABCDEFGH /N /M "Enter your choice: "
ECHO [1;33m
IF ERRORLEVEL 15 GOTO Main_Menu
IF ERRORLEVEL 14 GOTO sys_help
IF ERRORLEVEL 13 GOTO ds_large_icn_cache
IF ERRORLEVEL 12 GOTO ds_thumb
IF ERRORLEVEL 11 GOTO ds_web_search
IF ERRORLEVEL 10 GOTO ds_strtup_delay
IF ERRORLEVEL 9 GOTO ds_hibernate
IF ERRORLEVEL 8 GOTO ds_large_sys_cache
IF ERRORLEVEL 7 GOTO en_large_icn_cache_8mb
IF ERRORLEVEL 6 GOTO en_large_icn_cache_4mb
IF ERRORLEVEL 5 GOTO en_thumb
IF ERRORLEVEL 4 GOTO en_web_search
IF ERRORLEVEL 3 GOTO en_strtup_delay
IF ERRORLEVEL 2 GOTO en_hibernate
IF ERRORLEVEL 1 GOTO en_large_sys_cache


:en_large_sys_cache
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f
CAll :END_LINE_RSRT

:ds_large_sys_cache
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f
CAll :END_LINE_RSRT

:en_large_icn_cache_4mb
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "4096" /f
CAll :END_LINE_RSRT

:en_large_icn_cache_8mb
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "8192" /f
CAll :END_LINE_RSRT

:ds_large_icn_cache
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /f
CAll :END_LINE_RSRT

:en_hibernate
powercfg.exe /h off
ECHO  SUCCESS: Hibernation Enabled
CAll :END_LINE_RSRT

:ds_hibernate
powercfg.exe /h on
ECHO  SUCCESS: Hibernation Disabled
CAll :END_LINE_RSRT

:en_strtup_delay
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /f
CALL :END_LINE_RSRT

:ds_strtup_delay
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f
CALL :END_LINE_RSRT

:en_web_search
REG DELETE "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f >NUL 2>&1
REG DELETE "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f
CALL :RSTRT_WIN_EX
CALL :END_LINE_RSRT

:ds_web_search
REG ADD "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
CALL :RSTRT_WIN_EX
CALL :END_LINE_RSRT

:en_thumb
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableThumbnails" /f /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableThumbnails" /f
CALL :END_LINE_RSRT

:ds_thumb
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableThumbnails" /t REG_DWORD /d "1" /f /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableThumbnails" /t REG_DWORD /d "1" /f
CALL :END_LINE_RSRT

:sys_help
ECHO  ^=^> "Large System Cache" Make system faster but uses more RAM.
ECHO        Thats why use it only if you have 8GB or more RAM.
ECHO.
ECHO  ^=^> "Large Icon Cache" Help system and system icons load faster.
ECHO        Use the one works best for you.
ECHO.
ECHO  ^=^> "Hibernation" uses 3GB~6GB of space(HDD/SSD) for fastboot/sleep mode.
ECHO        However if you disable this option PC boot time will be incresed.
CALL :END_LINE



::::::::::::::::::::::::::
::						::
::		Download		::
::						::
::::::::::::::::::::::::::
:Downloads
SET Menu_Name=Downloads Center
SET Menu_Address=Downloads_Menu
SET "DESKTOP=%UserProfile%\Desktop"
ECHO  ^=^> [1;36mFetching Downloads Info......[1;33m
powershell.exe -Command wget https://github.com/Ahsan400/MagicX_Mod_Files/raw/master/Windows_10/Downloads_Info.bat -OutFile Downloads_Info.bat >NUL 2>&1
IF NOT EXIST "Downloads_Info.bat" CALL :Network_Error
CALL Downloads_Info.bat
DEL Downloads_Info.bat

:Downloads_Menu
IF NOT EXIST "%DESKTOP%\Apps" MD "%DESKTOP%\Apps"
CLS
COLOR 0E
Set "Pattern= "
Set "Replace=_"
CALL :Header
ECHO.
ECHO  ^=^> Antivirus may show false positive alerm for some apps. Don't worry about it.
ECHO.
CALL :CNTXT_Menu_Fig
CALL :END_LINE_DNL


:Download_Start_Apps_exe
SET "FILE_CAT=Apps"
SET "FILE_EXT=exe"
CALL :DL_MEC_NEW
EXIT /B

:Download_Start_Apps_zip
SET "FILE_CAT=Apps"
SET "FILE_EXT=zip"
CALL :DL_MEC_NEW
EXIT /B

:Download_Start_Mods
SET "FILE_CAT=Mods"
SET "FILE_EXT=zip"
CALL :DL_MEC_NEW
EXIT /B

:Download_Start_Tuts
SET "FILE_CAT=Tuts"
SET "FILE_EXT=mkv"
CALL :DL_MEC_NEW
EXIT /B

GOTO %Menu_Address%


::::::::::::::::::::::::::::::
::							::
::		Windows Update		::
::							::
::::::::::::::::::::::::::::::
:Windows_Update
CLS
COLOR 0E
SET Menu_Name=Windows Update Menu
SET Menu_Address=Windows_Update
CALL :Header
ECHO.
ECHO  ^=^> Please Apply "After Update Tweaks" After Install Windows Update.
ECHO  ^=^> Because After You Update Windwos It Can Change all the Tweaks I Made.
ECHO  ^=^> That Might Make System Slower and MS Will Collect Data/Log From Your PC.
CALL :TWO_ECHO
ECHO  1. After Update Tweaks
ECHO  2. Disable Windows Update
ECHO  3. Enable Windows Update
ECHO [1;36m H. Main Menu [1;33m
ECHO.

CHOICE /C:123H /N /M "Enter your choice: "
ECHO.
IF ERRORLEVEL 4 GOTO Main_Menu
IF ERRORLEVEL 3 GOTO en_Windows_Update
IF ERRORLEVEL 2 GOTO ds_Windows_Update
IF ERRORLEVEL 1 GOTO after_update_tweaks


:after_update_tweaks
CLS
COLOR 0E
CALL :Header

ECHO --^> Ads From Windows Store Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Downloaded Files From Being Blocked Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Get Suggestion When Using Windows Disabled
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Lockscreen Fun Facts, Tips Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Online Services for Narrator Disabled
REG ADD "HKCU\Software\Microsoft\Narrator\NoRoam" /v "OnlineServicesEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Office Telemetry Or Data Collection For Telemetry Agent Disabled
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common" /v "sendcustomerdata" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common\Feedback" /v "enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Office\16.0\Common\Feedback" /v "includescreenshot" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common" /v "qmenable" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common" /v "updatereliabilitydata" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common\General" /v "shownfirstrunoptin" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common\General" /v "skydrivesigninoption" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Common\ptwatson" /v "ptwoptin" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\Firstrun" /v "disablemovie" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM" /v "Enablelogging" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "accesssolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "olksolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "onenotesolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "pptsolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "projectsolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "publishersolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "visiosolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "wdsolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedapplications" /v "xlsolution" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "agave" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "appaddins" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "comaddins" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "documentfiles" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKCU\Software\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes" /v "templatefiles" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Online Tips And Help For Settings App Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Store App Auto Install Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Suggestions In Timeline Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Thumbsdb On Network Drives Disabled
REG ADD "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableThumbsDBOnNetworkFolders" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Transmission Of Typing Info Disabled
REG ADD "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Windows Error Reporting Current User Disabled
REG ADD "HKCU\Software\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Windows Explorer Ads Disabled
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Windows Feedback Disabled
REG ADD "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Windows Update Peer ^& PeerNet Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Auto Game Mode Disabled
REG ADD "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Game Bar Tips Disabled
REG ADD "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Show Me Tips About Windows Disabled
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Show Suggestions On Start Disabled
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Windows Welcome Experience Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Activity History Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Advertising With BT Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Advertising Info Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> App Telemetry Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Apps and Icons Auto Update Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Camera In LockScreen Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Conducting Experiment Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Customer Experience Improvement Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Data Collections Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Feedback Reminder Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Gamebar Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Handwriting Data Sharing Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Handwriting Error Reporting Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> Logging Disabled
REG ADD "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SYSTEM\ControlSet001\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >NUL 2>&1
REG ADD "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f >NUL 2>&1

ECHO --^> MAP Data Auto Download Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> MS Products Auto Update Disabled
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> Text Message Cloud Backup Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> WD Malware Report Collection Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >NUL 2>&1

ECHO --^> WD Smart Screen Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> WD Submitting Sample Data To Microsoft Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >NUL 2>&1

ECHO --^> Downloading App Updates Automatically Disabled
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f >NUL 2>&1

ECHO --^> Content Delivery Manager Reverting Feature Configuration Permission Disabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f >NUL 2>&1

ECHO --^> "Do This For All Current Items Check box By Default" Enabled
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "ConfirmationCheckBoxDoForAll" /t REG_DWORD /d "1" /f >NUL 2>&1
CALL :END_LINE


:ds_Windows_Update
ECHO [1;33m -^> Disabling Windows Update.... [1;32m
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >NUL 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d "1" /f >NUL 2>&1
net stop wuauserv >NUL 2>&1
sc config wuauserv start= disabled
net stop wuauserv >NUL 2>&1
CALL :END_LINE_RSRT

:en_Windows_Update
ECHO [1;33m -^> Enabling Windows Update.... [1;32m 
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /f >NUL 2>&1
sc config wuauserv start= demand
net start wuauserv >NUL 2>&1
CALL :END_LINE_RSRT



::::::::::::::::::::::::::::::
::							::
::		Check Updates		::
::							::
::::::::::::::::::::::::::::::
:Check_Update
CLS
ECHO.
ECHO  				============================
ECHO 				^|^| MagicX Toolbox Updater ^|^|
ECHO 				============================
ECHO.
COLOR 03
ECHO  [1;33m^=^> Checking For New Update.....
powershell.exe -nologo -noprofile -Command wget https://github.com/Ahsan400/MagicX_Mod_Files/raw/master/MagicX_Toolbox/Updater/Toolbox_Update_Info.bat -OutFile Toolbox_Update_Info.bat >NUL 2>&1
IF NOT EXIST "Toolbox_Update_Info.bat" CALL :Network_Error
IF EXIST "Toolbox_Update_Info.bat" (
    CALL Toolbox_Update_Info.bat
    DEL Toolbox_Update_Info.bat
)
IF "%Update_Version%" GTR "%Current_Version%" (
    GOTO Update
) ELSE IF "%Update_Version%" LEQ "%Current_Version%" (
    GOTO NoUpdate
) ELSE (
    CALL :Network_Error
)
EXIT


:Update
CLS
COLOR 0E
ECHO.
ECHO 				===========================
ECHO 				^|^| New Update Available! ^|^|
ECHO 				===========================
CALL :TWO_ECHO
ECHO  ^=^> Updates Downloading. Please Wait...
CD /D %~dp0
powershell.exe -nologo -noprofile -Command wget %DNL_LINK%/%Update_FileName% -OutFile %Update_FileName% >NUL 2>&1
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%Update_FileName%', 'Update'); }" >NUL 2>&1
IF EXIST "%CD%\%Update_FileName%" DEL %Update_FileName%
IF NOT EXIST "%CD%\Update\*.bat" CALL :Network_Error
IF EXIST "%CD%\Update\PreUpdater.bat" CALL "%CD%\Update\PreUpdater.bat" && DEL "%CD%\Update\PreUpdater.bat" >NUL 2>&1
ECHO  ^=^> Update Process will Start in 5s. Please Don't Close App While it Updating. 
TIMEOUT /t 5 >NUL 2>&1
CLS
CSCRIPT /B /Nologo "%CD%\Updater.vbs"
EXIT

:NoUpdate
SET Menu_Name=Home
SET Menu_Address=Main_Menu
CLS
COLOR 0A
ECHO.
ECHO 				=====================================
ECHO 				^|^| You Are Using The Latest Update ^|^|
ECHO 				=====================================
CALL :END_LINE

:Exit
EXIT

:END_LINE
ECHO.
ECHO [1;36m ^=^> Press Any Key To Go %Menu_Name%[1;33m
PAUSE >NUL 2>&1
GOTO %Menu_Address%
EXIT /B

:END_LINE_RSRT
ECHO.
ECHO [1;36m ^=^> Please Restart Windows to Apply This Tweak Properly
ECHO  ^=^> Press Any Key To Go %Menu_Name%[1;33m
PAUSE >NUL 2>&1
GOTO %Menu_Address%
EXIT /B

:END_LINE_DNL
ECHO.
ECHO [1;37m ^=^> DOWNLOAD COMPLETE
ECHO  ^=^> Check "Apps" folder in Desktop
ECHO.
ECHO [1;36m ^=^> Press Any Key To Enter Options[1;33m
PAUSE >NUL 2>&1
GOTO %Menu_Address%
EXIT /B


:CNTXT_Menu_Fig
SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion
SET /a "OPT_AMOUNT+=1"
SET "x=0"

:CNTXT_Var_Loop
SET /a "x+=1"
IF "%x%" NEQ "%OPT_AMOUNT%" (
    CALL SET "CNTXT[%x%]=%%CNTXT_OPT%x%%%"
    GOTO CNTXT_Var_Loop
)
SET "CNTXT[H]=Main Menu"

:CNTXT_Menu
SET "x=0"

:CNTXT_MenuLoop
SET /a "x+=1"
IF NOT "%x%"=="%OPT_AMOUNT%" (
    CALL ECHO   %x%. %%CNTXT[%x%]%%
    GOTO CNTXT_MenuLoop
)
ECHO  [1;36m H. Main Menu [1;33m
ECHO.
ECHO --^> You can choose Multiple Options (E.G: 1,2,7 or 1 2 7)

:Prompt
IF DEFINED Inp_Error_Message (
    ECHO.%Inp_Error_Message%
    SET "Inp_Error_Message="
)
ECHO [1;37m
SET /p "Input= %INP_MSG%"
ECHO [1;33m
IF NOT DEFINED Input (
    SET "Inp_Error_Message=[1;31m EMPTY INPUT! [1;33m"
    GOTO Prompt
)
SET "Input=%Input:"=%"
SET "Input=%Input:^=%"
SET "Input=%Input:<=%"
SET "Input=%Input:>=%"
SET "Input=%Input:&=%"
SET "Input=%Input:|=%"
SET "Input=%Input:(=%"
SET "Input=%Input:)=%"
SET "Input=%Input:^==%"
CALL :CNTXT_Inp_Validate %Input%
CALL :CNTXT_Process %Input%
GOTO End_Tasks

:CNTXT_Inp_Validate
SET "Next=%2"
IF NOT DEFINED CNTXT[%1] (
    SET "Inp_Error_Message=[1;31m INVALID INPUT: %1! [1;33m"
    SET "Input="
    GOTO Prompt
)
IF DEFINED Next SHIFT & GOTO CNTXT_Inp_Validate
GOTO :EOF

:CNTXT_Process
SET "Next=%2"
CALL SET "CNTXT=%%CNTXT[%1]%%"
CALL SET "OPT_ADRS=%%OPT_ADRS%1%%"
CALL SET "CNTXT_OPT=%%CNTXT_OPT%1%%"

IF "%CNTXT%" EQU "%CNTXT_OPT%" CALL :%OPT_ADRS%
ECHO.
IF "%CNTXT%" EQU "Main Menu" GOTO Main_Menu

SET "CNTXT[%1]="
IF DEFINED Next SHIFT & GOTO CNTXT_Process

:End_Tasks
ENDLOCAL
EXIT /B

:Header
ECHO  [1;3%_rand%m  __  __             _     __  __  _____           _ _               
ECHO   ^|  \/  ^| __ _  __ _(_) ___\ \/ / ^|_   _^|__   ___ ^| ^| ^|__   _____  __
ECHO   ^| ^|\/^| ^|/ _` ^|/ _` ^| ^|/ __^|\  /    ^| ^|/ _ \ / _ \^| ^| '_ \ / _ \ \/ /
ECHO   ^| ^|  ^| ^| (_^| ^| (_^| ^| ^| (__ /  \    ^| ^| (_) ^| (_) ^| ^| ^|_) ^| (_) ^>  ^< 
ECHO   ^|_^|  ^|_^|\__,_^|\__, ^|_^|\___/_/\_\   ^|_^|\___/ \___/^|_^|_.__/ \___/_/\_\
ECHO                 ^|___/         [1;33m
ECHO.
IF EXIST "%WinDir%\Toolbox\UpdateAvailable.yes" (
    DEL "%WinDir%\Toolbox\UpdateAvailable.yes"
    ECHO  [1;32m
    CHOICE /C:NY /N /M "--> Toolbox New Update Available. Wanna Update Now? [Y/N] "
    IF ERRORLEVEL 2 GOTO Check_Update
    IF ERRORLEVEL 1 GOTO %Menu_Address%
)
EXIT /B

:Network_Error
SET Menu_Name=Main Menu
SET Menu_Address=Main_Menu
CLS
COLOR 0C
ECHO.
ECHO 		======================================================================
ECHO 		^|^| Unexpected Error Occurred. Please Check Your Internet Connection ^|^|
ECHO 		======================================================================
ECHO.
CALL :END_LINE
EXIT /B

:THREE_ECHO
ECHO.
ECHO.
ECHO.
EXIT /B

:TWO_ECHO
ECHO.
ECHO.
EXIT /B


:RSTRT_WIN_EX
ECHO [1;33m -^> Restarting Windows Explorer.... [1;32m
TASKKILL /im explorer.exe /f
START explorer.exe
EXIT /B

:Check_SetACL
IF NOT EXIST "%WinDir%\system32\SetACL.exe" (
    ECHO  [1;37m
    CHOICE /C:NY /N /M "--> Necessary lib not found! Want to download it (547KB)? [Y/N] "
    IF ERRORLEVEL 2 CALL :DNL_SetACL
    IF ERRORLEVEL 1 GOTO %Menu_Address%
)
EXIT /B

:Check_NirCMD
IF NOT EXIST "%WinDir%\system32\nircmd.exe" (
    ECHO  [1;37m
    CHOICE /C:NY /N /M "--> Necessary lib not found! Want to download it (115KB)? [Y/N] "
    IF ERRORLEVEL 2 CALL :DNL_NirCMD
    IF ERRORLEVEL 1 GOTO %Menu_Address%
)
EXIT /B

:Check_SecDel
IF NOT EXIST "%WinDir%\system32\sdelete.exe" (
    ECHO  [1;37m
    CHOICE /C:NY /N /M "--> Necessary lib not found! Want to download it (241KB)? [Y/N] "
    IF ERRORLEVEL 2 CALL :DNL_SecDel
    IF ERRORLEVEL 1 GOTO %Menu_Address%
)
EXIT /B

:DNL_SetACL
ECHO --^> Necessary lib Downloading... [1;33m
powershell.exe -nologo -noprofile -Command wget https://raw.githubusercontent.com/Ahsan400/MagicX_Mod_Files/master/Windows_10/Libs/SetACL.exe -OutFile %WinDir%\system32\SetACL.exe >NUL 2>&1
EXIT /B

:DNL_NirCMD
ECHO --^> Necessary lib Downloading... [1;33m
powershell.exe -nologo -noprofile -Command wget https://raw.githubusercontent.com/Ahsan400/MagicX_Mod_Files/master/Windows_10/Libs/nircmd.exe -OutFile %WinDir%\system32\nircmd.exe >NUL 2>&1
EXIT /B

:DNL_SecDel
ECHO --^> Necessary lib Downloading... [1;33m
powershell.exe -nologo -noprofile -Command wget https://raw.githubusercontent.com/Ahsan400/MagicX_Mod_Files/master/Windows_10/Libs/sdelete.exe -OutFile %WinDir%\system32\sdelete.exe >NUL 2>&1
EXIT /B

:DL_MEC
CD "%DESKTOP%"
CALL SET "DNL_OPT=%%CNTXT_OPT%1%%"
SET "File_Name=!DNL_OPT:%Pattern%=%Replace%!"
ECHO [1;33m ^=^> %DNL_OPT% Downloading..... [1;32m
PowerShell -Command wget %DL_REPO%/%FILE_CAT%/%File_Name%.%FILE_EXT% -OutFile Apps\%File_Name%.%FILE_EXT%
EXIT /B

:DL_MEC_NEW
CD "%DESKTOP%"
CALL SET "DNL_OPT=%%CNTXT_OPT%1%%"
SET "File_Name=!DNL_OPT:%Pattern%=%Replace%!"
ECHO [1;33m ^=^> %DNL_OPT% Downloading..... [1;32m
PowerShell -Command ^
$ProgressPreference = 'SilentlyContinue';^
$dlLink = \"%DL_REPO%/%FILE_CAT%/%File_Name%.%FILE_EXT%\"; $dlLocation = \"Apps\%File_Name%.%FILE_EXT%\";^
function downloadFile($url, $targetFile)^
{^
    $uri = New-Object \"System.Uri\" \"$url\";^
    $request = [System.Net.HttpWebRequest]::Create($uri);^
    $request.set_Timeout(15000);^
    $response = $request.GetResponse();^
    $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024);^
    $responseStream = $response.GetResponseStream();^
    $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create;^
    $buffer = new-object byte[] 10KB;^
    $count = $responseStream.Read($buffer,0,$buffer.length);^
    $downloadedBytes = $count;^
    while ($count -gt 0)^
    {^
        [System.Console]::CursorLeft = 0;^
        [System.Console]::Write(\"  >>   Downloaded {0}K of {1}K ({2}%%) <<   \", [System.Math]::Floor($downloadedBytes/1024), $totalLength, [System.Math]::Floor((($downloadedBytes/1024)/$totalLength)*100));^
        $targetStream.Write($buffer, 0, $count);^
        $count = $responseStream.Read($buffer,0,$buffer.length);^
        $downloadedBytes = $downloadedBytes + $count;^
    }^
    $targetStream.Flush();^
    $targetStream.Close();^
    $targetStream.Dispose();^
    $responseStream.Dispose();^
}^
downloadFile $dlLink $dlLocation;
EXIT /B

:Check_AU
ECHO SET "Current_Version=%Current_Version%">"%WinDir%\Toolbox\Current_Version.bat"
CSCRIPT /B /Nologo "%WinDir%\Toolbox\CheckAU.vbs"
EXIT /B
