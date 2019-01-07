#' Load each element of a list into an environment.
#'
#' @inheritParams list_rds
#' @inheritParams base::list2env
#'
#' @return `invisible(path)`.
#'
#' @examples
#' # All functions default to load from the working directory.
#' rm(list = ls())
#' ls()
#'
#' load_csv()
#'
#' # Each dataframe is now available in the global environment
#' ls()
#' csv1
#'
#' #You may load from a `path`.
#' rm(list = ls())
#' ls()
#'
#' (path_mixed <- tor_example("mixed"))
#' dir(path_mixed)
#'
#' load_rdata(path_mixed)
#'
#' ls()
#' rda
#' @export
load_rds <- function(path = ".",
                     regexp = "[.]rds$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     envir = .GlobalEnv) {
  lst <- list_any(
    path,
    function(x) base::readRDS(x),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )

  list2env(lst, envir = envir)
  invisible(path)
}

#' @rdname load_rds
#' @export
load_rdata <- function(path = ".",
                       regexp = "[.]rdata$|[.]rda$",
                       ignore.case = TRUE,
                       invert = FALSE,
                       envir = .GlobalEnv) {
  lst <- list_any(
    path,
    function(x) get(load(x)),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )

  list2env(lst, envir = envir)
  invisible(path)
}

#' @rdname load_rds
#' @export
load_csv <- function(path = ".",
                     regexp = "[.]csv$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     header = TRUE,
                     sep = ",",
                     quote = "\"",
                     dec = ".",
                     fill = TRUE,
                     comment.char = "",
                     stringsAsFactors = FALSE,
                     na.strings = c("", "NA"),
                     envir = .GlobalEnv,
                     ...) {
  lst <- list_any(
    path,
    # TODO: Use function(x) to more obviously show what's going on
    function(x) utils::read.csv(
        file = x,
        header = header,
        sep = sep,
        quote = quote,
        dec = dec,
        fill = fill,
        comment.char = comment.char,
        stringsAsFactors = stringsAsFactors,
        na.strings = na.strings
      ),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )

  list2env(lst, envir = envir)
  invisible(path)
}

#' @rdname load_rds
#' @export
load_tsv <- function(path = ".",
                     regexp = "[.]tsv$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     header = TRUE,
                     sep = "\t",
                     quote = "\"",
                     dec = ".",
                     fill = TRUE,
                     comment.char = "",
                     stringsAsFactors = FALSE,
                     na.strings = c("", "NA"),
                     envir = .GlobalEnv,
                     ...) {
  lst <- list_any(
    path,
    function(x) utils::read.csv(
        file = x,
        header = header,
        sep = sep,
        quote = quote,
        dec = dec,
        fill = fill,
        comment.char = comment.char,
        stringsAsFactors = stringsAsFactors,
        na.strings = na.strings
      ),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )

  list2env(lst, envir = envir)
  invisible(path)
}
