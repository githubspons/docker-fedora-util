echo "Introdueix el nom d'usuari:"
read usuari
echo "Contrasenya:"
read pass
echo "Introdueix el hostname:"
read hostname

# update i setup packets inicials
dnf update -y
dnf install nano mc tmux iputils sshd top -y

#ssh
/usr/libexec/openssh/sshd-keygen rsa
/usr/libexec/openssh/sshd-keygen ecdsa
/usr/libexec/openssh/sshd-keygen ed25519
/usr/sbin/sshd

# creació usuari

adduser $usuari
echo "$usuari:$pass" | sudo chpasswd
passwd $pass
