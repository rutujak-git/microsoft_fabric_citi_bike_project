CREATE TABLE [gold].[fact_trip] (

	[ride_id] varchar(50) NOT NULL, 
	[rideable_type] varchar(30) NULL, 
	[start_station_key] int NULL, 
	[end_station_key] int NULL, 
	[rider_type_key] int NULL, 
	[trip_date] date NULL, 
	[start_hour] int NULL, 
	[trip_duration_minutes] float NULL, 
	[duration_category] varchar(10) NULL
);


GO
ALTER TABLE [gold].[fact_trip] ADD CONSTRAINT PK_fact_trip primary key NONCLUSTERED ([ride_id]);
GO
ALTER TABLE [gold].[fact_trip] ADD CONSTRAINT FK_fact_date FOREIGN KEY ([trip_date]) REFERENCES [gold].[dim_date]([date_key]);
GO
ALTER TABLE [gold].[fact_trip] ADD CONSTRAINT FK_fact_end_station FOREIGN KEY ([end_station_key]) REFERENCES [gold].[dim_station]([station_key]);
GO
ALTER TABLE [gold].[fact_trip] ADD CONSTRAINT FK_fact_rider_type FOREIGN KEY ([rider_type_key]) REFERENCES [gold].[dim_rider_type]([rider_type_key]);
GO
ALTER TABLE [gold].[fact_trip] ADD CONSTRAINT FK_fact_start_station FOREIGN KEY ([start_station_key]) REFERENCES [gold].[dim_station]([station_key]);