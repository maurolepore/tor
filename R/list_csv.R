#' Import multiple common files from a directory into a list.
#'
#' These functions wrap common use-cases of [list_any()].
#'
#' @inheritParams list_any
#' @inheritParams readr::read_delim
#' @param ... Arguments passed to `readr::read_csv()` or `readr::read_tsv()`.
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
#' @family functions to import files into a list
#' @family functions to import files of common formats
#' @export
list_csv <- function(path = ".",
                     regexp = "[.]csv$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     ...) {
  list_any(
    path,
    readr::read_csv,
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

#' @rdname list_csv
#' @export
list_tsv <- function(path = ".",
                     regexp = "[.]tsv$",
                     ignore.case = TRUE,
                     invert = FALSE,
                     ...) {
  list_any(
    path,
    .f = readr::read_tsv,
    regexp = regexp,
    ignore.case = ignore.case,
    invert = invert,
    ...
  )
}

#' @rdname list_csv
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

#' @rdname list_csv
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
