﻿## **Автоматический клейм бонусов в проекте transformers.**
**Задача:** 
Автоматический запрос бонусов.
Сохранение логов работы скрипта в текстовый фаил.
**Тестирование на оборудовании:**
OS Ubuntu 20.04
CPU Intel
### **Инструменты:** 
OS: Ubuntu 20.04
CPU: intel
SoftWare: tmux, nano, cron
### **Инструкция**
У меня:
Файлы:
**tfsc** - папка где расположен исполняемый фаил **transformers**.
**script\_transformers.sh** - имя исполняемого фаила, в котором записан скрипт.
**log\_transformers.txt** - текстовый фаил в который записывается история выполнения скрипта и результаты работы.
**tfsc** - так же у меня называется и исполняемый фаил проекта transformers.
Пути:
**cd $HOME/tfsc/ -** каталог в котором находится все что связано с проектом.

**1) Создаем скрипт и сохраняем его в папку с transformers.**

nano $HOME/tfsc/script\_transformers.sh