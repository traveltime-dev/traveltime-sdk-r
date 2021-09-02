
<!-- README.md is generated from README.Rmd. Please edit that file -->

# R Interface to Travel Time

<!-- badges: start -->
<!-- badges: end -->

traveltimeR is a R wrapper for Travel Time API
(<https://traveltime.com/>). TravelTime API helps users find locations
by journey time rather than using ‘as the crow flies’ distance.
Time-based searching gives users more opportunities for personalisation
and delivers a more relevant search.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("s-Nick-s/traveltimeR")
```

## Authentication

In order to authenticate with Travel Time API, you will have to supply
the Application Id and Api Key.

``` r
library(traveltimeR)

#store your credentials in an environment variable
Sys.setenv(TRAVELTIME_ID = "YOUR_API_ID")
Sys.setenv(TRAVELTIME_KEY = "YOUR_API_KEY")
```

## Usage

Get [Isochrones](https://traveltime.com/docs/api/reference/isochrones):

``` r
departure_search <-
  make_search(id = "public transport from Trafalgar Square",
              departure_time = "2021-09-01T08:00:00Z",
              travel_time = 900,
              coords = list(lat = 51.507609, lng = -0.128315),
              transportation = list(type = "public_transport"),
              properties = list('is_only_walking'))

result <- time_map(departure_searches = departure_search)
```

Check function documentation for more examples.
