#!/usr/bin/env Rscript
pacman::p_load('nvutils')

args = commandArgs(trailingOnly=TRUE)
file1 = args[1]
file2  = args[2]

waldo_compare_files(file1, file2)


cat("\n\n")
devtools::session_info()
