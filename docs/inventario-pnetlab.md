# Inventario consultado directamente en PNETLab

Consulta por SSH de solo lectura al host `192.168.22.132`, el 30 de septiembre de 2026 a las 23:16 UTC. No se modificaron equipos ni se iniciaron nodos.

| Tipo | Imagen instalada |
| --- | --- |
| FortiGate QEMU | `fortinet-FGT-v7.0.9`, discos `virtioa.qcow2` y `virtiob.qcow2` |
| Cisco QEMU | `viosl2-adventerprisek9-m.ssa.high_iron_20200929` |
| Docker | `pnetlab/apache2:latest` |
| Docker | `pnetlab/mysql_server:latest` |
| Docker | `pnetlab/ubuntu_sv:latest` |
| Docker | `pnetlab/pnet-chrome:latest` |

Los nombres de imagen no verifican por sí solos la versión del software en ejecución. No se encontraron binarios IOL de equipos; solamente archivos auxiliares. No había contenedores Docker en ejecución al consultar.

Se encontraron `Practica Seguridad De Redes.unl` y `VPN.unl`. La lectura XML de `VPN.unl` no encontró nodos ni redes definidos.

## Implicaciones para el diseño

- FortiGate tiene una imagen identificada como 7.0.9; queda verificar la versión desde GUI al iniciarlo.
- Cisco IOSvL2 es una imagen de switch. No asumir que ofrece las funciones NAT propuestas inicialmente para un router; habrá que ajustar el diseño o añadir una imagen de router.
- Apache y Ubuntu son candidatos para el servidor; hay que verificar HTTPS y SSH dentro de la imagen seleccionada.
- Chrome es candidato para la PC gráfica. Aún debe comprobarse si permite instalar o ejecutar un cliente VPN compatible y realizar SSH/traceroute.
- La carpeta superior contiene documentación de otra práctica que usa `10.17.45.0/25` para usuarios y `10.17.45.128/28` para servidores, basándose en los últimos cuatro dígitos de la matrícula. Es una referencia previa para revisar el direccionamiento preliminar de esta práctica, no evidencia de una configuración VPN actual.
