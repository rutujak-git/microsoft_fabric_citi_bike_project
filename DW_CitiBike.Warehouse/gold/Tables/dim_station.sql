CREATE TABLE [gold].[dim_station] (

	[station_key] int NOT NULL, 
	[station_name] varchar(200) NULL, 
	[latitude] float NULL, 
	[longitude] float NULL
);


GO
ALTER TABLE [gold].[dim_station] ADD CONSTRAINT PK_dim_station primary key NONCLUSTERED ([station_key]);