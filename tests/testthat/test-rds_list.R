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

context("list_rdata")

test_that("list_rdata lists .rdata, .Rdata, and .rda", {
  expect_named(
    list_rdata(tor_example("mixed")),
    c("lower_rdata", "rda", "upper_rdata")
  )
})

test_that("list_rdata defaults to read from working directory", {
  expect_named(list_rdata(), "rdata")
})

context("list_csv")

test_that("list_csv can read .csv specifically in a mixed directory", {
  expect_named(
    list_csv(tor_example("mixed")),
    "csv"
  )
})

test_that("list_csv defaults to `stringsAsFactors = FALSE`", {
  expect_is(list_csv(tor_example("mixed"))[[1]]$y, "character")
})

test_that("list_csv defaults to read from working directory", {
  expect_true(any("csv" %in% names(list_csv())))
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
