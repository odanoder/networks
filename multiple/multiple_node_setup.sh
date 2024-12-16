#!/bin/bash

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    echo -e "curl не найден, устанавливаем..."
    sudo apt update
    sudo apt install curl -y
fi

# Функция для отображения логотипа
display_logo() {
    echo -e "======================================"
    echo "          Multiple Network           "
    echo -e "======================================"
}

# Отображение логотипа
display_logo

# Меню выбора
echo -e "Выберите действие:"
echo -e "1) Установка ноды"
echo -e "2) Удаление ноды"
echo -e "3) Проверка логов"

read -p "Введите номер:" choice

case $choice in
    1)
        echo -e "Начинаем установку ноды..."

        # Обновление системы и установка зависимостей
        sudo apt update && sudo apt upgrade -y

        # Определение архитектуры системы
        ARCH=$(uname -m)
        if [[ "$ARCH" == "x86_64" || "$ARCH" == "i386" ]]; then
            CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
        else
            echo -e "Неподдерживаемая архитектура: $ARCH. Поддерживаются только x86 и x64."
            exit 1
        fi

        # Скачивание клиента
        wget $CLIENT_URL -O multipleforlinux.tar
        if [[ $? -ne 0 ]]; then
            echo -e "Ошибка при скачивании файла. Проверьте URL."
            exit 1
        fi

        # Распаковка архива
        tar -xvf multipleforlinux.tar
        cd multipleforlinux || { echo -e "Не удалось перейти в папку multipleforlinux."; exit 1; }

        # Выдача прав на выполнение
        chmod +x ./multiple-cli ./multiple-node

        # Добавление директории в PATH
        echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
        source ~/.bash_profile

        # Запуск ноды
        nohup ./multiple-node > output.log 2>&1 &

        # Привязка аккаунта
        read -p "Введите ваш Account ID: " IDENTIFIER
        read -p "Установите ваш PIN: " PIN
        ./multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFIER --pin $PIN --storage 200 --bandwidth-upload 100

        echo -e "Установка завершена!"
        echo -e "Для проверки статуса, зайдите в папку с нодой и выполните: ./multiple-cli status"
        ;;

    2)
        echo -e "Удаляем ноду...}"
        pkill -f multiple-node
        rm -rf ~/multipleforlinux
        echo -e "Нода успешно удалена."
        ;;

    3)
        echo -e "Проверяем логи..."
        if [[ -f ~/multipleforlinux/output.log ]]; then
            tail -f ~/multipleforlinux/output.log
        else
            echo -e "Лог-файл не найден. Возможно, нода не установлена."
        fi
        ;;

    *)
        echo -e "Неверный выбор. Попробуйте снова."
        ;;
esac
