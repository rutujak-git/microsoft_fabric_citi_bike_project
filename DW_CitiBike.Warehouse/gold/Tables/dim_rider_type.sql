CREATE TABLE [gold].[dim_rider_type] (

	[rider_type_key] int NOT NULL, 
	[rider_type] varchar(20) NULL
);


GO
ALTER TABLE [gold].[dim_rider_type] ADD CONSTRAINT PK_dim_rider_type primary key NONCLUSTERED ([rider_type_key]);