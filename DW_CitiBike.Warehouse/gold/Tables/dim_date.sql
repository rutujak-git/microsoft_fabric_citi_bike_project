CREATE TABLE [gold].[dim_date] (

	[date_key] date NOT NULL, 
	[year] int NULL, 
	[month] int NULL, 
	[month_name] varchar(20) NULL, 
	[day] int NULL, 
	[quarter] int NULL, 
	[day_name] varchar(20) NULL, 
	[is_weekend] int NULL
);


GO
ALTER TABLE [gold].[dim_date] ADD CONSTRAINT PK_dim_date primary key NONCLUSTERED ([date_key]);