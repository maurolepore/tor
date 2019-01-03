#' Export mapping each dataframe in a list to a corresponding .csv file.
#'
#' @source Adapted from an article by Jenny Bryan (https://goo.gl/ah8qkX).
#'
#' @param lst A list of dataframes.
#' @param dir Character; the directory where the files will be saved.
#' @param prefix Character; a prefix to add to the file names.
#'
#' @examples
#' lst <- list(df1 = data.frame(x = 1), df2 = data.frame(x = 2))
#'
#' # Saving the output to a temporary file
#' output <- tempdir()
#' list_csv(lst, output, prefix = "myfile-")
#'
#' # Look inside the output directory to confirm it worked
#' dir(output, pattern = "myfile")
#'
#' @family functions to handle multiple spreadsheets of an excel workbook
#' @family general functions to export data
#' @export
list_csv <- function(lst, dir, prefix = NULL) {
  stopifnot(is.list(lst), each_list_item_is_df(lst), is.character(dir))
  if (!is.null(prefix)) {
    stopifnot(is.character(prefix))
  }
  validate_dir(dir = dir, dir_name = "`dir`")

  purrr::walk2(lst, names(lst), list_csv_, prefix = prefix, dir = dir)
}

validate_dir <- function(dir, dir_name) {
  invalid_dir <- !fs::dir_exists(dir)
  if (invalid_dir) {
    msg <- paste0(
      dir_name, " must match a valid directory.\n",
      "bad ", dir_name, ": ", "'", dir, "'"
    )
    abort(msg)
  } else {
    invisible(dir)
  }
}

#' Do list_csv() for each df.
#' @noRd
list_csv_ <- function(df, df_name,  prefix = NULL, dir) {
  path <- file.path(paste0(dir, "/", prefix, df_name, ".csv"))
  readr::write_csv(df, path)
}
