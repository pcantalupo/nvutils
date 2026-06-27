# nvutils 1.0.1

* Fixed `two_category_barplot()` failing with "could not find function
  '%>%'" by importing the pipe operator from dplyr.
* Corrected the `two_category_barplot()` README example to use the base
  `mtcars` dataset so it runs without attaching ggplot2.

# nvutils 1.0.0

Initial release. A collection of R utility functions.

* Excel/TSV conversion: `xlsx2tsv()` and `tsv2xlsx()`, with `sheet`,
  `sep.names`, `detectDates`, and `guess_max` options. `xlsx2tsv()` uses
  `data.table::fwrite`, preserves literal "NA" on read, and writes blank
  cells as empty fields.
* `two_category_barplot()` for percent-stacked composition bar charts from a
  data frame.
* `getHomologousSymbols()` for cross-species gene symbol mapping via
  orthogene.
* `annotateids()` for annotating gene/transcript IDs from an EnsDb.
* `set_operations()` for set comparisons.
* `find_whitespace()` for detecting whitespace in data.
* Package search helpers: `search_for_function()`,
  `search_genomics_packages()`, `search_multiple_packages()`.
* Color palettes: `colors_ditto()` and `colors_polychrome()`.
* Session and environment utilities: `myRinfo()`,
  `check_version_packages()`, `object_info()`, `peek()`,
  `waldo_compare_files()`.
