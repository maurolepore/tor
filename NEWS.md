# tor 1.0.9001 unreleased

## Minor

* New `load_*()` variants load each file in a directory into an environment.

## Patch

* Refactor: For clarity source now uses the more common function(x) syntax. Text editors highlight `function()` which makes code easier to read.

* Source is now styled with `styler::style_pkg()` (defaults)

* Example data is now named more consistently so that `dir(tor_example("rds"))` no longer is `c("file1.rds", "file2.rds")`, but `c("rds1.rds", "rds2.rds")`.

# tor 1.0.0

* Initial release.
