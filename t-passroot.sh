
#!/bin/bash
loadkeys ru
setfont cyr-sun16




passroot=5
user=ccc

useradd -p $(openssl passwd -crypt $passroot) $user