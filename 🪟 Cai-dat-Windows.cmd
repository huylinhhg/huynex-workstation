@echo off
chcp 65001 >nul
title HuyNex Power-User Setup
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-windows.ps1"
