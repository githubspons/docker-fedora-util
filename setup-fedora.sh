#!/bin/bash

# Sol·licitud de dades
read -p "Introdueix el nom d'usuari: " usuari
read -sp "Contrasenya per a $usuari: " pass
echo ""
read -p "Introdueix el nou hostname: " nou_hostname

# 1. Configuració del Hostname
echo "$nou_hostname" > /etc/hostname
hostname "$nou_hostname"

# 2. Actualització i instal·lació de paquets
# --setopt=tsflags=nocaps és vital per a contenidors en Synology/Docker
dnf update -y
dnf install nano mc tmux iputils iproute openssh-server procps-ng sudo -y --setopt=tsflags=nocaps

# 3. Configuració de SSH
# Genera totes les claus de host automàticament
/usr/bin/ssh-keygen -A
# Assegurem que el directori d'execució existeixi
mkdir -p /run/sshd
/usr/sbin/sshd

# 4. Creació d'usuari i seguretat
if id "$usuari" &>/dev/null; then
    echo "L'usuari $usuari ja existeix. Actualitzant contrasenya..."
else
    useradd -m -s /bin/bash "$usuari"
fi

# Assignar contrasenya i permisos sudo
echo "$usuari:$pass" | chpasswd
usermod -aG wheel "$usuari"

# 5. CONFIGURACIÓ DEL PROMPT GROC PER A ROOT
# Afegim la configuració al .bashrc de root
# \e[1;33m és el codi ANSI per al groc negreta
cat << 'EOF' >> /root/.bashrc

# Prompt groc per a root
export PS1="\[\e[1;33m\][\u@\h \W]# \[\e[0m\]"
EOF

# Aplicar el canvi immediatament per a la sessió actual si s'executa com a root
export PS1="\[\e[1;33m\][\u@\h \W]# \[\e[0m\]"

echo "--------------------------------------------------"
echo "Configuració completada!"
echo "Usuari root ara té el prompt GROC."
echo "Recorda fer 'source /root/.bashrc' si no veus el canvi immediatament."
