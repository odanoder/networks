#!/bin/bash

# Путь к файлу, который будет создан
FILE_PATH="/healthcheck_hyperspace.sh"

# Код, который будет помещен в файл (используем двойные кавычки и экранируем специальные символы)
SCRIPT_CONTENT="#!/bin/bash

# Проверяем, существует ли сессия tmux с именем \"hyperspace\"
if tmux has-session -t hyperspace 2>/dev/null; then
    echo \"Сессия hyperspace уже запущена. Завершение работы скрипта.\"
    exit 0
else
    # Если сессия не запущена, создаем новую сессию и запускаем команду внутри неё
    echo \"Сессия hyperspace не найдена. Создание новой сессии...\"
    tmux new-session -d -s hyperspace
    tmux send-keys -t hyperspace \"aios-cli start --connect\" C-m
    echo \"Команда \\\"aios-cli start --connect\\\" успешно запущена в сессии hyperspace.\"
fi
"

# Создаем файл в корневой директории и записываем в него содержимое
echo "$SCRIPT_CONTENT" | sudo tee $FILE_PATH > /dev/null

# Проверяем, успешно ли создан файл
if [ -f "$FILE_PATH" ]; then
    echo "Файл '$FILE_PATH' успешно создан."

    # Даем файлу права на выполнение
    sudo chmod +x $FILE_PATH

    # Проверяем, успешно ли установлены права на выполнение
    if [ -x "$FILE_PATH" ]; then
        echo "Файл '$FILE_PATH' теперь исполняемый."
    else
        echo "Ошибка: Не удалось установить права на выполнение для файла '$FILE_PATH'."
        exit 1
    fi
else
    echo "Ошибка: Файл '$FILE_PATH' не был создан."
    exit 1
fi

# Выводим сообщение об успешном завершении
echo "Скрипт успешно выполнен. Файл '$FILE_PATH' готов к использованию."
