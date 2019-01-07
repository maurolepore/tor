#' Read multiple files from a directory into a list.
#'
#' These functions wrap the most common special cases of [list_any()].
#'
#' @inheritParams list_any
#' @inheritParams utils::read.table
#' @param ... Arguments passed to [utils::read.table()].
#'
#' @return A list.
#'
#' @examples
#' (rds <- tor_example("rds"))
#' dir(rds)
#'
#' list_rds(rds)
#'
#' (tsv <- tor_example("tsv"))
#' dir(tsv)
#'
#' list_tsv(tsv)
#'
#' (mixed <- tor_example("mixed"))
#' dir(mixed)
#'
#' list_rdata(mixed)
#'
#' list_csv(mixed)
#'
#' list_rdata(mixed, regexp = "[.]RData", ignore.case = FALSE)
#' @family general functions to import data
#' @export
list_rds <- function(path = ".",
                     regexp = "[.]rds$",
                     ignore.case = TRUE,
                     invert = FALSE) {
  list_any(
    path,
    function(x) base::readRDS(x),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )
}

#' @rdname list_rds
#' @export
list_rdata <- function(path = ".",
                       regexp = "[.]rdata$|[.]rda$",
                       ignore.case = TRUE,
                       invert = FALSE) {
  list_any(
    path,
    function(x) get(load(x)),
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert
  )
}

#' @rdname list_rds
#' @export
list_csv <- function(path = ".",
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
                     ...) {
  list_any(
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
}

#' @rdname list_rds
#' @export
list_tsv <- function(path = ".",
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
                     ...) {
  list_any(
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
}
