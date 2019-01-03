
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tor

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/maurolepore/tor.svg?branch=master)](https://travis-ci.org/maurolepore/tor)
[![Coverage
status](https://coveralls.io/repos/github/maurolepore/tor/badge.svg)](https://coveralls.io/r/maurolepore/tor?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tor)](https://cran.r-project.org/package=tor)

The goal of **tor** is to read multiple files at once with any reading
function. It is simple, flexible, and fits well in data-science
workflows with the tidyverse. It is easy to extend because it is focused
and small (it depends only on [**fs**](https://fs.r-lib.org/) and
[**rlang**](https://rlang.r-lib.org/)).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/tor")
```

## Example

``` r
library(magrittr)
library(tor)
```

All functions input a path and output a list.

#### `<input>_list`

The simplest functions are prefixed after the file format they read. The
argument `path` always defaults to the working directory.

``` r
dir()
#>  [1] "cran-comments.md" "csv1.csv"         "csv2.csv"        
#>  [4] "DESCRIPTION"      "inst"             "LICENSE.md"      
#>  [7] "man"              "NAMESPACE"        "NEWS.md"         
#> [10] "R"                "README.md"        "README.Rmd"      
#> [13] "tests"            "tmp.R"            "tor.Rproj"

csv_list()
#> $csv1
#>   x
#> 1 1
#> 2 2
#> 
#> $csv2
#>   y
#> 1 a
#> 2 b
```

But often you will specify a `path`.

``` r
# Helpes create paths to examples
tor_example()
#> [1] "csv"   "mixed" "rdata" "rds"   "tsv"

(path_rds <- tor_example("rds"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/rds"
dir(path_rds)
#> [1] "file1.rds" "file2.rds"

list_rds(path_rds)
#> $file1
#>   x
#> 1 1
#> 2 2
#> 
#> $file2
#>   y
#> 1 a
#> 2 b

(path_tsv <- tor_example("tsv"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/tsv"
dir(path_tsv)
#> [1] "tsv1.tsv" "tsv2.tsv"

tsv_list(path_tsv)
#> $tsv1
#>   x    y
#> 1 1    a
#> 2 2 <NA>
#> 3 3 <NA>
#> 
#> $tsv2
#>   x    y
#> 1 1    a
#> 2 2 <NA>
#> 3 3    b

path_mixed <- tor_example("mixed")
dir(path_mixed)
#> [1] "csv.csv"           "lower_rdata.rdata" "rda.rda"          
#> [4] "upper_rdata.RData"

csv_list(path_mixed)
#> $csv
#>   y
#> 1 a
#> 2 b

list_rdata(path_mixed)
#> $lower_rdata
#>   y
#> 1 a
#> 2 b
#> 
#> $rda
#>   y
#> 1 a
#> 2 b
#> 
#> $upper_rdata
#>   y
#> 1 a
#> 2 b
```

### `list_any()`

`list_any()` is the most flexible. You supply the function to read with.

``` r
(path_csv <- tor_example("csv"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/csv"
dir(path_csv)
#> [1] "file1.csv" "file2.csv"

list_any(path_csv, read.csv)
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

It understands lambda functions and formulas (powered by
[**rlang**](https://rlang.r-lib.org/)).

``` r
(path_rdata <- tor_example("rdata"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/rdata"
dir(path_rdata)
#> [1] "file1.rdata" "file2.rdata"

path_rdata %>% 
  list_any(function(x) get(load(x)))
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
path_rdata %>% 
  list_any(~get(load(.x)))
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

Pass additional arguments via `...` or inside the lambda function (as
`lapply()`).

``` r
list_any(path_csv, read.csv, stringsAsFactors = FALSE)
#> $file1
#>   x
#> 1 1
#> 2 2
#> 
#> $file2
#>   y
#> 1 a
#> 2 b

list_any(path_csv, ~read.csv(., stringsAsFactors = FALSE))
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

Use `regexp`, `ignore.case`, and `invert` to pick specific files in a
directory (powered by [**fs**](https://fs.r-lib.org/)).

``` r
path_mixed <- tor_example("mixed")
dir(path_mixed)
#> [1] "csv.csv"           "lower_rdata.rdata" "rda.rda"          
#> [4] "upper_rdata.RData"

path_mixed %>% 
  list_any(~get(load(.)), "[.]Rdata$", ignore.case = TRUE)
#> $lower_rdata
#>   y
#> 1 a
#> 2 b
#> 
#> $upper_rdata
#>   y
#> 1 a
#> 2 b

path_mixed %>% 
  list_any(~get(load(.)), regexp = "[.]csv$", invert = TRUE)
#> $lower_rdata
#>   y
#> 1 a
#> 2 b
#> 
#> $rda
#>   y
#> 1 a
#> 2 b
#> 
#> $upper_rdata
#>   y
#> 1 a
#> 2 b
```

# Related projects

There are great packages to read and write data, for example
[**rio**](https://CRAN.R-project.org/package=rio) and
[**io**](https://CRAN.R-project.org/package=io). **tor** does less than
the alternatives, yet it is more flexible and small.
