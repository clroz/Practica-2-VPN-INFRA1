# Scripts de apoyo

Archivos incluidos porque están referenciados en la documentación original. Se ejecutan en el host Linux de PNETLab con acceso administrativo a Docker, no en Windows. No se ejecutaron durante la preparación de este repositorio.

| Script | Propósito y efecto |
| --- | --- |
| [guardar-arranque-red.sh](guardar-arranque-red.sh) | Respalda scripts de inicio e instala rutinas de red en WEB, ISP y PC. Modifica archivos dentro de los contenedores. |
| [verificar-arranque-traceroute.sh](verificar-arranque-traceroute.sh) | Reaplica las rutinas de red, comprueba HTTPS y ejecuta sondas UDP desde PC. No sirve como evidencia de recuperación automática tras reinicio. |
| [persistir-shm-pc.sh](persistir-shm-pc.sh) | Amplía `/dev/shm` de PC a 1 GB e incorpora el ajuste al arranque. |

Antes de reutilizarlos, revisar los nombres `docker10` (WEB), `docker11` (PC) y `docker12` (ISP), las interfaces, las IP y las rutas de inicio. Están asociados al montaje documentado y no constituyen un instalador general del laboratorio.

El ajuste gráfico de memoria compartida se aplicó en vivo; no se confirmó otro reinicio ni la recuperación del navegador tras ese cambio. Estos scripts no sustituyen la configuración y demostración de FortiGate por GUI exigidas por la consigna.
