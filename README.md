
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readwith

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/maurolepore/readwith.svg?branch=master)](https://travis-ci.org/maurolepore/readwith)
[![Coverage
status](https://coveralls.io/repos/github/maurolepore/readwith/badge.svg)](https://coveralls.io/r/maurolepore/readwith?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/readwith)](https://cran.r-project.org/package=readwith)

**readwith** allows you to read multiple files at once with any reading
function. Its main function, `readwith::read_with()`, inputs a reader
function and returns a modified version that reads any number of files
and stores them into a list (provided the first argument of the reader
function is a path to a file). Compared to other packages aimed to
reading files, **readwith** is more simpler, more flexible, and has less
dependencies.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/readwith")
```

## Example

``` r
library(readwith)

readwith_example()
#> [1] "csv"   "mixed" "rdata" "rds"

(csv_files <- readwith_example("csv"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/readwith/extdata/csv"
dir(csv_files)
#> [1] "file1.csv" "file2.csv"

csv_list <- read_with(read.csv)

csv_list(csv_files)
#> $file1
#>   x
#> 1 1
#> 2 2
#> 
#> $file2
#>   y
#> 1 a
#> 2 b

# Same
read_with(read.csv)(csv_files)
#> $file1
#>   x
#> 1 1
#> 2 2
#> 
#> $file2
#>   y
#> 1 a
#> 2 b
```

The argument `regexp` allows you to match specific files. You can pass
arguments to the reader function via `...` (not an argument of
`read_with()` but of the modified function it creates).

``` r
(mixed_files <- readwith_example("mixed"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/readwith/extdata/mixed"
dir(mixed_files)
#> [1] "file1.csv"   "file2.rdata"

# Using `regexp` to match .csv only
csv_list <- read_with(read.csv, regexp = "[.]csv$")

# Passing `stringsAsFactors` via the argument `...` of read.csv
result1 <- csv_list(mixed_files, stringsAsFactors = TRUE)
result2 <- csv_list(mixed_files, stringsAsFactors = FALSE)

# Compare
class(result1[["file1"]]$y)
#> [1] "factor"
class(result2[["file1"]]$y)
#> [1] "character"

result2
#> $file1
#>   y
#> 1 a
#> 2 b
```

You may use any available reader function, such as
[`readr::read_csv()`](https://CRAN.R-project.org/package=readr), and
[`readxl::read_excel()`](https://CRAN.R-project.org/package=readxl)), or
create your own.

``` r
read_rdata <- function(x) get(load(x))

(rdata_files <- readwith_example("rdata"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/readwith/extdata/rdata"
dir(rdata_files)
#> [1] "file1.rdata" "file2.rdata"

read_with(read_rdata)(rdata_files)
#> $file1
#>   x
#> 1 1
#> 2 2
#> 
#> $file2
#>   y
#> 1 a
#> 2 b
```

# Related projects

There are great packages to read and write data, for example
[**rio**](https://CRAN.R-project.org/package=rio) and
[**io**](https://CRAN.R-project.org/package=io). Compared to them, this
is how **readwith** compares:

  - **readwith** may be confusing if you are unfamiliar with [function
    factories](https://adv-r.hadley.nz/function-factories.html).
  - **readwith** is simpler:
      - It does not write data (only reads it).
      - It is not **readwith** but the user who provides the reader
        function – thus **readwith** has almost no dependency.
  - **readwith** is more flexible because it works at a higher level of
    abstraction.
