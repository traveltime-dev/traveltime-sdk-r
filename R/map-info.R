#' Map Info
#'
#'Returns information about currently supported countries.
#'
#'See \url{https://traveltime.com/docs/api/reference/map-info} for details
#'
#' @return API response parsed as list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' map_info()
#' }
map_info <- function() {
  traveltime_api(path = 'map-info')
}
