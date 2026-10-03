set -eu
python3 - <<'PY'
import subprocess, pathlib, datetime
backup=pathlib.Path('/root/vpn-backups')/('arranque-'+datetime.datetime.utcnow().strftime('%Y%m%d-%H%M%S'))
backup.mkdir(parents=True,mode=0o700)
common='''#!/bin/sh
set -eu
for i in $(seq 1 90); do
 ip link show eth1 >/dev/null 2>&1 && break
 sleep 1
done
ip link set eth1 up
'''
configs={
'docker10':('/home/start.sh',common+'''ip addr replace 192.168.2.10/24 dev eth1
ip addr replace 10.17.45.130/28 dev eth1
ip route replace 10.17.45.0/25 via 10.17.45.129 dev eth1
ip route replace 192.0.2.44/30 via 10.17.45.129 dev eth1
if ! ss -ltn | grep -q ':18081 '; then
 socat TCP-LISTEN:18081,bind=10.177.0.4,reuseaddr,fork TCP:10.17.45.129:80 >/var/log/vpn-gui-proxy.log 2>&1 &
fi
'''),
'docker12':('/home/start.sh',common+'''for i in $(seq 1 90); do
 ip link show eth2 >/dev/null 2>&1 && break
 sleep 1
done
ip link set eth2 up
ip addr replace 192.0.2.45/30 dev eth1
ip addr replace 198.51.100.21/30 dev eth2
echo 1 >/proc/sys/net/ipv4/ip_forward
'''),
'docker11':('/start.sh',common+'''mount -o remount,size=1G /dev/shm
ip addr replace 192.168.1.10/24 dev eth1
ip link show eth1.10 >/dev/null 2>&1 || ip link add link eth1 name eth1.10 type vlan id 10
ip link set eth1.10 up
if ! pgrep -f '^dnsmasq .*fortigate-dhcp' >/dev/null; then
 dnsmasq --conf-file=/dev/null --port=0 --interface=eth1 --bind-interfaces --dhcp-range=192.168.1.99,192.168.1.99,255.255.255.0,1h --dhcp-option=3 --dhcp-option=6 --dhcp-leasefile=/tmp/fortigate-dhcp.leases --pid-file=/tmp/fortigate-dhcp.pid --log-dhcp --log-facility=/tmp/fortigate-dhcp.log
fi
if ! pgrep -f '^dhclient .*eth1.10' >/dev/null; then
 dhclient -nw eth1.10
fi
''')}
hook='/usr/local/sbin/vpn-lab-network'
for c,(entry,script) in configs.items():
    old=subprocess.check_output(['docker','exec',c,'cat',entry]).decode()
    if 'exec $@' not in old: raise SystemExit('Arranque inesperado: '+c)
    (backup/(c+'-start.sh')).write_text(old)
    (backup/(c+'-network.sh')).write_text(script)
    subprocess.run(['docker','exec','-i',c,'sh','-n'],input=script.encode(),check=True)
    new=old if hook in old else old.replace('exec $@',hook+' >/var/log/vpn-lab-network.log 2>&1 &\nexec $@')
    subprocess.run(['docker','exec','-i',c,'sh','-n'],input=new.encode(),check=True)
    for path,content in ((hook,script),(entry,new)):
        subprocess.run(['docker','exec','-i',c,'tee',path],input=content.encode(),stdout=subprocess.DEVNULL,check=True)
        subprocess.run(['docker','exec',c,'chmod','755',path],check=True)
    print(c+': hook instalado; script validado con sh -n')
print('Respaldo en host: '+str(backup))
print('No se reiniciaron contenedores. La recreación desde imagen base requiere reinstalar estos scripts.')
PY
