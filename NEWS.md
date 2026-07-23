# nvutils 1.0.6

* `waldo_compare_files()` now reads `.qs2` files via `qs2::qs_read()`, added
  `qs2` to Imports.

# nvutils 1.0.5

* Added an `--infer_types` flag to the `inst/scripts/write_xlsx_pretty.R` CLI.
  By default `.tsv`/`.txt` inputs are read with every column as text (to
  preserve leading zeros), which stores numeric columns as text in the
  workbook; `--infer_types` lets `fread` infer column types so numeric columns
  are written as real numbers.

# nvutils 1.0.4

* Added `write_xlsx_pretty()`, which writes a single data frame to an XLSX with
  left/top cell alignment, auto column widths, character columns forced to text
  format (preserving leading zeros), `YYYY-MM-DD` dates, an initial worksheet
  zoom, and a large default window size. The `pct_cols` argument handles columns
  that mix numeric percentages (e.g. `0.9` shown as `90%`) with free text (e.g.
  `<90%`). Requires the new `tibble` and `stringr` imports.
* Added `inst/scripts/write_xlsx_pretty.R`, a command-line wrapper that reads
  `.tsv`/`.txt`/`.xlsx` input and writes a prettified `.xlsx`. It errors on
  multi-sheet Excel input unless `--sheet` is given, so no data is dropped
  silently.

# nvutils 1.0.3

* `two_category_barplot()` now takes a `colors` argument (defaulting to the
  exported `colors_ditto` palette) instead of an inlined color vector, so any
  palette such as `colors_polychrome` can be supplied. The CLI wrapper exposes
  this via `--colors` (`ditto` or `polychrome`). README documents both with
  example figures.

# nvutils 1.0.2

* Added `inst/scripts/two_category_barplot.R`, a command-line wrapper around
  `two_category_barplot()`. Reads `.tsv`/`.txt`/`.xlsx` input and saves a PNG,
  with options for title, legend title, theme, x-label rotation, sheet, and
  output size/resolution.

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
