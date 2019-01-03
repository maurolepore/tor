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
#' rdata_list(mixed)
#'
#' csv_list(mixed)
#'
#' (tsv <- tor_example("tsv"))
#' dir(tsv)
#'
#' tsv_list(tsv)
list_rds <- function(path = ".") {
  list_any(path, base::readRDS, regexp = "[.]rds$", ignore.case = TRUE)
}

#' @rdname list_rds
#' @export
rdata_list <- function(path = ".") {
  list_any(
    path,
    ~get(load(.x)),
    regexp = "[.]rdata$|[.]rda$",
    ignore.case = TRUE
  )
}

#' @rdname list_rds
#' @export
csv_list <- function(path = ".",
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
tsv_list <- function(path = ".",
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
