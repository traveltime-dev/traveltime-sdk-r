#' Time Filter (Postcodes)
#'
#' Find reachable postcodes from origin (or to destination) and get statistics about such postcodes.
#' Currently only supports United Kingdom.
#'
#' See \url{https://docs.traveltime.com/api/reference/postcode-search/} for details
#'
#' @inheritParams time_filter
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' departure_search <-
#'  make_search(id = "public transport from Trafalgar Square",
#'              departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
#'              travel_time = 1800,
#'              coords = list(lat = 51.507609, lng = -0.128315),
#'              transportation = list(type = "public_transport"),
#'              properties = list('travel_time', 'distance'))
#'
#' arrival_search <-
#'   make_search(id = "public transport to Trafalgar Square",
#'               arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
#'               travel_time = 1800,
#'               coords = list(lat = 51.507609, lng = -0.128315),
#'               transportation = list(type = "public_transport"),
#'               properties = list('travel_time', 'distance'))
#'
#' result <-
#'   time_filter_postcodes(
#'     departure_searches = departure_search,
#'     arrival_searches = arrival_search
#'   )
#'}
time_filter_postcodes <- function(departure_searches = NULL, arrival_searches = NULL) {

  if((is.null(departure_searches) && is.null(arrival_searches))) {
    stop("At least one of arrival_searches/departure_searches required!")
  }

  body <- list(
    departure_searches = departure_searches,
    arrival_searches = arrival_searches)

  traveltime_api(path = c('time-filter', 'postcodes'), body = build_body(body))
}


