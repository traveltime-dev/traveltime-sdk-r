#' Isochrones (Time Map) Fast
#'
#' A very fast version of Isochrone API. However, the request parameters are much more limited.
#'
#' See \url{https://traveltime.com/docs/api/reference/isochrones-fast} for details
#'
#' @param arrival_many_to_one One or more objects created by \code{\link{make_search}}
#' @param arrival_one_to_many One or more objects created by \code{\link{make_search}}
#' @param format time-map response format. See \url{https://docs.traveltime.com/api/reference/isochrones-fast#Response-Body} for details.
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#'
#'arrival_search = {
#'  id: "public transport to Trafalgar Square",
#'  coords: {
#'    lat: 51.506756,
#'    lng: -0.128050
#'  },
#'  transportation: { type: "public_transport" },
#'  arrival_time_period: 'weekday_morning',
#'  travel_time: 1800,
#'}
#'
#'response = client.time_map_fast(
#'  arrival_searches: {
#'    one_to_many: [arrival_search]
#'  },
#')
#'}
time_map_fast <- function(
    arrival_many_to_one = NULL,
    arrival_one_to_many = NULL,
    format = NULL) {

  if((is.null(arrival_many_to_one) && is.null(arrival_one_to_many))) {
    stop("At least one of arrival_many_to_one/arrival_one_to_many required!")
  }

  bodyPrep <- build_body(
    list(
      arrival_many_to_one = arrival_many_to_one,
      arrival_one_to_many = arrival_one_to_many))

  body <- list(
    arrival_searches = list(many_to_one = bodyPrep$arrival_many_to_one,
                            one_to_many = bodyPrep$arrival_one_to_many))

  traveltime_api(path = 'time-map/fast', body = body, format = format)
}
