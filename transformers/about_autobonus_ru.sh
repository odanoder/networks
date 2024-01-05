#Инструкция 
#Скрипт каждые 3 часа запрашивает бонусы.
#Задача: 
# - автоматический запрос бонусов.
# - сохранение логов работы скрипта в текстовый фаил.
# - скрипт работает в cron

#Тестирование на оборудовании
# OS Ubuntu 20.04
# CPU Intel

# 1) Создаем скрипт и сохраняем его в папку с transformers.
# У меня эта папка называется: tfsc
# Имя файла (скрипта): script_transformers.sh
nano script_transformers.sh

# 2) Тело скрипта, копируем все что ниже и сохраняем
 #!/bin/bash
echo "$(date) - Start of the script" >> log_transformers.txt
# Ваш скрипт
tmux send-keys -t tfsc '6' C-m 
sleep 5
tmux send-keys -t tfsc '7' C-m
tmux capture-pane -p -t tfsc | grep -E 'Version:|Base58:|Balance:|Block top:' >> log_transformers.txt
echo -e "$(date) - Stop of the script\n\n" >> log_transformers.txt

# 3) Добавляем запись в cron
cd $HOME
cd tfsc
pwd #копируем вывод строки ниже
crontab -e
# В самый низ файла добавляем заись, сохраняем и выходим.

0 */3 * * * /home/unocasperm/script_transformers.sh
