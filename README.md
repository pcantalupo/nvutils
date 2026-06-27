
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

Arguments: `data` (data frame), `category` (x-axis column), `subcategory`
(fill column), `title`, and `legend_title`. Returns a ggplot2 object.

This is a general-purpose extraction of the `get_barplots_and_tables()`
function in [sctools](https://github.com/pcantalupo/sctools). The sctools
version is single-cell oriented (reads a Seurat/SCE object) and produces a
fuller set of outputs: grouped, stacked, and percent-stacked barplots,
count and percentage contingency tables, and heatmaps. `two_category_barplot()`
keeps only the percent-stacked plot, drops the single-cell coupling, and
adds title/legend arguments and input validation.

