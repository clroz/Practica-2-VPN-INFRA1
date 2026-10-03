# Pruebas y entregables

Consigna confirmada: [consigna.md](consigna.md). Este registro sustituye el plan inicial de acceso remoto.

| Prueba | Estado |
| --- | --- |
| Usuario /25, VLAN 10 y DHCP | Confirmado: eth1.10, 10.17.45.20/25, DHCP server/router 10.17.45.1 en concesión |
| Servidor /28 | Confirmado: 10.17.45.130/28 |
| HTTPS privado con VPN | HTTP 200, contenido Web Server is running; curl con -k no valida confianza de certificado |
| SSH privado con VPN | Usuario confirmó ingreso vpnssh y volvió a entrar tras habilitar túnel |
| IPsec | ESP bidireccional capturado entre WAN de ambos FortiGate |
| SSH con túnel administrativamente Disabled | Usuario reportó Network is unreachable; demuestra falta de conectividad, no rechazo explícito de política |
| HTTPS privado con túnel Disabled | Confirmado remotamente 19:59 UTC: conexión nueva falla con Network is unreachable. SSH privado falla igual; HTTPS y SSH por WAN agotan espera |
| Recuperación tras reactivar túnel | Confirmada 20:00:57 UTC: HTTPS privado 200 y banner SSH disponible; WAN sigue sin responder. No se repitió login en esta prueba |
| Conectividad estable, 2 de octubre | Aún no validada: tras ver GUI S2S-CLIENTE Up, una captura vio ESP y 3/3 ping; dos rondas HTTPS=200 y SSH banner, tercera ronda perdió ping/HTTPS/SSH. Conectividad intermitente. Revisar Forward Traffic y Phase 2 en fallo |
| HTTPS publicado por WAN | Usuario confirmó deshabilitar ambas políticas. Prueba 19:53 UTC: HTTPS WAN agota espera, mientras HTTPS privado responde 200 y SSH privado entrega banner |
| Traceroute privado | Confirmado mediante sondas UDP: 10.17.45.1 → 10.17.45.129 → 10.17.45.130 |
| NAT | Reglas visibles en pruebas anteriores; publicación a deshabilitar. Consigna no precisa aplicación final de NAT |
| Persistencia | Reinicio PNETLab de PC, WEB e ISP comprobado: DHCP, red, HTTPS, SSH y acceso GUI recuperados automáticamente. Evidencia en evidencias/reinicio-20261001.txt. Falta reinicio completo del host/FortiGate; no cubre recreación desde imágenes base |
| Capturas y video finales | Pendientes |

## Siguiente prueba guiada

1. Completado según usuario: deshabilitar por GUI WAN_HTTPS_WEB en Fortinet2 y CLIENTE_HTTPS_WAN en Fortinet1. Verificada falta de acceso WAN desde PC.
2. Con VPN activa, probar https://10.17.45.130 y SSH al mismo destino.
3. Desactivar administrativamente S2S-CLIENTE por GUI.
4. Probar conexiones nuevas: HTTPS privado y SSH deben fallar. Comprobar también que no se accede por la WAN pública.
5. Reactivar S2S-CLIENTE, generar tráfico y demostrar recuperación HTTPS/SSH.
6. Capturar traceroute desde la PC y mostrar DHCP, VLAN, direccionamiento, túnel y políticas en GUI.

Para evitar confundir caché con tráfico real, hacer una solicitud nueva desde terminal además de recargar el navegador.

## Entrega

Falta confirmar número de práctica y requisitos completos de entrega. Preparar topología actual, direccionamiento, configuración/documentación, resultados y capturas sin contraseñas. No hay enlace final de repositorio ni video confirmado.

La guía anterior proponía un video de menos de diez minutos; comprobar ese límite con la consigna completa antes de producirlo. El montaje final y el video deben mostrar VPN site-to-site, no conexión de cliente VPN de acceso remoto.
