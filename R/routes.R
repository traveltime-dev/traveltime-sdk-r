#' Routes
#'
#' Returns routing information between source and destinations.
#'
#' See \url{https://traveltime.com/docs/api/reference/routes} for details
#'
#' @inheritParams time_filter
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' locations <- c(
#'   make_location(
#'     id = 'London center',
#'     coords = list(lat = 51.508930, lng = -0.131387)),
#'   make_location(
#'     id = 'Hyde Park',
#'     coords = list(lat = 51.508824, lng = -0.167093)),
#'   make_location(
#'     id = 'ZSL London Zoo',
#'     coords = list(lat = 51.536067, lng = -0.153596))
#' )
#'
#' departure_search <-
#'   make_search(id = "departure search example",
#'               departure_location_id = "London center",
#'               arrival_location_ids = list("Hyde Park", "ZSL London Zoo"),
#'               departure_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
#'               travel_time = 1800,
#'               transportation = list(type = "driving"),
#'               properties = list("travel_time", "distance", "route"))
#'
#' arrival_search <-
#'   make_search(id = "arrival  search example",
#'               arrival_location_id = "London center",
#'               departure_location_ids = list("Hyde Park", "ZSL London Zoo"),
#'               arrival_time = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
#'               travel_time = 1800,
#'               transportation = list(type = "public_transport"),
#'               properties = list('travel_time', "distance", "route", "fares"),
#'               range = list(enabled = T, width = 1800, max_results = 1))
#'
#' result <-
#'   routes(
#'     departure_searches = departure_search,
#'     arrival_searches = arrival_search,
#'     locations = locations
#'   )
#'}
routes <- function(locations, departure_searches = NULL, arrival_searches = NULL) {

  if((is.null(departure_searches) && is.null(arrival_searches))) {
    stop("At least one of arrival_searches/departure_searches required!")
  }

  body <- list(
    departure_searches = departure_searches,
    arrival_searches = arrival_searches,
    locations = locations)

  traveltime_api(path = 'routes', body = build_body(body))
}
