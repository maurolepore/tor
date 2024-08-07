<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# tor 1.1.3

* Modernize: Upkeep for tor (2024) (#47).

# tor 1.1.2

* No longer assume `stringsAsFactor` defaults to `TRUE`.
* Require R >= 3.2 (checked on GitHub actions).

# tor 1.1.1

## Feature

* New `load_any()` is analog to `list_any()` and completes the set.

## Fixes

* In `list_any()`, the argument `...` is now correctly defined.
* The title of `load_csv()` and friends is now correct.

# tor 1.0.1

* `list_any()`, `list_csv()`, `list_tsv()`, `load_csv()`, and `load_tsv()` now use __readr__.
  * This makes reading data faster and safer.

* Listed dataframes are now converted to tibbles. Users no longer need to call `tibble::as_tibble()`.
    
* New `load_*()` functions load each file in a directory into an environment.

* Example data is now named more consistently. For example:
    * `dir(tor_example("rds"))` returns `c("rds1.rds", "rds2.rds")`.
    * `dir(tor_example("csv"))` returns `c("csv1.csv", "csv2.csv")`.

# tor 1.0.0 (GitHub release)

* Initial GitHub release.
