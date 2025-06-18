#!/bin/bash

# Скрипт запускается от root. Если нет — выход.
if [ "$EUID" -ne 0 ]; then
  echo "❌ Пожалуйста, запустите этот скрипт от имени root"
  exit 1
fi

#!/bin/bash

# Скрипт установки Cysic Verifier Node для Linux

# Обновление системы
echo "🔄 Обновляем список пакетов и устанавливаем обновления..."
apt update && apt upgrade -y

# Запрос адреса
echo ""
echo "📩 Введите ваш EVM-адрес для получения наград (пример: 0x1234abcd...):"
echo "ℹ️  Если вы участвовали в предыдущих тестнетах — можете использовать старый адрес или создать новый. Решать вам."
read -p "👉 Введите EVM-адрес: " CLAIM_REWARD_ADDRESS

# Проверка формата адреса
if [[ ! "$CLAIM_REWARD_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
  echo "❌ Введённый адрес не соответствует формату EVM. Пример: 0x1234abcd5678..."
  exit 1
fi

# Очистка старой директории
echo "🧹 Удаляем старую директорию ~/cysic-verifier (если есть)..."
rm -rf ~/cysic-verifier
mkdir ~/cysic-verifier
cd ~/cysic-verifier

# Скачивание бинарников
echo "⬇️ Скачиваем необходимые файлы..."
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/verifier_linux -o verifier
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/libdarwin_verifier.so -o libdarwin_verifier.so
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/librsp.so -o librsp.so

# Создание конфигурационного файла
echo "🛠 Создаём файл конфигурации..."
cat <<EOF > config.yaml
chain:
  endpoint: "grpc-testnet.prover.xyz:80"
  chain_id: "cysicmint_9001-1"
  gas_coin: "CYS"
  gas_price: 10
claim_reward_address: "$CLAIM_REWARD_ADDRESS"

server:
  cysic_endpoint: "https://ws-pre.prover.xyz"
EOF

# Создание скрипта запуска
echo "🚀 Создаём скрипт запуска..."
cat <<EOF > start.sh
#!/bin/bash
LD_LIBRARY_PATH=. CHAIN_ID=534352 ./verifier
EOF

chmod +x verifier
chmod +x start.sh

# Создание systemd-сервиса
echo "⚙️ Настраиваем systemd сервис..."
cat <<EOF > /etc/systemd/system/cysic-verifier.service
[Unit]
Description=Cysic Verifier Node
After=network.target

[Service]
User=root
WorkingDirectory=/root/cysic-verifier
ExecStart=/root/cysic-verifier/start.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Применение systemd и запуск
systemctl daemon-reload
systemctl enable cysic-verifier
systemctl restart cysic-verifier

echo ""
echo "✅ Установка завершена!"
echo "Проверьте статус ноды: journalctl -u cysic-verifier -f"
