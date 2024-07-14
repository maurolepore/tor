
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tor

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/tor)](https://CRAN.R-project.org/package=tor)
[![Codecov test
coverage](https://codecov.io/gh/maurolepore/tor/branch/main/graph/badge.svg)](https://app.codecov.io/gh/maurolepore/tor?branch=main)
[![R-CMD-check](https://github.com/maurolepore/tor/workflows/R-CMD-check/badge.svg)](https://github.com/maurolepore/tor/actions)
[![R-CMD-check](https://github.com/maurolepore/tor/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/maurolepore/tor/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**tor** (*to-R*) helps you to import multiple files at once. For
example:

- Run `list_rds()` to import all .csv files from your working directory
  into a list.
- Run `load_csv()` to import all .csv files from your working directory
  into your global environment.

## Installation

Install **tor** from CRAN with:

``` r
install.packages("tor")
```

Or install the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/tor")
```

## Example

``` r
library(tor)
```

### `list_*()`: Import multiple files from a directory into a list

All functions default to importing files from the working directory.

``` r
dir()
#>  [1] "_pkgdown.yml"     "codecov.yml"      "cran-comments.md" "csv1.csv"        
#>  [5] "csv2.csv"         "DESCRIPTION"      "inst"             "LICENSE.md"      
#>  [9] "man"              "NAMESPACE"        "NEWS.md"          "R"               
#> [13] "README.md"        "README.Rmd"       "tests"            "tor.Rproj"       
#> [17] "vignettes"

list_csv()
#> Rows: 2 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (1): x
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Rows: 2 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): y
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> $csv1
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 × 1
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
#> [1] "/tmp/RtmpYaA5se/temp_libpath3ffe324f0098/tor/extdata/rds"
dir(path_rds)
#> [1] "rds1.rds" "rds2.rds"

list_rds(path_rds)
#> $rds1
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $rds2
#> # A tibble: 2 × 1
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
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $rda
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $upper_rdata
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

Or you may read specific files matching a pattern.

``` r
list_rdata(path_mixed, regexp = "[.]RData", ignore.case = FALSE)
#> $upper_rdata
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

`list_any()` is the most flexible function. You supply the function to
read with.

``` r
(path_csv <- tor_example("csv"))
#> [1] "/tmp/RtmpYaA5se/temp_libpath3ffe324f0098/tor/extdata/csv"
dir(path_csv)
#> [1] "csv1.csv" "csv2.csv"

list_any(path_csv, read.csv)
#> $csv1
#> # A tibble: 2 × 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

It understands lambda functions and formulas (powered by
[**rlang**](https://rlang.r-lib.org/)).

``` r
# Use the pipe (%>%)
library(magrittr)

(path_rdata <- tor_example("rdata"))
#> [1] "/tmp/RtmpYaA5se/temp_libpath3ffe324f0098/tor/extdata/rdata"
dir(path_rdata)
#> [1] "rdata1.rdata" "rdata2.rdata"

path_rdata %>%
  list_any(function(x) get(load(x)))
#> $rdata1
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $rdata2
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b

# Same
path_rdata %>%
  list_any(~ get(load(.x)))
#> $rdata1
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
#> 
#> $rdata2
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

Pass additional arguments via `...` or inside the lambda function.

``` r
path_csv %>%
  list_any(readr::read_csv, skip = 1)
#> Rows: 1 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (1): 1
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Rows: 1 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): a
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> $csv1
#> # A tibble: 1 × 1
#>     `1`
#>   <dbl>
#> 1     2
#> 
#> $csv2
#> # A tibble: 1 × 1
#>   a    
#>   <chr>
#> 1 b

path_csv %>%
  list_any(~ read.csv(., stringsAsFactors = FALSE))
#> $csv1
#> # A tibble: 2 × 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 
#> $csv2
#> # A tibble: 2 × 1
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
  list_any(~ get(load(.)), "[.]Rdata$", ignore.case = TRUE)
#> $lower_rdata
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $upper_rdata
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b

path_mixed %>%
  list_any(~ get(load(.)), regexp = "[.]csv$", invert = TRUE)
#> $lower_rdata
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $rda
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b    
#> 
#> $upper_rdata
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

### `load_*()`: Load multiple files from a directory into an environment

All functions default to importing files from the working directory and
into the global environment.

``` r
# The working directory contains .csv files
dir()
#>  [1] "_pkgdown.yml"     "codecov.yml"      "cran-comments.md" "csv1.csv"        
#>  [5] "csv2.csv"         "DESCRIPTION"      "inst"             "LICENSE.md"      
#>  [9] "man"              "NAMESPACE"        "NEWS.md"          "R"               
#> [13] "README.md"        "README.Rmd"       "tests"            "tor.Rproj"       
#> [17] "vignettes"

load_csv()
#> Rows: 2 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (1): x
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Rows: 2 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): y
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

# Each file is now available as a dataframe in the global environment
csv1
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
csv2
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b

rm(list = ls())
```

You may import files from a specific `path`.

``` r
(path_mixed <- tor_example("mixed"))
#> [1] "/tmp/RtmpYaA5se/temp_libpath3ffe324f0098/tor/extdata/mixed"
dir(path_mixed)
#> [1] "csv.csv"           "lower_rdata.rdata" "rda.rda"          
#> [4] "upper_rdata.RData"

load_rdata(path_mixed)

ls()
#> [1] "path_mixed"
rda
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

You may import files into a specific `envir`onment.

``` r
e <- new.env()
ls(e)
#> character(0)

load_rdata(path_mixed, envir = e)

ls(e)
#> [1] "lower_rdata" "rda"         "upper_rdata"
```

For more flexibility use `load_any()` with a function able to read one
file of the format you want to import.

``` r
dir()
#>  [1] "_pkgdown.yml"     "codecov.yml"      "cran-comments.md" "csv1.csv"        
#>  [5] "csv2.csv"         "DESCRIPTION"      "inst"             "LICENSE.md"      
#>  [9] "man"              "NAMESPACE"        "NEWS.md"          "R"               
#> [13] "README.md"        "README.Rmd"       "tests"            "tor.Rproj"       
#> [17] "vignettes"

load_any(".", .f = readr::read_csv, regexp = "[.]csv$")
#> Rows: 2 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (1): x
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Rows: 2 Columns: 1
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): y
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

# The data is now available in the global environment
csv1
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1     1
#> 2     2
csv2
#> # A tibble: 2 × 1
#>   y    
#>   <chr>
#> 1 a    
#> 2 b
```

# Related projects

Two great packages to read and write data are
[**rio**](https://CRAN.R-project.org/package=rio) and
[**io**](https://CRAN.R-project.org/package=io).

## Information

- [Getting help](https://maurolepore.github.io/tor/SUPPORT.html).
- [Contributing](https://maurolepore.github.io/tor/CONTRIBUTING.html).
- [Contributor Code of
  Conduct](https://maurolepore.github.io/tor/CODE_OF_CONDUCT.html).
