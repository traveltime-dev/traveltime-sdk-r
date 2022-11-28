.onLoad <- function(libname, pkgname) {
  f <- system.file("proto", package = "traveltimeR")
  RProtoBuf::readProtoFiles(dir = f)
}
