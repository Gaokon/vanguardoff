$currentScriptPath = $MyInvocation.MyCommand.Definition
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$currentScriptPath`"" -Verb RunAs
    exit
}

$serviceVGC = Get-Service -Name "vgc"
$serviceVGC | Set-Service -StartupType "Manual"
Write-Host "VGC enabled"

$serviceVGK = Get-Service -Name "vgk"
$command = { sc.exe config vgk start= system }
. $command | Out-Null
Write-Host "VGK enabled"

Write-Host "Para activar Vanguard, Es necesario Reiniciar."
Restart-Computer -Confirm