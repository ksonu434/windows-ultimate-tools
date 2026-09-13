@echo off
setlocal EnableDelayedExpansion
set "ramSize=2"
set "ramDrive=R:"
set "ramTools=%ramDrive%\Tools"
set "ramTemp=%ramDrive%\Temp"
set "ramOut=%ramDrive%\Output"
if exist "%ramDrive%\" goto :CheckFolders
net session >nul 2>&1 || (powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c \"%~dpnx0\"' -Verb RunAs" & exit)
imdisk -a -t vm -s %ramSize%G -m %ramDrive% -p "/fs:ntfs /q /y /v:GOD" >nul 2>&1
:CheckFolders
for %%d in ("%ramTools%" "%ramTemp%" "%ramOut%") do (if not exist "%%~d" mkdir "%%~d" >nul 2>&1)
exit
