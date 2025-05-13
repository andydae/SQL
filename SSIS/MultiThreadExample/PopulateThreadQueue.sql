USE [ThreadConfig]
GO

/****** Object:  Table [dbo].[ThreadQueue]    Script Date: 3/23/2023 10:09:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ThreadQueue](
	[TableId] [int] NOT NULL,
	[FullTableName] [varchar](200) NOT NULL,
	[BaseTableName] [varchar](100) NOT NULL,
	[Status] [varchar](50) NULL,
	[ThreadInstanceNumber] [smallint] NULL
) ON [PRIMARY]
GO



select * from ThreadConfig.dbo.ThreadQueue
truncate table ThreadConfig.dbo.ThreadQueue


insert into ThreadConfig.dbo.ThreadQueue
select  TOP 10
		ROW_NUMBER() OVER (ORDER BY TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME) as TableId
	   ,TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME as FullTableName
       ,TABLE_NAME as BaseTableName
	   ,NULL as Status
	   ,NULL as ThreadInstanceNumber
from INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE'