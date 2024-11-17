# Домашнее задание к занятию "`CI/CD`" - `Гайнуллин Дамир`


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

```
/usr/local/go/bin/go test .
docker build .
```


![скриншот 1](https://github.com/Reqroot-pro/homework/blob/main/hw8.2/img/1.png)


![скриншот 2](https://github.com/Reqroot-pro/homework/blob/main/hw8.2/img/2.png)


---

### Задание 2
 

```
pipeline {
 agent any
 stages {
  stage('Git') {
   steps {git 'https://github.com/netology-code/sdvps-materials.git'}
  }
  stage('Test') {
   steps {
    sh '/usr/local/go/bin/go test .'
   }
  }
  stage('Build') {
   steps {
    sh 'docker build . -t ubuntu-bionic:8082/hello-world:v$BUILD_NUMBER'
   }
  }
 }
}
```

![скриншот 3](https://github.com/Reqroot-pro/homework/blob/main/hw8.2/img/3.png)

![скриншот 4](https://github.com/Reqroot-pro/homework/blob/main/hw8.2/img/4.png)


---

### Задание 3 

```
pipeline {
    agent any

    environment {
        GO_PATH = '/usr/local/go/bin'  // Путь к Go
        PATH = "$GO_PATH:$PATH"  // Добавляем Go в PATH
        NEXUS_URL = 'http://192.168.56.20:8081/repository/my_repo/'  // URL репозитория Nexus
        NEXUS_USER = 'admin'  // Ваш логин Nexus
        NEXUS_PASS = 'admin'  // Ваш пароль Nexus
    }

    stages {
        stage('Checkout') {
            steps {
                // Клонируем репозиторий с исходным кодом
                git 'https://github.com/netology-code/sdvps-materials.git'
            }
        }

        stage('Build Binary') {
            steps {
                // Компилируем бинарный файл Go с указанными параметрами
                sh 'CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o app'
            }
        }

        stage('Upload to Nexus') {
            steps {
                script {
                    // Загружаем скомпилированный файл в Nexus
                    sh """
                        curl -u $NEXUS_USER:$NEXUS_PASS --upload-file app $NEXUS_URL
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline завершен.'
        }
    }
}

```

![скриншот 1](https://github.com/Reqroot-pro/homework/blob/main/hw8.2/img/5.png)


![скриншот 2](https://github.com/Reqroot-pro/homework/blob/main/hw8.2/img/6.png)

