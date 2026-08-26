# nvutils 1.1.0

* `inst/scripts/xlsx2tsv.R`, `inst/scripts/tsv2xlsx.R` and
  `inst/scripts/waldocompare.R` now parse arguments with optparse, matching
  `write_xlsx_pretty.R` and `two_category_barplot.R`. Each script gains
  `--help`, per-option help text, and validation that runs before nvutils is
  loaded. **Breaking:** positional arguments are no longer accepted; use
  `-i/--input`, `-o/--output`, `--sheet`, `-v/--verbose`, and
  `--file1`/`--file2` instead.
* `-v/--verbose` is a flag rather than a string compared against `TRUE`, so it
  no longer ignores anything but the literal `"TRUE"`.
* `xlsx2tsv.R` accepts `--sheet` as either a number or a sheet name without
  emitting a coercion warning for named sheets.
* `waldocompare.R` validates that both files are supplied and exist instead of
  passing missing arguments through to `waldo_compare_files()`.

# nvutils 1.0.8

* `waldo_compare_files()` now compares every worksheet of an `.xlsx` file.
  `openxlsx::read.xlsx()` reads only the first sheet, so differences in any
  other sheet went unreported. Each sheet is read into a named list, so waldo
  reports differences per sheet name and flags sheets present in only one of
  the two files.

# nvutils 1.0.7

* `write_xlsx_pretty()` gained `max_col_width` (default 100), which caps column
  widths in the same character units Excel shows in its "Column Width" dialog.
  openxlsx resolves `widths = "auto"` at save time and stops only at Excel's
  250-character ceiling, so a single long free-text column rendered unreadably
  wide. Columns under the cap keep their auto-fitted width; `NULL` disables the
  cap.
* `write_xlsx_pretty()` gained `wrap_text` (default `TRUE`), which wraps cell
  contents so a value longer than its column does not spill across whichever
  neighbouring cells happen to be empty.
* `write_xlsx_pretty()` now applies left/top alignment to the header row as well
  as the data.
* The `inst/scripts/write_xlsx_pretty.R` CLI gained `--max_col_width` (use `0`
  for no cap) and `--no_wrap_text`.
* Test suite maintenance: `withr::local_file()` for output cleanup, `annotateids`
  tests skip when `org.Hs.eg.db` is not installed, and unreachable `orthogene`
  availability checks were removed.

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
