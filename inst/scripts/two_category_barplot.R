#!/usr/bin/env Rscript
# Load only optparse up front so --help and arg errors return fast; nvutils
# (and its ggplot2/dplyr deps) is loaded after validation passes.
pacman::p_load('optparse')

# Arguments
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL,
              help = "Input data file (.tsv, .txt, or .xlsx) [required]"),
  make_option(c("-c", "--category"), type = "character", default = NULL,
              help = "Column name for the main category (x-axis) [required]"),
  make_option(c("-s", "--subcategory"), type = "character", default = NULL,
              help = "Column name for the subcategory (fill) [required]"),
  make_option(c("-o", "--output"), type = "character", default = NULL,
              help = "Output PNG path [default: input basename + .png]"),
  make_option(c("-t", "--title"), type = "character",
              default = "Percent stacked barchart",
              help = "Plot title [default: %default]"),
  make_option(c("-l", "--legend-title"), type = "character", default = NULL,
              help = "Legend title [default: subcategory name]"),
  make_option("--colors", type = "character", default = "ditto",
              help = paste("Fill palette: ditto (colorblind-safe) or polychrome",
                           "(maximum visual separation) [default: %default]")),
  make_option("--theme", type = "character", default = "classic",
              help = paste("Base ggplot2 theme: grey (the ggplot2 default), gray,",
                           "bw, classic, minimal, light, dark, linedraw, void",
                           "[default: %default]")),
  make_option("--rotatex_angle", type = "double", default = 45,
              help = "X-axis label rotation angle in degrees [default: %default]"),
  make_option("--sheet", type = "integer", default = 1L,
              help = "Sheet number for xlsx input [default: %default]"),
  make_option("--width", type = "double", default = 7,
              help = "Plot width in inches [default: %default]"),
  make_option("--height", type = "double", default = 7,
              help = "Plot height in inches [default: %default]"),
  make_option("--dpi", type = "double", default = 300,
              help = "Plot resolution in dpi [default: %default]")
)

parser <- OptionParser(option_list = option_list)
opt <- parse_args(parser)

# Argument validation
if (is.null(opt$input) || is.null(opt$category) || is.null(opt$subcategory)) {
  print_help(parser)
  stop("--input, --category, and --subcategory are all required")
}
if (!file.exists(opt$input)) {
  stop("input file not found: ", opt$input)
}
valid_themes <- c("grey", "gray", "bw", "classic", "minimal",
                  "light", "dark", "linedraw", "void")
if (!opt$theme %in% valid_themes) {
  stop("unknown theme '", opt$theme, "'; choose one of: ",
       paste(valid_themes, collapse = ", "))
}
valid_palettes <- c("ditto", "polychrome")
if (!opt$colors %in% valid_palettes) {
  stop("unknown palette '", opt$colors, "'; choose one of: ",
       paste(valid_palettes, collapse = ", "))
}

# Load the heavy package only after args validate
pacman::p_load('nvutils')

# Resolve the palette name to the exported color vector
palette <- switch(opt$colors,
                  ditto = colors_ditto,
                  polychrome = colors_polychrome)

# Read input by extension
ext <- tolower(tools::file_ext(opt$input))
if (ext == "xlsx") {
  data <- openxlsx::read.xlsx(opt$input, sheet = opt$sheet)
} else if (ext %in% c("tsv", "txt", "")) {
  data <- data.table::fread(opt$input, data.table = FALSE)
} else {
  stop("unsupported input extension '", ext, "'; use .tsv, .txt, or .xlsx")
}

# Derive output path if not supplied
output <- opt$output
if (is.null(output)) {
  output <- paste0(tools::file_path_sans_ext(opt$input), ".png")
}

# Create the plot
p <- two_category_barplot(data,
                          category = opt$category,
                          subcategory = opt$subcategory,
                          title = opt$title,
                          legend_title = opt[["legend-title"]],
                          colors = palette)

# Apply base theme (when not classic) and x-label rotation. A complete theme
# replaces everything before it, so re-apply the rotation afterwards. The
# rotation is applied unconditionally so --rotatex_angle works with any theme.
if (opt$theme != "classic") {
  theme_fn <- get(paste0("theme_", opt$theme), envir = asNamespace("ggplot2"))
  p <- p + theme_fn()
}
p <- p + ggplot2::theme(
  axis.text.x = ggplot2::element_text(angle = opt$rotatex_angle,
                                      hjust = 1, vjust = 1))

# Save the plot
ggplot2::ggsave(filename = output, plot = p,
                width = opt$width, height = opt$height, dpi = opt$dpi)

cat("Wrote plot to", output, "\n")
