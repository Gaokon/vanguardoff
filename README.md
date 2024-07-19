# Vanguardoff
Es un simple proyecto que permite detener o activar los servicios VGC, VGK y Vanguard System Tray.

## Funcionamiento
deactivateVanguard.ps1, primero revisa si los servicios de vanguard estan corriendo:
1. Si no están corriendo, el script finaliza.
2. Si están corriendo, el script nos pregunta si deseamos jugar algo de Riot, Si la respuesta es positiva, el script finaliza; en el caso contrario, desactiva los procesos.

activateVanguard.ps1, simplemente activa los servicios de vanguard y reinicia el sistema.

## Consideraciones
Si bien los scripts pueden ejecutarse a demanda, recomiendo agregar deactivateVanguard.ps1 al taskscheduler de windows y ejecutarlo cada vez que inicia el sistema, de esta forma, siempre tendremos el vanguard desactivado y solo lo activaremos cuando querramos jugar algún juego de Riot (previo a la ejecución manual de activateVanguard.ps1) 
