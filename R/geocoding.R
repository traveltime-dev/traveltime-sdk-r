#' Geocoding (Search)
#'
#' Match a query string to geographic coordinates.
#'
#' See \url{https://traveltime.com/docs/api/reference/geocoding-search} for details
#'
#' @param query A query to geocode. Can be an address, a postcode or a venue.
#' @param within.country Only return the results that are within the specified country.
#'  If no results are found it will return the country itself. Optional. Format:ISO 3166-1 alpha-2 or alpha-3
#' @param format.name Format the name field of the response to a well formatted, human-readable address of the location. Experimental. Optional.
#' @param format.exclude.country Exclude the country from the formatted name field (used only if format.name is equal true). Optional.
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
geocoding <- function(query, within.country = NA, format.name = NA, format.exclude.country = NA, bounds = NA) {
  queryFull <- c(query = query,
                 within.country = paste(within.country, collapse=",")[!missing(within.country)],
                 format.name = format.name,
                 format.exclude.country = format.exclude.country[!missing(format.name)],
                 bounds = paste(as.character(bounds), collapse=",")[!missing(bounds)])
                 
  traveltime_api(path = c('geocoding', 'search'), query = as.list(queryFull)[!is.na(queryFull)])
}