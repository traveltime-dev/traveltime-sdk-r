.onLoad <- function(libname, pkgname) {
  f <- system.file("proto", package = "traveltimeR")

  # Get all proto files except RequestsCommon.proto to avoid duplicate definitions
  protoFiles <- list.files(f, pattern = "\\.proto$", full.names = TRUE)
  protoFiles <- protoFiles[!grepl("RequestsCommon\\.proto$", protoFiles)]

  # Read only these files - they'll import RequestsCommon.proto as needed
  RProtoBuf::readProtoFiles(protoFiles)
}
