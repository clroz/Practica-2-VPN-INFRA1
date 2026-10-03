# Persistencia y recuperación

El 1 de octubre de 2026 se guardó /usr/local/sbin/vpn-lab-network dentro de PC, WEB e ISP, invocado en segundo plano desde sus scripts de arranque. Se validó sintaxis con sh -n y se ejecutaron los tres scripts sin reiniciar equipos; HTTPS privado continuó respondiendo 200.

Respaldo de los scripts originales y de las rutinas de red en el host:
`/root/vpn-backups/arranque-20261001-192459`

| Contenedor actual | Arranque | Ajustes conservados |
| --- | --- | --- |
| docker10 WEB | /home/start.sh | IP de servicio y base, retorno LAN, retorno WAN de pruebas, proxy GUI 18081 |
| docker11 PC | /start.sh | IP base, VLAN 10, cliente DHCP, DHCP de administración de Fortinet1 |
| docker12 ISP | /home/start.sh | IP de ambos enlaces, forwarding IPv4 |

La rutina espera a que aparezcan las interfaces antes de configurar la red. No modifica FortiGate. Las direcciones de administración Docker y los nombres actuales se usan explícitamente; si cambia la asignación, revisar antes de ejecutar.

## Reinicio comprobado el 1 de octubre de 2026

Se detuvieron y arrancaron ISP, WEB y PC, individualmente, mediante el wrapper de PNETLab (sesión 2, nodos 5, 4 y 3). Cambiaron sus PID y horas de arranque. Se conservaron sus contenedores y se reconstruyeron los enlaces de PNETLab; no se aplicaron manualmente las rutinas de red después del arranque.

A las 20:16:34 UTC se verificó: DHCP renovado hasta el 8 de octubre 20:15:01 UTC, PC 10.17.45.20/25, HTTPS privado 200, banner SSH privado, GUI de ambos FortiGate HTTP 200, forwarding ISP=1, XRDP activo y HTTPS público sin respuesta. [Evidencia](../evidencias/reinicio-20261001.txt).

Respaldo previo privado en host: /root/vpn-backups/reinicio-20261001-201453. Incluye XML del lab, metadatos Docker y rutas. No es una copia integral de discos/imágenes. Los registros de arranque muestran avisos del intento de configurar eth0/bridge vnet2_0 por PNETLab; eth0 de administración y los enlaces eth1/eth2 requeridos quedaron operativos.

## Límites

Después de la prueba apareció un fallo Chrome SIGTRAP con registro Out of memory. /dev/shm había regresado a 64 MB al reiniciar; el 1 de octubre a las 21:03 UTC se amplió en vivo a 1 GB y se incorporó el ajuste a la rutina de arranque de PC. Script: scripts/persistir-shm-pc.sh. Se verificó el tamaño aplicado, pero no se repitió el reinicio ni se confirmó aún recuperación del navegador. La prueba de red anterior no cubría este ajuste gráfico.

- Reinicio de los tres contenedores existentes comprobado; no se reiniciaron FortiGate ni el host PNETLab/VM. Un apagón completo sigue sin estar validado.
- Los archivos permanecen al reiniciar los mismos contenedores, pero no se integraron en las imágenes base. Si PNETLab elimina/recrea un contenedor, o se hace Wipe, hay que recuperar la configuración.
- No se realizó exportación de imágenes, respaldo de discos FortiGate ni prueba de restauración completa.
- La ruta WEB a 192.0.2.44/30 corresponde a las pruebas de publicación anteriores. No habilita una política de FortiGate; no la presentar como requisito de la VPN.

## Archivos reproducibles

- scripts/guardar-arranque-red.sh instala los ajustes y respalda scripts originales. Revisar IDs antes de reutilizar.
- scripts/verificar-arranque-traceroute.sh aplica las rutinas de red, comprueba HTTPS privado y realiza traceroute UDP.
- Registro de ejecución en cada contenedor: /var/log/vpn-lab-network.log.

Tras un reinicio, comprobar IP/DHCP, rutas, ISP forwarding, GUI, túnel, HTTPS y SSH. No ejecutar los antiguos scripts de montaje sobre la topología actual.
