# Capturas finales

Guardar imágenes en evidencias/capturas. No mostrar contraseñas, claves VPN, hashes ni claves privadas. No usar las antiguas capturas de publicación HTTPS activa como estado final.

1. Topología completa: PC, Fortinet1, ISP, Fortinet2, WEB y conexiones.
2. Fortinet1 GUI: interfaz VLAN10-USUARIOS /25 y DHCP; WAN 192.0.2.46/30.
3. Fortinet2 GUI: interfaz servidor /28 y WAN 198.51.100.22/30.
4. Ambos FortiGate: túneles Up y políticas VPN. Mostrar las políticas de publicación deshabilitadas si se conservan.
5. Cliente con VPN: navegador en https://10.17.45.130 mostrando Web Server is running. Mostrar dirección completa.
6. Cliente con VPN: sesión SSH al servidor, whoami e ip -br -4 addr.
7. PC: IP /25, concesión DHCP y recorrido al servidor. La implementación UDP verificada está en scripts/verificar-arranque-traceroute.sh; ese script también reaplica las rutinas de red, no usarlo para demostrar recuperación automática tras reinicio.
8. GUI con S2S-CLIENTE Disabled y conexiones NUEVAS de HTTPS privado y SSH fallando. Evitar usar una página en caché como evidencia. Reactivar después y capturar recuperación.

La prueba sin VPN ya se verificó remotamente; repetir el cambio de estado solo durante la captura/video. Dejar Enabled al terminar.

## Primera captura pendiente tras el reinicio

Volver a abrir la consola gráfica de PC desde PNETLab, abrir https://10.17.45.130 y guardar evidencia de la página. Después abrir la terminal del cliente y ejecutar:

```sh
ssh vpnssh@10.17.45.130
whoami
ip -br -4 addr
exit
```

La última revisión automática verificó el banner SSH; el login interactivo posterior al reinicio se documenta con esta captura.
