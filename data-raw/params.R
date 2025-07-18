## static package parameters

#transportation mapping to proto
protoTransport <- c(
  pt = 0,
  'driving+ferry' = 3,
  'cycling+ferry' = 6,
  'walking+ferry' = 7
)

#api base uris
apiBaseUris <- list(
  base = list(main = "https://api.traveltimeapp.com", path = c("v4")),
  proto = list(main = "http://proto.api.traveltimeapp.com", path = c("api", "v3")),
  # FIXME: proto-with-distance is not used anymore
  protoDist = list(main = "https://proto-with-distance.api.traveltimeapp.com", path = c("api", "v3"))
)

usethis::use_data(protoTransport, apiBaseUris, overwrite = TRUE, internal = TRUE)
