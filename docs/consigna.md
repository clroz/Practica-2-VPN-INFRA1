# Consigna aportada por el usuario el 1 de octubre de 2026

> Comunicar el Usuario con el Servidor a través del enlace VPN.
> Comprobar que la comunicación solo fluye si el enlace VPN esta activo.
> 2 Fortigate (Toda configuración y demostración debe ser por GUI)
> Configuraciones de Red.
> NAT
> VPN Site-To-Site entre los Fortigates.
> ISP
> IP Publicas.
> 1 Servidor Web (/28)
> Web Server (HTTPS).
> 1 Usuarios (/25)
> Vlan 10.
> DHCP.
> Traceroute hacia el servidor.

El requisito confirmado es site-to-site, no acceso remoto. La publicación HTTPS sin VPN fue una interpretación previa incorrecta; debe deshabilitarse para el estado final.

No se especifica aquí el número de práctica ni cómo debe aplicarse NAT. Las reglas NAT de las pruebas anteriores existen, pero no justifican acceso al servidor fuera de la VPN.
