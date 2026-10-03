set -eu
python3 - <<'PY'
import subprocess,pathlib,datetime
c='docker11'
path='/usr/local/sbin/vpn-lab-network'
old=subprocess.check_output(['docker','exec',c,'cat',path]).decode()
line='mount -o remount,size=1G /dev/shm'
if line not in old:
 if 'set -eu\n' not in old: raise SystemExit('Formato inesperado; no se modifica')
 backup=pathlib.Path('/root/vpn-backups')/('pc-network-antes-shm-'+datetime.datetime.utcnow().strftime('%Y%m%d-%H%M%S')+'.sh')
 backup.write_text(old); backup.chmod(0o600)
 new=old.replace('set -eu\n','set -eu\n'+line+'\n',1)
 subprocess.run(['docker','exec','-i',c,'sh','-n'],input=new.encode(),check=True)
 subprocess.run(['docker','exec','-i',c,'tee',path],input=new.encode(),stdout=subprocess.DEVNULL,check=True)
 print('Respaldo:',backup)
subprocess.run(['docker','exec',c,'mount','-o','remount,size=1G','/dev/shm'],check=True)
subprocess.run(['docker','exec',c,'df','-h','/dev/shm'],check=True)
print('Ampliación en vivo aplicada y conservada en rutina de arranque. No se cerró Chrome ni se reinició PC.')
PY
