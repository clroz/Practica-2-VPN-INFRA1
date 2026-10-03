set -eu
for c in docker10 docker12 docker11; do
 docker exec "$c" /usr/local/sbin/vpn-lab-network
 printf '\n--- %s RED ---\n' "$c"
 docker exec "$c" ip -4 route
done
printf '\n--- HTTPS PRIVADO ---\n'
docker exec docker11 curl --noproxy '*' -k -sS --connect-timeout 4 --max-time 8 -w '\nHTTP=%{http_code}\n' https://10.17.45.130/
printf '\n--- TRACEROUTE UDP DESDE PC ---\n'
docker exec -i docker11 python3 -u - <<'PY'
import socket,time,struct
dst='10.17.45.130'
print('Traceroute UDP a',dst,'maximo 8 saltos, 1 sonda por salto')
for ttl in range(1,9):
    port=33434+ttl
    recv=socket.socket(socket.AF_INET,socket.SOCK_RAW,socket.IPPROTO_ICMP)
    send=socket.socket(socket.AF_INET,socket.SOCK_DGRAM,socket.IPPROTO_UDP)
    send.setsockopt(socket.SOL_IP,socket.IP_TTL,ttl)
    started=time.monotonic(); send.sendto(b'VPN-LAB-TRACE',(dst,port))
    found=False
    while time.monotonic()-started<2:
        recv.settimeout(max(.01,2-(time.monotonic()-started)))
        try: data,addr=recv.recvfrom(4096)
        except socket.timeout: break
        h=(data[0]&15)*4
        if len(data)<h+8+20+8: continue
        kind,code=data[h],data[h+1]
        inner=h+8; ih=(data[inner]&15)*4
        if data[inner+9]!=17 or len(data)<inner+ih+8: continue
        if struct.unpack('!H',data[inner+ih+2:inner+ih+4])[0]!=port: continue
        print(ttl,addr[0],round((time.monotonic()-started)*1000,2),'ms ICMP',kind,code)
        found=True; break
    recv.close(); send.close()
    if not found: print(ttl,'*')
    elif addr[0]==dst and kind==3: break
print('Los asteriscos indican ausencia de respuesta ICMP; validar HTTPS por separado.')
PY
