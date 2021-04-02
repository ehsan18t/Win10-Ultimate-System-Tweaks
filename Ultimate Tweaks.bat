@ECHO OFF
SET "VERSION=v2.0"
TITLE Ultimate System Tweaks %VERSION% by Ahsan
SET "Current_Dir=%~dp0"
SET "Bin_Dir=%Current_Dir%\bin"
SET "Programs_Dir=%Bin_Dir%\programs"
PUSHD %~DP0
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(WScript "%Bin_Dir%\Elevate.vbs" && EXIT)
Rd "%WinDir%\System32\test_permissions" 2>NUL
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
