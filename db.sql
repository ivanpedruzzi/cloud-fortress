use boston;


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
  ADD CONSTRAINT accounts`transactions_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `accounts` (`UserID`);

--
-- Limiti per la tabella `visitlog`
--
ALTER TABLE `visitlog`
  ADD CONSTRAINT `visitlog_ibfk_1` FOREIGN KEY (`AccountID`) REFERENCES `accounts` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


USE `boston`;
DROP procedure IF EXISTS `createUser`;

DELIMITER $$
USE `boston`$$
CREATE PROCEDURE createUser (
  IN p_Username varchar(32),
  IN p_Password varchar(32),
  IN p_FirstName varchar(128),
  IN p_LastName varchar(128),
  IN p_Phone varchar(128),
  IN p_eMail varchar(76),
  IN p_AddressStreet varchar(256),
  IN p_AddressPostalCode varchar(30),
  IN p_AddressCity varchar(64),
  IN p_AddressStateOrRegion varchar(64),
  IN p_AddressCountryCode varchar(2)
)
BEGIN

INSERT INTO boston.users 
	(
	  Username,
	  `Password`,
	  FirstName,
	  LastName,
	  Phone,
	  eMail,
	  AddressStreet,
	  AddressPostalCode,
	  AddressCity,
	  AddressStateOrRegion,
	  AddressCountryCode
	)
 VALUES
    (
	  p_Username,
	  p_Password,
	  p_FirstName,
	  p_LastName,
	  p_Phone,
	  p_eMail,
	  p_AddressStreet,
	  p_AddressPostalCode,
	  p_AddressCity,
	  p_AddressStateOrRegion,
	  p_AddressCountryCode
    );
END
;$$

DELIMITER ;
