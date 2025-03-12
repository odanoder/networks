#!/bin/bash

# Обновление системы и установка необходимых утилит
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget

# Определение архитектуры системы и выбор правильного архива
DOWNLOAD_URL=""
ARCH=$(arch)
if [[ $ARCH =~ "x86_64" ]]; then 
    DOWNLOAD_URL="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/x64/multipleforlinux.tar"
elif [[ $ARCH =~ "aarch64" ]]; then 
    DOWNLOAD_URL="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/arm64/multipleforlinux.tar"
else
    echo "Ваш сервер не поддерживается"
    exit 1
fi

# Загрузка и распаковка архива
wget $DOWNLOAD_URL -O multipleforlinux.tar
mkdir -p ~/multipleforlinux
sudo tar -xvf multipleforlinux.tar -C ~/multipleforlinux --strip-components=1
rm -f multipleforlinux.tar

# Назначение прав и добавление в PATH
chmod -R 777 ~/multipleforlinux
cd ~/multipleforlinux
chmod +x multiple-cli multiple-node

# Добавление пути в переменные окружения
echo "export PATH=\$PATH:\$HOME/multipleforlinux" >> ~/.bash_profile
source ~/.bash_profile

# Создание systemd сервиса
sudo tee /etc/systemd/system/multiple.service > /dev/null << EOF
[Unit]
Description=Multiple Network Node
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/multipleforlinux/multiple-node
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Запуск и включение сервиса
sudo systemctl daemon-reload
sudo systemctl enable multiple
sudo systemctl start multiple

# Привязка аккаунта
echo -e "Введите ваш Account ID. Он берется на сайте. Setup -> Wallet address unique identification code :"
read IDENTIFIER
echo -e "Установите ваш PIN:"
read PIN

~/multipleforlinux/multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFIER --pin $PIN --storage 200 --bandwidth-upload 100

# Вывод команды для проверки статуса
echo "-------------------------------------------------------------"
echo "Команда для проверки статуса ноды:"
echo "~/multipleforlinux/multiple-cli status"
echo "Команда для проверки логов ноды:"
echo "sudo journalctl -u multiple.service -n 100 -f"
echo "-------------------------------------------------------------"
