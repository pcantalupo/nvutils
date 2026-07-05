
# nvutils

<!-- badges: start -->
<!-- badges: end -->

nvutils is a collection of R utility functions.

## Installation

You can install the development version of nvutils like so:

``` r
devtools::install_github("pcantalupo/nvutils")
```

## Example

Converting an Excel file to TSV.

``` r
library(nvutils)
## basic example code to convert XLSX to TSV
xlsx2tsv(xlsxfile, tsvoutfile)
```

## Two-category bar plot

`two_category_barplot()` makes a 100% stacked bar chart showing the
proportional breakdown of a subcategory within each level of a main
category. It takes a plain data frame and two column names, so it works on
any tabular data, not just single-cell metadata.

``` r
library(nvutils)
## proportion of gears within each cylinder count (mtcars is a base dataset)
two_category_barplot(mtcars, category = "cyl", subcategory = "gear")

## with a custom title and legend label
two_category_barplot(mtcars,
                     category = "cyl",
                     subcategory = "gear",
                     title = "Gear Distribution by Cylinder Count",
                     legend_title = "Gears")
```

![](man/figures/README-two-category-title.png)

``` r
## with a different palette (defaults to colors_ditto)
two_category_barplot(mtcars,
                     category = "cyl",
                     subcategory = "gear",
                     colors = colors_polychrome)
```

![](man/figures/README-two-category-polychrome.png)

Arguments: `data` (data frame), `category` (x-axis column), `subcategory`
(fill column), `title`, `legend_title`, and `colors` (fill palette, defaults
to the exported `colors_ditto`; pass any color vector, e.g. `colors_polychrome`).
Returns a ggplot2 object.

### Command-line usage

`inst/scripts/two_category_barplot.R` wraps the function as a CLI tool that
reads a tabular file (`.tsv`, `.txt`, or `.xlsx`, auto-detected by extension)
and saves a PNG.

``` sh
two_category_barplot.R -i data.tsv -c cyl -s gear -o plot.png

## with the polychrome palette and a custom title
two_category_barplot.R -i data.tsv -c cyl -s gear -o plot.png \
  --colors polychrome -t "Gear Distribution by Cylinder Count"
```

Required flags: `-i/--input`, `-c/--category`, `-s/--subcategory`. Optional
flags: `-o/--output` (defaults to the input basename + `.png`), `-t/--title`,
`-l/--legend-title`, `--colors` (`ditto` (default) or `polychrome`), `--theme`
(ggplot2 theme; `grey` is the ggplot2 default, script default is `classic`),
`--rotatex_angle` (x-label rotation, default 45), `--sheet` (xlsx sheet, default
1), `--width`/`--height` (inches, default 7x7), and `--dpi` (default 300).

This is a general-purpose extraction of the `get_barplots_and_tables()`
function in [sctools](https://github.com/pcantalupo/sctools). The sctools
version is single-cell oriented (reads a Seurat/SCE object) and produces a
fuller set of outputs: grouped, stacked, and percent-stacked barplots,
count and percentage contingency tables, and heatmaps. `two_category_barplot()`
keeps only the percent-stacked plot, drops the single-cell coupling, and
adds title/legend arguments and input validation.

