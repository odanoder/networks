#!/bin/bash

# Имя файла, который нужно найти
TARGET_FILE="healthcheck_hyperspace.sh"

# Поиск файла в системе
FILE_PATH=$(find / -name "$TARGET_FILE" 2>/dev/null)

# Проверяем, найден ли файл
if [ -z "$FILE_PATH" ]; then
    echo "Ошибка: Файл '$TARGET_FILE' не найден."
    exit 1
else
    echo "Файл '$TARGET_FILE' найден по пути: $FILE_PATH"
fi

# Проверяем, существует ли уже такое задание в cron
if crontab -l | grep -q "$FILE_PATH"; then
    echo "Задание для '$FILE_PATH' уже существует в cron."
else
    # Добавляем новое задание в cron для выполнения каждые 15 минут
    (crontab -l 2>/dev/null; echo "*/15 * * * * $FILE_PATH") | crontab -
    echo "Задание добавлено в cron для выполнения каждые 15 минут."
fi

# Выводим текущие задания cron для проверки
echo "Текущие задания cron:"
crontab -l
