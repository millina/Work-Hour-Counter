@echo off
title Work Hour Counter

echo Hi! Let's count how long you  have worked for today
echo Input the hour and minutes seperately when prompted
pause

:hourcheck
set /p HOURSTART="What was the hour you arrived at work?: "
	SET /a HELPER = 0
	SET "var="&for /f "delims=0123456789" %%i in ("%HOURSTART%") do set var=%%i
	if defined var (set /a HELPER = 1)
	if %HOURSTART% LSS 0 (set /a HELPER = 1)
	if %HOURSTART% GTR 24 (set /a HELPER = 1)
	if %HELPER% EQU 1 echo %HOURSTART% is an illegal value, enter a new value for hour && goto :hourcheck

:mincheck	
set /p MINSTART="What were the minutes when you arrived at work?: "
	SET "var="&for /f "delims=0123456789" %%i in ("%MINSTART%") do set var=%%i
	if defined var (echo %MINSTART% is not a number, enter a new value for minutes && goto :mincheck)
	
set /a HOURNOW=%time:~0,2%
set /a MINNOW =%time:~3,2%
if %HOURNOW% LSS %HOURSTART% echo ERROR: Time now is less than when you started working. Please note that this script doesn't have the functionality to count hours when they are divided over multiple days. && goto :end
echo You arrvied at %HOURSTART%.%MINSTART%.
echo Time now %HOURNOW%.%MINNOW%.

if %MINNOW% LSS %MINSTART% (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-1 && set /a MINSWORKED = %MINNOW%+60-%MINSTART%) else (set /a HOURSWORKED = %HOURNOW%-%HOURSTART% && set /a MINSWORKED = %MINNOW%-%MINSTART%)

:yncheck1
set /p LUNCHINC="Does your lunch break count as working hours? (y/n) "
	if NOT %LUNCHINC% EQU y if NOT %LUNCHINC% EQU n (echo %LUNCHINC% is an illegal value, enter a new value && goto yncheck1)
	
if %LUNCHINC% EQU y goto :echo_answer

:yncheck2
set /p HADLUNCH="Have you had your lunch break yet? (y/n) "
	if NOT %HADLUNCH% EQU y if NOT %HADLUNCH% EQU n (echo %HADLUNCH% is an illegal value, enter a new value && goto yncheck2)

if %HADLUNCH% EQU n goto :echo_answer

:lengthcheck
if %HADLUNCH% EQU y (set /p LUNCHLENGTH="How long was your lunch break? (in minutes) ")
	SET "var="&for /f "delims=0123456789" %%i in ("%LUNCHLENGTH%") do set var=%%i
	if defined var (echo %LUNCHLENGTH% is not a number, enter a new value for lunch length && goto :lengthcheck)

if %MINSWORKED% LSS %LUNCHLENGTH% (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-1 && set /a MINSWORKED = %MINNOW%+60-%MINSTART%-%LUNCHLENGTH% && goto :echo_answer) else (set /a MINSWORKED -= %LUNCHLENGTH% && goto :echo_answer)

if %MINSWORKED% LSS 0 (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-2 && set /a MINSWORKED = %MINNOW%+120-%MINSTART%-%LUNCHLENGTH% && echo You have worked for %HOURSWORKED% hours and %MINSWORKED% minutes 5. && goto :end)
if %MINSWORKED% GTR 59 (set /a HOURSWORKED = %HOURNOW%-%HOURSTART%-1 && set /a MINSWORKED -= 60  && echo You have worked for %HOURSWORKED% hours and %MINSWORKED% minutes 6.)

:echo_answer
	if %HOURSWORKED% EQU 0 (echo You have worked for %MINSWORKED% minutes.) else (echo You have worked for %HOURSWORKED% hours and %MINSWORKED% minutes.)
:end
echo Done!
pause
