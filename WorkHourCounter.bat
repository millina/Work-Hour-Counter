@echo off
title Work Hour Counter

echo Hi! Let's count how long you  have worked for today
echo Input the hour and minutes seperately when prompted
pause

:hourcheck
set /p HOURSTART="What was the hour you arrived at work?: "
	SET "var="&for /f "delims=0123456789" %%i in ("%HOURSTART%") do set var=%%i
	if defined var (echo %HOURSTART% is not a number, enter a new value for hour && goto :hourcheck)
	
set /p MINSTART="What were the minutes when you arrived at work?: "
:mincheck
	SET "var="&for /f "delims=0123456789" %%i in ("%MINSTART%") do set var=%%i
	if defined var (echo %MINSTART% is not a number, enter a new value for minutes && set /p MINSTART="What were the minutes when you arrived at work?: " && goto :mincheck)
	
echo You arrvied at %HOURSTART%.%MINSTART%.
set /a HOURNOW=%time:~0,2%
set /a MINNOW =%time:~3,2%
echo Time now %HOURNOW%.%MINNOW%.

if %MINNOW% LSS %MINSTART% (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-1 && set /a MINSWORKED = %MINNOW%+60-%MINSTART%) else (set /a HOURSWORKED = %HOURNOW%-%HOURSTART% && set /a MINSWORKED = %MINNOW%-%MINSTART%)

set /p LUNCHINC="Does your lunch break count as working hours? (y/n) "
:yncheck1
	if NOT %LUNCHINC% EQU y if NOT %LUNCHINC% EQU n (echo %LUNCHINC% is an illegal value, enter a new value && set /p LUNCHINC="Does your lunch break count as working hours? (y/n) " && goto yncheck1)
	
if %LUNCHINC% EQU y goto :echo_answer
if %LUNCHINC% EQU n (set /p HADLUNCH="Have you had your lunch break yet? (y/n) ")

if %HADLUNCH% EQU n goto :echo_answer
if %HADLUNCH% EQU y (set /p LUNCHLENGTH="How long was your lunch break? (in minutes) ")

if %LUNCHINC% EQU n if %HADLUNCH% EQU y if %MINSWORKED% LSS %LUNCHLENGTH% (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-1 && set /a MINSWORKED = %MINNOW%+60-%MINSTART%-%LUNCHLENGTH% && goto :echo_answer)
if %LUNCHINC% EQU n if %HADLUNCH% EQU y if %MINSWORKED% GTR %LUNCHLENGTH% (set /a MINSWORKED -= %LUNCHLENGTH% && goto :echo_answer)

if %MINSWORKED% LSS 0 (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-2 && set /a MINSWORKED = %MINNOW%+120-%MINSTART%-%LUNCHLENGTH% && echo You have worked for %HOURSWORKED% hours and %MINSWORKED% minutes 5. && goto :end)
if %MINSWORKED% GTR 59 (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-1 && set /a MINSWORKED -= 60  && echo You have worked for %HOURSWORKED% hours and %MINSWORKED% minutes 6.)

:echo_answer
	if %HOURSWORKED% EQU 0 (echo You have worked for %MINSWORKED% minutes.) else (echo You have worked for %HOURSWORKED% hours and %MINSWORKED% minutes.)
echo Done!
pause