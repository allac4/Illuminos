-- 1. УДАЛЯЕМ СТАРУЮ БАЗУ И СОЗДАЕМ НОВУЮ
DROP DATABASE IF EXISTS illuminos;
CREATE DATABASE illuminos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE illuminos;

-- 2. СОЗДАЕМ ВСЕ ТАБЛИЦЫ
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','subscriber','user') DEFAULT 'user',
    subscription_until DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('movie','series') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    poster VARCHAR(255),
    trailer_url VARCHAR(255) DEFAULT NULL,
    duration INT DEFAULT 0,
    rating DECIMAL(3,1) DEFAULT 0,
    year INT,
    category_id INT,
    is_new TINYINT(1) DEFAULT 0,
    is_popular TINYINT(1) DEFAULT 0,
    is_banner TINYINT(1) DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE people (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(150) NOT NULL, 
    role_type ENUM('actor','director') DEFAULT 'actor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE content_people (
    content_id INT, person_id INT, PRIMARY KEY (content_id, person_id),
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE,
    FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE seasons (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    content_id INT, 
    season_number INT NOT NULL,
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE episodes (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    season_id INT, 
    episode_number INT NOT NULL, 
    title VARCHAR(255), 
    duration INT DEFAULT 45,
    FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE favorites (
    user_id INT, content_id INT, added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, content_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE watch_history (
    id INT AUTO_INCREMENT PRIMARY KEY, user_id INT, content_id INT, watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tariffs (
    id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50) NOT NULL, price DECIMAL(10,2) NOT NULL, duration_days INT NOT NULL, features TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY, user_id INT, tariff_id INT, amount DECIMAL(10,2), status ENUM('pending','paid','cancelled') DEFAULT 'pending', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, FOREIGN KEY (tariff_id) REFERENCES tariffs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. ЗАПОЛНЯЕМ ДАННЫМИ
INSERT INTO users (full_name, email, password, role) VALUES
('Администратор', 'admin@illuminos.ru', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

INSERT INTO categories (name) VALUES
('Боевик'),('Драма'),('Комедия'),('Фантастика'),('Ужасы'),
('Триллер'),('Детектив'),('Приключения'),('Мультфильм'),('Документальный');

INSERT INTO content (type, title, description, poster, trailer_url, duration, rating, year, category_id, is_new, is_popular, is_banner) VALUES
('movie','Оппенгеймер','История жизни американского физика-теоретика Роберта Оппенгеймера, который стоял во главе первых разработок ядерного оружия.', 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', 'https://www.youtube.com/watch?v=uYPbbksJxIg', 180, 8.5, 2023, 2, 1, 1, 1),
('movie','Дюна: Часть вторая','Пол Атрейдес объединяется с фрименами, чтобы отомстить заговорщикам, которые уничтожили его семью.', 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg', 'https://www.youtube.com/watch?v=Way9Dexny3w', 166, 8.6, 2024, 4, 1, 1, 0),
('series','Во все тяжкие','Школьный учитель химии Уолтер Уайт узнает, что болен раком, и решает производить метамфетамин, чтобы обеспечить семью.', 'https://image.tmdb.org/t/p/w500/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg', 'https://www.youtube.com/watch?v=HhesaQXLuRY', 0, 9.5, 2008, 2, 0, 1, 0),
('movie','Интерстеллар','Группа исследователей ищет новый дом для человечества сквозь червоточину.', 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', 'https://www.youtube.com/watch?v=zSWdZVtXT7E', 169, 8.7, 2014, 4, 0, 1, 0),
('series','Ведьмак','Геральт из Ривии, наёмный охотник на монстров, пытается найти своё место в мире, где люди часто оказываются злее чудовищ.', 'https://image.tmdb.org/t/p/w500/7vjaCdMw15FEbXyLcQ1vC5sHw9h.jpg', 'https://www.youtube.com/watch?v=ndl1W4ltcmg', 0, 8.2, 2019, 4, 1, 1, 0),
('movie','Джокер','Неудачливый комик Артур Флек, страдающий психическим расстройством, постепенно превращается в культового злодея Джокера.', 'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg', 'https://www.youtube.com/watch?v=zAGVQLHvwOY', 122, 8.4, 2019, 2, 0, 1, 0),
('movie','Мстители: Финал','Герои Marvel объединяются для финальной битвы с Таносом.', 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg', 'https://www.youtube.com/watch?v=TcMBFSGVi1c', 181, 8.4, 2019, 1, 0, 1, 0),
('series','Очень странные дела','В 1980-х в городке Хоукинс после исчезновения мальчика его друзья сталкиваются со сверхъестественными силами.', 'https://image.tmdb.org/t/p/w500/49WJfeN0moxb9IPfGn8AIqMGskD.jpg', 'https://www.youtube.com/watch?v=b9EkMc79ZSU', 0, 8.6, 2016, 5, 1, 1, 0),
('movie','Бегущий по лезвию 2049','Офицер полиции раскрывает тайну, способную перевернуть общество.', 'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', 'https://www.youtube.com/watch?v=gCcx85zbxz4', 164, 8.0, 2017, 4, 0, 0, 0),
('series','Дом Дракона','Приквел Игры Престолов о гражданской войне Таргариенов.', 'https://image.tmdb.org/t/p/w500/z2yahl2uefxDCl0nogcRBstwruJ.jpg', 'https://www.youtube.com/watch?v=DotnJ7tTA34', 0, 8.4, 2022, 2, 1, 1, 0),
('movie','Барби','Барби отправляется в реальный мир и узнает о его проблемах.', 'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', 'https://www.youtube.com/watch?v=pBk4NYhWNMM', 114, 7.0, 2023, 3, 1, 1, 0),
('movie','Тихое место','Семья выживает в мире, где монстры реагируют на любой звук.', 'https://image.tmdb.org/t/p/w500/nAU74GmpUk7t5iklEp3bufwDq4n.jpg', 'https://www.youtube.com/watch?v=WR7cc5t7tv8', 90, 7.5, 2018, 5, 0, 0, 0),
('series','Аркейн','История о конфликте между городами Пилтовер и Заун.', 'https://image.tmdb.org/t/p/w500/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg', 'https://www.youtube.com/watch?v=4t_TjG0Gg5Y', 0, 9.0, 2021, 9, 1, 1, 0),
('movie','Гладиатор','Римский полководец, преданный императором, становится гладиатором.', 'https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg', 'https://www.youtube.com/watch?v=owK1qxDselE', 155, 8.5, 2000, 1, 0, 1, 0),
('movie','Начало','Вор, крадущий секреты из снов, получает задание внедрить идею.', 'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg', 'https://www.youtube.com/watch?v=YoHD9XEInc0', 148, 8.8, 2010, 4, 0, 1, 0),
('movie','Матрица','Хакер узнает, что мир — это симуляция.', 'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg', 'https://www.youtube.com/watch?v=vKQi3bBA1y8', 136, 8.7, 1999, 4, 0, 1, 0),
('series','Игра Престолов','Девять знатных домов борются за контроль над Вестеросом.', 'https://image.tmdb.org/t/p/w500/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg', 'https://www.youtube.com/watch?v=KPLWWIOCOOQ', 0, 9.2, 2011, 2, 0, 1, 0),
('movie','Побег из Шоушенка','Бухгалтер, осужденный за убийство, планирует побег.', 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg', 'https://www.youtube.com/watch?v=6hB3S9bIaco', 142, 9.3, 1994, 2, 0, 1, 0),
('movie','Форрест Гамп','Человек с низким IQ становится свидетелем важных исторических событий.', 'https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg', 'https://www.youtube.com/watch?v=bLvqoHBptjg', 142, 8.8, 1994, 2, 0, 1, 0),
('movie','Бойцовский клуб','Офисный работник и мыловар создают подпольный бойцовский клуб.', 'https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg', 'https://www.youtube.com/watch?v=qtRKdVHc-cE', 139, 8.8, 1999, 6, 0, 1, 0),
('movie','Властелин колец: Братство Кольца','Хоббит Фродо отправляется в поход, чтобы уничтожить Кольцо Всевластия.', 'https://image.tmdb.org/t/p/w500/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg', 'https://www.youtube.com/watch?v=V75dMMIW2B4', 178, 8.9, 2001, 8, 0, 1, 0),
('series','Чернобыль','История аварии на Чернобыльской АЭС.', 'https://image.tmdb.org/t/p/w500/hlLXt2tOPT6RRnjiUmoxyG1LTFi.jpg', 'https://www.youtube.com/watch?v=s9APLXM9Ei8', 0, 8.9, 2019, 2, 1, 1, 0),
('series','Шерлок','Современная адаптация приключений Шерлока Холмса.', 'https://image.tmdb.org/t/p/w500/7WTsnHkbA0FaG6R9twfFde0I9hl.jpg', 'https://www.youtube.com/watch?v=xK7S9cGqQ28', 0, 9.1, 2010, 7, 0, 1, 0),
('series','Друзья','Шестеро друзей живут в Нью-Йорке и справляются с жизненными трудностями.', 'https://image.tmdb.org/t/p/w500/2koX1xLkpTQM4IZebYvKysFW1Nh.jpg', 'https://www.youtube.com/watch?v=hDNNmeeJs1Q', 0, 8.8, 1994, 3, 0, 0, 0),
('series','Настоящий детектив','Детективы расследуют запутанные дела.', 'https://image.tmdb.org/t/p/w500/cuV2O5ZyAQ8cXlYNy6Vv8g6z2Jq.jpg', 'https://www.youtube.com/watch?v=fH7GmS4R9y8', 0, 9.0, 2014, 7, 0, 0, 0);

INSERT INTO people (name, role_type) VALUES 
('Киллиан Мёрфи', 'actor'), ('Эмили Блант', 'actor'), ('Роберт Дауни мл.', 'actor'), ('Кристофер Нолан', 'director'),
('Тимоти Шаламе', 'actor'), ('Зендея', 'actor'), ('Дени Вильнёв', 'director'),
('Брайан Крэнстон', 'actor'), ('Аарон Пол', 'actor'), ('Анна Ганн', 'actor'),
('Мэттью МакКонахи', 'actor'), ('Энн Хэтэуэй', 'actor'), ('Джессика Честейн', 'actor'),
('Генри Кавилл', 'actor'), ('Аня Чалотра', 'actor'),
('Хоакин Феникс', 'actor'), ('Роберт Де Ниро', 'actor'),
('Крис Эванс', 'actor'), ('Скарлетт Йоханссон', 'actor'),
('Милли Бобби Браун', 'actor'), ('Финн Вулфхард', 'actor'),
('Рассел Кроу', 'actor'), 
('Леонардо ДиКаприо', 'actor'), ('Джозеф Гордон-Левитт', 'actor'),
('Киану Ривз', 'actor'), ('Лоренс Фишбёрн', 'actor'),
('Эмилия Кларк', 'actor'), ('Питер Динклэйдж', 'actor'),
('Тим Роббинс', 'actor'), ('Морган Фриман', 'actor'),
('Том Хэнкс', 'actor'), ('Робин Райт', 'actor'),
('Брэд Питт', 'actor'), ('Эдвард Нортон', 'actor'),
('Элайджа Вуд', 'actor'), ('Иэн Маккеллен', 'actor'),
('Джаред Харрис', 'actor'), ('Стеллан Скарсгард', 'actor'),
('Бенедикт Камбербэтч', 'actor'), ('Мартин Фриман', 'actor'),
('Дженнифер Энистон', 'actor'), ('Кортни Кокс', 'actor'),
('Мэттью МакКонахи', 'actor'), ('Вуди Харрельсон', 'actor');

INSERT INTO content_people (content_id, person_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4),
(2, 5), (2, 6), (2, 7),
(3, 8), (3, 9), (3, 10),
(4, 11), (4, 12), (4, 13), (4, 4),
(5, 14), (5, 15),
(6, 16), (6, 17),
(7, 3), (7, 18), (7, 19),
(8, 20), (8, 21),
(14, 22), (14, 16),
(15, 23), (15, 24),
(16, 25), (16, 26),
(17, 27), (17, 28),
(18, 29), (18, 30),
(19, 31), (19, 32),
(20, 33), (20, 34),
(21, 35), (21, 36),
(22, 37), (22, 38),
(23, 39), (23, 40),
(24, 41), (24, 42),
(25, 43), (25, 44);

INSERT INTO seasons (content_id, season_number) VALUES 
(3, 1), (5, 1), (8, 1), (10, 1), (13, 1), (17, 1), (22, 1), (23, 1), (24, 1), (25, 1);

INSERT INTO episodes (season_id, episode_number, title, duration) VALUES 
(1, 1, 'Пилот', 58), (1, 2, 'Кот в мешке...', 48), (1, 3, 'Игра в прятки', 48), (1, 4, 'Раковый больной', 48), (1, 5, 'Серый матер', 48),
(2, 1, 'Начало конца', 61), (2, 2, 'Четыре марки', 60), (2, 3, 'Предательская луна', 60), (2, 4, 'Банкет придворных', 62),
(3, 1, 'Исчезновение Уилла Байерса', 47), (3, 2, 'Кленовая улица', 55), (3, 3, 'Светлячок', 51),
(4, 1, 'Наследник Дракона', 66), (4, 2, 'Принцесса и королева', 59), (4, 3, 'Второй своего имени', 60),
(5, 1, 'Добро пожаловать в Пилтовер', 44), (5, 2, 'Некоторые тайны', 40), (5, 3, 'Жестокие насильственные действия', 40),
(6, 1, 'Зима близко', 62), (6, 2, 'Королевский тракт', 56), (6, 3, 'Лорд Сноу', 58),
(7, 1, '1:23:45', 65), (7, 2, 'Пожалуйста, оставайтесь спокойны', 65), (7, 3, 'Открыто и широко', 60),
(8, 1, 'Этюд в розовых тонах', 88), (8, 2, 'Слепой банкир', 88), (8, 3, 'Большая игра', 88),
(9, 1, 'Пилот', 22), (9, 2, 'Сын и дочь', 22), (9, 3, 'Один с браслетом', 22),
(10, 1, 'Долгая светлая тьма', 60), (10, 2, 'Смотрители', 55), (10, 3, 'Запертая комната', 58);

INSERT INTO tariffs (name, price, duration_days, features) VALUES
('Месяц', 399.00, 30, 'Без рекламы, HD качество, 2 устройства'),
('Год', 2990.00, 365, 'Без рекламы, 4K качество, 5 устройств, Скачивание'),
('Студенческий', 199.00, 30, 'Без рекламы, HD качество, 1 устройство');
