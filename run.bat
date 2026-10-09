@echo off
rem Usage:  run.bat          run the demo on the sample data
rem         run.bat test     run the unit tests
rem         run.bat scale    generate and reconcile 500 synthetic shipments
setlocal
cd /d "%~dp0"

set PY=python
where python >nul 2>nul || set PY=py -3
%PY% --version >nul 2>nul
if errorlevel 1 (
  echo Python 3.9 or newer is required. Install it from https://www.python.org/downloads/
  exit /b 1
)

if "%1"=="test" (
  %PY% -m unittest discover -s tests -v
  exit /b %errorlevel%
)
if "%1"=="scale" (
  %PY% -m gs1demo generate --shipments 500 --out outputs\scale_data
  %PY% -m gs1demo run --scans outputs\scale_data\scans.csv --record outputs\scale_data\system_of_record.csv --out outputs\scale_report
  exit /b %errorlevel%
)
%PY% -m gs1demo demo
exit /b %errorlevel%
