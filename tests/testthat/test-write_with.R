context("write_with")

test_that("write_with wries .csv files with utils::read.csv", {
  td <- tempdir()
  wd <- getwd()
  setwd(td)
  on.exit(setwd(wd))
  on.exit(rm(td))

  dfms <- csv_list(readwith_example("csv"))
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

  dfms <- csv_list(readwith_example("csv"))
  names(dfms) <- paste0("readr-", names(dfms))
  write_with(dfms, .f = readr::write_csv, ext = "csv")

  expect_true(
    any(
      dir(td, pattern = "[.]csv$") %in% paste0(names(dfms), ".csv")
    )
  )
})


# TODO:
# Extension
# Error messages invalid directory
# Non null path
# Extension with ".ext" instead of "ext"

# TODO:
# Wrapper list_csv list_rdata list_rds list_tsv
