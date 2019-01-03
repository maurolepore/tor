context("write_with")

test_that("write_with wries .csv files with utils::read.csv", {
  td <- tempdir()
  wd <- getwd()
  setwd(td)
  on.exit(setwd(wd))
  on.exit(rm(td))

  dfms <- csv_list(tor_example("csv"))
  write_with(dfms, .f = write.csv, ext = "csv")
  expect_equal(dir(td, pattern = "[.]csv$"), paste0(names(dfms), ".csv"))
})

test_that("write_with wries .csv files with readr::read_csv", {
  skip_if_not_installed("readr")

  td <- tempdir()
  wd <- getwd()
  setwd(td)
  on.exit(setwd(wd))
  on.exit(rm(td))

  dfms <- csv_list(tor_example("csv"))
  names(dfms) <- paste0("readr-", names(dfms))
  write_with(dfms, .f = readr::write_csv, ext = "csv")

  expect_true(
    any(
      dir(td, pattern = "[.]csv$") %in% paste0(names(dfms), ".csv")
    )
  )
})



# dfm <- csv_list(tor_example("csv"))
# dfm
#
# write_with(
#   dfm,
#   # Is sensitive to path
#   path = "../",
#   # Accepts lamda as formula
#   # Passes additional arguments via `...` inside lamda
#   ~utils::write.csv(.x, .y, row.names = FALSE),
#   # Is sensitive to ext
#   ext = "csv",
#   # Is sensitive to ext
#   prefix = "pre"
# )
#
# # TODO: Try other file formats
# # Writes with other functions
# write_with(dfm, path = ".", readr::write_tsv, ext = ".tsv")

# TODO:
# Error messages invalid directory
# Extension with ".ext" instead of "ext"
# Wrapper list_csv list_rdata list_rds list_tsv
