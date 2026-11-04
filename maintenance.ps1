POWERSHELL
<#
.SYNOPSIS
    Automated IT Support Maintenance & Diagnostic Tool
.DESCRIPTION
    Performs system cleanup, network reset, and basic system diagnostic checks.
.AUTHOR
    Santiago Zalazar
#>

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   IT SUPPORT SYSTEM MAINTENANCE & REPAIR    " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# 1. Clear Temporary Files
Write-Host "[1/4] Cleaning System Temporary Files..." -ForegroundColor Yellow
try {
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "-> Temp files successfully cleaned." -ForegroundColor Green
} catch {
    Write-Host "-> Partial cleanup completed." -ForegroundColor Gray
}

# 2. Network Diagnostics & Flush
Write-Host "`n[2/4] Resetting Network Configuration..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null
Write-Host "-> DNS Cache flushed successfully." -ForegroundColor Green

# 3. System Storage Info
Write-Host "`n[3/4] Checking Free Disk Space..." -ForegroundColor Yellow
Get-Volume | Where-Object {$_.DriveLetter} | Select-Object DriveLetter, FileSystem, @{Name="FreeSpace(GB)"; Expression={[math]::round($_.SizeRemaining/1GB,2)}}, @{Name="TotalSize(GB)"; Expression={[math]::round($_.Size/1GB,2)}} | Format-Table -AutoSize

# 4. Active Network Interfaces
Write-Host "[4/4] Checking Network Interfaces..." -ForegroundColor Yellow
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} | Select-Object InterfaceAlias, IPAddress | Format-Table -AutoSize

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "     MAINTENANCE PROCESS COMPLETED           " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
