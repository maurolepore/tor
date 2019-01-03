context("rds_list")

test_that("rds_list lists .rds files", {
  expect_named(
    rds_list(readwith_example("rds")),
    c("file1", "file2")
  )
})

test_that("rds_list defaults to read from working directory", {
  expect_named(rds_list(), "rds")
})

context("rdata_list")

test_that("rdata_list lists .rdata, .Rdata, and .rda", {
  expect_named(
    rdata_list(readwith_example("mixed")),
    c("lower_rdata", "rda", "upper_rdata")
  )
})

test_that("rdata_list defaults to read from working directory", {
  expect_named(rdata_list(), "rdata")
})

context("csv_list")

test_that("csv_list can read .csv specifically in a mixed directory", {
  expect_named(
    csv_list(readwith_example("mixed")),
    "csv"
  )
})

test_that("csv_list defaults to `stringsAsFactors = FALSE`", {
  expect_is(csv_list(readwith_example("mixed"))[[1]]$y, "character")
})

test_that("csv_list defaults to read from working directory", {
  expect_true(any("csv" %in% names(csv_list())))
})

context("tsv_list")

test_that("tsv_list lists .tsv files", {
  skip_if_not_installed("readr")

  readr <- readr::read_tsv(fs::dir_ls(readwith_example("tsv"))[[1]])
  readwith <- tsv_list(readwith_example("tsv"))[[1]]
  expect_equivalent(readr, readwith)
})

test_that("tsv_list defaults to read from working directory", {
  expect_named(tsv_list(), "tsv")
})
