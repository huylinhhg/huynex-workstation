@echo off
chcp 65001 >nul
title HuyNex Workstation 1-Click Setup (Windows)
cls
echo =================================================================
echo    ⚡ HUYNEX WORKSTATION 1-CLICK SETUP (Windows) ⚡
echo    Dang keo ban cai dat moi nhat tu GitHub huynex-workstation...
echo =================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-windows.ps1 | iex"

echo.
echo =================================================================
echo    HOAN TAT CAI DAT VA TOI UU HE THONG!
echo =================================================================
echo Ban co muon xoa thu muc cai dat tam nay de may gon gang 100%% khong?
echo    [Enter] = Xoa ngay (Gon gang sach se)
echo    [n]     = Giu lai (De sau nay chay lai khi can cap nhat)
set /p delchoice="Lua chon cua ban [Y/n]: "
if "%delchoice%"=="" set delchoice=y
if /i "%delchoice%"=="y" (
    echo.
    echo Dang don dep thu muc cai dat...
    start /b "" cmd /c "timeout /t 2 /nobreak >nul & rd /s /q \"%~dp0\""
    exit
) else (
    echo.
    echo Da giu lai file cai dat tren may.
    pause
)
