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
#'
#' @return API response parsed as list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' geocoding('Parliament square')
#' }
geocoding <- function(query, within.country = NA, exclude.location.types = NA) {

  queryFull <- c(query = query,
                 within.country = within.country,
                 exclude.location.types = exclude.location.types)

  traveltime_api(path = c('geocoding', 'search'), query = as.list(queryFull)[!is.na(queryFull)])
}


