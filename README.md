
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
#> Downloading GitHub repo s-Nick-s/traveltimeR@HEAD
#> R6   (2.5.0 -> 2.5.1) [CRAN]
#> mime (0.10  -> 0.11 ) [CRAN]
#> curl (4.3.1 -> 4.3.2) [CRAN]
#> Installing 3 packages: R6, mime, curl
#> Installing packages into 'C:/Users/Nick/AppData/Local/Temp/Rtmps1cgmX/temp_libpath24a0586b7711'
#> (as 'lib' is unspecified)
#> package 'R6' successfully unpacked and MD5 sums checked
#> package 'mime' successfully unpacked and MD5 sums checked
#> package 'curl' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\Nick\AppData\Local\Temp\Rtmpodhaqm\downloaded_packages
#>          checking for file 'C:\Users\Nick\AppData\Local\Temp\Rtmpodhaqm\remotes5a44eef736c\s-Nick-s-traveltimeR-e374a2f/DESCRIPTION' ...  v  checking for file 'C:\Users\Nick\AppData\Local\Temp\Rtmpodhaqm\remotes5a44eef736c\s-Nick-s-traveltimeR-e374a2f/DESCRIPTION'
#>       -  preparing 'traveltimeR':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   v  checking DESCRIPTION meta-information
#>       -  checking for LF line-endings in source and make files and shell scripts
#>   -  checking for empty or unneeded directories
#>      Omitted 'LazyData' from DESCRIPTION
#>       -  building 'traveltimeR_0.0.0.9000.tar.gz'
#>      
#> 
#> Installing package into 'C:/Users/Nick/AppData/Local/Temp/Rtmps1cgmX/temp_libpath24a0586b7711'
#> (as 'lib' is unspecified)
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
