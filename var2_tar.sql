-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 09 2024 г., 11:37
-- Версия сервера: 8.0.29
-- Версия PHP: 7.3.33

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `metering_device`
--
ALTER TABLE `metering_device`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `prescribed`
--
ALTER TABLE `prescribed`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tariff`
--
ALTER TABLE `tariff`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
