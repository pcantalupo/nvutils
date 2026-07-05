#' Create a Two-Category Stacked Bar Plot
#'
#' Generates a 100% stacked bar chart showing the proportional breakdown of a
#' subcategory within each level of a main category. Uses the dittoSeq color
#' palette for consistent visualization.
#'
#' @param data A data frame containing the variables to plot
#' @param category Character string specifying the column name for the main
#'   category (x-axis). Will be converted to a factor if not already.
#' @param subcategory Character string specifying the column name for the
#'   subcategory (fill variable). Will be converted to a factor if not already.
#' @param title Character string for the plot title. Default is
#'   "Percent stacked barchart".
#' @param legend_title Character string for the legend title. If NULL (default),
#'   uses the subcategory variable name.
#' @param colors A character vector of hex color codes for the fill scale.
#'   Defaults to \code{colors_ditto}, the exported 40-color dittoSeq/Okabe-Ito
#'   palette. The palette is recycled three times to provide headroom for many
#'   subcategory levels. Any color vector works, e.g. \code{colors_polychrome}.
#'
#' @return A ggplot2 object representing the stacked bar chart
#'
#' @details
#' The function creates a proportional stacked bar chart where each bar
#' represents 100% of the observations in that category level. The bars are
#' filled according to the subcategory proportions. Colors are assigned using
#' the dittoSeq color palette, which is designed for accessibility and
#' consistency with single-cell visualization tools.
#'
#' @importFrom dplyr mutate %>%
#' @importFrom ggplot2 ggplot aes geom_bar position_fill scale_fill_manual
#'   scale_y_continuous labs theme_classic theme element_text
#' @importFrom rlang .data :=
#' @importFrom scales percent_format
#'
#' @export
#'
#' @examples
#' # Basic usage with mpg dataset
#' library(dplyr)
#' library(ggplot2)
#'
#' # Vehicle class distribution by manufacturer
#' two_category_barplot(mpg,
#'                      category = "manufacturer",
#'                      subcategory = "class")
#'
#' # With custom title and legend
#' two_category_barplot(mpg,
#'                      category = "year",
#'                      subcategory = "manufacturer",
#'                      title = "Manufacturer Distribution by Year",
#'                      legend_title = "Manufacturer")
#'
#' # With a different palette
#' two_category_barplot(mpg,
#'                      category = "manufacturer",
#'                      subcategory = "class",
#'                      colors = colors_polychrome)
#'
#' # Cell type composition across samples (single-cell example)
#' \dontrun{
#' # Assuming seurat_obj is a Seurat object with metadata
#' metadata <- seurat_obj@meta.data
#' two_category_barplot(metadata,
#'                      category = "sample_id",
#'                      subcategory = "cell_type",
#'                      title = "Cell Type Composition Across Samples",
#'                      legend_title = "Cell Type")
#' }
two_category_barplot <- function(data, category, subcategory,
                                 title = "Percent stacked barchart",
                                 legend_title = NULL,
                                 colors = colors_ditto) {
  # Input validation
  if (!category %in% names(data)) stop("category not found in data")
  if (!subcategory %in% names(data)) stop("subcategory not found in data")

  # Factor conversion with explicit handling of existing factors
  data <- data %>%
    mutate({{category}} := factor(.data[[category]]),
           {{subcategory}} := factor(.data[[subcategory]]))

  # Recycle the palette to provide headroom for many subcategory levels
  palette <- rep(colors, 3)

  p <- data %>%
    ggplot(aes(x = .data[[category]], fill = .data[[subcategory]])) +
    geom_bar(position = position_fill(reverse = FALSE)) +
    scale_fill_manual(values = palette, name = legend_title) +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(title = title, y = "Proportion (%)", x = category) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

  return(p)
}

