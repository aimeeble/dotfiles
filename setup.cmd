@echo off
setlocal

if "%1" == "" (
   echo run as %0 dotfile_path
   exit /b 1
)

set HOME=%HOMEDRIVE%%HOMEPATH%
set DOTFILE_PATH=%1

mkdir %HOME%\.vim
call :linkit %HOME%\.vimrc %DOTFILE_PATH%\vim\_vimrc FILE
call :linkit %HOME%\.vim\syntax %DOTFILE_PATH%\vim\syntax DIR
call :linkit %HOME%\.vim\plugins %DOTFILE_PATH%\vim\plugins DIR

goto :eof

rem ###########################################################################
:linkit
set DST=%1
set SRC=%2
set TYPE=%3

if exist %DST% (
   echo File %DST% already exists.
   goto :eof
)
if "%TYPE%" == "DIR" (
   mklink /d %DST% %SRC%
) else (
   mklink %DST% %SRC%
)
