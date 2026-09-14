test_that("two_category_barplot.R accepts xlsx column names containing spaces", {
  infile = withr::local_file("barplot_space_in.xlsx")
  outfile = withr::local_file("barplot_space_out.png")
  df = data.frame(`sample id` = c("s1", "s1", "s2"),
                  `cell type` = c("a", "b", "a"), check.names = FALSE)
  openxlsx::write.xlsx(df, file = infile)
  script = system.file("scripts", "two_category_barplot.R", package = "nvutils")

  status = system2(file.path(R.home("bin"), "Rscript"),
                   c(script, "--input", infile, "--output", outfile,
                     "--category", shQuote("sample id"),
                     "--subcategory", shQuote("cell type")),
                   stdout = FALSE, stderr = FALSE)
  expect_equal(status, 0)
  expect_true(file.exists(outfile))
})
