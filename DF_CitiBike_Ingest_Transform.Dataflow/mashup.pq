[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared #"202606-citibike-tripdata_1 csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "citibike_raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "202606-citibike-tripdata_1.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ride_id", type text}, {"rideable_type", type text}, {"started_at", type datetime}, {"ended_at", type datetime}, {"start_station_name", type text}, {"start_station_id", type number}, {"end_station_name", type text}, {"end_station_id", type number}, {"start_lat", type number}, {"start_lng", type number}, {"end_lat", type number}, {"end_lng", type number}, {"member_casual", type text}})
in
  #"Changed column type";
shared #"202606-citibike-tripdata_2 csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "citibike_raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "202606-citibike-tripdata_2.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ride_id", type text}, {"rideable_type", type text}, {"started_at", type datetime}, {"ended_at", type datetime}, {"start_station_name", type text}, {"start_station_id", type number}, {"end_station_name", type text}, {"end_station_id", type number}, {"start_lat", type number}, {"start_lng", type number}, {"end_lat", type number}, {"end_lng", type number}, {"member_casual", type text}})
in
  #"Changed column type";
shared #"202606-citibike-tripdata_3 csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "citibike_raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "202606-citibike-tripdata_3.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ride_id", type text}, {"rideable_type", type text}, {"started_at", type datetime}, {"ended_at", type datetime}, {"start_station_name", type text}, {"start_station_id", type number}, {"end_station_name", type text}, {"end_station_id", type number}, {"start_lat", type number}, {"start_lng", type number}, {"end_lat", type number}, {"end_lng", type number}, {"member_casual", type text}})
in
  #"Changed column type";
shared #"202606-citibike-tripdata_4 csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "citibike_raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "202606-citibike-tripdata_4.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ride_id", type text}, {"rideable_type", type text}, {"started_at", type datetime}, {"ended_at", type datetime}, {"start_station_name", type text}, {"start_station_id", type number}, {"end_station_name", type text}, {"end_station_id", type number}, {"start_lat", type number}, {"start_lng", type number}, {"end_lat", type number}, {"end_lng", type number}, {"member_casual", type text}})
in
  #"Changed column type";
shared #"202606-citibike-tripdata_5 csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "citibike_raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "202606-citibike-tripdata_5.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ride_id", type text}, {"rideable_type", type text}, {"started_at", type datetime}, {"ended_at", type datetime}, {"start_station_name", type text}, {"start_station_id", type number}, {"end_station_name", type text}, {"end_station_id", type number}, {"start_lat", type number}, {"start_lng", type number}, {"end_lat", type number}, {"end_lng", type number}, {"member_casual", type text}})
in
  #"Changed column type";
shared #"202606-citibike-tripdata_6 csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "citibike_raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "202606-citibike-tripdata_6.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 13, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ride_id", type text}, {"rideable_type", type text}, {"started_at", type datetime}, {"ended_at", type datetime}, {"start_station_name", type text}, {"start_station_id", type number}, {"end_station_name", type text}, {"end_station_id", type text}, {"start_lat", type number}, {"start_lng", type number}, {"end_lat", type number}, {"end_lng", type number}, {"member_casual", type text}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Append_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Append = let
  Source = Table.Combine({#"202606-citibike-tripdata_1 csv", #"202606-citibike-tripdata_2 csv", #"202606-citibike-tripdata_3 csv", #"202606-citibike-tripdata_4 csv", #"202606-citibike-tripdata_5 csv", #"202606-citibike-tripdata_6 csv"}),
  #"Choose columns" = Table.SelectColumns(Source, {"ride_id", "rideable_type", "started_at", "ended_at", "start_station_name", "end_station_name", "start_lat", "start_lng", "end_lat", "end_lng", "member_casual"}),
  #"Added custom" = Table.TransformColumnTypes(Table.AddColumn(#"Choose columns", "trip_duration_minutes", each Number.Round(Duration.TotalMinutes([ended_at] - [started_at]), 2)), {{"trip_duration_minutes", type number}}),
  #"Capitalized each word" = Table.TransformColumns(#"Added custom", {{"start_station_name", each Text.Proper(_), type nullable text}, {"end_station_name", each Text.Proper(_), type nullable text}}),
  #"Filtered rows" = Table.SelectRows(#"Capitalized each word", each [ride_id] <> null and [ride_id] <> ""),
  #"Duplicated column" = Table.DuplicateColumn(#"Filtered rows", "started_at", "started_at - Copy"),
  #"Renamed columns" = Table.RenameColumns(#"Duplicated column", {{"started_at - Copy", "start_date"}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Renamed columns", {{"start_date", type date}}),
  #"Duplicated column 1" = Table.DuplicateColumn(#"Changed column type", "ended_at", "ended_at - Copy"),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Duplicated column 1", {{"ended_at - Copy", type date}}),
  #"Renamed columns 1" = Table.RenameColumns(#"Changed column type 1", {{"ended_at - Copy", "end_date"}})
in
  #"Renamed columns 1";
shared Append_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "57f058e2-89c3-4489-a7b7-84375063b53b"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "de42d368-a6f8-4294-9a0c-44d4b5f6585e"]}[Data],
  Navigation_3 = Navigation_2{[Id = "bronze", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "bronze_citibike_trips", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
