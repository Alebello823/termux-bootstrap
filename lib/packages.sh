install_packages(){

echo "[+] Actualizando repositorios"

pkg update -y
pkg upgrade -y

echo "[+] Instalando paquetes base"

pkg install -y \
git \
curl \
wget \
nano \
vim \
python \
python-pip \
golang \
clang \
make \
cmake \
ruby \
perl \
nmap \
jq \
tmux \
tree \
openssh

}
