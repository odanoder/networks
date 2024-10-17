#!/bin/bash

# Функция для вывода команд помощи
function help() {
    echo -e "\nДополнительные команды:"
    echo -e "\nОстановить ноду:"
    echo "docker compose -f \$HOME/unichain-node/docker-compose.yml down"
    echo -e "\nРестарт ноды:"
    echo "docker compose -f \$HOME/unichain-node/docker-compose.yml restart"
}

# 1. Обновляем систему и список пакетов
echo "Обновляем систему и список пакетов..."
sudo apt update && sudo apt upgrade -y

# 2. Устанавливаем Docker, если он не установлен
if ! command -v docker &> /dev/null; then
    echo "Docker не найден, устанавливаем Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker установлен и пользователь добавлен в группу docker."
else
    echo "Docker уже установлен, пропускаем установку."
fi

# 3. Инструкция по выходу/перезагрузке
echo "Выходим из пользователя или перезагружаем систему для применения настроек Docker."
echo "Если вы используете сервер, просто выполните повторный вход (re-login)."

# 4. Клонируем репозиторий Unichain
echo "Клонируем репозиторий Unichain..."
git clone https://github.com/Uniswap/unichain-node
cd unichain-node

# 5. Открываем файл .env.sepolia для редактирования
echo "Откройте файл .env.sepolia для редактирования:"
echo "nano .env.sepolia"
echo "Измените значения OP_NODE_L1_ETH_RPC и OP_NODE_L1_BEACON."
echo "После внесения изменений сохраните файл (Ctrl + X, Y, Enter)."

# 6. Запускаем ноду
echo "Запускаем ноду..."
docker compose -f $HOME/unichain-node/docker-compose.yml up -d

# Проверка работы
echo "Проверка работы ноды..."
curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' \
  -H "Content-Type: application/json" http://localhost:8545

# 7. Просмотр приватного ключа
echo "Просмотр приватного ключа:"
echo "sudo less \$HOME/unichain-node/geth-data/geth/nodekey"

# Вывод помощи
help
