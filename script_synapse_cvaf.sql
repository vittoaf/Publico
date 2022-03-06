/****** Object:  Database [bd_cvaf]    Script Date: 18/02/2022 09:59:38 ******/
CREATE DATABASE [bd_cvaf]  (EDITION = 'DataWarehouse', SERVICE_OBJECTIVE = 'DW100c', MAXSIZE = 128 GB);
GO
/****** Object:  DatabaseScopedCredential [AzureStorageCredential]    Script Date: 18/02/2022 09:59:38 ******/
CREATE DATABASE SCOPED CREDENTIAL [AzureStorageCredential] WITH IDENTITY = N'StorageAccount'
GO
/****** Object:  DatabaseRole [xlargerc]    Script Date: 18/02/2022 09:59:38 ******/
CREATE ROLE [xlargerc]
GO
/****** Object:  DatabaseRole [staticrc80]    Script Date: 18/02/2022 09:59:39 ******/
CREATE ROLE [staticrc80]
GO
/****** Object:  DatabaseRole [staticrc70]    Script Date: 18/02/2022 09:59:39 ******/
CREATE ROLE [staticrc70]
GO
/****** Object:  DatabaseRole [staticrc60]    Script Date: 18/02/2022 09:59:39 ******/
CREATE ROLE [staticrc60]
GO
/****** Object:  DatabaseRole [staticrc50]    Script Date: 18/02/2022 09:59:40 ******/
CREATE ROLE [staticrc50]
GO
/****** Object:  DatabaseRole [staticrc40]    Script Date: 18/02/2022 09:59:40 ******/
CREATE ROLE [staticrc40]
GO
/****** Object:  DatabaseRole [staticrc30]    Script Date: 18/02/2022 09:59:40 ******/
CREATE ROLE [staticrc30]
GO
/****** Object:  DatabaseRole [staticrc20]    Script Date: 18/02/2022 09:59:41 ******/
CREATE ROLE [staticrc20]
GO
/****** Object:  DatabaseRole [staticrc10]    Script Date: 18/02/2022 09:59:41 ******/
CREATE ROLE [staticrc10]
GO
/****** Object:  DatabaseRole [mediumrc]    Script Date: 18/02/2022 09:59:41 ******/
CREATE ROLE [mediumrc]
GO
/****** Object:  DatabaseRole [largerc]    Script Date: 18/02/2022 09:59:42 ******/
CREATE ROLE [largerc]
GO
/****** Object:  DatabaseRole [db_exporter]    Script Date: 18/02/2022 09:59:42 ******/
CREATE ROLE [db_exporter]
GO
/****** Object:  Schema [sysdiag]    Script Date: 18/02/2022 09:59:44 ******/
CREATE SCHEMA [sysdiag]
GO
/****** Object:  ExternalDataSource [MyAzureStorage]    Script Date: 18/02/2022 09:59:45 ******/
CREATE EXTERNAL DATA SOURCE [MyAzureStorage] WITH (TYPE = HADOOP, LOCATION = N'wasbs://landing@dlv227021991.blob.core.windows.net/', CREDENTIAL = [AzureStorageCredential])
GO
/****** Object:  ExternalDataSource [MyAzureStorage_staging]    Script Date: 18/02/2022 09:59:45 ******/
CREATE EXTERNAL DATA SOURCE [MyAzureStorage_staging] WITH (TYPE = HADOOP, LOCATION = N'wasbs://staging@dlv227021991.blob.core.windows.net/', CREDENTIAL = [AzureStorageCredential])
GO
/****** Object:  ExternalFileFormat [parquetfile]    Script Date: 18/02/2022 09:59:46 ******/
CREATE EXTERNAL FILE FORMAT [parquetfile] WITH (FORMAT_TYPE = PARQUET, DATA_COMPRESSION = N'org.apache.hadoop.io.compress.SnappyCodec')
GO
/****** Object:  ExternalFileFormat [textdelimited]    Script Date: 18/02/2022 09:59:46 ******/
CREATE EXTERNAL FILE FORMAT [textdelimited] WITH (FORMAT_TYPE = DELIMITEDTEXT, FORMAT_OPTIONS (FIELD_TERMINATOR = N',', STRING_DELIMITER = N'"', FIRST_ROW = 2, USE_TYPE_DEFAULT = True))
GO
/****** Object:  Table [dbo].[cvaf]    Script Date: 18/02/2022 09:59:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cvaf]
(
	[Cod_Producto] [varchar](50) NULL,
	[Producto] [varchar](200) NULL,
	[Subcategoria] [varchar](100) NULL,
	[Categoria] [varchar](200) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Cod_Producto] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
/****** Object:  Table [dbo].[DimProductoExternal]    Script Date: 18/02/2022 09:59:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[DimProductoExternal]
(
	[Cod_Producto] [varchar](50) NULL,
	[Producto] [varchar](200) NULL,
	[Subcategoria] [varchar](100) NULL,
	[Categoria] [varchar](200) NULL,
	[Persona] [varchar](100) NULL
)
WITH (DATA_SOURCE = [MyAzureStorage],LOCATION = N'/',FILE_FORMAT = [textdelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 10,REJECTED_ROW_LOCATION = N'/REJECT_DIRECTORY/Categoria/')
GO
/****** Object:  Table [dbo].[DimProductoExternal2]    Script Date: 18/02/2022 09:59:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[DimProductoExternal2]
(
	[Cod_Producto] [varchar](50) NULL,
	[Producto] [varchar](200) NULL,
	[Subcategoria] [varchar](100) NULL,
	[Categoria] [varchar](200) NULL
)
WITH (DATA_SOURCE = [MyAzureStorage_staging],LOCATION = N'/DimProducto2/',FILE_FORMAT = [textdelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 10,REJECTED_ROW_LOCATION = N'/REJECT_DIRECTORY/Categoria/')
GO
