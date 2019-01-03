
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tor

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/maurolepore/tor.svg?branch=master)](https://travis-ci.org/maurolepore/tor)
[![Coverage
status](https://coveralls.io/repos/github/maurolepore/tor/badge.svg)](https://coveralls.io/r/maurolepore/tor?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tor)](https://cran.r-project.org/package=tor)

The goal of **tor** is to import multiple files of any kind into R, and
to do so as flexibly, quickly, and fluently when combined with tools
from the tidyverse. Essentially, it vectorizes reading functions so you
provide not the path to each file you want to read but the path to the
directory they live in.

**tor** does nothing you can’t do with functions from base R (or
[**fs**](https://fs.r-lib.org/) plus
[**purrr**](https://purrr.tidyverse.org/%20plus%20some%20reader%20package)
but it provides a shortcut so you don’t have to waste brain power in
such a common task.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/tor")
```

## Example

``` r
library(magrittr)
library(fs)
library(tor)
```

All functions list whatever they read, and default to reading from the
working directory.

``` r
dir()
#>  [1] "cran-comments.md" "csv1.csv"         "csv2.csv"        
#>  [4] "datasets"         "DESCRIPTION"      "inst"            
#>  [7] "LICENSE.md"       "man"              "NAMESPACE"       
#> [10] "NEWS.md"          "R"                "README.md"       
#> [13] "README.Rmd"       "tests"            "tmp.R"           
#> [16] "tor.Rproj"

list_csv()
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

list_tsv(path_tsv)
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

list_csv(path_mixed)
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

### Writing data

**tor** does not write data. Compared to reading, writing data is a
little easier because you have all the tools from R to choose what to
write, how and where.

Yet **tor** helps you in a small, important way. Because creating the
paths to write files may interrupt your workflow, **torr** provides a
helper to do just that.

``` r
dir(pattern = "[.]csv$")
#> [1] "csv1.csv" "csv2.csv"

dfms <- list_csv()

format_path(names(dfms), "csv")
#> [1] "./csv1.csv" "./csv2.csv"

format_path(names(dfms), "csv", "base", "prefix-")
#> [1] "base/prefix-csv1.csv" "base/prefix-csv2.csv"
```

Combine it with \[**purrr**\](<https://purrr.tidyverse.org/>.

``` r
library(purrr)
#> 
#> Attaching package: 'purrr'
#> The following object is masked from 'package:magrittr':
#> 
#>     set_names

imap_chr(dfms, ~ format_path(.y, "csv"))
#>         csv1         csv2 
#> "./csv1.csv" "./csv2.csv"

# Same
map_chr(dfms, ~ format_path(names(.), "csv", ".", "this-"))
#>           csv1           csv2 
#> "./this-x.csv" "./this-y.csv"
```

This is how to use it in a pipeline:

``` r
list_csv() %>% 
  walk2(
    imap_chr(dfms, ~ format_path(.y, "csv", base = ".", prefix = "this-")), 
    write.csv
  )

dir_ls(".", regexp = "this-")
#> this-csv1.csv this-csv2.csv
```

# Related projects

There are great packages to read and write data, for example
[**rio**](https://CRAN.R-project.org/package=rio) and
[**io**](https://CRAN.R-project.org/package=io). **tor** does less than
the alternatives, but it is much smaller and more flexible.
