#' Read multiple (common) files from a directory into a list.
#'
#' These functions wrap the most common special cases of [read_with()].
#'
#' @inheritParams read_with
#' @inheritParams utils::read.table
#' @param ... Arguments passed to [utils::read.table()].
#'
#' @return A list.
#'
#' @family general functions to import data
#' @export
#'
#' @examples
#' (rds <- readwith_example("rds"))
#' dir(rds)
#'
#' rds_list(rds)
#'
#' (mixed <- readwith_example("mixed"))
#' dir(mixed)
#'
#' rdata_list(mixed)
#'
#' csv_list(mixed)
#'
#' (tsv <- readwith_example("tsv"))
#' dir(tsv)
#'
#' tsv_list(tsv)
rds_list <- function(path = ".") {
  read_with(path, base::readRDS, regexp = "[.]rds$", ignore.case = TRUE)
}

#' @rdname rds_list
#' @export
rdata_list <- function(path = ".") {
  read_with(
    path,
    ~get(load(.x)),
    regexp = "[.]rdata$|[.]rda$",
    ignore.case = TRUE
  )
}

#' @rdname rds_list
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
    read_with(
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

#' @rdname rds_list
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
    read_with(
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
