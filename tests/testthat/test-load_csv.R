context("load_rds")

test_that("load_rds loads multiple .rds files in a new environment", {
  e <- new.env()
  load_rds(tor_example("rds"), envir = e)

  expect_equal(
    ls(e),
    c("rds1", "rds2")
  )
  rm(list = ls())
})

context("load_rdata")

test_that("load_rdata loads multiple .rdata files in a new environment", {
  e <- new.env()
  load_rdata(tor_example("rdata"), envir = e)

  expect_equal(
    ls(e),
    c("rdata1", "rdata2")
  )
  rm(list = ls())
})

context("load_csv")

test_that("load_csv loads multiple .csv files in a new environment", {
  e <- new.env()
  load_csv(tor_example("csv"), envir = e)

  expect_equal(
    ls(e),
    c("csv1", "csv2")
  )
  rm(list = ls())
})

context("load_tsv")

test_that("load_tsv loads multiple .tsv files in a new environment", {
  e <- new.env()
  load_tsv(tor_example("tsv"), envir = e)

  expect_equal(
    ls(e),
    c("tsv1", "tsv2")
  )
  rm(list = ls())
})



context("load_any")

test_that("load_any with a formula-function loads data into an environment", {
  e <- new.env()
  load_any(tor_example("rdata"), .f = ~ get(load(.x)), envir = e)

  expect_equal(
    ls(e),
    c("rdata1", "rdata2")
  )
  rm(list = ls())
})

test_that("load_any defaults to importing from the working directory", {
  e <- new.env()
  load_any(.f = readr::read_csv, regexp = "[.]csv$", envir = e)

  expect_equal(
    ls(e),
    c("csv1", "csv2")
  )
  rm(list = ls())
})

test_that("load_any defaults to importing from the working directory", {
  e <- new.env()
  load_any(.f = readr::read_csv, regexp = "[.]csv$", envir = e)

  expect_equal(
    ls(e),
    c("csv1", "csv2")
  )
  rm(list = ls())
})

test_that("load_any passes arguments to .f via ...", {
  e <- new.env()
  load_any(
    .f = read.csv, regexp = "[.]csv$", envir = e,
    stringsAsFactors = FALSE
  )
  expect_false(inherits(e$csv2$y, "factor"))
  expect_is(e$csv2$y, "character")
})

test_that("load_any passes arguments to .f inside lambda", {
  e <- new.env()
  load_any(
    .f = ~read.csv(.x, stringsAsFactors = FALSE), regexp = "[.]csv$", envir = e,
  )
  expect_false(inherits(e$csv2$y, "factor"))
  expect_is(e$csv2$y, "character")
})
