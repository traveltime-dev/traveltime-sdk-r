.onLoad <- function(libname, pkgname) {
  f <- system.file("proto", package = "traveltimeR")

  # Get all proto files except RequestsCommon.proto to avoid duplicate definitions (will crash otherwise)
  protoFiles <- list.files(f, pattern = "\\.proto$", full.names = TRUE)
  commonProtoPath <- file.path(f, "RequestsCommon.proto")
  protoFiles <- protoFiles[!grepl("RequestsCommon\\.proto$", protoFiles)]

  # Read only these files - they'll import RequestsCommon.proto as needed
  RProtoBuf::readProtoFiles(protoFiles)
}
