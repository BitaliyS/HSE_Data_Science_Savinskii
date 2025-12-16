-- Финальное ДЗ "Базы Данных"
-- Задание по выбору № 1
-- Савинский Виталий
-- Создание структуры БД и наполнения данными

CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- 1. Удаление старых таблицу (Если вдруг у других студентов аналогичные работы, думаю, что логично при проверке сначала очистить)
-- Порядок важен из-за внешних ключей
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS `groups`;

-- 2. Создание структуры

-- Таблица групп
CREATE TABLE `groups` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица студентов
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    group_id INT,
    FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE SET NULL
);

-- Таблица преподавателей
CREATE TABLE teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Таблица предметов
CREATE TABLE subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category ENUM('Math', 'Humanities', 'IT', 'Law', 'Other') NOT NULL DEFAULT 'Other'
);

-- Таблица оценок (ОГОВОРКА: В задании сказано: "наличие ограничений на атрибуты (например,
-- оценки должны быть в диапазоне от 1 до 5) — 1 балл;" Я сделал приближенное к реальности в ВШЭ и оценки стоят от 1 до 10, оценки выдуманные, не реальные
CREATE TABLE grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    teacher_id INT,
    subject_id INT NOT NULL,
    score INT NOT NULL,
    grade_date DATE NOT NULL,
    -- Оценка от 1 до 10
    CONSTRAINT chk_score CHECK (score >= 1 AND score <= 10),
    -- Каскадное удаление: удалили студента -> удалились оценки
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- 3. Наполнение данными

-- Группы
INSERT INTO `groups` (name) VALUES
('Law-2024'),
('Dev-2024'),
('LegalTech-2024');

-- Преподаватели
INSERT INTO teachers (full_name, email) VALUES
('Дмитрий Калугин-Балашов', 'dima_kb@hse.ru'),
('Владимир Зайцев', 'zaytsev@hse.ru'),
('Дмитрий Кутейников', 'kuteynikov@hse.ru'),
('Владислав Сирота', 'sirota@hse.ru');

-- Дисциплины
INSERT INTO subjects (name, category) VALUES
('Базы данных', 'IT'),
('Ключевые технологии LegalTech', 'IT'),
('Регулирование ИИ', 'Law'),
('Менеджмент', 'Humanities'),
('Теория баз данных', 'IT'),
('Конституционное право', 'Law'),
('Частное право', 'Law'),
('Математическое моделирование', 'Math'),
('Логика', 'Humanities'),
('Информационное право', 'Law');

-- Студенты
INSERT INTO students (full_name, email, group_id, birth_date) VALUES
('Архипов Алексей Владимирович', 'arkhipov_a@hse.ru', 1, '2000-01-01'),
('Баранов Евгений Дмитриевич', 'baranov_e@hse.ru', 2, '2000-02-02'),
('Баснина Вероника Валерьевна', 'basnina_v@hse.ru', 3, '2000-03-03'),
('Бондарчук Дарья Игоревна', 'bondarchuk_d@hse.ru', 1, '2000-04-04'),
('Гайдук Виталий Сергеевич', 'gayduk_v@hse.ru', 2, '2000-05-05'),
('Горева Виктория Алексеевна', 'goreva_v@hse.ru', 3, '2000-06-06'),
('Ершов Алексей Владимирович', 'ershov_a@hse.ru', 1, '2000-07-07'),
('Катаев Михаил', 'kataev_m@hse.ru', 2, '2000-08-08'),
('Космачева Евгения Сергеевна', 'kosmacheva_e@hse.ru', 3, '2000-09-09'),
('Майер Елена Вадимовна', 'mayer_e@hse.ru', 1, '2000-10-10'),
('Мартынов Алексей Николаевич', 'martynov_a@hse.ru', 2, '2000-11-11'),
('Михайлов Даниил Михайлович', 'mikhailov_d@hse.ru', 3, '2000-12-12'),
('Мудрук Анастасия Александровна', 'mudruk_a@hse.ru', 1, '2001-01-13'),
('Николаев Александр Владиславович', 'nikolaev_a@hse.ru', 2, '2001-02-14'),
('Петровская Оксана Юрьевна', 'petrovskaya_o@hse.ru', 3, '2001-03-15'),
('Пивень Алексей Сергеевич', 'piven_a@hse.ru', 1, '2001-04-16'),
('Романов Роман Эдуадрович', 'romanov_r@hse.ru', 2, '2001-05-17'),
('Савинский Виталий Сергеевич', 'savinsky_v@hse.ru', 3, '2001-06-18'),
('Симанова Марина Александровна', 'simanova_m@hse.ru', 1, '2001-07-19'),
('Стацурин Ярослав Александрович', 'statsurin_ya@hse.ru', 2, '2001-08-20'),
('Хакимова Фарида Фаритовна', 'khakimova_f@hse.ru', 3, '2001-09-21'),
('Шадрина Екатерина Александровна', 'shadrina_e@hse.ru', 1, '2001-10-22'),
('Шадрина Татьяна Олеговна', 'shadrina_t@hse.ru', 2, '2001-11-23'),
('Шакуров Игорь Игоревич', 'shakurov_i@hse.ru', 3, '2001-12-24'),
('Швецова Елена Александровна', 'shvetsova_e@hse.ru', 1, '2002-01-25'),
('Головатюк Иван Олегович', 'golovatyuk_i@hse.ru', 2, '2002-02-26'),
('Владимирова Юлия', 'vladimirova_y@hse.ru', 3, '2002-03-27');

-- Оценки

-- LegalTech (Зайцев)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score) VALUES
(1, 2, 2, CURDATE(), 9), (2, 2, 2, CURDATE(), 8), (3, 2, 2, CURDATE(), 8),
(4, 2, 2, CURDATE(), 8), (5, 2, 2, CURDATE(), 8), (6, 2, 2, CURDATE(), 8),
(7, 2, 2, CURDATE(), 9), (8, 2, 2, CURDATE(), 8), (9, 2, 2, CURDATE(), 8),
(10, 2, 2, CURDATE(), 9), (11, 2, 2, CURDATE(), 8), (12, 2, 2, CURDATE(), 8),
(13, 2, 2, CURDATE(), 8), (14, 2, 2, CURDATE(), 8), (15, 2, 2, CURDATE(), 9),
(16, 2, 2, CURDATE(), 8), (17, 2, 2, CURDATE(), 8), (18, 2, 2, CURDATE(), 8),
(19, 2, 2, CURDATE(), 8), (20, 2, 2, CURDATE(), 8), (21, 2, 2, CURDATE(), 8),
(22, 2, 2, CURDATE(), 8), (23, 2, 2, CURDATE(), 8),
(24, 2, 2, CURDATE(), 9), (25, 2, 2, CURDATE(), 8), (26, 2, 2, CURDATE(), 8), (27, 2, 2, CURDATE(), 8);

-- Регулирование ИИ (Кутейников)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 3, 3, CURDATE(), FLOOR(RAND() * (8 - 3 + 1)) + 3 FROM students;

-- БД (Калугин-Балашов)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 1, 1, CURDATE(), FLOOR(RAND() * (7 - 3 + 1)) + 3 FROM students;

-- Теория БД (Калугин-Балашов)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 5, 1, CURDATE(), 8 FROM students WHERE id <= 10;

-- Математическое моделирование (Зайцев)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 8, 2, CURDATE(), 7 FROM students WHERE id > 10 AND id <= 20;

-- Логика (Зайцев)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 9, 2, CURDATE(), 9 FROM students WHERE id > 20;

-- Конституционное право (Кутейников)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 6, 3, CURDATE(), 7 FROM students WHERE id <= 5;

-- Частное право (Кутейников)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 7, 3, CURDATE(), 8 FROM students WHERE id > 5 AND id <= 10;

-- Информационное право (Кутейников)
INSERT INTO grades (student_id, subject_id, teacher_id, grade_date, score)
SELECT id, 10, 3, CURDATE(), 10 FROM students WHERE id > 10 AND id <= 15;
