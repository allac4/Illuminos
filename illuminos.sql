-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3307
-- Время создания: Ноя 19 2026 г., 11:54
-- Версия сервера: 5.7.39
-- Версия PHP: 8.0.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `illuminos`
--

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Боевик'),
(7, 'Детектив'),
(10, 'Документальный'),
(2, 'Драма'),
(3, 'Комедия'),
(9, 'Мультфильм'),
(8, 'Приключения'),
(6, 'Триллер'),
(5, 'Ужасы'),
(4, 'Фантастика');

-- --------------------------------------------------------

--
-- Структура таблицы `content`
--

CREATE TABLE `content` (
  `id` int(11) NOT NULL,
  `type` enum('movie','series') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `poster` varchar(255) DEFAULT NULL,
  `trailer_url` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT '0',
  `rating` decimal(3,1) DEFAULT '0.0',
  `year` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `is_new` tinyint(1) DEFAULT '0',
  `is_popular` tinyint(1) DEFAULT '0',
  `is_banner` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `content`
--

INSERT INTO `content` (`id`, `type`, `title`, `description`, `poster`, `trailer_url`, `duration`, `rating`, `year`, `category_id`, `is_new`, `is_popular`, `is_banner`) VALUES
(1, 'movie', 'Оппенгеймер', 'История жизни американского физика-теоретика Роберта Оппенгеймера, который стоял во главе первых разработок ядерного оружия.', 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', 'https://www.youtube.com/watch?v=uYPbbksJxIg', 180, '8.5', 2023, 2, 1, 1, 0),
(2, 'movie', 'Дюна: Часть вторая', 'Пол Атрейдес объединяется с фрименами, чтобы отомстить заговорщикам, которые уничтожили его семью.', 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg', 'https://www.youtube.com/watch?v=Way9Dexny3w', 166, '8.6', 2024, 4, 1, 1, 0),
(3, 'series', 'Во все тяжкие', 'Школьный учитель химии Уолтер Уайт узнает, что болен раком, и решает производить метамфетамин, чтобы обеспечить семью.', 'https://image.tmdb.org/t/p/w500/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg', 'https://www.youtube.com/watch?v=HhesaQXLuRY', 0, '9.5', 2008, 2, 0, 1, 0),
(4, 'movie', 'Интерстеллар', 'Группа исследователей ищет новый дом для человечества сквозь червоточину.', 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', 'https://www.youtube.com/watch?v=zSWdZVtXT7E', 169, '8.7', 2014, 4, 0, 1, 0),
(5, 'series', 'Ведьмак', 'Геральт из Ривии, наёмный охотник на монстров, пытается найти своё место в мире, где люди часто оказываются злее чудовищ.', 'https://avatars.mds.yandex.net/i?id=f1415769b3627f191f4fb3b742748b60_l-5528343-images-thumbs&n=13', 'https://www.youtube.com/watch?v=ndl1W4ltcmg', 0, '8.2', 2019, 4, 1, 1, 0),
(6, 'movie', 'Джокер', 'Неудачливый комик Артур Флек, страдающий психическим расстройством, постепенно превращается в культового злодея Джокера.', 'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg', 'https://www.youtube.com/watch?v=zAGVQLHvwOY', 122, '8.4', 2019, 2, 0, 1, 0),
(7, 'movie', 'Мстители: Финал', 'Герои Marvel объединяются для финальной битвы с Таносом.', 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg', 'https://www.youtube.com/watch?v=TcMBFSGVi1c', 181, '8.4', 2019, 1, 0, 1, 0),
(8, 'series', 'Очень странные дела', 'В 1980-х в городке Хоукинс после исчезновения мальчика его друзья сталкиваются со сверхъестественными силами.', 'https://image.tmdb.org/t/p/w500/49WJfeN0moxb9IPfGn8AIqMGskD.jpg', 'https://www.youtube.com/watch?v=b9EkMc79ZSU', 0, '8.6', 2016, 5, 1, 1, 0),
(9, 'movie', 'Бегущий по лезвию 2049', 'Офицер полиции раскрывает тайну, способную перевернуть общество.', 'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', 'https://www.youtube.com/watch?v=gCcx85zbxz4', 164, '8.0', 2017, 4, 0, 0, 0),
(10, 'series', 'Дом Дракона', 'Приквел Игры Престолов о гражданской войне Таргариенов.', 'https://image.tmdb.org/t/p/w500/z2yahl2uefxDCl0nogcRBstwruJ.jpg', 'https://www.youtube.com/watch?v=DotnJ7tTA34', 0, '8.4', 2022, 2, 1, 1, 0),
(11, 'movie', 'Барби', 'Барби отправляется в реальный мир и узнает о его проблемах.', 'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', 'https://www.youtube.com/watch?v=pBk4NYhWNMM', 114, '7.0', 2023, 3, 1, 1, 0),
(12, 'movie', 'Тихое место', 'Семья выживает в мире, где монстры реагируют на любой звук.', 'https://image.tmdb.org/t/p/w500/nAU74GmpUk7t5iklEp3bufwDq4n.jpg', 'https://www.youtube.com/watch?v=WR7cc5t7tv8', 90, '7.5', 2018, 5, 0, 0, 0),
(13, 'series', 'Аркейн', 'История о конфликте между городами Пилтовер и Заун.', 'https://image.tmdb.org/t/p/w500/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg', 'https://www.youtube.com/watch?v=4t_TjG0Gg5Y', 0, '9.0', 2021, 9, 1, 1, 0),
(14, 'movie', 'Гладиатор', 'Римский полководец, преданный императором, становится гладиатором.', 'https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg', 'https://www.youtube.com/watch?v=owK1qxDselE', 155, '8.5', 2000, 1, 0, 1, 0),
(15, 'movie', 'Начало', 'Вор, крадущий секреты из снов, получает задание внедрить идею.', 'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg', 'https://www.youtube.com/watch?v=YoHD9XEInc0', 148, '8.8', 2010, 4, 0, 1, 0),
(16, 'movie', 'Матрица', 'Хакер узнает, что мир — это симуляция.', 'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg', 'https://www.youtube.com/watch?v=vKQi3bBA1y8', 136, '8.7', 1999, 4, 0, 1, 0),
(17, 'series', 'Игра Престолов', 'Девять знатных домов борются за контроль над Вестеросом.', 'https://image.tmdb.org/t/p/w500/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg', 'https://www.youtube.com/watch?v=KPLWWIOCOOQ', 0, '9.2', 2011, 2, 0, 1, 0),
(18, 'movie', 'Побег из Шоушенка', 'Бухгалтер, осужденный за убийство, планирует побег.', 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg', 'https://www.youtube.com/watch?v=6hB3S9bIaco', 142, '9.3', 1994, 2, 0, 1, 0),
(19, 'movie', 'Форрест Гамп', 'Человек с низким IQ становится свидетелем важных исторических событий.', 'https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg', 'https://www.youtube.com/watch?v=bLvqoHBptjg', 142, '8.8', 1994, 2, 0, 1, 0),
(20, 'movie', 'Бойцовский клуб', 'Офисный работник и мыловар создают подпольный бойцовский клуб.', 'https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg', 'https://www.youtube.com/watch?v=qtRKdVHc-cE', 139, '8.8', 1999, 6, 0, 1, 0),
(21, 'movie', 'Властелин колец: Братство Кольца', 'Хоббит Фродо отправляется в поход, чтобы уничтожить Кольцо Всевластия.', 'https://image.tmdb.org/t/p/w500/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg', 'https://www.youtube.com/watch?v=V75dMMIW2B4', 178, '8.9', 2001, 8, 0, 1, 0),
(22, 'series', 'Чернобыль', 'История аварии на Чернобыльской АЭС.', 'https://image.tmdb.org/t/p/w500/hlLXt2tOPT6RRnjiUmoxyG1LTFi.jpg', 'https://www.youtube.com/watch?v=s9APLXM9Ei8', 0, '8.9', 2019, 2, 1, 1, 0),
(23, 'series', 'Шерлок', 'Современная адаптация приключений Шерлока Холмса.', 'https://image.tmdb.org/t/p/w500/7WTsnHkbA0FaG6R9twfFde0I9hl.jpg', 'https://www.youtube.com/watch?v=xK7S9cGqQ28', 0, '9.1', 2010, 7, 0, 1, 0),
(24, 'series', 'Друзья', 'Шестеро друзей живут в Нью-Йорке и справляются с жизненными трудностями.', 'https://image.tmdb.org/t/p/w500/2koX1xLkpTQM4IZebYvKysFW1Nh.jpg', 'https://www.youtube.com/watch?v=hDNNmeeJs1Q', 0, '8.8', 1994, 3, 0, 0, 0),
(25, 'series', 'Настоящий детектив', 'Детективы расследуют запутанные дела.', 'https://avatars.mds.yandex.net/i?id=89f9fa5050944ca7596818819715634f_l-10933087-images-thumbs&n=13', 'https://www.youtube.com/watch?v=fH7GmS4R9y8', 0, '9.0', 2014, 7, 0, 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `content_people`
--

CREATE TABLE `content_people` (
  `content_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `content_people`
--

INSERT INTO `content_people` (`content_id`, `person_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(7, 3),
(1, 4),
(4, 4),
(2, 5),
(2, 6),
(2, 7),
(3, 8),
(3, 9),
(3, 10),
(4, 11),
(4, 12),
(4, 13),
(5, 14),
(5, 15),
(6, 16),
(14, 16),
(6, 17),
(7, 18),
(7, 19),
(8, 20),
(8, 21),
(14, 22),
(15, 23),
(15, 24),
(16, 25),
(16, 26),
(17, 27),
(17, 28),
(18, 29),
(18, 30),
(19, 31),
(19, 32),
(20, 33),
(20, 34),
(21, 35),
(21, 36),
(22, 37),
(22, 38),
(23, 39),
(23, 40),
(24, 41),
(24, 42),
(25, 43),
(25, 44);

-- --------------------------------------------------------

--
-- Структура таблицы `episodes`
--

CREATE TABLE `episodes` (
  `id` int(11) NOT NULL,
  `season_id` int(11) DEFAULT NULL,
  `episode_number` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT '45'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `episodes`
--

INSERT INTO `episodes` (`id`, `season_id`, `episode_number`, `title`, `duration`) VALUES
(1, 1, 1, 'Пилот', 58),
(2, 1, 2, 'Кот в мешке...', 48),
(3, 1, 3, 'Игра в прятки', 48),
(4, 1, 4, 'Раковый больной', 48),
(5, 1, 5, 'Серый матер', 48),
(6, 2, 1, 'Начало конца', 61),
(7, 2, 2, 'Четыре марки', 60),
(8, 2, 3, 'Предательская луна', 60),
(9, 2, 4, 'Банкет придворных', 62),
(10, 3, 1, 'Исчезновение Уилла Байерса', 47),
(11, 3, 2, 'Кленовая улица', 55),
(12, 3, 3, 'Светлячок', 51),
(13, 4, 1, 'Наследник Дракона', 66),
(14, 4, 2, 'Принцесса и королева', 59),
(15, 4, 3, 'Второй своего имени', 60),
(16, 5, 1, 'Добро пожаловать в Пилтовер', 44),
(17, 5, 2, 'Некоторые тайны', 40),
(18, 5, 3, 'Жестокие насильственные действия', 40),
(19, 6, 1, 'Зима близко', 62),
(20, 6, 2, 'Королевский тракт', 56),
(21, 6, 3, 'Лорд Сноу', 58),
(22, 7, 1, '1:23:45', 65),
(23, 7, 2, 'Пожалуйста, оставайтесь спокойны', 65),
(24, 7, 3, 'Открыто и широко', 60),
(25, 8, 1, 'Этюд в розовых тонах', 88),
(26, 8, 2, 'Слепой банкир', 88),
(27, 8, 3, 'Большая игра', 88),
(28, 9, 1, 'Пилот', 22),
(29, 9, 2, 'Сын и дочь', 22),
(30, 9, 3, 'Один с браслетом', 22),
(31, 10, 1, 'Долгая светлая тьма', 60),
(32, 10, 2, 'Смотрители', 55),
(33, 10, 3, 'Запертая комната', 58);

-- --------------------------------------------------------

--
-- Структура таблицы `favorites`
--

CREATE TABLE `favorites` (
  `user_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `tariff_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','paid','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `people`
--

CREATE TABLE `people` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `role_type` enum('actor','director') DEFAULT 'actor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `people`
--

INSERT INTO `people` (`id`, `name`, `role_type`) VALUES
(1, 'Киллиан Мёрфи', 'actor'),
(2, 'Эмили Блант', 'actor'),
(3, 'Роберт Дауни мл.', 'actor'),
(4, 'Кристофер Нолан', 'director'),
(5, 'Тимоти Шаламе', 'actor'),
(6, 'Зендея', 'actor'),
(7, 'Дени Вильнёв', 'director'),
(8, 'Брайан Крэнстон', 'actor'),
(9, 'Аарон Пол', 'actor'),
(10, 'Анна Ганн', 'actor'),
(11, 'Мэттью МакКонахи', 'actor'),
(12, 'Энн Хэтэуэй', 'actor'),
(13, 'Джессика Честейн', 'actor'),
(14, 'Генри Кавилл', 'actor'),
(15, 'Аня Чалотра', 'actor'),
(16, 'Хоакин Феникс', 'actor'),
(17, 'Роберт Де Ниро', 'actor'),
(18, 'Крис Эванс', 'actor'),
(19, 'Скарлетт Йоханссон', 'actor'),
(20, 'Милли Бобби Браун', 'actor'),
(21, 'Финн Вулфхард', 'actor'),
(22, 'Рассел Кроу', 'actor'),
(23, 'Леонардо ДиКаприо', 'actor'),
(24, 'Джозеф Гордон-Левитт', 'actor'),
(25, 'Киану Ривз', 'actor'),
(26, 'Лоренс Фишбёрн', 'actor'),
(27, 'Эмилия Кларк', 'actor'),
(28, 'Питер Динклэйдж', 'actor'),
(29, 'Тим Роббинс', 'actor'),
(30, 'Морган Фриман', 'actor'),
(31, 'Том Хэнкс', 'actor'),
(32, 'Робин Райт', 'actor'),
(33, 'Брэд Питт', 'actor'),
(34, 'Эдвард Нортон', 'actor'),
(35, 'Элайджа Вуд', 'actor'),
(36, 'Иэн Маккеллен', 'actor'),
(37, 'Джаред Харрис', 'actor'),
(38, 'Стеллан Скарсгард', 'actor'),
(39, 'Бенедикт Камбербэтч', 'actor'),
(40, 'Мартин Фриман', 'actor'),
(41, 'Дженнифер Энистон', 'actor'),
(42, 'Кортни Кокс', 'actor'),
(43, 'Мэттью МакКонахи', 'actor'),
(44, 'Вуди Харрельсон', 'actor');

-- --------------------------------------------------------

--
-- Структура таблицы `seasons`
--

CREATE TABLE `seasons` (
  `id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `season_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `seasons`
--

INSERT INTO `seasons` (`id`, `content_id`, `season_number`) VALUES
(1, 3, 1),
(2, 5, 1),
(3, 8, 1),
(4, 10, 1),
(5, 13, 1),
(6, 17, 1),
(7, 22, 1),
(8, 23, 1),
(9, 24, 1),
(10, 25, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `tariffs`
--

CREATE TABLE `tariffs` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration_days` int(11) NOT NULL,
  `features` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `tariffs`
--

INSERT INTO `tariffs` (`id`, `name`, `price`, `duration_days`, `features`) VALUES
(1, 'Месяц', '399.00', 30, 'Без рекламы, HD качество, 2 устройства'),
(2, 'Год', '2990.00', 365, 'Без рекламы, 4K качество, 5 устройств, Скачивание'),
(3, 'Студенческий', '199.00', 30, 'Без рекламы, HD качество, 1 устройство');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','subscriber','user') DEFAULT 'user',
  `subscription_until` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `role`, `subscription_until`, `created_at`) VALUES
(2, 'Дамир Ахтариев Шамилевич', 'admin@illuminos.com', '$2y$10$xiYKlwRthe8lp9Jntz6g..Qi3mvDK3x4m25J.GMvA5LgAydy185JG', 'admin', NULL, '2026-11-19 08:52:27');

-- --------------------------------------------------------

--
-- Структура таблицы `watch_history`
--

CREATE TABLE `watch_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `watched_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `content`
--
ALTER TABLE `content`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Индексы таблицы `content_people`
--
ALTER TABLE `content_people`
  ADD PRIMARY KEY (`content_id`,`person_id`),
  ADD KEY `person_id` (`person_id`);

--
-- Индексы таблицы `episodes`
--
ALTER TABLE `episodes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `season_id` (`season_id`);

--
-- Индексы таблицы `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`user_id`,`content_id`),
  ADD KEY `content_id` (`content_id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `tariff_id` (`tariff_id`);

--
-- Индексы таблицы `people`
--
ALTER TABLE `people`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `seasons`
--
ALTER TABLE `seasons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `content_id` (`content_id`);

--
-- Индексы таблицы `tariffs`
--
ALTER TABLE `tariffs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Индексы таблицы `watch_history`
--
ALTER TABLE `watch_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `content_id` (`content_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `content`
--
ALTER TABLE `content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `episodes`
--
ALTER TABLE `episodes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `people`
--
ALTER TABLE `people`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT для таблицы `seasons`
--
ALTER TABLE `seasons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `tariffs`
--
ALTER TABLE `tariffs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `watch_history`
--
ALTER TABLE `watch_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `content`
--
ALTER TABLE `content`
  ADD CONSTRAINT `content_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `content_people`
--
ALTER TABLE `content_people`
  ADD CONSTRAINT `content_people_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `content` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `content_people_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `people` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `episodes`
--
ALTER TABLE `episodes`
  ADD CONSTRAINT `episodes_ibfk_1` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `content` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`tariff_id`) REFERENCES `tariffs` (`id`);

--
-- Ограничения внешнего ключа таблицы `seasons`
--
ALTER TABLE `seasons`
  ADD CONSTRAINT `seasons_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `content` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `watch_history`
--
ALTER TABLE `watch_history`
  ADD CONSTRAINT `watch_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `watch_history_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `content` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
