
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tor

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/maurolepore/tor.svg?branch=master)](https://travis-ci.org/maurolepore/tor)
[![Coverage
status](https://coveralls.io/repos/github/maurolepore/tor/badge.svg)](https://coveralls.io/r/maurolepore/tor?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tor)](https://cran.r-project.org/package=tor)

The goal of **tor** (*to-R*) is to make importing data into R
ridiculously easy. It helps you to import multiple files from a single
directory into R in a simple, intuitive way. `list_csv()` creates a list
of all “\*.csv” files in your working directory; and `load_rdata()`
loads all “\*.rdata” files into your global environment (see all
functions in
[Reference](https://maurolepore.github.io/tor/reference/index.html)).
**tor** does nothing you can’t do with functions from base R but it
makes a frequent task less painful. It has few dependencies and works
well with the [tidyverse](https://www.tidyverse.org/).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/tor")
```

## Example

``` r
library(tidyverse)
#> -- Attaching packages -------------------------------------------- tidyverse 1.2.1 --
#> v ggplot2 3.1.0     v purrr   0.2.5
#> v tibble  2.0.0     v dplyr   0.7.8
#> v tidyr   0.8.2     v stringr 1.3.1
#> v readr   1.3.1     v forcats 0.3.0
#> -- Conflicts ----------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(fs)
library(tor)
```

All functions list whatever they read, and default to reading from the
working directory. Dataframes are coerced to tibbles.

### `list_*()`: Import multiple files from a directory into a list

``` r
dir()
#>  [1] "_pkgdown.yml"     "cran-comments.md" "CRAN-RELEASE"    
#>  [4] "csv1.csv"         "csv2.csv"         "datasets"        
#>  [7] "DESCRIPTION"      "docs"             "inst"            
#> [10] "LICENSE.md"       "man"              "NAMESPACE"       
#> [13] "NEWS.md"          "R"                "README.md"       
#> [16] "README.Rmd"       "tests"            "tmp.R"           
#> [19] "tor.Rproj"

list_csv()
#> Parsed with column specification:
#> cols(
#>   x = col_double()
#> )
#> Parsed with column specification:
#> cols(
#>   y = col_character()
#> )
#> $csv1
#> # A tibble: 2 x 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

Often you will specify a `path` to read from.

``` r
# Helpes create paths to examples
tor_example()
#> [1] "csv"   "mixed" "rdata" "rds"   "tsv"

(path_rds <- tor_example("rds"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/rds"
dir(path_rds)
#> [1] "rds1.rds" "rds2.rds"

list_rds(path_rds)
#> $rds1
#> # A tibble: 2 x 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $rds2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

You may read all files with a particular extension.

``` r
path_mixed <- tor_example("mixed")
dir(path_mixed)
#> [1] "csv.csv"           "lower_rdata.rdata" "rda.rda"          
#> [4] "upper_rdata.RData"

list_rdata(path_mixed)
#> $lower_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $rda
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $upper_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

Or you may read specific files matching a pattern.

``` r
list_rdata(path_mixed, regexp = "[.]RData", ignore.case = FALSE)
#> $upper_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

`list_any()` is the most flexible function. You supply the function to
read with.

``` r
(path_csv <- tor_example("csv"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/csv"
dir(path_csv)
#> [1] "csv1.csv" "csv2.csv"

list_any(path_csv, read.csv)
#> $csv1
#> # A tibble: 2 x 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 x 1
#>   y    
#>   <fct>
#> 1 a    
#> 2 b
```

It understands lambda functions and formulas (powered by
[**rlang**](https://rlang.r-lib.org/)).

``` r
(path_rdata <- tor_example("rdata"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/rdata"
dir(path_rdata)
#> [1] "rdata1.rdata" "rdata2.rdata"

path_rdata %>% 
  list_any(function(x) get(load(x)))
#> $rdata1
#> # A tibble: 2 x 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $rdata2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b

# Same
path_rdata %>% 
  list_any(~get(load(.x)))
#> $rdata1
#> # A tibble: 2 x 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $rdata2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

Pass additional arguments via `...` or inside the lambda function.

``` r
path_csv %>% 
  list_any(readr::read_csv, skip = 1)
#> Parsed with column specification:
#> cols(
#>   `1` = col_double()
#> )
#> Parsed with column specification:
#> cols(
#>   a = col_character()
#> )
#> $csv1
#> # A tibble: 1 x 1
#>     `1`
#>   <dbl>
#> 1     2
#> 
#> $csv2
#> # A tibble: 1 x 1
#>   a    
#>   <chr>
#> 1 b

path_csv %>% 
  list_any(~read.csv(., stringsAsFactors = FALSE)) %>% 
  map(as_tibble)
#> $csv1
#> # A tibble: 2 x 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

It also provides the arguments `regexp`, `ignore.case`, and `invert` to
pick specific files in a directory (powered by
[**fs**](https://fs.r-lib.org/)).

``` r
path_mixed <- tor_example("mixed")
dir(path_mixed)
#> [1] "csv.csv"           "lower_rdata.rdata" "rda.rda"          
#> [4] "upper_rdata.RData"

path_mixed %>% 
  list_any(~get(load(.)), "[.]Rdata$", ignore.case = TRUE)
#> $lower_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $upper_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b

path_mixed %>% 
  list_any(~get(load(.)), regexp = "[.]csv$", invert = TRUE)
#> $lower_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $rda
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $upper_rdata
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

### `load_*()`: Load multiple files from a directory into an environment

All functions default to load from the working directory.

``` r
# The working directory contains .csv files
dir()
#>  [1] "_pkgdown.yml"     "cran-comments.md" "CRAN-RELEASE"    
#>  [4] "csv1.csv"         "csv2.csv"         "datasets"        
#>  [7] "DESCRIPTION"      "docs"             "inst"            
#> [10] "LICENSE.md"       "man"              "NAMESPACE"       
#> [13] "NEWS.md"          "R"                "README.md"       
#> [16] "README.Rmd"       "tests"            "tmp.R"           
#> [19] "tor.Rproj"

load_csv()

# Each file is now available as a dataframe in the global environment
csv1
#> # A tibble: 2 x 1
#>       x
#>   <int>
#> 1     1
#> 2     2
csv2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

You may load from a `path`.

``` r
rm(list = ls())
ls()
#> character(0)

(path_mixed <- tor_example("mixed"))
#> [1] "C:/Users/LeporeM/Documents/R/R-3.5.2/library/tor/extdata/mixed"
dir(path_mixed)
#> [1] "csv.csv"           "lower_rdata.rdata" "rda.rda"          
#> [4] "upper_rdata.RData"

load_rdata(path_mixed)

ls()
#> [1] "lower_rdata" "path_mixed"  "rda"         "upper_rdata"
rda
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

### [**purrr**](https://purrr.tidyverse.org/) + `format_path()`: Map each list element to a file in a directory

**tor** does not write data but includes a helper to create the paths to
output files.

``` r
dir(pattern = "[.]csv$")
#> [1] "csv1.csv" "csv2.csv"

dfms <- list_csv()
#> Parsed with column specification:
#> cols(
#>   x = col_double()
#> )
#> Parsed with column specification:
#> cols(
#>   y = col_character()
#> )

format_path(names(dfms), "csv")
#> [1] "./csv1.csv" "./csv2.csv"

format_path(names(dfms), "csv", base = "home", prefix = "this-")
#> [1] "home/this-csv1.csv" "home/this-csv2.csv"
```

Combine it with [**purrr**](https://purrr.tidyverse.org/).

``` r
imap_chr(dfms, ~ format_path(.y, "csv"))
#>         csv1         csv2 
#> "./csv1.csv" "./csv2.csv"

# Same
map_chr(dfms, ~ format_path(names(.), "csv", ".", "this-"))
#>           csv1           csv2 
#> "./this-x.csv" "./this-y.csv"

(dfs <- list_csv())
#> Parsed with column specification:
#> cols(
#>   x = col_double()
#> )
#> Parsed with column specification:
#> cols(
#>   y = col_character()
#> )
#> $csv1
#> # A tibble: 2 x 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 x 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b

paths <- dfs %>% 
  imap_chr(~ format_path(.y, "csv", base = ".", prefix = "this-"))

walk2(dfs, paths, readr::write_csv)

dir_ls(".", regexp = "this-")
#> this-csv1.csv this-csv2.csv
```

# Related projects

There are great packages to read and write data, for example
[**rio**](https://CRAN.R-project.org/package=rio) and
[**io**](https://CRAN.R-project.org/package=io). **tor** does less than
the alternatives, but it is much smaller and more flexible.
