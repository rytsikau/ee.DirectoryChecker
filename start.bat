@echo off
set DIRINPUT="c:\Program Files\"

rem DO NOT EDIT:
if not [%1]==[] set DIRINPUT=%1
set DIRINPUT=%DIRINPUT:"=%
set DIRINPUT=%DIRINPUT:'=%
powershell "& '%CD%\directorychecker.ps1' '%DIRINPUT%'"
pause