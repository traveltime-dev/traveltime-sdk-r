#' Geocoding (Search)
#'
#' Match a query string to geographic coordinates.
#'
#' See \url{https://traveltime.com/docs/api/reference/geocoding-search} for details
#'
#' @param query A query to geocode. Can be an address, a postcode or a venue.
#' @param within.country Only return the results that are within the specified country.
#'  If no results are found it will return the country itself. Optional. Format:ISO 3166-1 alpha-2 or alpha-3
#' @param exclude.location.types Exclude location types from results. Available values: "country". Optional.
#' @param bounds Used to limit the results to a bounding box. Expecting a character vector with four floats,
#' marking a south-east and north-west corners of a rectangle: min-latitude,min-longitude,max-latitude,max-longitude.
#' e.g. bounds for Scandinavia c(54.16243,4.04297,71.18316,31.81641). Optional.
#'
#' @return API response parsed as list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' geocoding('Parliament square')
#' }
geocoding <- function(query, within.country = NA, exclude.location.types = NA, bounds = NA) {

  queryFull <- c(query = query,
                 within.country = within.country,
                 exclude.location.types = exclude.location.types,
                 bounds = paste(as.character(bounds), collapse=",")[!missing(bounds)])

  traveltime_api(path = c('geocoding', 'search'), query = as.list(queryFull)[!is.na(queryFull)])
}


