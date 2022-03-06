-- Create a database master key if one does not already exist, using your own password. This key is used to encrypt the credential secret in next step.
CREATE MASTER KEY --ENCRYPTION BY PASSWORD = 'P@ssw0rd12345'

-- Create a database scoped credential with Azure storage account key as the secret.
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
  IDENTITY = 'StorageAccount',
  SECRET = 'v8m61uuV+q/+/CrrjgmnUuc0NYAbyL3JGQ16Y2/dwjFit3VcdApLjghgdvglc8jmgqesdXk7Wtv/9SvMB4AJ9A==' ;

-- Create an external data source with CREDENTIAL option.
CREATE EXTERNAL DATA SOURCE MyAzureStorage
WITH
  ( LOCATION = 'wasbs://landing@dlv2tstd.blob.core.windows.net/' ,
  
    CREDENTIAL = AzureStorageCredential ,
    TYPE = HADOOP
  ) ;

CREATE EXTERNAL FILE FORMAT textdelimited
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2, 
          USE_TYPE_DEFAULT = True)
)

--CREATE EXTERNAL FILE FORMAT parquetfile
--WITH (  
--    FORMAT_TYPE = PARQUET,  
--    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
--);  

CREATE EXTERNAL TABLE [dbo].[DimCategoriaExternal]
( [CodCategoria] varchar(300) NULL,
  [Nombre] varchar(300) NULL )
WITH
(
    LOCATION='/Categoria/' ,
    DATA_SOURCE = MyAzureStorage ,
    FILE_FORMAT = textdelimited ,
    REJECT_TYPE = value ,
    REJECT_VALUE = 10,
	REJECTED_ROW_LOCATION='/REJECT_DIRECTORY/Categoria/'
) ;

CREATE TABLE [dbo].[DimCategoriaHash]
WITH (DISTRIBUTION = HASH([CodCategoria] ) )
AS SELECT * FROM
[dbo].[DimCategoriaExternal] ;

CREATE TABLE [dbo].[DimCategoriaRR]
WITH (DISTRIBUTION = round_robin )
AS SELECT * FROM
[dbo].[DimCategoriaExternal] ;

CREATE TABLE [dbo].[DimCategoriaReplicate]
WITH (DISTRIBUTION = replicate )
AS SELECT * FROM
[dbo].[DimCategoriaExternal] ;


---Consulta Tables Externas
select * from sys.tables 

CREATE TABLE dbo.producto
( producto_id int null PRIMARY KEY NONCLUSTERED NOT ENFORCED)

insert into 
dbo.producto
select  1