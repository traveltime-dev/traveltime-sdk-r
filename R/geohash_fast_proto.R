
#' Geohash (Fast) with Protobuf
#'
#' Returns geohash cells that are reachable from the origin within the given travel time.
#' Uses Protocol Buffers for higher performance.
#'
#' @param lat origin/destination latitude
#' @param lng origin/destination longitude
#' @param transportation One of supported transportation methods: 'pt', 'driving+ferry', 'cycling+ferry', 'walking+ferry'.
#' @param country Origin country. See \url{https://docs.traveltime.com/api/overview/supported-countries} for the list of supported countries.
#' @param travelTime Maximum journey time (in seconds).
#' @param resolution Geohash resolution level.
#' @param type Request type: 'one_to_many' or 'many_to_one'.
#' @param properties Optional list of cell property types to include in the response (e.g. 0 = MIN, 1 = MAX, 2 = MEAN).
#'
#' @return API response parsed as a list and as a raw json
#' @export
#'
#' @examples \dontrun{
#' geohash_fast_proto(
#'   lat = 51.508930,
#'   lng = -0.131387,
#'   transportation = 'driving+ferry',
#'   travelTime = 1800,
#'   country = "uk",
#'   resolution = 6
#' )
#' }
geohash_fast_proto <- function(
    lat,
    lng,
    country = c(
      "nl", "at", "uk", "be", "de", "fr", "ie", "lt", "us", "za",
      "ro", "pt", "ph", "nz", "no", "lv", "jp", "in", "id", "hu",
      "gr", "fi", "dk", "ca", "au", "sg", "ch", "es", "it", "pl",
      "se", "li", "mx", "sa", "rs", "si"
    ),
    travelTime,
    transportation = names(protoTransport),
    resolution,
    type = c("one_to_many", "many_to_one"),
    properties = NULL
) {
  transportation <- match.arg(transportation)
  country <- match.arg(country)
  type <- match.arg(type)

  transportationMsg <- RProtoBuf::new(
    com.igeolise.traveltime.rabbitmq.requests.Transportation,
    type = as.integer(protoTransport[transportation])
  )

  locationMsg <- RProtoBuf::new(
    com.igeolise.traveltime.rabbitmq.requests.Coords,
    lat = lat,
    lng = lng
  )

  if (type == "one_to_many") {
    innerRequest <- RProtoBuf::new(
      com.igeolise.traveltime.rabbitmq.requests.GeohashFastRequest.OneToMany,
      departureLocation = locationMsg,
      transportation = transportationMsg,
      arrivalTimePeriod = 0,
      travelTime = travelTime,
      resolution = resolution
    )

    msg <- RProtoBuf::new(
      com.igeolise.traveltime.rabbitmq.requests.GeohashFastRequest,
      oneToManyRequest = innerRequest
    )

    if (!is.null(properties))
      msg$oneToManyRequest$properties <- as.integer(properties)
  } else {
    innerRequest <- RProtoBuf::new(
      com.igeolise.traveltime.rabbitmq.requests.GeohashFastRequest.ManyToOne,
      arrivalLocation = locationMsg,
      transportation = transportationMsg,
      arrivalTimePeriod = 0,
      travelTime = travelTime,
      resolution = resolution
    )

    msg <- RProtoBuf::new(
      com.igeolise.traveltime.rabbitmq.requests.GeohashFastRequest,
      manyToOneRequest = innerRequest
    )

    if (!is.null(properties))
      msg$manyToOneRequest$properties <- as.integer(properties)
  }

  respMsg <- com.igeolise.traveltime.rabbitmq.responses.GeohashFastResponse

  traveltime_api(
    path = c(country, 'geohash', 'fast', transportation),
    body = msg$serialize(NULL),
    format = "application/octet-stream",
    type = "proto",
    respMsg = respMsg
  )
}
