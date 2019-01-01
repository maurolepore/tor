
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readw

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/maurolepore/readw.svg?branch=master)](https://travis-ci.org/maurolepore/readw)
[![Coverage
status](https://coveralls.io/repos/github/maurolepore/readw/badge.svg)](https://coveralls.io/r/maurolepore/readw?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/readw)](https://cran.r-project.org/package=readw)

**readw** allows you to read multiple files at once with any reading
function. Its main function, `readw::read_with()`, inputs a reader
function and returns a modified version that reads any number of files
and stores them into a list (provided the first argument of the reader
function is a path to a file). Compared to other packages aimed to
reading files, **readw** is more simpler, more flexible, and has less
dependencies.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/readw")
```

## Example

``` r
library(readw)

readw_example()
#> [1] "csv"   "mixed" "rdata" "rds"

(csv_files <- readw_example("csv"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/readw/extdata/csv"
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
(mixed_files <- readw_example("mixed"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/readw/extdata/mixed"
dir(mixed_files)
#> [1] "file1.csv"   "file2.rdata"

# Using `regexp` to match .csv only
csv_list <- read_with(read.csv, regexp = "[.]csv")
# Passing `stringsAsFactors` via the argument `...` of read.csv
csv_list(mixed_files, stringsAsFactors = TRUE)
#> $file1
#>   y
#> 1 a
#> 2 b

# Compare
class(csv_list(mixed_files)[[1]]$y)
#> [1] "factor"
class(csv_list(mixed_files, stringsAsFactors = FALSE)[[1]]$y)
#> [1] "character"
```

You may use any available reader function, such as
[`readr::read_csv()`](https://CRAN.R-project.org/package=readr), and
[`readxl::read_excel()`](https://CRAN.R-project.org/package=readxl)), or
create your own.

``` r
read_rdata <- function(x) get(load(x))

(rdata_files <- readw_example("rdata"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/readw/extdata/rdata"
dir(rdata_files)
#> [1] "file1.rdata" "file2.rdata"

rdata_list <- read_with(read_rdata)
rdata_list(rdata_files)
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
is how **readw** compares:

  - **readw** may be confusing if you are unfamiliar with [function
    factories](https://adv-r.hadley.nz/function-factories.html).
  - **readw** is simpler:
      - It does not write data (only reads it).
      - It is not **readw** but the user who provides the reader
        function – thus **readw** has almost no dependency.
  - **readw** is more flexible because it works at a higher level of
    abstraction.
