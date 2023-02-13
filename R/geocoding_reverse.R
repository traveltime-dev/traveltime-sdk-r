#' Reverse Geocoding
#'
#' Attempt to match a latitude, longitude pair to an address.
#'
#' See \url{https://traveltime.com/docs/api/reference/geocoding-reverse} for details
#'
#' @param lat Latitude of the point to reverse geocode.
#' @param lng Longitude of the point to reverse geocode.
#' @inheritParams geocoding
#'
#' @return API response parsed as list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' geocoding_reverse(lat=51.507281, lng=-0.132120)
#' }
geocoding_reverse <- function(lat, lng) {

  queryFull <- c(lat = lat,
                 lng = lng)

  traveltime_api(path = c('geocoding', 'reverse'), query = as.list(queryFull)[!is.na(queryFull)])
}


