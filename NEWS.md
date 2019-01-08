# tor 1.0.9001 unreleased

## Minor

* Each dataframe output is now converted to tibble. 
    * Users no longer need to call `tibble::as_tibble()`.
    
* New `load_*()` variants load each file in a directory into an environment.

## Patch

* File names now emphasize the most common case when users import .csv files.

* Example data is now named more consistently. For example:
    * `dir(tor_example("rds"))` returns `c("rds1.rds", "rds2.rds")`.
    * `dir(tor_example("csv"))` returns `c("csv1.csv", "csv2.csv")`.

* Source is now styled with `styler::style_pkg()` (defaults)

* Lambda functions in source code now use the more common function(x) syntax.
    * Text editors highlight `function()` which makes code easier to read.

# tor 1.0.0

* Initial release.
