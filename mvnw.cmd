@echo off
setlocal
set "BASE=%~dp0"
set "MAVEN_VERSION=3.9.9"
set "MAVEN_HOME=%BASE%.tools\apache-maven-%MAVEN_VERSION%"
if exist "%MAVEN_HOME%\bin\mvn.cmd" goto run
where mvn >nul 2>nul
if not errorlevel 1 (
  call mvn %*
  exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%scripts\install-maven.ps1"
if errorlevel 1 exit /b 1
:run
call "%MAVEN_HOME%\bin\mvn.cmd" %*
exit /b %errorlevel%
