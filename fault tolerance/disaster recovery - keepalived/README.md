# Домашнее задание к занятию "`Disaster recovery и Keepalived`" - ` Гайнуллин Дамир`


### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` данного репозитория к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/git-hw или  https://github.com/имя-вашего-репозитория/7-1-ansible-hw).
   2. Выполните клонирование данного репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите вверху название занятия и вашу фамилию и имя
      - в каждом задании добавьте решение в требуемом виде (текст/код/скриншоты/ссылка)
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
   6. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!
   
### Дополнительные материалы, которые могут быть полезны для выполнения задания

1. [Руководство по оформлению Markdown файлов](https://gist.github.com/Jekins/2bf2d0638163f1294637#Code)

---

### Задание 1


![скриншот 1](https://github.com/Reqroot-pro/homework/blob/main/fault%20tolerance/disaster%20recovery%20-%20keepalived/img/1.png)


---

### Задание 2 

```
#!/bin/bash

WEB_PORT=80
INDEX_FILE="/var/www/html/index.nginx-debian.html"

# Проверка доступности порта
if ! nc -z 192.168.56.30 $WEB_PORT; then
    exit 1
fi

# Проверка наличия файла index.html
if [ ! -f "$INDEX_FILE" ]; then
    exit 1
fi

# Если всё в порядке
exit 0
```

```
global_defs {
	enable_script_security
}

vrrp_script check_web {
	script "/usr/local/bin/check_web.sh"
	user keepalived_script
	interval 3
	fall 2
	rise 1
}

vrrp_instance VI_1 {
        state MASTER
        interface enp0s8
        virtual_router_id 35
        priority 255
        advert_int 1

        virtual_ipaddress {
		192.168.56.35/24
	}

	track_script {
		check_web

	}
}
```



![скриншот 2](https://github.com/Reqroot-pro/homework/blob/main/fault%20tolerance/disaster%20recovery%20-%20keepalived/img/2.png)

---

