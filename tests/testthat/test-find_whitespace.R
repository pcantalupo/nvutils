test_that("find_whitespace correctly identifies leading and trailing whitespace", {
  # Test data frame with various whitespace scenarios
  df <- data.frame(
    col1 = c(" bad", "bad  ", " bad "),
    col2 = c("good", "good", "good"),
    col3 = c("has space here", "no problem", "also fine"),  # spaces in middle
    col4 = factor(c("good", " bad", "good")),  # factor column
    col5 = c(1, 2, 3),  # numeric column
    col6 = c("", " ", "  "),  # empty and whitespace-only strings
    stringsAsFactors = FALSE
  )

  result <- find_whitespace(df)

  # Test basic functionality
  expect_type(result, "list")
  expect_named(result)

  # Test col1 (leading and trailing whitespace)
  expect_true("col1" %in% names(result))
  expect_length(result$col1, 3)  # Should find 3 problematic values
  expect_true(all(c("Row1", "Row2", "Row3") == names(result$col1)))

  # Test col2 (no whitespace issues)
  expect_false("col2" %in% names(result))

  # Test col3 (internal spaces should not be flagged)
  expect_false("col3" %in% names(result))

  # Test col4 (factor column with whitespace)
  expect_true("col4" %in% names(result))
  expect_length(result$col4, 1)

  # Test col5 (numeric column should be ignored)
  expect_false("col5" %in% names(result))

  # Test col6 (empty and whitespace-only strings)
  expect_true("col6" %in% names(result))
  expect_length(result$col6, 2)  # Should find the " " and "  " but not ""
})

test_that("find_whitespace handles edge cases correctly", {
  # Empty data frame
  empty_df <- data.frame(stringsAsFactors = FALSE)
  expect_null(find_whitespace(empty_df))

  # Data frame with no character columns
  numeric_df <- data.frame(
    a = c(1, 2, 3),
    b = c(4, 5, 6),
    stringsAsFactors = FALSE
  )
  expect_null(find_whitespace(numeric_df))

  # Data frame with all NA values
  na_df <- data.frame(
    a = c(NA, NA, NA),
    b = c(NA, "good", NA),
    stringsAsFactors = FALSE
  )
  expect_null(find_whitespace(na_df))

  # Data frame with mixed NA and whitespace values
  mixed_df <- data.frame(
    a = c(NA, " bad", NA),
    b = c("bad ", NA, "good"),
    stringsAsFactors = FALSE
  )
  result <- find_whitespace(mixed_df)
  expect_length(result, 2)
  expect_true(all(c("a", "b") %in% names(result)))
})
