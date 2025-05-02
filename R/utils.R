
build_body <- function(body) {

  lapply(body, function(x) {
    dt <- data.table::rbindlist(x, fill = TRUE)
    #rbindlist fills empty lists with NULLs, but we need them as NAs
    for (nm in colnames(dt)) {
      if(is.list(dt[[nm]]))
        dt[[nm]][vapply(dt[[nm]], is.null, FUN.VALUE = logical(1))] <- NA
    }
    dt
  })

}

get_ua <- function() {
  httr::user_agent("Travel Time R SDK")
}

get_api_headers <- function(format = NULL, contentType = NULL) {

  id <- Sys.getenv('TRAVELTIME_ID')
  key <- Sys.getenv('TRAVELTIME_KEY')

  if (identical(id, "")) {
    stop("Please set env var TRAVELTIME_ID to your Travel Time Application Id",
         call. = FALSE)
  }
  if (identical(key, "")) {
    stop("Please set env var TRAVELTIME_KEY to your Travel Time Api Key",
         call. = FALSE)
  }

  httr::add_headers(`X-Application-Id` = id, `X-Api-Key` = key,
                    `Accept` = format, `Content-Type` = contentType)
}

get_with_default <- function(value, default) {
  if (is.null(value)) default else value
}

#' @importFrom utils head
traveltime_api <- function(path, body = NULL, query = NULL, format = NULL, type = c("base", "proto", "protoDist"), respMsg = NULL) {

  type <- match.arg(type)
  baseUri <- apiBaseUris[[type]]
  url <- httr::modify_url(baseUri$main, path = c(baseUri$path, path), query = query)

  if (is.null(body)) {
    resp <- httr::GET(url = url, get_ua(), get_api_headers())
  } else if (type == "base") {
    resp <- httr::POST(url = url, get_ua(), get_api_headers(format = format), body = body, encode = 'json')
  } else {
    resp <- httr::POST(url = url, get_ua(),
                       get_api_headers(format, format),
                       httr::authenticate(Sys.getenv('TRAVELTIME_ID'), Sys.getenv('TRAVELTIME_KEY')),
                       body = body, encode = 'raw')
  }

  if (httr::status_code(resp) != 200) {
    if (type != "base")
      parsedHeaders <- httr::headers(resp)
      # Extract specific error headers with default values
      errorCode <- get_with_default(parsedHeaders[["X-ERROR-CODE"]], "Unknown")
      errorDetails <- get_with_default(parsedHeaders[["X-ERROR-DETAILS"]], "No details provided")
      errorMessage <- get_with_default(parsedHeaders[["X-ERROR-MESSAGE"]], "No message provided")

      # Create error message
      msg <- sprintf(
        "Travel Time API proto request failed with error code: %s\nX-ERROR-CODE: %s\nX-ERROR-DETAILS: %s\nX-ERROR-MESSAGE: %s",
        httr::status_code(resp),
        errorCode,
        errorDetails,
        errorMessage
      )

      stop(msg)

    errorResponse <- httr::content(resp, "text", encoding = "UTF-8")
    parsedError <- jsonlite::fromJSON(errorResponse, simplifyVector = FALSE)
    info <- parsedError$additional_info
    stop(
      sprintf(
        "Travel Time API request failed [%s]\n%s\nError code: %s\n<%s>\n",
        httr::status_code(resp),
        parsedError$description,
        parsedError$error_code,
        parsedError$documentation_link
      ),
      head(names(info),1),
      " - ",
      head(unlist(info), 1),
      call. = FALSE
    )
  }


  if (httr::http_type(resp) == "application/json") {
    json <- httr::content(resp, "text", encoding = "UTF-8")
    parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)

    structure(
      list(
        contentParsed = parsed,
        contentJSON = jsonlite::toJSON(parsed, auto_unbox = TRUE, digits = 22),
        contentRaw = json
      ),
      class = "traveltime_api"
    )
  } else if (httr::http_type(resp) == "application/octet-stream") {
    msg <- respMsg$read(resp$content)
    structure(
      list(
        contentParsed = parse_protobuf_msg(msg),
        contentJSON = msg$toJSON(),
        contentRaw = msg$as.character()
      ),
      class = "traveltime_api"
    )
  } else {
    response <- httr::content(resp, "text", encoding = "UTF-8")

    structure(
      list(
        contentRaw = response
      ),
      class = "traveltime_api"
    )
  }
}

parse_protobuf_msg <- function(msg) {
  msl <- msg$as.list()
  moreMsgs <- sapply(msg, class) == "Message"
  msl[moreMsgs] <- lapply(msl[moreMsgs], parse_protobuf_msg)
  return(msl)
}

add_search_args <- function(...) {

  args <- list(...)
  if (is.null(names(args)) || any(names(args) == "")) {
    stop("All objects must be named!", call. = FALSE)
  }

  list_args <- vapply(args, is.list, FUN.VALUE = logical(1))

  df <- data.frame(args[names(list_args[!list_args])])

  if(length(list_args[list_args])) {
    for (nm in names(list_args[list_args])) {
      df[[nm]] <- args[nm]
    }
  }

  return(list(df))
}

encodeFixedPoints <- function(sourcePoint, targetPoints) {
  round((targetPoints - sourcePoint) * 10^5) |> as.integer()
}


