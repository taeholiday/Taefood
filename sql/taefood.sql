-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 19, 2022 at 07:07 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `taefood`
--

-- --------------------------------------------------------

--
-- Table structure for table `foodtable`
--

CREATE TABLE `foodtable` (
  `id` int(11) NOT NULL,
  `idShop` text COLLATE utf8_unicode_ci NOT NULL,
  `NameFood` text COLLATE utf8_unicode_ci NOT NULL,
  `PathImage` text COLLATE utf8_unicode_ci NOT NULL,
  `Price` text COLLATE utf8_unicode_ci NOT NULL,
  `Detail` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `foodtable`
--

INSERT INTO `foodtable` (`id`, `idShop`, `NameFood`, `PathImage`, `Price`, `Detail`) VALUES
(1, '2', 'กะเพราไก่', '/TaeFood/Food/food850653.jpg', '65', 'กระเพราไก่และไข่ดาว');

-- --------------------------------------------------------

--
-- Table structure for table `ordertable`
--

CREATE TABLE `ordertable` (
  `id` int(11) NOT NULL,
  `OrderDateTime` text COLLATE utf8_unicode_ci NOT NULL,
  `idUser` text COLLATE utf8_unicode_ci NOT NULL,
  `NameUser` text COLLATE utf8_unicode_ci NOT NULL,
  `idShop` text COLLATE utf8_unicode_ci NOT NULL,
  `NameShop` text COLLATE utf8_unicode_ci NOT NULL,
  `Distance` text COLLATE utf8_unicode_ci NOT NULL,
  `Transport` text COLLATE utf8_unicode_ci NOT NULL,
  `idFood` text COLLATE utf8_unicode_ci NOT NULL,
  `NameFood` text COLLATE utf8_unicode_ci NOT NULL,
  `Price` text COLLATE utf8_unicode_ci NOT NULL,
  `Amount` text COLLATE utf8_unicode_ci NOT NULL,
  `Sum` text COLLATE utf8_unicode_ci NOT NULL,
  `idRider` text COLLATE utf8_unicode_ci NOT NULL,
  `Status` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `ordertable`
--

INSERT INTO `ordertable` (`id`, `OrderDateTime`, `idUser`, `NameUser`, `idShop`, `NameShop`, `Distance`, `Transport`, `idFood`, `NameFood`, `Price`, `Amount`, `Sum`, `idRider`, `Status`) VALUES
(1, '2022-09-17 19:19', '1', 'anukul', '2', 'shop1', '2.91', '55', '[1]', '[กะเพราไก่]', '[65]', '[1]', '[65]', 'none', 'UserOrder'),
(2, '2022-09-19 21:22', '1', 'anukul', '2', 'shop1', '2.91', '55', '[1]', '[กะเพราไก่]', '[65]', '[4]', '[260]', 'none', 'Cancel'),
(3, '2022-09-19 22:06', '6', 'user2', '2', 'shop1', '2.91', '55', '[1]', '[กะเพราไก่]', '[65]', '[2]', '[130]', 'none', 'Finish');

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `id` int(11) NOT NULL,
  `ChooseType` text COLLATE utf8_unicode_ci NOT NULL,
  `Name` text COLLATE utf8_unicode_ci NOT NULL,
  `User` text COLLATE utf8_unicode_ci NOT NULL,
  `Password` text COLLATE utf8_unicode_ci NOT NULL,
  `NameShop` text COLLATE utf8_unicode_ci NOT NULL,
  `Address` text COLLATE utf8_unicode_ci NOT NULL,
  `Phone` text COLLATE utf8_unicode_ci NOT NULL,
  `UrlPicture` text COLLATE utf8_unicode_ci NOT NULL,
  `Lat` text COLLATE utf8_unicode_ci NOT NULL,
  `Lng` text COLLATE utf8_unicode_ci NOT NULL,
  `Token` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`id`, `ChooseType`, `Name`, `User`, `Password`, `NameShop`, `Address`, `Phone`, `UrlPicture`, `Lat`, `Lng`, `Token`) VALUES
(1, 'User', 'anukul', 'user1', 'User1234', '', '', '', '', '', '', ''),
(2, 'Shop', 'jetterin', 'shop1', 'Shop1234', 'shop1', 'address1', 'Shop1234', '/TaeFood/Shop/editShop70078.jpg', '13.9289467', '100.6470583', ''),
(3, 'Shop', 'shop2', 'shop2', 'Shop1234', '', '', '', '', '', '', ''),
(4, 'Rider', 'rider1', 'rider1', 'Rider1234', '', '', '', '', '', '', ''),
(6, 'User', 'user2', 'user2', 'User1234', '', '121/189 saimai 21 saimai bangkok 10220 thailand', '0642589176', '', '13.9047283', '100.65724', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `foodtable`
--
ALTER TABLE `foodtable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ordertable`
--
ALTER TABLE `ordertable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `foodtable`
--
ALTER TABLE `foodtable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `ordertable`
--
ALTER TABLE `ordertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
