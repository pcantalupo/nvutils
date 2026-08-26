#!/usr/bin/env Rscript
# Load only optparse up front so --help and arg errors return fast; nvutils
# (and its dependencies) is loaded after validation passes.
pacman::p_load('optparse')

# Arguments
option_list <- list(
  make_option("--file1", type = "character", default = NULL,
              help = "First file to compare [required]"),
  make_option("--file2", type = "character", default = NULL,
              help = "Second file to compare [required]")
)

parser <- OptionParser(option_list = option_list)
opt <- parse_args(parser)

# Argument validation
if (is.null(opt$file1) || is.null(opt$file2)) {
  print_help(parser)
  stop("--file1 and --file2 are both required")
}
for (f in c(opt$file1, opt$file2)) {
  if (!file.exists(f)) {
    stop("file not found: ", f)
  }
}

# Load the package only after args validate
pacman::p_load('nvutils')

waldo_compare_files(opt$file1, opt$file2)

cat("\n\n")
devtools::session_info()
