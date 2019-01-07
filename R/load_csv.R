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
}
