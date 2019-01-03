#' Read multiple (common) files from a directory into a list.
#'
#' These functions wrap the most common special cases of [list_any()].
#'
#' @inheritParams list_any
#' @inheritParams utils::read.table
#' @param ... Arguments passed to [utils::read.table()].
#'
#' @return A list.
#'
#' @family general functions to import data
#' @export
#'
#' @examples
#' (rds <- tor_example("rds"))
#' dir(rds)
#'
#' list_rds(rds)
#'
#' (mixed <- tor_example("mixed"))
#' dir(mixed)
#'
#' list_rdata(mixed)
#'
#' list_csv(mixed)
#'
#' (tsv <- tor_example("tsv"))
#' dir(tsv)
#'
#' list_tsv(tsv)
list_rds <- function(path = ".", regexp = "[.]rds$", invert = FALSE) {
  list_any(
    path,
    base::readRDS,
    regexp = regexp,
    ignore.case = TRUE,
    invert = invert
  )
}

#' @rdname list_rds
#' @export
list_rdata <- function(path = ".") {
  list_any(
    path,
    ~get(load(.x)),
    regexp = "[.]rdata$|[.]rda$",
    ignore.case = TRUE
  )
}

#' @rdname list_rds
#' @export
list_csv <- function(path = ".",
                      header = TRUE,
                      sep = ",",
                      quote = "\"",
                      dec = ".",
                      fill = TRUE,
                      comment.char = "",
                      stringsAsFactors = FALSE,
                      na.strings = c("", "NA"),
                      ...) {
    list_any(
      path,
      ~utils::read.csv(
        file = .x,
        header = header,
        sep = sep,
        quote = quote,
        dec = dec,
        fill = fill,
        comment.char = comment.char,
        stringsAsFactors = stringsAsFactors,
        na.strings = na.strings
      ),
      regexp = "[.]csv$",
      ignore.case = TRUE,
      ...
    )
}

#' @rdname list_rds
#' @export
list_tsv <- function(path = ".",
                      header = TRUE,
                      sep = "\t",
                      quote = "\"",
                      dec = ".",
                      fill = TRUE,
                      comment.char = "",
                      stringsAsFactors = FALSE,
                      na.strings = c("", "NA"),
                      ...) {
    list_any(
      path,
      ~utils::read.csv(
        file = .x,
        header = header,
        sep = sep,
        quote = quote,
        dec = dec,
        fill = fill,
        comment.char = comment.char,
        stringsAsFactors = stringsAsFactors,
        na.strings = na.strings
      ),
      regexp = "[.]tsv$",
      ignore.case = TRUE,
      ...
    )
}
