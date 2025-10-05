# tests/testthat/test-homology.R

test_that("getHomologousSymbols maintains input order and length", {
  skip_if_not_installed("orthogene")

  mouse_genes <- c("Trp53", "Brca1", "Pbsn")
  result <- getHomologousSymbols(mouse_genes, current = "mouse", target = "human")

  # Check that output has same number of rows as input
  expect_equal(nrow(result), length(mouse_genes))

  # Check that input order is preserved
  expect_equal(result$mouse, mouse_genes)

  # Check that genes without orthologs have empty strings
  expect_equal(result$human[3], "")

  # Correct column names
  expect_equal(colnames(result), c("mouse", "human"))

  # Returns a data frame
  expect_s3_class(result, "data.frame")

})

test_that("getHomologousSymbols works for human to mouse conversion", {
  skip_if_not_installed("orthogene")

  human_genes <- c("TP53", "BRCA1")
  result <- getHomologousSymbols(human_genes, current = "human", target = "mouse")

  expect_equal(nrow(result), length(human_genes))
  expect_equal(result$human, human_genes)
  expect_equal(colnames(result), c("human", "mouse"))
})

test_that("getHomologousSymbols handles all missing orthologs", {
  skip_if_not_installed("orthogene")

  # Using fake gene names that won't have orthologs
  fake_genes <- c("FAKEGENE1", "FAKEGENE2", "FAKEGENE3")
  result <- getHomologousSymbols(fake_genes, current = "mouse", target = "human")

  expect_equal(nrow(result), length(fake_genes))
  expect_equal(result$mouse, fake_genes)
  expect_true(all(result$human == ""))
})

test_that("getHomologousSymbols validates input", {
  skip_if_not_installed("orthogene")

  # Test empty vector
  expect_error(
    getHomologousSymbols(character(0)),
    "symbols must be a non-empty character vector"
  )

  # Test non-character input
  expect_error(
    getHomologousSymbols(c(1, 2, 3)),
    "symbols must be a non-empty character vector"
  )
})

