#!/usr/bin/env Rscript
pacman::p_load('nvutils')

args = commandArgs(trailingOnly = TRUE)
file = args[1]
outfile = args[2]

xlsx2tsv(file, outfile)


cat("\n\n")
devtools::session_info()
