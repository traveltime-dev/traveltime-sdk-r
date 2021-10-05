#' Isochrones (Time Map)
#'
#' Given origin coordinates, find shapes of zones reachable within corresponding travel time.
#' Find unions/intersections between different searches
#'
#' See \url{https://traveltime.com/docs/api/reference/isochrones} for details
#'
#' @param departure_searches One or more objects created by \code{\link{make_search}}
#' @param arrival_searches One or more objects created by \code{\link{make_search}}
#' @param unions One or more objects created by \code{\link{make_union_intersect}}
#' @param intersections One or more objects created by \code{\link{make_union_intersect}}
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#'
#' dateTime <- strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ")
#'
#' departure_search1 <-
#'   make_search(id = "public transport from Trafalgar Square",
#'               departure_time = dateTime,
#'               travel_time = 900,
#'               coords = list(lat = 51.507609, lng = -0.128315),
#'               transportation = list(type = "public_transport"),
#'               properties = list('is_only_walking'))
#'
#' departure_search2 <-
#'   make_search(id = "driving from Trafalgar Square",
#'               departure_time = dateTime,
#'               travel_time = 900,
#'               coords = list(lat = 51.507609, lng = -0.128315),
#'               transportation = list(type = "driving"))
#'
#' arrival_search <-
#'   make_search(id = "public transport to Trafalgar Square",
#'               arrival_time = dateTime,
#'               travel_time = 900,
#'               coords = list(lat = 51.507609, lng = -0.128315),
#'               transportation = list(type = "public_transport"),
#'               range = list(enabled = T, width = 3600))
#'
#' union <- make_union_intersect(id = "union of driving and public transport",
#'                                search_ids = list('driving from Trafalgar Square',
#'                                                  'public transport from Trafalgar Square'))
#' intersection <- make_union_intersect(id = "intersection of driving and public transport",
#'                                search_ids = list('driving from Trafalgar Square',
#'                                                  'public transport from Trafalgar Square'))
#' result <-
#'   time_map(
#'     departure_searches = c(departure_search1, departure_search2),
#'     arrival_searches = arrival_search,
#'     unions = union,
#'     intersections = intersection
#'   )
#'}
time_map <- function(departure_searches = NULL, arrival_searches = NULL, unions = NULL, intersections = NULL) {

  if((is.null(departure_searches) && is.null(arrival_searches))) {
    stop("At least one of arrival_searches/departure_searches required!")
  }

  body <- list(
    departure_searches = departure_searches,
    arrival_searches = arrival_searches,
    unions = unions,
    intersections = intersections)

  traveltime_api(path = 'time-map', body = build_body(body))
}


