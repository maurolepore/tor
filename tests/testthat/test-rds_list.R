context("list_rds")

test_that("list_rds lists .rds files", {
  expect_named(
    list_rds(tor_example("rds")),
    c("file1", "file2")
  )
})

test_that("list_rds defaults to read from working directory", {
  expect_named(list_rds(), "rds")
})

context("rdata_list")

test_that("rdata_list lists .rdata, .Rdata, and .rda", {
  expect_named(
    rdata_list(tor_example("mixed")),
    c("lower_rdata", "rda", "upper_rdata")
  )
})

test_that("rdata_list defaults to read from working directory", {
  expect_named(rdata_list(), "rdata")
})

context("csv_list")

test_that("csv_list can read .csv specifically in a mixed directory", {
  expect_named(
    csv_list(tor_example("mixed")),
    "csv"
  )
})

test_that("csv_list defaults to `stringsAsFactors = FALSE`", {
  expect_is(csv_list(tor_example("mixed"))[[1]]$y, "character")
})

test_that("csv_list defaults to read from working directory", {
  expect_true(any("csv" %in% names(csv_list())))
})

context("tsv_list")

test_that("tsv_list lists .tsv files", {
  skip_if_not_installed("readr")

  readr <- readr::read_tsv(fs::dir_ls(tor_example("tsv"))[[1]])
  tor <- tsv_list(tor_example("tsv"))[[1]]
  expect_equivalent(readr, tor)
})

test_that("tsv_list defaults to read from working directory", {
  expect_named(tsv_list(), "tsv")
})
