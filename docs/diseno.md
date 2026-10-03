# Diseño real — VPN site-to-site

## Topología

PC → Fortinet1 → ISP → Fortinet2 → WEB. El túnel une Fortinet1 y Fortinet2; la PC no usa cliente VPN de acceso remoto.

| Equipo/interfaz | Dirección | Función |
| --- | --- | --- |
| PC eth1.10 | 10.17.45.20/25 por DHCP | VLAN 10 |
| Fortinet1 VLAN10-USUARIOS | 10.17.45.1/25 | Gateway y servidor DHCP |
| Fortinet1 port2 | 192.0.2.46/30 | WAN cliente |
| ISP eth1 | 192.0.2.45/30 | Enlace hacia Fortinet1 |
| ISP eth2 | 198.51.100.21/30 | Enlace hacia Fortinet2 |
| Fortinet2 port2 | 198.51.100.22/30 | WAN servidor |
| Fortinet2 port1 | 10.17.45.129/28 | Red del servidor |
| WEB eth1 | 10.17.45.130/28 | HTTPS y SSH |

WAN usa rangos de documentación para simular Internet. Usuarios: 10.17.45.0/25. Servidor: 10.17.45.128/28.
WEB conserva red de administración y default por 10.177.0.1; su retorno a 10.17.45.0/25 va por 10.17.45.129.

## Accesos administrativos

Fortinet1: http://192.168.1.99 desde PC. Fortinet2: http://10.177.0.4:18081 mediante proxy en WEB. La administración usa direcciones adicionales, separadas de las IP usadas en las demostraciones de tráfico del laboratorio.

## Comportamiento requerido

| Prueba | Túnel activo | Túnel desactivado |
| --- | --- | --- |
| HTTPS a 10.17.45.130 | Funciona | No conecta |
| SSH a 10.17.45.130 | Funciona | No conecta |
| HTTPS a WAN 198.51.100.22 | No debe publicarse como acceso alternativo | No debe conectar |

Túneles S2S-CLIENTE y S2S-SERVIDOR. ESP bidireccional comprobado en ISP. Para la prueba de caída se utilizó Status Disabled en la interfaz S2S-CLIENTE: Bring Down solo permitió renegociación posterior.

## Ajuste pendiente de GUI

Deshabilitar WAN_HTTPS_WEB en Fortinet2 y CLIENTE_HTTPS_WAN en Fortinet1. Conservar VIP_HTTPS_WEB como antecedente hasta cerrar la documentación; no confundirlo con un requisito de publicación pública.

Las políticas del túnel visibles permiten ALL. La consigna aportada no limita a SSH/HTTPS, pero no describirlas como políticas restringidas a esos dos servicios.

## Traceroute comprobado

Traceroute UDP desde PC, una sonda por TTL:

1. 10.17.45.1 — 0.88 ms
2. 10.17.45.129 — 1.35 ms
3. 10.17.45.130 — 5.03 ms

Se ejecutó una implementación con sockets Python en scripts/verificar-arranque-traceroute.sh. El último salto devuelve ICMP puerto inalcanzable, que identifica la llegada de la sonda UDP. El ISP no aparece como salto del paquete interno en esta medición del túnel.
