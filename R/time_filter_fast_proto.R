
#' Time Filter (Fast) with Protobuf
#'
#' The Travel Time Matrix (Fast) endpoint is available with even higher performance through a
#' version using Protocol Buffers.
#' The endpoint takes as inputs a single origin location, multiple destination locations, a mode of transport,
#' and a maximum travel time.
#' The endpoint returns the travel times to each destination location, so long as it is within the maximum travel time.
#'
#' See \url{https://docs.traveltime.com/api/start/travel-time-distance-matrix-proto} for details
#'
#' @param departureLat origin latitude
#' @param departureLng origin longitude
#' @param transportation One of supported transportation methods: 'pt', 'driving+ferry', 'cycling+ferry', 'walking+ferry'.
#' @param country Origin country. Only UK and Ireland are supported.
#' @param travelTime Maximum journey time (in seconds).
#' @param destinationCoordinates data.frame with pairs of coordinates. Coordinates columns must be named 'lat' and 'lng'
#' @param useDistance return distance information
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' time_filter_fast_proto(
#' departureLat = 51.508930,
#' departureLng = -0.131387,
#' destinationCoordinates = data.frame(
#'   lat = c(51.508824, 51.536067),
#'   lng = c(-0.167093, -0.153596)
#' ),
#' transportation = 'driving+ferry',
#' travelTime = 7200,
#' country = "uk",
#' useDistance = FALSE
#' )
#' }
time_filter_fast_proto <- function(departureLat, departureLng,
                                   country = c("uk", "ireland"), travelTime,
                                   destinationCoordinates, transportation = names(protoTransport), useDistance = FALSE) {

  transportation <- match.arg(transportation)
  country <- match.arg(country)

  if (!is.data.frame(destinationCoordinates) ||
     !all(c("lat", "lng") %in% names(destinationCoordinates))) {
    stop("destinationCoordinates must be a data.frame with lat/lng columns!")
  }

  transportationMsg = RProtoBuf::new(com.igeolise.traveltime.rabbitmq.requests.Transportation,
                                  type = as.integer(protoTransport[transportation]))

  departureLocationMsg = RProtoBuf::new(com.igeolise.traveltime.rabbitmq.requests.Coords,
                                     lat = departureLat,
                                     lng = departureLng)

  lats = encodeFixedPoints(departureLat, destinationCoordinates$lat)
  lngs = encodeFixedPoints(departureLng, destinationCoordinates$lng)
  locationDeltas = c(matrix(c(lats, lngs), nrow = 2, byrow = TRUE))

  oneToManyRequest = RProtoBuf::new(com.igeolise.traveltime.rabbitmq.requests.TimeFilterFastRequest.OneToMany,
                                    departureLocation = departureLocationMsg,
                                    locationDeltas = locationDeltas,
                                    transportation = transportationMsg,
                                    arrivalTimePeriod = 0,
                                    travelTime = travelTime
  )

  msg = RProtoBuf::new(com.igeolise.traveltime.rabbitmq.requests.TimeFilterFastRequest,
                            oneToManyRequest = oneToManyRequest)

  respMsg = com.igeolise.traveltime.rabbitmq.responses.TimeFilterFastResponse

  if (useDistance)
    msg$oneToManyRequest$properties = 1

  traveltime_api(path = c(country, 'time-filter', 'fast', transportation),
                 body = msg$serialize(NULL),
                 format = "application/octet-stream",
                 type = ifelse(useDistance, "protoDist", "proto"),
                 respMsg = respMsg)
}


