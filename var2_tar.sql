-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 16 2024 г., 18:54
-- Версия сервера: 8.0.30
-- Версия PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `var2_tar`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `CalculateElectricityTariff` (IN `house_id` INT)   BEGIN
    SELECT SUM(i.total * t.price)
    FROM indications AS i
    JOIN tariff AS t ON i.tariff_id = t.id
    WHERE i.dev_id = house_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `CheckIfPensioner` (IN `person_id` INT)   BEGIN
    SELECT CASE
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) >= 65 THEN TRUE
        ELSE FALSE
    END
    FROM prescribed
    WHERE id = person_id;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `CountChildrenInHouse` (IN `house_id` INT)   BEGIN
    SELECT COUNT(*)
    FROM prescribed
    WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) < 18
    AND dev_id = house_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `accounted_benefits`
--

CREATE TABLE `accounted_benefits` (
  `id` int NOT NULL,
  `id_benefit` int DEFAULT NULL,
  `id_indic` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `benefits`
--

CREATE TABLE `benefits` (
  `id` int NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `indications`
--

CREATE TABLE `indications` (
  `id` int NOT NULL,
  `data` datetime DEFAULT NULL,
  `indications` int DEFAULT NULL,
  `total` decimal(8,2) DEFAULT NULL,
  `tariff_id` int DEFAULT NULL,
  `dev_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `indications`
--

INSERT INTO `indications` (`id`, `data`, `indications`, `total`, `tariff_id`, `dev_id`) VALUES
(1, '2024-04-16 09:00:00', 150, '75.00', 1, 1),
(2, '2024-04-16 09:30:00', 200, '100.00', 1, 2),
(3, '2024-04-16 10:00:00', 180, '90.00', 2, 3),
(4, '2024-04-16 10:30:00', 220, '110.00', 2, 4),
(10, '2024-04-16 18:51:55', 1, '4.71', 1, 2),
(11, '2024-04-16 18:52:02', 8, '37.69', 1, 2),
(12, '2024-04-16 18:52:48', 2, '4.04', 1, 3),
(13, '2024-04-16 18:52:54', 8, '16.15', 1, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `metering_device`
--

CREATE TABLE `metering_device` (
  `id` int NOT NULL,
  `address` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `metering_device`
--

INSERT INTO `metering_device` (`id`, `address`) VALUES
(1, 'Петропавлоцкий проспект д13 к1 546'),
(2, 'Переулок Камский д12'),
(3, 'Улица Кирова д4 к2 234'),
(4, 'Ясеневая д1 к1 493');

-- --------------------------------------------------------

--
-- Структура таблицы `prescribed`
--

CREATE TABLE `prescribed` (
  `id` int NOT NULL,
  `FIO` varchar(60) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `dev_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `prescribed`
--

INSERT INTO `prescribed` (`id`, `FIO`, `birthday`, `dev_id`) VALUES
(1, 'Иванов Иван Иванович', '1992-05-15', 1),
(2, 'Петрова Анна Петровна', '1985-08-20', 1),
(3, 'Сидоров Петр Петрович', '2012-11-03', 1),
(4, 'Кузнецова Мария Васильевна', '1955-03-15', 2),
(5, 'Смирнов Василий Петрович', '1950-12-28', 3),
(6, 'Николаева Екатерина Ивановна', '2018-06-10', 3),
(7, 'Козлова Анастасия Павловна', '2008-08-02', 3),
(8, 'Петрова Ольга Алексеевна', '2010-01-20', 3),
(9, 'Тарарака Артём Дмитриевич', '2006-02-09', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `tariff`
--

CREATE TABLE `tariff` (
  `id` int NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tariff`
--

INSERT INTO `tariff` (`id`, `name`, `price`) VALUES
(1, 'Дневной тариф', '6.73'),
(2, 'Ночной тариф', '3.61');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accounted_benefits`
--
ALTER TABLE `accounted_benefits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_benefit` (`id_benefit`),
  ADD KEY `id_indic` (`id_indic`);

--
-- Индексы таблицы `benefits`
--
ALTER TABLE `benefits`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `indications`
--
ALTER TABLE `indications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tariff_id` (`tariff_id`),
  ADD KEY `dev_id` (`dev_id`);

--
-- Индексы таблицы `metering_device`
--
ALTER TABLE `metering_device`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `prescribed`
--
ALTER TABLE `prescribed`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dev_id` (`dev_id`);

--
-- Индексы таблицы `tariff`
--
ALTER TABLE `tariff`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accounted_benefits`
--
ALTER TABLE `accounted_benefits`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `benefits`
--
ALTER TABLE `benefits`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `indications`
--
ALTER TABLE `indications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `metering_device`
--
ALTER TABLE `metering_device`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `prescribed`
--
ALTER TABLE `prescribed`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `tariff`
--
ALTER TABLE `tariff`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
