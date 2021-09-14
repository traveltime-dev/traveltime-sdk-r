#' Time Filter (Fast)
#'
#' A very fast version of \code{\link{time_filter}}. However, the request parameters are much more limited.
#' Currently only supports UK and Ireland.
#'
#' See \url{https://traveltime.com/docs/api/reference/time-filter-fast} for details
#'
#' @param arrival_many_to_one One or more objects created by \code{\link{make_search}}
#' @param arrival_one_to_many One or more objects created by \code{\link{make_search}}
#' @inheritParams time_filter
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' arrival_many_to_one <- make_search(id = "arrive-at many-to-one search example",
#'                                    arrival_location_id = "London center",
#'                                    departure_location_ids = list("Hyde Park", "ZSL London Zoo"),
#'                                    travel_time = 1900,
#'                                    transportation = list(type = "public_transport"),
#'                                    properties = list('travel_time', "fares"),
#'                                    arrival_time_period = "weekday_morning")
#'
#' arrival_one_to_many <- make_search(id = "arrive-at one-to-many search example",
#'                                    departure_location_id = "London center",
#'                                    arrival_location_ids = list("Hyde Park", "ZSL London Zoo"),
#'                                    travel_time = 1900,
#'                                    transportation = list(type = "public_transport"),
#'                                    properties = list('travel_time', "fares"),
#'                                    arrival_time_period = "weekday_morning")
#'
#' result <- time_filter_fast(locations, arrival_many_to_one, arrival_one_to_many)
#' }
time_filter_fast <- function(locations, arrival_many_to_one = NULL, arrival_one_to_many = NULL) {

  if((is.null(arrival_many_to_one) && is.null(arrival_one_to_many))) {
    stop("At least one of arrival_many_to_one/arrival_one_to_many required!")
  }

  bodyPrep <- build_body(
    list(
      arrival_many_to_one = arrival_many_to_one,
      arrival_one_to_many = arrival_one_to_many,
      locations = locations
    )
  )

  body <- list(
    arrival_searches = list(many_to_one = bodyPrep$arrival_many_to_one,
                            one_to_many = bodyPrep$arrival_one_to_many),
    locations = bodyPrep$locations)

  traveltime_api(path = c('time-filter', 'fast'), body = body)
}


