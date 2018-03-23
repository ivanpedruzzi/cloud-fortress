-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Feb 22, 2018 alle 12:52
-- Versione del server: 10.1.28-MariaDB
-- Versione PHP: 7.0.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `boston_db`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `accounts`
--

CREATE TABLE `accounts` (
  `AccountID` bigint(20) NOT NULL,
  `UserID` bigint(20) NOT NULL,
  `CreatedOn` date NOT NULL,
  `AccountType` int(11) NOT NULL,
  `RountingName` varchar(64) COLLATE utf8_bin NOT NULL,
  `AccountNumber` varchar(64) COLLATE utf8_bin NOT NULL,
  `AmountAvailable` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Struttura della tabella `transactions`
--

CREATE TABLE `transactions` (
  `TransactionId` bigint(20) NOT NULL,
  `accountID` bigint(20) NOT NULL,
  `executedOn` date NOT NULL,
  `operationType` int(11) NOT NULL,
  `amount` decimal(10,0) NOT NULL,
  `from_account_number` varchar(64) COLLATE utf8_bin NOT NULL,
  `from_rounting_number` varchar(64) COLLATE utf8_bin NOT NULL,
  `to_rounting_number` varchar(64) COLLATE utf8_bin NOT NULL,
  `to_account_number` varchar(64) COLLATE utf8_bin NOT NULL,
  `success` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE `users` (
  `UserID` bigint(20) NOT NULL,
  `Username` varchar(32) COLLATE utf8_bin NOT NULL,
  `Password` varchar(32) COLLATE utf8_bin NOT NULL,
  `FirstName` varchar(128) COLLATE utf8_bin NOT NULL,
  `LastName` varchar(128) COLLATE utf8_bin NOT NULL,
  `Phone` varchar(128) COLLATE utf8_bin NOT NULL,
  `eMail` varchar(76) COLLATE utf8_bin NOT NULL,
  `AddressStreet` varchar(256) COLLATE utf8_bin NOT NULL,
  `AddressPostalCode` varchar(30) COLLATE utf8_bin NOT NULL,
  `AddressCity` varchar(64) COLLATE utf8_bin NOT NULL,
  `AddressStateOrRegion` varchar(64) COLLATE utf8_bin NOT NULL,
  `AddressCountryCode` varchar(2) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Struttura della tabella `visitlog`
--

CREATE TABLE `visitlog` (
  `logId` bigint(20) NOT NULL,
  `AccountID` bigint(11) NOT NULL,
  `executedOn` date NOT NULL,
  `sourceIP` varchar(128) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`AccountID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indici per le tabelle `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`TransactionId`),
  ADD KEY `accountID` (`accountID`);

--
-- Indici per le tabelle `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `eMail` (`eMail`);

--
-- Indici per le tabelle `visitlog`
--
ALTER TABLE `visitlog`
  ADD PRIMARY KEY (`logId`),
  ADD KEY `AccountID` (`AccountID`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `users`
--
ALTER TABLE `users`
  MODIFY `UserID` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Limiti per la tabella `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `accounts` (`UserID`);

--
-- Limiti per la tabella `visitlog`
--
ALTER TABLE `visitlog`
  ADD CONSTRAINT `visitlog_ibfk_1` FOREIGN KEY (`AccountID`) REFERENCES `accounts` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
