@ECHO OFF
SET "VERSION=v2.0"
TITLE Ultimate System Tweaks %VERSION% by Ahsan
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

SET "Current_Dir=%~dp0"
SET "Bin_Dir=%Current_Dir%\bin"
SET "Programs_Dir=%Current_Dir%\programs"

%Bin_Dir%\Codes.bat 2>&1 | %Bin_Dir%\wtee.exe %Current_Dir%\logs.txt
PAUSE
