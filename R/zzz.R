.onLoad <- function(libname, pkgname) {
  f <- system.file("proto", package = "traveltimeR")

  # RProtoBuf cannot handle multiple files importing the same proto file.
  # Work around by merging all request protos into a single temp file
  # so RequestsCommon.proto is only imported once.
  tmpDir <- file.path(tempdir(), "traveltimeR_proto")
  dir.create(tmpDir, showWarnings = FALSE)

  file.copy(file.path(f, "RequestsCommon.proto"), tmpDir, overwrite = TRUE)

  requestFiles <- list.files(f, pattern = "Request\\.proto$", full.names = TRUE)
  requestFiles <- requestFiles[!grepl("RequestsCommon\\.proto$", requestFiles)]

  header <- paste(
    'syntax = "proto3";',
    'package com.igeolise.traveltime.rabbitmq.requests;',
    'import "RequestsCommon.proto";',
    sep = "\n"
  )
  bodies <- vapply(requestFiles, function(rf) {
    lines <- readLines(rf)
    lines <- lines[!grepl("^(syntax|package|import)", lines)]
    paste(lines, collapse = "\n")
  }, character(1))

  writeLines(c(header, bodies), file.path(tmpDir, "CombinedRequests.proto"))
  RProtoBuf::readProtoFiles(file.path(tmpDir, "CombinedRequests.proto"))

  responseFiles <- list.files(f, pattern = "Response\\.proto$", full.names = TRUE)
  RProtoBuf::readProtoFiles(responseFiles)
}
