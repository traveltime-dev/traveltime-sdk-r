
build_body <- function(body) {

  lapply(body, function(x) {
    dt <- data.table::rbindlist(x, fill = T)
    #rbindlist fills empty lists with NULLs, but we need them as NAs
    for (nm in colnames(dt)) {
      if(is.list(dt[[nm]]))
        dt[[nm]][vapply(dt[[nm]], is.null, FUN.VALUE = logical(1))] <- NA
    }
    dt
  })

}

get_ua <- function() {
  httr::user_agent("http://github.com/s-nick-s/traveltimeR")
}

get_api_headers <- function(format = NULL) {

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

  httr::add_headers(`X-Application-Id` = id, `X-Api-Key` = key, `Accept` = format)
}

#' @importFrom utils head
traveltime_api <- function(path, body = NULL, query = NULL, format = NULL) {

  url <- httr::modify_url("https://api.traveltimeapp.com", path = c('v4', path), query = query)

  if (is.null(body)) {
    resp <- httr::GET(url = url, get_ua(), get_api_headers())
  } else {
    resp <- httr::POST(url = url, get_ua(), get_api_headers(format = format), body = body, encode = 'json')
  }

  if (httr::status_code(resp) != 200) {
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
        contentJSON = jsonlite::toJSON(parsed, auto_unbox = T, digits = 22),
        contentRaw = json
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

add_search_args <- function(...) {

  args <- list(...)
  if (is.null(names(args)) || any(names(args) == "")) {
    stop("All objects must be named!", call. = F)
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



