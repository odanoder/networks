## **Автоматический клейм бонусов в проекте transformers.**
**Задача:** <br>
Автоматический запрос бонусов.<br>
Сохранение логов работы скрипта в текстовый фаил.<br>
**Тестирование на оборудовании:**<br>
OS Ubuntu 20.04<br>
CPU Intel<br>
### **Инструменты:** <br>
OS: Ubuntu 20.04<br>
CPU: intel<br>
SoftWare: tmux, nano, cron<br>
### **Инструкция**<br>
У меня:<br>
Файлы:<br>
**tfsc** - папка где расположен исполняемый фаил **transformers**.<br>
**auto_bonus_tfsc.sh** - имя исполняемого фаила, в котором записан скрипт.<br>
**log\_transformers.txt** - текстовый фаил в который записывается история выполнения скрипта и результаты работы.<br>
**tfsc** - так же у меня называется и исполняемый фаил проекта transformers.<br>
Пути:<br>
**cd $HOME/tfsc/ -** каталог в котором находится все что связано с проектом.<br>

**1) Создаем скрипт и сохраняем его в папку с transformers.**<br>
Открываем текстовый редактор<br>
```bash
nano $HOME/tfsc/auto_bonus_tfsc.sh
```

Копируем тело скрипта и сохраняем в открывшемся окне<br>
```bash
#!/bin/bash
echo "$(date) - Start of the script" >> $HOME/tfsc/log_transformers.txt
# Ваш скрипт
tmux send-keys -t tfsc '6' C-m 
sleep 5
tmux send-keys -t tfsc '7' C-m
tmux capture-pane -p -t tfsc | grep -E 'Version:|Base58:|Balance:|Block top:' >> $HOME/tfsc/log_transformers.txt
echo -e "$(date) - Stop of the script\n\n" >> $HOME/tfsc/log_transformers.txt
```

**2) Создаем скрипт и сохраняем его в папку с transformers.**<br>
Делаем скрипт исполняемым<br>
```bash
chmod +x $HOME/tfsc/auto_bonus_tfsc.sh
```

**3) Настраиваем автоматическое выполнение скрипта, используя cron**<br>
Ввыодим команду ниже и нажимаем клавишу [ENTER]<br>
```bash
crontab -e
```
Перед нами откроется окно, идем в самый низ и вставляем эту строчку<br>
`/root/tfsc/` - это путь к нашему скрипту, вставляем свой путь. <br>
Что бы узнать где хранится наш скрипт, выполните эту команду `cd $HOME/tfsc/ && pwd` - результат выполнения этой команды и будет местом нахождния файла<br>
```bash
0 */4 * * * /root/tfsc/auto_bonus_tfsc.sh
```
Сохраняем и выходим. Ждем 4 часа, и наш скрипт выполнит свою работу. Проверить это можно будет в автоматически созданном файле `log_transformers.txt`
