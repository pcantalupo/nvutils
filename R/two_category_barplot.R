#' Create a Two-Category Stacked Bar Plot
#'
#' Generates a 100% stacked bar chart showing the proportional breakdown of a
#' subcategory within each level of a main category. Uses the dittoSeq color
#' palette for consistent visualization.
#'
#' @param data A data frame containing the variables to plot
#' @param category Character string specifying the column name for the main
#'   category (x-axis). Will be converted to a factor if not already. A
#'   character column is ordered naturally with \code{gtools::mixedsort()}, so
#'   "c2" comes before "c10". A factor keeps its level order.
#' @param subcategory Character string specifying the column name for the
#'   subcategory (fill variable). Will be converted to a factor if not already,
#'   ordered the same way as \code{category}. NA values are drawn grey50.
#' @param title Character string for the plot title. Default is
#'   "Percent stacked barchart".
#' @param legend_title Character string for the legend title. If NULL (default),
#'   uses the subcategory variable name.
#' @param colors A character vector of hex color codes for the fill scale.
#'   Defaults to \code{colors_ditto}, the exported 40-color dittoSeq/Okabe-Ito
#'   palette. The palette repeats when there are more subcategory levels than
#'   colors. Any color vector works, e.g. \code{colors_polychrome}.
#' @param match How \code{colors} are assigned to subcategory levels.
#'   \code{"position"} (default): the nth level in the plot gets the nth color,
#'   so a level shifts color when an earlier level is absent from the data.
#'   \code{"name"}: colors are assigned over the full level set of the
#'   subcategory (factor levels including unused ones, else a natural sort of
#'   the values with \code{gtools::mixedsort()}) and matched by level name, so
#'   a level keeps one color across runs and subsets. Any names on
#'   \code{colors} are replaced.
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
#' @importFrom dplyr mutate across all_of %>%
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
                                 colors = colors_ditto,
                                 match = c("position", "name")) {
  match = match.arg(match)

  # Input validation
  if (!category %in% names(data)) stop("category not found in data")
  if (!subcategory %in% names(data)) stop("subcategory not found in data")

  # Full subcategory level set (unused factor levels included), read before
  # factor() drops unused levels. match = "name" assigns colors over this set.
  if (match == "name") {
    x = data[[subcategory]]
    if (is.factor(x)) {
      all_levels = levels(x)
    } else {
      all_levels = gtools::mixedsort(unique(as.character(x[!is.na(x)])))
    }
  }

  # Convert both columns to factors, read from the inside out:
  # 1. .x[!is.na(.x)]: the non-missing values
  # 2. unique(...): each value once
  # 3. gtools::mixedsort(...): natural order, so "c2" comes before "c10"
  # 4. factor(.x, levels = ...): a character column gets that natural order.
  #    It is the same order match = "name" uses for colors.
  # Other columns use factor(.x): a factor keeps its level order, and numbers
  # sort by value.
  # factor() drops unused levels. NA stays missing and is drawn grey50.
  data <- data %>%
    mutate(across(all_of(c(category, subcategory)),
                  ~ if (is.character(.x)) factor(.x, levels = gtools::mixedsort(unique(.x[!is.na(.x)]))) else factor(.x)))

  if (match == "name") {
    palette = rep(colors, length.out = length(all_levels))
    names(palette) = all_levels
  } else {
    # One color per level in the plot, repeating the palette when there are
    # more levels than colors
    palette <- rep(colors, length.out = nlevels(data[[subcategory]]))
  }

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

