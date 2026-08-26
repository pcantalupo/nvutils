#!/usr/bin/env Rscript
# Load only optparse up front so --help and arg errors return fast; nvutils
# (and its dependencies) is loaded after validation passes.
pacman::p_load('optparse')

# Arguments
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL,
              help = "Input TSV file [required]"),
  make_option(c("-o", "--output"), type = "character", default = NULL,
              help = "Output XLSX path [default: input basename + .xlsx]"),
  make_option(c("-v", "--verbose"), action = "store_true", default = FALSE,
              help = "Print session_info() after writing")
)

parser <- OptionParser(option_list = option_list)
# positional_arguments = TRUE keeps getopt from erroring out on a bare
# argument, so leftovers are reported here with the full help instead
parsed <- parse_args(parser, positional_arguments = TRUE)
opt <- parsed$options

if (length(parsed$args) > 0) {
  print_help(parser)
  stop("unexpected argument(s): ", paste(parsed$args, collapse = ", "),
       "\n  all arguments must be given as named flags (see usage above)")
}

# Argument validation
if (is.null(opt$input)) {
  print_help(parser)
  stop("--input is required")
}
if (!file.exists(opt$input)) {
  stop("input file not found: ", opt$input)
}

# Load the package only after args validate
pacman::p_load('nvutils')

# Derive output path if not supplied
output <- opt$output
if (is.null(output)) {
  output <- paste0(tools::file_path_sans_ext(opt$input), ".xlsx")
}

# Convert TSV to XLSX
tsv2xlsx(opt$input, output, colClasses = "character", na.strings = NULL)

if (opt$verbose) {
  cat("\n\n")
  devtools::session_info()
}
