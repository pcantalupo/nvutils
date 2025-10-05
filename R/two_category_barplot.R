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
#' @importFrom dplyr mutate
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
                                 legend_title = NULL) {
  # Input validation
  if (!category %in% names(data)) stop("category not found in data")
  if (!subcategory %in% names(data)) stop("subcategory not found in data")

  # Factor conversion with explicit handling of existing factors
  data <- data %>%
    mutate({{category}} := factor(.data[[category]]),
           {{subcategory}} := factor(.data[[subcategory]]))

  dittocolors <- rep(
    c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
      "#0072B2", "#D55E00", "#CC79A7", "#666666",
      "#AD7700", "#1C91D4", "#007756", "#D5C711",
      "#005685", "#A04700", "#B14380", "#4D4D4D",
      "#FFBE2D", "#80C7EF", "#00F6B3", "#F4EB71",
      "#06A5FF", "#FF8320", "#D99BBD", "#8C8C8C",
      "#FFCB57", "#9AD2F2", "#2CFFC6", "#F6EF8E",
      "#38B7FF", "#FF9B4D", "#E0AFCA", "#A3A3A3",
      "#8A5F00", "#1674A9", "#005F45", "#AA9F0D",
      "#00446B", "#803800", "#8D3666", "#3D3D3D"), 3)

  p <- data %>%
    ggplot(aes(x = .data[[category]], fill = .data[[subcategory]])) +
    geom_bar(position = position_fill(reverse = FALSE)) +
    scale_fill_manual(values = dittocolors, name = legend_title) +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(title = title, y = "Proportion (%)", x = category) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

  return(p)
}

