<#
.SYNOPSIS
    HuyNex System Optimizer & Auto-Cleaner for Windows (PowerShell)
    100% Free - Khong loi font - Do RAM truoc va sau don dep
#>

$Host.UI.RawUI.ForegroundColor = "Cyan"
Write-Host "================================================================="
Write-Host "   HUYNEX SYSTEM OPTIMIZER & AUTO-CLEANER (WINDOWS)" -ForegroundColor Green
Write-Host "================================================================="
$Host.UI.RawUI.ForegroundColor = "White"

# Do RAM truoc khi don
$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
if ($os) {
    $beforeFreeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    Write-Host "-> RAM con trong truoc khi don: $beforeFreeRAM GB`n" -ForegroundColor Yellow
}

# 1. Dong tien trinh ngam chiem RAM
Write-Host "[1/6] Dong cac tien trinh chay ngam chiem tai nguyen..." -ForegroundColor Yellow
$bloatProcesses = @("GoogleUpdate", "MicrosoftEdgeUpdate", "AdobeARM", "Creative Cloud", "AdobeDesktopService", "CCXProcess")
foreach ($proc in $bloatProcesses) {
    $running = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($running) {
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔ Da dong tien trinh ngam: $proc" -ForegroundColor Green
    }
}

# 2. Package Managers Cache
Write-Host "[2/6] Don dep bo nho dem Package Managers (npm, pip, winget)..." -ForegroundColor Yellow
if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm cache clean --force 2>$null | Out-Null
    Write-Host "  ✔ npm cache cleaned" -ForegroundColor Green
}
if (Get-Command pip -ErrorAction SilentlyContinue) {
    pip cache purge 2>$null | Out-Null
    Write-Host "  ✔ pip cache cleaned" -ForegroundColor Green
}

# 3. User Temp Files
Write-Host "[3/6] Don dep thu muc Temp cua nguoi dung..." -ForegroundColor Yellow
$userTemp = [System.IO.Path]::GetTempPath()
Get-ChildItem -Path $userTemp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "  ✔ User Temp cleaned" -ForegroundColor Green

# 4. System Temp Files
Write-Host "[4/6] Don dep Windows System Temp..." -ForegroundColor Yellow
$sysTemp = "C:\Windows\Temp"
if (Test-Path $sysTemp) {
    Get-ChildItem -Path $sysTemp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "  ✔ Windows Temp cleaned" -ForegroundColor Green
}

# 5. Don file rac trong workspace HuyNex
Write-Host "[5/6] Don dep file tam, thumbs.db trong HuyNex workspace..." -ForegroundColor Yellow
$huyNexPath = "$HOME\HuyNex"
if (Test-Path $huyNexPath) {
    Get-ChildItem -Path $huyNexPath -Filter "Thumbs.db" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path $huyNexPath -Filter ".DS_Store" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "  ✔ Thumbs.db & .DS_Store purged" -ForegroundColor Green
}

# 6. Empty Recycle Bin
Write-Host "[6/6] Don sach Thung rac (Recycle Bin)..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "  ✔ Recycle Bin emptied" -ForegroundColor Green

# Do RAM sau khi don
$osAfter = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
if ($osAfter) {
    $afterFreeRAM = [math]::Round($osAfter.FreePhysicalMemory / 1MB, 2)
    Write-Host "`n-> RAM con trong sau khi don: $afterFreeRAM GB (Tang: $([math]::Round($afterFreeRAM - $beforeFreeRAM, 2)) GB)" -ForegroundColor Green
}

Write-Host "`n================================================================="
Write-Host "   BAO TRI HOAN TAT - HE THONG WINDOWS DA TOI UU" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
