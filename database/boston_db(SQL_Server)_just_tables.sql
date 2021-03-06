USE [boston_db]
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 10/05/2018 23:15:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[AccountID] [bigint] NOT NULL,
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
/****** Object:  Table [dbo].[Transactions]    Script Date: 10/05/2018 23:15:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionID] [bigint] NOT NULL,
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
/****** Object:  Table [dbo].[Users]    Script Date: 10/05/2018 23:15:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [bigint] NOT NULL,
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
/****** Object:  Table [dbo].[VisitLog]    Script Date: 10/05/2018 23:15:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitLog](
	[LogID] [bigint] NOT NULL,
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
/****** Object:  Index [Constraint1_Users]    Script Date: 10/05/2018 23:15:43 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Constraint1_Users] ON [dbo].[Users]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Constraint2_Users]    Script Date: 10/05/2018 23:15:43 ******/
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
USE [master]
GO
ALTER DATABASE [boston_db] SET  READ_WRITE 
GO
