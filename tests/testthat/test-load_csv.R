context("load_csv")

test_that("load_csv loads multiple csv in a new environment", {
  e <- new.env()
  load_csv(tor_example("csv"), envir = e)

  expect_equal(c("file1", "file2"), ls(e))
  rm(list = ls())
})

