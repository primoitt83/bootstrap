#!/bin/bash
# Testado no Lubuntu 18.04

# ssh como root
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sed -i "s/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# desativar ipv6
cp /etc/default/grub /etc/default/grub.bak

sed -i 's/\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1"/g' /etc/default/grub
sed -i 's/\GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub

update-grub

apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y containerd.io=1.6.21-1
apt install -y docker-ce-cli=5:20.10.21~3-0~ubuntu-bionic
apt install -y docker-ce-rootless-extras=5:20.10.21~3-0~ubuntu-bionic
apt install -y docker-scan-plugin=0.23.0~ubuntu-bionic
apt install -y docker-compose-plugin=2.11.2~ubuntu-bionic
apt install -y docker-ce=5:20.10.21~3-0~ubuntu-bionic

systemctl enable docker
systemctl start docker

curl -L https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

reboot