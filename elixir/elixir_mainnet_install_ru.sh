#!/bin/bash

# Проверка на наличие Docker
if ! command -v docker &>/dev/null; then
    echo -e "\033[31mDocker не установлен. Пожалуйста, установите Docker перед продолжением.\033[0m"
    exit 1
fi

# Проверка на наличие Docker Compose
if ! command -v docker-compose &>/dev/null; then
    echo -e "\033[31mDocker Compose не установлен. Пожалуйста, установите Docker Compose перед продолжением.\033[0m"
    exit 1
fi

# Создание рабочей директории
cd $HOME
mkdir -p elixir
cd elixir

# Запрос данных у пользователя с примерами
echo -e "\033[34mВведите название вашего валидатора (например MyNodeName):\033[0m"
read -r STRATEGY_EXECUTOR_DISPLAY_NAME
echo -e "\033[34mВведите адрес вашего кошелька для вознаграждений (например 0xe10C191F857529295823C3743AfeA26AE9a3a00b):\033[0m"
read -r STRATEGY_EXECUTOR_BENEFICIARY
echo -e "\033[34mВведите приватный ключ кошелька (без префикса 0x , например e412ab1b5c2c0d5c04d6d0d46e478c67ed46f78c5e65d1ed4ac70f56e9655d30):\033[0m"
read -r SIGNER_PRIVATE_KEY

# Создание файла validator.env
echo -e "\033[32mСоздаем файл настроек валидатора (validator.env)...\033[0m"
cat <<EOF >validator.env
ENV=prod
STRATEGY_EXECUTOR_DISPLAY_NAME=$STRATEGY_EXECUTOR_DISPLAY_NAME
STRATEGY_EXECUTOR_BENEFICIARY=$STRATEGY_EXECUTOR_BENEFICIARY
SIGNER_PRIVATE_KEY=$SIGNER_PRIVATE_KEY
EOF
echo -e "\033[32mФайл validator.env успешно создан.\033[0m"

# Создание файла docker-compose.yml
echo -e "\033[32mСоздаем файл Docker Compose (docker-compose.yml)...\033[0m"
cat <<EOF >docker-compose.yml
version: '3'
services:
  elixir-validator:
    image: elixirprotocol/validator
    container_name: elixir
    env_file:
      - ./validator.env
    restart: always
    ports:
      - "17690:17690"  # для мониторинга состояния и метрик
EOF
echo -e "\033[32mФайл docker-compose.yml успешно создан.\033[0m"

# Запуск валидатора
echo -e "\033[32mЗапускаем валидатор...\033[0m"
docker-compose up -d

# Ожидание и проверка успешного запуска
sleep 5
if docker ps | grep -q "elixir"; then
    echo -e "\033[32mВалидатор успешно запущен!\033[0m"
else
    echo -e "\033[31mОшибка при запуске валидатора. Проверьте логи для получения дополнительной информации.\033[0m"
    exit 1
fi

# Инструкции для пользователя
echo -e "\n\033[33m--- Команды для управления валидатором Elixir ---\033[0m"
echo -e "\033[34mДля проверки логов контейнера:\033[0m \033[36mdocker logs -f elixir\033[0m"
echo -e "\033[34mДля перезапуска валидатора:\033[0m \033[36mdocker-compose restart elixir\033[0m"
echo -e "\033[34mДля остановки валидатора:\033[0m \033[36mdocker-compose down\033[0m"
echo -e "\033[34mДля просмотра состояния валидатора на сайте (обновление каждые 10 минут):\033[0m"
echo -e "https://www.elixir.xyz/validators/search/${STRATEGY_EXECUTOR_BENEFICIARY}"
echo -e "\033[32mУстановка завершена. Теперь ваш валидатор Elixir работает!\033[0m"
