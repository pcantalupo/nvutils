#!/usr/bin/env Rscript
pacman::p_load('nvutils')

args = commandArgs(trailingOnly = TRUE)
file = args[1]
outfile = args[2]
guess_max = args[3]
show_col_types = args[4]

if (is.na(guess_max)) {
  guess_max = 1000        # same default as readr:read_tsv
} else if (guess_max == "Inf") {
  guess_max = Inf
} else { guess_max = as.integer(guess_max) }

if (is.na(show_col_types)) {
  show_col_types = NULL   # same default as readr::read_tsv
}


tsv2xlsx(file, outfile, guess_max = guess_max, show_col_types = show_col_types)


cat("\n\n")
devtools::session_info()
