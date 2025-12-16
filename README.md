# HSE_Data_Science_Savinskii
HSE_Data_Science_Savinskii

___________________________________

# Итоговое ДЗ по дисциплине "Базы данных"

Студент: Савинский Виталий
Преподаватель: Дмитрий Калугин-Балашов
Вариант: 1
СУБД: MySQL

# 1. Описание базы данных

Спроектирована реляционная база данных для учета успеваемости студентов, преподавательской нагрузки и анализа эффективности учебного процесса. 

# 1.1. Структура таблиц и атрибуты

База данных состоит из 5 нормализованных таблиц:

1.  **`groups`** (Учебные группы)

`id` (PK): Уникальный идентификатор.
`name` (Unique): Название группы (например, 'Law-2024').

2.  **`students`** (Студенты)

`id` (PK): Идентификатор студента.
`full_name`: ФИО.
`birth_date`: Дата рождения.
`email` (Unique): Контактные данные.
`group_id` (FK): Ссылка на таблицу `groups`.

Связь: При удалении группы поле у студентов становится `NULL`.

3.  **`teachers`** (Преподаватели)

`id` (PK): Идентификатор преподавателя.
`full_name`: ФИО.
`email` (Unique): Служебная почта.

4.  **`subjects`** (Дисциплины)

`id` (PK): Идентификатор предмета.
`name` (Unique): Название дисциплины.
`category` (Enum): Категория ('IT', 'Law', 'Humanities', 'Math') — для аналитики по направлениям.

5.  **`grades`** (Журнал успеваемости)

Таблица связывает Студента, Преподавателя и Предмет.
`score`: Оценка. **Важно: Установлено ограничение `CHECK (score >= 1 AND score <= 10)` согласно стандарту оценивания НИУ ВШЭ.**
`grade_date`: Дата выставления оценки.

Целостность: Настроен `ON DELETE CASCADE`. При удалении студента или предмета все связанные оценки удаляются автоматически.

______________________________

## 2. SQL-запросы (Выполнение задания)

Ниже представлены SQL-скрипты, реализующие функциональные требования задания (Пункт 4).

# А. Выборки и Аналитика

**1. Вывести список студентов по определённому предмету**

```sql
SELECT s.full_name, g.score 
FROM students s
JOIN grades g ON s.id = g.student_id
JOIN subjects sub ON g.subject_id = sub.id
WHERE sub.name = 'Базы данных';
```

**2. Вывести список предметов, которые преподает конкретный преподаватель**

```sql
SELECT DISTINCT sub.name 
FROM subjects sub
JOIN grades g ON sub.id = g.subject_id
JOIN teachers t ON g.teacher_id = t.id
WHERE t.full_name = 'Дмитрий Кутейников';
```

**3. Вывести средний балл студента по всем предметам**

```sql
SELECT s.full_name, ROUND(AVG(g.score), 2) as avg_score
FROM students s
JOIN grades g ON s.id = g.student_id
GROUP BY s.id, s.full_name;
```

**4. Вывести рейтинг преподавателей по средней оценке студентов**

```sql
SELECT t.full_name, ROUND(AVG(g.score), 2) as rating
FROM teachers t
JOIN grades g ON t.id = g.teacher_id
GROUP BY t.id, t.full_name
ORDER BY rating DESC;
```

**5. Список преподавателей, которые преподавали более 3 предметов за последний год**

```sql
SELECT t.full_name, COUNT(DISTINCT g.subject_id) as subjects_count
FROM teachers t
JOIN grades g ON t.id = g.teacher_id
WHERE g.grade_date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY t.id, t.full_name
HAVING subjects_count > 3;
```

**6. Студенты: Отлично (\>7) по IT, но Неуд (\<6) по Праву**
(Условие адаптировано под 10-балльную систему)

```sql
SELECT s.full_name
FROM students s
JOIN grades g ON s.id = g.student_id
JOIN subjects sub ON g.subject_id = sub.id
GROUP BY s.id, s.full_name
HAVING 
    AVG(CASE WHEN sub.category = 'IT' THEN g.score END) > 7 
    AND 
    AVG(CASE WHEN sub.category = 'Law' THEN g.score END) < 6;
```

**7. Предметы, по которым больше всего неудов (\<4) в текущем семестре**

```sql
SELECT sub.name, COUNT(*) as bad_grades
FROM subjects sub
JOIN grades g ON sub.id = g.subject_id
WHERE g.score < 4
GROUP BY sub.id, sub.name
ORDER BY bad_grades DESC
LIMIT 1;
```

**8. Студенты, получившие высший балл (10) по всем экзаменам**

```sql
SELECT s.full_name
FROM students s
JOIN grades g ON s.id = g.student_id
GROUP BY s.id, s.full_name
HAVING MIN(g.score) = 10;
```

**9. Изменение среднего балла студента по годам обучения**

```sql
SELECT YEAR(g.grade_date) as year, ROUND(AVG(g.score), 2) as avg_score
FROM grades g
JOIN students s ON g.student_id = s.id
WHERE s.full_name = 'Архипов Алексей Владимирович'
GROUP BY year
ORDER BY year;
```

**10. Сравнение групп (анализ успеваемости по категориям предметов)**

```sql
SELECT grp.name, sub.category, ROUND(AVG(g.score), 2) as avg_score
FROM `groups` grp
JOIN students s ON grp.id = s.group_id
JOIN grades g ON s.id = g.student_id
JOIN subjects sub ON g.subject_id = sub.id
GROUP BY grp.name, sub.category
ORDER BY sub.category, avg_score DESC;
```

# Б. Модификация данных 

**11. Вставка записи о новом студенте**

```sql
INSERT INTO students (full_name, birth_date, email, group_id) 
VALUES ('Новый Студент', '2005-01-01', 'new_student@hse.ru', 1);
```

**12. Обновление контактной информации преподавателя**

```sql
UPDATE teachers 
SET email = 'new_email@hse.ru' 
WHERE full_name = 'Владимир Зайцев';
```

**13. Удаление предмета с контролем зависимостей**
*При удалении предмета, благодаря `ON DELETE CASCADE`, все оценки по этому предмету удаляются автоматически.*

```sql
DELETE FROM subjects WHERE name = 'Менеджмент';
```

**14. Вставка новой оценки**

```sql
INSERT INTO grades (student_id, subject_id, teacher_id, score, grade_date) 
VALUES (
    (SELECT id FROM students WHERE email = 'new_student@hse.ru'), 
    1, 1, 8, CURDATE()
);
```
