
# Travel Time R SDK

[Travel Time](https://docs.traveltime.com/api/overview/introduction) R SDK helps users find locations by journey time rather than using ‘as the crow flies’ distance.  
Time-based searching gives users more opportunities for personalisation and delivers a more relevant search.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("traveltime-dev/traveltime-sdk-r")
```

### System requirements

`traveltimeR` uses [rprotobuf](https://github.com/eddelbuettel/rprotobuf) as a dependency. If your package installation fails, please make sure you have the system requirements covered for `rprotobuf`

#### Debian/Ubuntu
```bash
sudo apt-get install protobuf-compiler libprotobuf-dev libprotoc-dev
```

#### MacOS
```bash
brew install protobuf
```

There also exists similar commands on other distributions or operating systems.

## Authentication

In order to authenticate with Travel Time API, you will have to supply
the Application ID and API Key.

``` r
library(traveltimeR)

#store your credentials in an environment variable
Sys.setenv(TRAVELTIME_ID = "YOUR_APP_ID")
Sys.setenv(TRAVELTIME_KEY = "YOUR_APP_KEY")
```

## Usage

### [Isochrones (Time Map)](https://docs.traveltime.com/api/reference/isochrones)
Given origin coordinates, find shapes of zones reachable within corresponding travel time. Find unions/intersections between different searches.

```r
dateTime <- strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ")

departure_search <-
  make_search(id = "public transport from Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              departure_time = dateTime,
              travel_time = 900,
              transportation = list(type = "public_transport"),
              properties = list('is_only_walking'))

arrival_search <-
  make_search(id = "public transport to Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              arrival_time = dateTime,
              travel_time = 900,
              transportation = list(type = "public_transport"),
              range = list(enabled = T, width = 3600))

result <-
  time_map(
    departure_searches = departure_search,
    arrival_searches = arrival_search
  )

print(result)
```

### [Distance Matrix (Time Filter)](https://docs.traveltime.com/api/reference/distance-matrix)
Given origin and destination points filter out points that cannot be reached within specified time limit.
Find out travel times, distances and costs between an origin and up to 2,000 destination points.

Body attributes:
* locations: Locations to use. Each location requires an id and lat/lng values.
* departure_searches: Searches based on departure times. Leave departure location at no earlier than given time. You can define a maximum of 10 searches.
* arrival_searches: Searches based on arrival times. Arrive at destination location at no later than given time. You can define a maximum of 10 searches.

```r
locationsDF <- data.frame(
  id = c('London center', 'Hyde Park', 'ZSL London Zoo'),
  lat = c(51.508930, 51.508824, 51.536067),
  lng = c(-0.131387, -0.167093, -0.153596)
)
locations <- apply(locationsDF, 1, function(x)
  make_location(id = x['id'], coords = list(lat = as.numeric(x["lat"]),
                                            lng = as.numeric(x["lng"]))))
locations <- unlist(locations, recursive = F)

departure_search <-
  make_search(id = "departure search example",
              departure_location_id = "London center",
              arrival_location_ids = list("Hyde Park", "ZSL London Zoo"),
              departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              properties = list('travel_time'),
              transportation = list(type = "bus"),
              range = list(enabled = T, width = 600, max_results = 3))

arrival_search <-
  make_search(id = "arrival search example",
              arrival_location_id = "London center",
              departure_location_ids = list("Hyde Park", "ZSL London Zoo"),
              arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              properties = list('travel_time', "distance", "distance_breakdown", "fares"),
              transportation = list(type = "public_transport"),
              range = list(enabled = T, width = 600, max_results = 3))

result <-
  time_filter(
    departure_searches = departure_search,
    arrival_searches = arrival_search,
    locations = locations
  )

print(result)
```

### [Routes](https://docs.traveltime.com/api/reference/routes)
Returns routing information between source and destinations.

Body attributes:
* locations: Locations to use. Each location requires an id and lat/lng values.
* departure_searches: Searches based on departure times. Leave departure location at no earlier than given time. You can define a maximum of 10 searches.
* arrival_searches: Searches based on arrival times. Arrive at destination location at no later than given time. You can define a maximum of 10 searches.

```r
locations <- c(
  make_location(
    id = 'London center',
    coords = list(lat = 51.508930, lng = -0.131387)),
  make_location(
    id = 'Hyde Park',
    coords = list(lat = 51.508824, lng = -0.167093)),
  make_location(
    id = 'ZSL London Zoo',
    coords = list(lat = 51.536067, lng = -0.153596))
)

departure_search <-
  make_search(id = "departure search example",
              departure_location_id = "London center",
              arrival_location_ids = list("Hyde Park", "ZSL London Zoo"),
              departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              properties = list("travel_time", "distance", "route"),
              transportation = list(type = "driving"))

arrival_search <-
  make_search(id = "arrival  search example",
              arrival_location_id = "London center",
              departure_location_ids = list("Hyde Park", "ZSL London Zoo"),
              arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              properties = list('travel_time', "distance", "route", "fares"),
              transportation = list(type = "public_transport"),
              range = list(enabled = T, width = 1800, max_results = 1))

result <-
  routes(
    departure_searches = departure_search,
    arrival_searches = arrival_search,
    locations = locations
  )

print(result)
```

### [Time Filter (Fast)](https://docs.traveltime.com/api/reference/time-filter-fast)
A very fast version of `time_filter()`.
However, the request parameters are much more limited.
Currently only supports UK and Ireland.

```r
locations <-
  c(
    make_location('London center', list(lat = 51.508930, lng = -0.131387)),
    make_location('Hyde Park', list(lat = 51.508824, lng = -0.167093)),
    make_location('ZSL London Zoo', list(lat = 51.536067, lng = -0.153596))
  )

arrival_many_to_one <- 
  make_search(id = "arrive-at many-to-one search example",
              arrival_location_id = "London center",
              departure_location_ids = list("Hyde Park", "ZSL London Zoo"),
              travel_time = 1900,
              arrival_time_period = "weekday_morning",
              properties = list('travel_time', "fares"),
              transportation = list(type = "public_transport"))


arrival_one_to_many <- 
  make_search(id = "arrive-at one-to-many search example",
              departure_location_id = "London center",
              arrival_location_ids = list("Hyde Park", "ZSL London Zoo"),
              travel_time = 1900,
              properties = list('travel_time', "fares"),
              arrival_time_period = "weekday_morning",
              transportation = list(type = "public_transport"))

result <- time_filter_fast(locations, arrival_many_to_one, arrival_one_to_many)

print(result)
```

### [Time Filter Fast (Proto)](https://docs.traveltime.com/api/start/travel-time-distance-matrix-proto#)
A fast version of time filter communicating using [protocol buffers](https://github.com/protocolbuffers/protobuf).

The request parameters are much more limited and only travel time is returned. In addition, the results are only approximately correct (95% of the results are guaranteed to be within 5% of the routes returned by regular time filter).

This inflexibility comes with a benefit of faster response times (Over 5x faster compared to regular time filter) and larger limits on the amount of destination points.

Body attributes:
* departureLat: Origin point latitude.
* departureLng: Origin point longitude.
* destinationCoordinates: Destination points. Cannot be more than 200,000.
* transportation: Transportation type.
* travelTime: Time limit.
* country: Return the results that are within the specified country.

```r
time_filter_fast_proto(
  departureLat = 51.508930,
  departureLng = -0.131387,
  destinationCoordinates = data.frame(
    lat = c(51.508824, 51.536067),
    lng = c(-0.167093, -0.153596)
  ),
  transportation = 'driving+ferry',
  travelTime = 7200,
  country = "uk",
  useDistance = F
)
```

### [Time Filter (Postcode Districts)](https://docs.traveltime.com/api/reference/postcode-district-filter)
Find reachable postcodes from origin (or to destination) and get statistics about such postcodes. Currently only supports United Kingdom.

```r
departure_search <-
  make_search(id = "public transport from Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              transportation = list(type = "public_transport"),
              reachable_postcodes_threshold = 0.1,
              properties = list("coverage", "travel_time_reachable", "travel_time_all"))

arrival_search <-
  make_search(id = "public transport to Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              transportation = list(type = "public_transport"),
              reachable_postcodes_threshold = 0.1,
              properties = list("coverage", "travel_time_reachable", "travel_time_all"))

result <-
  time_filter_postcode_districts(
    departure_searches = departure_search,
    arrival_searches = arrival_search
  )

print(result)
```

### [Time Filter (Postcode Sectors)](https://docs.traveltime.com/api/reference/postcode-sector-filter)
Find sectors that have a certain coverage from origin (or to destination) and get statistics about postcodes within such sectors. Currently only supports United Kingdom.

```r
departure_search <-
  make_search(id = "public transport from Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              transportation = list(type = "public_transport"),
              reachable_postcodes_threshold = 0.1,
              properties = list("coverage", "travel_time_reachable", "travel_time_all"))

arrival_search <-
  make_search(id = "public transport to Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              transportation = list(type = "public_transport"),
              reachable_postcodes_threshold = 0.1,
              properties = list("coverage", "travel_time_reachable", "travel_time_all"))

result <-
  time_filter_postcode_sectors(
    departure_searches = departure_search,
    arrival_searches = arrival_search
  )

print(result)
```

### [Time Filter (Postcodes)](https://docs.traveltime.com/api/reference/postcode-search)
Find reachable postcodes from origin (or to destination) and get statistics about such postcodes. Currently only supports United Kingdom.

```r
departure_search <-
  make_search(id = "public transport from Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              transportation = list(type = "public_transport"),
              properties = list('travel_time', 'distance'))

arrival_search <-
  make_search(id = "public transport to Trafalgar Square",
              coords = list(lat = 51.507609, lng = -0.128315),
              arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
              travel_time = 1800,
              transportation = list(type = "public_transport"),
              properties = list('travel_time', 'distance'))

result <-
  time_filter_postcodes(
    departure_searches = departure_search,
    arrival_searches = arrival_search
  )

print(result)
```

### [Geocoding (Search)](https://docs.traveltime.com/api/reference/geocoding-search) 
Match a query string to geographic coordinates.

Function accepts the following parameters:
* `query` - A query to geocode. Can be an address, a postcode or a venue.
* `within.country` - Only return the results that are within the specified country or countries. If no results are found it will return the country itself. Optional. Format:ISO 3166-1 alpha-2 or alpha-3.
* `format.exclude.country` - Format the name field of the response to a well formatted, human-readable address of the location. Experimental. Optional.
* `format.name` - Exclude the country from the formatted name field (used only if format.name is equal true). Optional.
* `bounds` - Used to limit the results to a bounding box. Expecting a character vector with four floats, marking a south-east and north-west corners of a rectangle: min-latitude,min-longitude,max-latitude,max-longitude. e.g. bounds for Scandinavia c(54.16243,4.04297,71.18316,31.81641). Optional.

```r
geocoding('Parliament square')
```

### [Reverse Geocoding](https://docs.traveltime.com/api/reference/geocoding-reverse)
Attempt to match a latitude, longitude pair to an address.

Function accepts the following parameters:

* `lat` - Latitude of the point to reverse geocode.
* `lng` - lng Longitude of the point to reverse geocode.

```r
geocoding_reverse(lat=51.507281, lng=-0.132120)
```

### [Map Info](https://docs.traveltime.com/api/reference/map-info)
Get information about currently supported countries.

```r
map_info()
```

### [Supported Locations](https://docs.traveltime.com/api/reference/supported-locations)
Find out what points are supported by the api.

```r
locationsDF <- data.frame(
  id = c('Kaunas', 'London', 'Bangkok', 'Lisbon'),
  lat = c(54.900008, 51.506756, 13.761866, 38.721869),
  lng = c(23.957734, -0.128050, 100.544818, -9.138549)
)
locations <- apply(locationsDF, 1, function(x)
  make_location(id = x['id'], coords = list(lat = as.numeric(x["lat"]),
                                            lng = as.numeric(x["lng"]))))
supported_locations(unlist(locations, recursive = F))
```
