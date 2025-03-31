# Домашнее задание к занятию «Индексы» - `Дамир Гайнуллин`

### Инструкция по выполнению домашнего задания

1. Сделайте fork [репозитория c шаблоном решения](https://github.com/netology-code/sys-pattern-homework) к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/gitlab-hw или https://github.com/имя-вашего-репозитория/8-03-hw).
2. Выполните клонирование этого репозитория к себе на ПК с помощью команды `git clone`.
3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
   - впишите вверху название занятия и ваши фамилию и имя;
   - в каждом задании добавьте решение в требуемом виде: текст/код/скриншоты/ссылка;
   - для корректного добавления скриншотов воспользуйтесь инструкцией [«Как вставить скриншот в шаблон с решением»](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md);
   - при оформлении используйте возможности языка разметки md. Коротко об этом можно посмотреть в [инструкции по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md).
4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`).
5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
6. Любые вопросы задавайте в чате учебной группы и/или в разделе «Вопросы по заданию» в личном кабинете.

Желаем успехов в выполнении домашнего задания.

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

```
SELECT 
    (SUM(INDEX_LENGTH) / SUM(DATA_LENGTH) * 100) AS index_percentage
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'sakila';
```
![Скриншот 1](https://github.com/Reqroot-pro/homework/blob/main/SDBSQL-36/12.05/img/1.png)


### Задание 2

Выполните explain analyze следующего запроса:
```
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

  ![Скриншот 1](https://github.com/Reqroot-pro/homework/blob/main/SDBSQL-36/12.05/img/2.png)

- Узкие места

1️Фильтрация по дате с DATE(p.payment_date) = '2005-07-30'
Использование DATE() в WHERE приводит к полному сканированию таблицы, так как MySQL не может использовать индекс по payment_date.

2️Использование DISTINCT
DISTINCT может быть лишним, так как он добавляет дополнительную операцию сортировки.

3️Нет JOIN

4️Отсутствие индексов



- Оптимизированный запрос
  
```
EXPLAIN ANALYZE
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS customer_name, 
    f.title AS film_title,
    SUM(p.amount) OVER (PARTITION BY c.customer_id, f.title) AS total_payment
FROM payment p
JOIN rental r ON p.payment_date = r.rental_date
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE p.payment_date >= '2005-07-30 00:00:00' 
  AND p.payment_date < '2005-07-31 00:00:00';
```

```
CREATE INDEX idx_payment_date ON payment(payment_date);
CREATE INDEX idx_rental_customer ON rental(customer_id);
CREATE INDEX idx_inventory_film ON inventory(film_id);
CREATE INDEX idx_payment_partition ON payment (customer_id, amount);

```


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*
