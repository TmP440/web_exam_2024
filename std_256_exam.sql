-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: std-mysql
-- Время создания: Июн 18 2024 г., 22:11
-- Версия сервера: 5.7.26-0ubuntu0.16.04.1
-- Версия PHP: 8.1.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `std_256_exam`
--

-- --------------------------------------------------------

--
-- Структура таблицы `book`
--

CREATE TABLE `book` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `short_description` text NOT NULL,
  `year` smallint(6) NOT NULL,
  `publisher` varchar(64) NOT NULL,
  `author` varchar(64) NOT NULL,
  `pages` int(11) NOT NULL,
  `cover_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `book`
--

INSERT INTO `book` (`id`, `title`, `short_description`, `year`, `publisher`, `author`, `pages`, `cover_id`) VALUES
(49, 'Букашка Феня Топ', 'Феня Фенечка Фенек Топ', 1999, 'Республика Татарстан Топ', 'Рузанов Е.Ф', 235, 36);

-- --------------------------------------------------------

--
-- Структура таблицы `book_style`
--

CREATE TABLE `book_style` (
  `book_id` int(11) NOT NULL,
  `style_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `book_style`
--

INSERT INTO `book_style` (`book_id`, `style_id`) VALUES
(49, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `cover`
--

CREATE TABLE `cover` (
  `id` int(11) NOT NULL,
  `file_name` varchar(200) NOT NULL,
  `MIME_type` varchar(200) NOT NULL,
  `MD5_hash` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `cover`
--

INSERT INTO `cover` (`id`, `file_name`, `MIME_type`, `MD5_hash`) VALUES
(36, 'image.jpg', 'image/jpeg', 'fbbdc4a54936d73a99c6320f288df869');

-- --------------------------------------------------------

--
-- Структура таблицы `review`
--

CREATE TABLE `review` (
  `book_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `text` text NOT NULL,
  `status` varchar(32) NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `review`
--

INSERT INTO `review` (`book_id`, `user_id`, `score`, `text`, `status`, `creation_date`) VALUES
(49, 1, 5, 'Я бы пошел к Фене', 'accepted', '2024-06-18 22:04:54');

-- --------------------------------------------------------

--
-- Структура таблицы `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `role`
--

INSERT INTO `role` (`id`, `name`, `description`) VALUES
(1, 'admin', 'Имеет полный доступ к системе, в том числе к созданию и удалению книг'),
(2, 'mod', 'Может редактировать данные книг и производить модерацию рецензий'),
(3, 'user', 'Может оставлять рецензии');

-- --------------------------------------------------------

--
-- Структура таблицы `style`
--

CREATE TABLE `style` (
  `id` int(11) NOT NULL,
  `style_name` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `style`
--

INSERT INTO `style` (`id`, `style_name`) VALUES
(2, 'Детектив'),
(3, 'Триллер'),
(1, 'Фантастика');

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `login` varchar(32) NOT NULL,
  `password_hash` varchar(300) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `middle_name` varchar(64) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `login`, `password_hash`, `last_name`, `first_name`, `middle_name`, `role_id`) VALUES
(1, 'admin', 'scrypt:32768:8:1$T7aWszDpoq1TphZm$3d780ce93e1722a7208431e3a878c1b93d17c90209672bb2e5259670037e66a1c3cdb5e86670a2a1b379033effeea49924bcc60f1680ca7746c0dc81584ca308', 'Крутой', 'Ахха', 'Крутой', 1),
(2, 'mod', 'scrypt:32768:8:1$2uJa8uqacopXn6Mz$ebab945a95013fefc5cf83ce34e67cb115f4379af898dba5ffb3d926bef892b519548ce30c7718dc4c7ed2e99715982b37e8dffc81377e6b20b446bacafad06b', 'Урунда', 'Паел', 'Ис', 2),
(3, 'user', 'scrypt:32768:8:1$H2ddVGWCQlEnEXgE$65d09d9df6f69e306e4065cedd2e83b4619c84993db562a3a44477464173e17193e52eaa823ce60e16210fef7e5dd3fc49cad71cf246ddd015f51f77646a4846', 'Мяу', 'Владик', 'Гавгав', 3);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `cover_id` (`cover_id`);

--
-- Индексы таблицы `book_style`
--
ALTER TABLE `book_style`
  ADD PRIMARY KEY (`book_id`,`style_id`),
  ADD KEY `style_id` (`style_id`);

--
-- Индексы таблицы `cover`
--
ALTER TABLE `cover`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`book_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `description` (`description`);

--
-- Индексы таблицы `style`
--
ALTER TABLE `style`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `style_name` (`style_name`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `book`
--
ALTER TABLE `book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT для таблицы `cover`
--
ALTER TABLE `cover`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `style`
--
ALTER TABLE `style`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `book_ibfk_1` FOREIGN KEY (`cover_id`) REFERENCES `cover` (`id`);

--
-- Ограничения внешнего ключа таблицы `book_style`
--
ALTER TABLE `book_style`
  ADD CONSTRAINT `book_style_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`),
  ADD CONSTRAINT `book_style_ibfk_2` FOREIGN KEY (`style_id`) REFERENCES `style` (`id`);

--
-- Ограничения внешнего ключа таблицы `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Ограничения внешнего ключа таблицы `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
