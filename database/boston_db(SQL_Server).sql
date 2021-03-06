USE [boston_db]
GO
/****** Object:  UserDefinedFunction [dbo].[login]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[login]
(
	@user varchar(32), 
	@psw varchar(32)
)
RETURNS bit
AS
BEGIN
	DECLARE @queryUser varchar(64);
	SET @queryUser = '';
	DECLARE @queryPsw varchar(64);
	SET @queryPsw = '';
	SELECT @queryUser = Users.Username, @queryPsw = Users.Password FROM Users;
	
	if (@user=@queryUser AND @psw=@queryPsw)
		return 1;
	return 0;
END
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[AccountID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[AccountType] [int] NOT NULL,
	[RoutingNumber] [varchar](64) NOT NULL,
	[AccountNumber] [varchar](64) NOT NULL,
	[AmountAvailable] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountID] [bigint] NOT NULL,
	[ExecutedOn] [datetime] NOT NULL,
	[OperationType] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[From_Account_Number] [varchar](64) NOT NULL,
	[From_Routing_Number] [varchar](64) NOT NULL,
	[To_Routing_Number] [varchar](64) NOT NULL,
	[To_Account_Number] [varchar](64) NOT NULL,
	[Success] [int] NOT NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](32) NOT NULL,
	[Password] [varchar](32) NOT NULL,
	[FirstName] [varchar](128) NOT NULL,
	[LastName] [varchar](128) NOT NULL,
	[Phone] [varchar](128) NOT NULL,
	[Email] [varchar](256) NOT NULL,
	[AddressStreet] [varchar](256) NOT NULL,
	[AddressPostalCode] [varchar](30) NOT NULL,
	[AddressCity] [varchar](64) NOT NULL,
	[AddressStateOrRegion] [varchar](64) NOT NULL,
	[AddressCountryCode] [varchar](2) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VisitLog]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountID] [bigint] NOT NULL,
	[ExecutedOn] [datetime] NOT NULL,
	[SourceIP] [varchar](128) NOT NULL,
 CONSTRAINT [PK_VisitLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Constraint1_Users]    Script Date: 29/05/2018 21:48:55 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Constraint1_Users] ON [dbo].[Users]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Constraint2_Users]    Script Date: 29/05/2018 21:48:55 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Constraint2_Users] ON [dbo].[Users]
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [FK_Accounts] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [FK_Accounts]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions]
GO
ALTER TABLE [dbo].[VisitLog]  WITH CHECK ADD  CONSTRAINT [FK_VisitLog] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[VisitLog] CHECK CONSTRAINT [FK_VisitLog]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [CHK_Accounts] CHECK  (([AccountType]>=(0) AND [AccountType]<=(2)))
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [CHK_Accounts]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [CHK_Transactions] CHECK  (([Success]>=(0) AND [Success]<=(1)))
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [CHK_Transactions]
GO
/****** Object:  StoredProcedure [dbo].[create_account]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[create_account]
	@userID bigint,
	@createdOn datetime,
	@accountType int,
	@routingNumber varchar(64),
	@accountNumber varchar(64),
	@amountAvailable decimal(18, 2)
AS
BEGIN
	INSERT INTO Accounts([AccountID],[UserID],[CreatedOn],[AccountType],[RoutingNumber],[AccountNumber],[AmountAvailable])
	VALUES ('',@userID, @createdOn, @accountType, @routingNumber, @accountNumber, @amountAvailable);
END
GO
/****** Object:  StoredProcedure [dbo].[create_user]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[create_user] 
	@user varchar(32),
	@psw varchar(32),
	@firstName varchar(128),
	@lastName varchar(128),
	@phone varchar(128),
	@e_mail varchar(256),
	@addressStreet varchar(256),
	@addressPostalCode varchar(30),
	@addressCity varchar(64),
	@addressStateOrRegion varchar(64),
	@addressCountryCode varchar(2)
AS
BEGIN
	INSERT INTO Users([UserID],[Username],[Password],[FirstName],[LastName],[Phone],[Email],[AddressStreet],[AddressPostalCode],[AddressCity],[AddressStateOrRegion],[AddressCountryCode])
	VALUES ('',@user,@psw,@firstName,@lastName,@phone,@e_mail,@addressStreet,@addressPostalCode,@addressCity,@addressStateOrRegion,@addressCountryCode);
END
GO
/****** Object:  StoredProcedure [dbo].[transaction]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[transaction]
	@accountID bigint,
	@executedOn datetime,
	@operationType int,
	@amount decimal(18, 2),
	@from_Account_Number varchar(64),
	@from_Routing_Number varchar(64),
	@to_Routing_Number varchar(64),
	@to_Account_Number varchar(64),
	@success int
AS
BEGIN
	INSERT INTO Transactions([TransactionID],[AccountID],[ExecutedOn],[OperationType],[Amount],[From_Account_Number],[From_Routing_Number],[To_Routing_Number],[To_Account_Number],[Success])
	VALUES ('',@accountID, @executedOn, @operationType, @amount, @from_Account_Number, @from_Routing_Number, @to_Routing_Number, @to_Account_Number, @success);
END
GO
/****** Object:  StoredProcedure [dbo].[update_user]    Script Date: 29/05/2018 21:48:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_user] 
	@user varchar(32),
	@psw varchar(32),
	@firstName varchar(128),
	@lastName varchar(128),
	@phone varchar(128),
	@e_mail varchar(256),
	@addressStreet varchar(256),
	@addressPostalCode varchar(30),
	@addressCity varchar(64),
	@addressStateOrRegion varchar(64),
	@addressCountryCode varchar(2)
AS
BEGIN
	UPDATE Users
	SET [Username] = @user,
	[Password] =  @psw,
	[FirstName] =  @firstName,
	[LastName] =  @lastName,
	[Phone] = @phone,
	[Email] = @e_mail,
	[AddressStreet] = @addressStreet,
	[AddressPostalCode] = @addressPostalCode,
	[AddressCity] = @addressCity,
	[AddressStateOrRegion] = @addressStateOrRegion,
	[AddressCountryCode] = @addressCountryCode;
END
GO
USE [master]
GO
ALTER DATABASE [boston_db] SET  READ_WRITE 
GO