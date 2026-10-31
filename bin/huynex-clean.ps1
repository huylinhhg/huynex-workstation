<#
.SYNOPSIS
    HuyNex System Optimizer & Auto-Cleaner for Windows (PowerShell)
.DESCRIPTION
    Tắt tác vụ chạy ngầm, dọn dẹp temp, cache dev và thùng rác chuẩn Power-User HuyNex.
#>

$Host.UI.RawUI.ForegroundColor = "Cyan"
Write-Host "================================================================="
Write-Host "   ⚡ HuyNex System Optimizer & Auto-Cleaner (Windows) ⚡" -ForegroundColor Green
Write-Host "================================================================="
$Host.UI.RawUI.ForegroundColor = "White"

# 1. Kill Rogue Background Processes (Google Update, Edge Update, Adobe)
Write-Host "`n[1/6] Đóng các tiến trình chạy ngầm ăn tài nguyên..." -ForegroundColor Yellow
$bloatProcesses = @("GoogleUpdate", "MicrosoftEdgeUpdate", "AdobeARM", "Creative Cloud", "AdobeDesktopService", "CCXProcess")
foreach ($proc in $bloatProcesses) {
    $running = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($running) {
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔ Đã đóng tiến trình ngầm: $proc" -ForegroundColor Green
    }
}

# 2. Package Managers Cache
Write-Host "[2/6] Dọn dẹp bộ nhớ đệm Package Managers (npm, pip, winget)..." -ForegroundColor Yellow
if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm cache clean --force 2>$null | Out-Null
    Write-Host "  ✔ npm cache cleaned" -ForegroundColor Green
}
if (Get-Command pip -ErrorAction SilentlyContinue) {
    pip cache purge 2>$null | Out-Null
    Write-Host "  ✔ pip cache cleaned" -ForegroundColor Green
}

# 3. User Temp Files
Write-Host "[3/6] Dọn dẹp thư mục Temp của người dùng..." -ForegroundColor Yellow
$userTemp = [System.IO.Path]::GetTempPath()
Get-ChildItem -Path $userTemp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "  ✔ User Temp cleaned" -ForegroundColor Green

# 4. System Temp Files
Write-Host "[4/6] Dọn dẹp Windows System Temp..." -ForegroundColor Yellow
$sysTemp = "C:\Windows\Temp"
if (Test-Path $sysTemp) {
    Get-ChildItem -Path $sysTemp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "  ✔ Windows Temp cleaned" -ForegroundColor Green
}

# 5. Dọn file rác trong workspace HuyNex
Write-Host "[5/6] Dọn dẹp file tạm, thumbs.db trong HuyNex workspace..." -ForegroundColor Yellow
$huyNexPath = "$HOME\HuyNex"
if (Test-Path $huyNexPath) {
    Get-ChildItem -Path $huyNexPath -Filter "Thumbs.db" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path $huyNexPath -Filter ".DS_Store" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "  ✔ Thumbs.db & .DS_Store purged" -ForegroundColor Green
}

# 6. Empty Recycle Bin
Write-Host "[6/6] Dọn sạch Thùng rác (Recycle Bin)..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "  ✔ Recycle Bin emptied" -ForegroundColor Green

Write-Host "`n================================================================="
Write-Host "   ✨ BẢO TRÌ HOÀN TẤT - HỆ THỐNG WINDOWS ĐÃ TỐI ƯU ✨" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
