#' Search objects constructor
#'
#' Searches based on departure or arrival times.
#' Departure: Leave departure location at no earlier than given time. You can define a maximum of 10 searches
#' Arrival: Arrive at destination location at no later than given time. You can define a maximum of 10 searches
#'
#' @param id Used to identify this specific search in the results array. MUST be unique among all searches.
#' @param travel_time Travel time in seconds. Maximum value is 14400 (4 hours)
#' @param coords The coordinates of the location we should start the search from. Must use this format: list(lat = 0, lng = 0)
#' @param departure_time Date in extended ISO-8601 format
#' @param arrival_time Date in extended ISO-8601 format
#' @param transportation Transportation mode and related parameters.
#' @param ... Any additional parameters to pass. Some functions require extra parameters to work. Check their API documentation for details.
#'
#' @return A data.frame wrapped in a list.
#'  It is constructed in a way that allows jsonlite::toJSON to correctly transform it into a valid request body
#' @export
#' @seealso See \code{\link{time_map}} for usage examples
#'
make_search <- function(id, travel_time = NA, coords = NA, departure_time = NA, arrival_time = NA,
                                  transportation = list(type = 'driving'), ...) {

# skip coords check for time_filter endpoints
  if (!'departure_location_id' %in% names(list(...)) &&
      !'arrival_location_id' %in% names(list(...)) &&
      !'reachable_postcodes_threshold' %in% names(list(...))) {
    if(check_coords_for_error(coords)) stop("coords must be named lat/lng list!")
  }

  #skip this check for time_filter_fast
  if (!'arrival_time_period' %in% names(list(...)) &&
      ((is.na(departure_time) && is.na(arrival_time)) ||
       (!is.na(departure_time) && !is.na(arrival_time)))) {
    stop("Specify one of arrival_time/departure_time!")
  }


  add_search_args(
    id = id,
    coords = coords,
    travel_time = travel_time,
    departure_time = departure_time,
    arrival_time = arrival_time,
    transportation = transportation,
    coords = coords,
    ...
  )
}

#' Set objects constructor
#'
#' Allows you to define unions or intersections of shapes that are results of previously defined searches.
#' You can define a maximum of 10 unions/intersections
#'
#' See \url{https://docs.traveltime.com/api/reference/isochrones} for details
#'
#' @param id Used to identify this specific search in the results array. MUST be unique among all searches.
#' @param search_ids An unnamed list of search ids which results will formulate this union.
#'
#' @return A data.frame wrapped in a list.
#'  It is constructed in a way that allows jsonlite::toJSON to correctly transform it into a valid request body
#' @export
#'
#' @seealso See \code{\link{time_map}} for usage examples
make_union_intersect <- function(id, search_ids){

  if(!is.list(search_ids) || !is.null(names(search_ids)))
    stop('search_ids must be an unnamed list!')

  df <- data.frame(id = id)
  df$search_ids <- list(search_ids)

  list(df)
}

#' Location objects constructor
#'
#' Define your locations to use later in departure_searches or arrival_searches.
#'
#' See \url{https://docs.traveltime.com/api/reference/distance-matrix} for details
#'
#' @param id You will have to reference this id in your searches.
#' It will also be used in the response body. MUST be unique among all locations.
#' @param coords Location coordinates. Must use this format: list(lat = 0, lng = 0)
#'
#' @return A data.frame wrapped in a list.
#'  It is constructed in a way that allows jsonlite::toJSON to correctly transform it into a valid request body
#' @export
#'
#' @seealso See \code{\link{time_filter}} for usage examples
make_location <- function(id, coords) {

  if(check_coords_for_error(coords)) stop("coords must be named lat/lng list!")

  add_search_args(id = id, coords = coords)
}

#' Validates location coordinates
#'
#' @param coords Location coordinates. Must use this format: list(lat = 0, lng = 0)
#'
#' @return TRUE if coords are valid, FALSE otherwise
#' @export
check_coords_for_error <- function(coords){
    is_coords_broken <- (
        !is.list(coords) |
            is.null(names(coords)) |
            anyNA(coords) |
            !all(c('lat', 'lng') %in% names(coords)))

    return(is_coords_broken)
}
