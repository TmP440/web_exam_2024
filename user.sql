-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: std-mysql
-- Время создания: Июн 18 2024 г., 22:09
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
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
