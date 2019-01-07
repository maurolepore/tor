context("load_rdata")

test_that("load_rdata loads multiple .rdata files in a new environment", {
  e <- new.env()
  load_rdata(tor_example("rdata"), envir = e)

  expect_equal(c("file1", "file2"), ls(e))
  rm(list = ls())
})



context("load_csv")

test_that("load_csv loads multiple .csv files in a new environment", {
  e <- new.env()
  load_csv(tor_example("csv"), envir = e)

  expect_equal(c("file1", "file2"), ls(e))
  rm(list = ls())
})



context("load_tsv")

test_that("load_tsv loads multiple .tsv files in a new environment", {
  e <- new.env()
  load_tsv(tor_example("tsv"), envir = e)

  expect_equal(c("tsv1", "tsv2"), ls(e))
  rm(list = ls())
})
