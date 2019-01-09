# tor 1.0.1.9000

* Work in progress.

# tor 1.0.1 (GitHub release 2019-01-09)

* `list_any()`, `list_csv()`, `list_tsv()`, `load_csv()`, and `load_tsv()` now use __readr__.
  * This makes reading data faster and safer.

* Listed dataframes are now converted to tibbles. Users no longer need to call `tibble::as_tibble()`.
    
* New `load_*()` functions load each file in a directory into an environment.

* Example data is now named more consistently. For example:
    * `dir(tor_example("rds"))` returns `c("rds1.rds", "rds2.rds")`.
    * `dir(tor_example("csv"))` returns `c("csv1.csv", "csv2.csv")`.

# tor 1.0.0 (GitHub release 2019-01-07)

* Initial GitHub release.
