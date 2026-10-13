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

test_that("two_category_barplot.R --palette sccustomize fills bars with scCustomize colors", {
  skip_if_not_installed("scCustomize")
  skip_if_not_installed("png")
  infile = withr::local_file("barplot_sccustomize_in.tsv")
  outfile = withr::local_file("barplot_sccustomize_out.png")
  df = data.frame(sample = c("s1", "s1", "s1"), celltype = c("a", "b", "c"))
  readr::write_tsv(df, infile)
  script = system.file("scripts", "two_category_barplot.R", package = "nvutils")

  status = system2(file.path(R.home("bin"), "Rscript"),
                   c(script, "--input", infile, "--output", outfile,
                     "--category", "sample", "--subcategory", "celltype",
                     "--palette", "sccustomize"),
                   stdout = FALSE, stderr = FALSE)
  expect_equal(status, 0)

  img = png::readPNG(outfile)
  pixel_colors = unique(rgb(img[, , 1], img[, , 2], img[, , 3]))
  expected = scCustomize::scCustomize_Palette(num_groups = 3, ggplot_default_colors = FALSE)
  expected = rgb(t(col2rgb(expected)), maxColorValue = 255)
  expect_true(all(expected %in% pixel_colors))
  expect_false(any(rgb(t(col2rgb(colors_ditto[1:3])), maxColorValue = 255) %in% pixel_colors))
})

test_that("match = 'position' gives the nth level in the plot the nth color", {
  df = data.frame(sample = "s1",
                  celltype = factor(c("a", "c"), levels = c("a", "b", "c")))
  p = two_category_barplot(df, "sample", "celltype")
  ld = ggplot2::layer_data(p)
  expect_equal(ld$fill[order(ld$group)], colors_ditto[1:2])
})

test_that("match = 'name' keeps a level's color when another level is absent", {
  df = data.frame(sample = "s1",
                  celltype = factor(c("a", "c"), levels = c("a", "b", "c")))
  p = two_category_barplot(df, "sample", "celltype", match = "name")
  ld = ggplot2::layer_data(p)
  expect_equal(ld$fill[order(ld$group)], colors_ditto[c(1, 3)])
})

test_that("character columns are ordered naturally, so name and position agree", {
  df = data.frame(sample = c("s10", "s2", "s10"), celltype = c("c10", "c2", "c1"))
  p = two_category_barplot(df, "sample", "celltype")
  expect_equal(levels(p$data$celltype), c("c1", "c2", "c10"))
  expect_equal(levels(p$data$sample), c("s2", "s10"))

  # One sample, so layer_data() has one group per celltype level, in level order
  df = data.frame(sample = "s1", celltype = c("c10", "c2", "c1"))

  ld = ggplot2::layer_data(two_category_barplot(df, "sample", "celltype", match = "position"))
  expect_equal(ld$fill[order(ld$group)], colors_ditto[1:3])

  ld = ggplot2::layer_data(two_category_barplot(df, "sample", "celltype", match = "name"))
  expect_equal(ld$fill[order(ld$group)], colors_ditto[1:3])
})

test_that("match = 'position' repeats the palette for more levels than colors", {
  # 76 levels with the 25-color polychrome palette (more than 3 x 25)
  df = data.frame(sample = "s1", celltype = paste0("L", 1:76))
  ld = ggplot2::layer_data(two_category_barplot(df, "sample", "celltype", colors = colors_polychrome))
  expect_equal(ld$fill[order(ld$group)], rep(colors_polychrome, length.out = 76))
})

test_that("NA subcategory values are drawn grey50", {
  df = data.frame(sample = "s1", celltype = c("a", NA, "b"))

  ld = ggplot2::layer_data(two_category_barplot(df, "sample", "celltype", match = "position"))
  expect_equal(ld$fill[order(ld$group)], c(colors_ditto[1:2], "grey50"))

  ld = ggplot2::layer_data(two_category_barplot(df, "sample", "celltype", match = "name"))
  expect_equal(ld$fill[order(ld$group)], c(colors_ditto[1:2], "grey50"))
})

test_that("match = 'position' uses a named palette as given", {
  # Unused level "b", palette named over all 7 levels (nvutils#10)
  df = data.frame(sample = "s1",
                  celltype = factor(c("a", "c", "d", "e", "f", "g"),
                                    levels = c("a", "b", "c", "d", "e", "f", "g")))
  pal = setNames(colors_ditto[1:7], levels(df$celltype))
  ld = ggplot2::layer_data(two_category_barplot(df, "sample", "celltype", colors = pal))
  expect_equal(ld$fill[order(ld$group)], unname(pal[c("a", "c", "d", "e", "f", "g")]))
})
