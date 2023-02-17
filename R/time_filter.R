#' Distance Matrix (Time Filter)
#'
#' Given origin and destination points filter out points that cannot be reached within specified time limit.
#' Find out travel times, distances and costs between an origin and up to 2,000 destination points.
#'
#' See \url{https://docs.traveltime.com/api/reference/travel-time-distance-matrix/} for details
#'
#' @param locations One or more objects created by \code{\link{make_location}}
#' @inheritParams time_map
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' locationsDF <- data.frame(
#'   id = c('London center', 'Hyde Park', 'ZSL London Zoo'),
#'   lat = c(51.508930, 51.508824, 51.536067),
#'   lng = c(-0.131387, -0.167093, -0.153596)
#'   )
#' locations <- apply(locationsDF, 1, function(x)
#'   make_location(id = x['id'], coords = list(lat = as.numeric(x["lat"]),
#'                                             lng = as.numeric(x["lng"]))))
#' locations <- unlist(locations, recursive = F)
#'
#' departure_search <-
#'   make_search(id = "forward search example",
#'               departure_location_id = "London center",
#'               arrival_location_ids = list("Hyde Park", "ZSL London Zoo"),
#'               departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
#'               travel_time = 1800,
#'               transportation = list(type = "bus"),
#'               properties = list('travel_time'),
#'               range = list(enabled = T, width = 600, max_results = 3))
#'
#' arrival_search <-
#'   make_search(id = "backward search example",
#'               arrival_location_id = "London center",
#'               departure_location_ids = list("Hyde Park", "ZSL London Zoo"),
#'               arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
#'               travel_time = 1800,
#'               transportation = list(type = "public_transport"),
#'               properties = list('travel_time', "distance", "distance_breakdown", "fares"),
#'               range = list(enabled = T, width = 600, max_results = 3))
#'
#' result <-
#'   time_filter(
#'     departure_searches = departure_search,
#'     arrival_searches = arrival_search,
#'     locations = locations
#'   )
#'}
time_filter <- function(locations, departure_searches = NULL, arrival_searches = NULL) {

  if((is.null(departure_searches) && is.null(arrival_searches))) {
    stop("At least one of arrival_searches/departure_searches required!")
  }

  body <- list(
    departure_searches = departure_searches,
    arrival_searches = arrival_searches,
    locations = locations)

  traveltime_api(path = 'time-filter', body = build_body(body))
}


