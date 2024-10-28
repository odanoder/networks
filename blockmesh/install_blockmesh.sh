#!/bin/bash

# Проверка версии Ubuntu
UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" < "22.04" ]]; then
  echo "Эта установка требует Ubuntu версии 22.04 или выше."
  exit 1
fi

# Обновление системы
echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

# Запрос email и пароля
read -p "Введите ваш email, указанный при регистрации: " EMAIL
read -sp "Введите ваш пароль: " PASSWORD
echo

# Скачивание и установка последней версии
echo "Скачивание и распаковка последней версии..."
wget https://github.com/block-mesh/block-mesh-monorepo/releases/download/v0.0.316/blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz
tar -xvzf blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz -C "$HOME"
rm blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz

# Создание файла сервиса systemd
echo "Создание и настройка сервиса blockmesh..."
sudo bash -c "cat <<EOT > /etc/systemd/system/blockmesh.service
[Unit]
Description=BlockMesh
After=network.target

[Service]
User=$USER
ExecStart=$HOME/target/release/blockmesh-cli login --email '$EMAIL' --password '$PASSWORD'
WorkingDirectory=$HOME/target/release
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT"

# Перезагрузка systemd, включение и запуск сервиса
echo "Перезагрузка systemd, включение и запуск сервиса blockmesh..."
sudo systemctl daemon-reload
sudo systemctl enable blockmesh
sudo systemctl start blockmesh

echo "Установка завершена. Логи сервиса можно просматривать командой:"
echo "sudo journalctl -u blockmesh.service -f -n 100"
