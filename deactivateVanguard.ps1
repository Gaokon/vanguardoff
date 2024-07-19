$currentScriptPath = $MyInvocation.MyCommand.Definition
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$isVGC = $false
$isVGK = $false

#Revisamos si los servicios estan corriendo
$serviceVGC = Get-Service -Name "vgc"
    if ($serviceVGC.StartType -eq "Manual") {
        Write-Output "VGC Activo, Hay que Apagarlo"
        $isVGC = $true
    }
    else {
        Write-Host "VGC Inactivo"
        
    }

$serviceVGK = Get-Service -Name "vgk"
    if ($serviceVGK.StartType -eq "System") {
        Write-Output "VGK Activo, Hay que Apagarlo"
        $isVGK = $true
    }
    else {
        Write-Host "VGK Inactivo"

    }

if (($isVGC -eq $true ) -or ($isvgk -eq $true)){ #Si algun servicio está corriendo
    #Si los servicios están corriendo me hago admin, si no no.
    if (-not $isAdmin) {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$currentScriptPath`"" -Verb RunAs
        exit
    }
    $resp = " "
    $askagain = $true
    while($askagain){ #Preguntamos si vamos a jugar algo de riot
        Write-Host "Vas a jugar algo de Riot? [S/N] "
        $resp = [System.Console]::ReadKey('NoEcho,IncludeKeyDown').Key.ToString()
        if(($resp -eq "S") -or ($resp -eq "s") ){ #Si jugamos algo de riot, Dejamos activadas los procesos. 
            Write-Host "Todo Listo para Jugar"
            Write-Host "Presiona una tecla para continuar..." -NoNewline
            [void][System.Console]::ReadKey($true)
            $askagain = $false
        }
        if(($resp -eq "N") -or ($resp -eq "n")){ #Si no vamos a jugar algo de riot, los Desactiva.
            #Primero desactivamos VGC
            $serviceVGC | Set-Service -StartupType "Disabled"
            Stop-Service $serviceVGC -ErrorAction SilentlyContinue
            Write-Host "VGC disabled"

            #Luego desactivamos VGK
            $serviceVGK | Set-Service -StartupType "Disabled"
            Stop-Service $serviceVGK -ErrorAction SilentlyContinue
            Write-Output "VGK disabled"

            #Sacamos el System Tray
            Get-Process -Name "vgtray" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

            $askagain = $false
        }
    }
}



