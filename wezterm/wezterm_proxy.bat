@echo off
:: WezTerm 실행 파일 (Scoop 경로)
SET WEZTERM_EXE=C:\Users\jkkow\scoop\apps\wezterm\current\wezterm.exe

:: 필수 환경 변수 주입
SET USERPROFILE=C:\Users\jkkow
SET HOME=%USERPROFILE%

:: WezTerm 실행
"%WEZTERM_EXE%" cli proxy --config-file NUL
