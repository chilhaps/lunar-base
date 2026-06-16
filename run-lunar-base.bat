@echo off
setlocal
cd /d "%~dp0"

if not exist .venv (
    echo Virtual environment not found. Run setup.bat first.
    exit /b 1
)

set "HOST=127.0.0.1"
set "PORT=8888"

:parse_args
if "%~1"=="" goto args_done
if "%~1"=="--host" (
    shift
    if "%~1"=="" (
        echo Usage: %~n0 [--host HOST] [--port PORT]
        exit /b 1
    )
    set "HOST=%~1"
    shift
    goto parse_args
)
if "%~1"=="--port" (
    shift
    if "%~1"=="" (
        echo Usage: %~n0 [--host HOST] [--port PORT]
        exit /b 1
    )
    set "PORT=%~1"
    shift
    goto parse_args
)
echo Usage: %~n0 [--host HOST] [--port PORT]
exit /b 1

:args_done
call .venv\Scripts\activate.bat
echo.
echo === Lunar Base ===
echo Open http://%HOST%:%PORT% in your browser. Ctrl+C to stop.
echo.
python -m uvicorn web.app:app --host %HOST% --port %PORT%
endlocal
