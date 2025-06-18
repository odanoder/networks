#!/bin/bash

# Скрипт запускается от root. Если нет — выход.
if [ "$EUID" -ne 0 ]; then
  echo "❌ Пожалуйста, запустите этот скрипт от имени root"
  exit 1
fi

# Пример EVM-адреса
EXAMPLE_ADDRESS="0x1234567890abcdef1234567890abcdef12345678"

# Запрос адреса у пользователя
echo "Введите ваш EVM-адрес для получения наград (пример: $EXAMPLE_ADDRESS):"
echo "Если вы участвовали в предыдущих тестнетах — можете указать старый адрес или использовать новый, на ваше усмотрение."
read -rp "Адрес: " CLAIM_REWARD_ADDRESS

# Проверка корректности формата (грубая, 42 символа, начинается с 0x)
if [[ ! "$CLAIM_REWARD_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
  echo "❌ Введён некорректный EVM-адрес. Убедитесь, что он начинается с 0x и содержит 42 символа."
  exit 1
fi

# Удаление старой папки и загрузка файлов
echo "🔄 Подготовка окружения..."
rm -rf /root/cysic-verifier
mkdir -p /root/cysic-verifier
cd /root/cysic-verifier || exit 1

echo "⬇️ Скачивание файлов..."
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/verifier_linux -o verifier
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/libdarwin_verifier.so -o libdarwin_verifier.so
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/librsp.so -o librsp.so

# Конфигурация verifier
echo "🛠️ Создание файла конфигурации..."
cat <<EOF > /root/cysic-verifier/config.yaml
chain:
  endpoint: "grpc-testnet.prover.xyz:80"
  chain_id: "cysicmint_9001-1"
  gas_coin: "CYS"
  gas_price: 10
claim_reward_address: "$CLAIM_REWARD_ADDRESS"
server:
  cysic_endpoint: "https://ws-pre.prover.xyz"
EOF

# Скрипт запуска
echo "📝 Создание стартового скрипта..."
chmod +x /root/cysic-verifier/verifier
echo 'LD_LIBRARY_PATH=. CHAIN_ID=534352 ./verifier' > /root/cysic-verifier/start.sh
chmod +x /root/cysic-verifier/start.sh

# Создание systemd сервиса
echo "🔧 Настройка systemd-сервиса..."
cat <<EOF > /etc/systemd/system/cysic-verifier.service
[Unit]
Description=Cysic Verifier Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/cysic-verifier
ExecStart=/root/cysic-verifier/start.sh
Restart=always
RestartSec=5
Environment=LD_LIBRARY_PATH=.

[Install]
WantedBy=multi-user.target
EOF

# Перезапуск systemd
echo "🚀 Запуск сервиса..."
systemctl daemon-reload
systemctl enable cysic-verifier
systemctl start cysic-verifier

# Проверка статуса
echo "✅ Установка завершена. Статус сервиса:"
systemctl status cysic-verifier --no-pager

echo ""
echo "ℹ️ Для проверки логов используйте:"
echo "journalctl -u cysic-verifier -f"
