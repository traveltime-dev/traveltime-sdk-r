#' Distance Map
#'
#' Given origin coordinates, find shapes of zones reachable within corresponding travel distance.
#' Find unions/intersections between different searches
#'
#' See \url{https://docs.traveltime.com/api/reference/distance-map/} for details
#'
#' @param departure_searches One or more objects created by \code{\link{make_search}}
#' @param arrival_searches One or more objects created by \code{\link{make_search}}
#' @param unions One or more objects created by \code{\link{make_union_intersect}}
#' @param intersections One or more objects created by \code{\link{make_union_intersect}}
#' @param format distance-map response format. See \url{https://docs.traveltime.com/api/reference/distance-map#Response-Body} for details.
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#'
#' dateTime <- strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%SZ")
#'
#' departure_search <-
#'   make_search(id = "driving from Trafalgar Square",
#'               departure_time = dateTime,
#'               travel_distance = 900,
#'               coords = list(lat = 51.507609, lng = -0.128315),
#'               transportation = list(type = "driving"))
#'
#' arrival_search <-
#'   make_search(id = "driving to Trafalgar Square",
#'               arrival_time = dateTime,
#'               travel_distance = 900,
#'               coords = list(lat = 51.507609, lng = -0.128315),
#'               transportation = list(type = "driving"),
#'               range = list(enabled = TRUE, width = 3600))
#'
#' union <- make_union_intersect(id = "union of driving to and from Trafalgar Square",
#'                                search_ids = list('driving from Trafalgar Square',
#'                                                  'driving to Trafalgar Square'))
#' intersection <- make_union_intersect(id = "intersection of driving to and from Trafalgar Square",
#'                                search_ids = list('driving from Trafalgar Square',
#'                                                  'driving to Trafalgar Square'))
#' result <-
#'   distance_map(
#'     departure_searches = departure_search,
#'     arrival_searches = arrival_search,
#'     unions = union,
#'     intersections = intersection
#'   )
#'}
distance_map <- function(
  departure_searches = NULL,
  arrival_searches = NULL,
  unions = NULL,
  intersections = NULL,
  format = NULL) {

  if((is.null(departure_searches) && is.null(arrival_searches))) {
    stop("At least one of arrival_searches/departure_searches required!")
  }

  body <- list(
    departure_searches = departure_searches,
    arrival_searches = arrival_searches,
    unions = unions,
    intersections = intersections)

  traveltime_api(path = 'distance-map', body = build_body(body), format = format)
}
