test_that("set_operations returns correct set operations", {
  set1 <- 1:5
  set2 <- 4:8
  result <- set_operations(list(set1, set2))

  expect_equal(result$len_set1, 5)
  expect_equal(result$len_set2, 5)
  expect_equal(result$intersectlen, 2)
  expect_equal(result$intersect, c(4, 5))
  expect_equal(result$unionlen, 8)
  expect_equal(result$union, 1:8)
  expect_equal(result$setdiff_set1_vs_set2_len, 3)
  expect_equal(result$setdiff_set1_vs_set2, c(1, 2, 3))
  expect_equal(result$setdiff_set2_vs_set1_len, 3)
  expect_equal(result$setdiff_set2_vs_set1, c(6, 7, 8))
})

test_that("set_operations handles named lists appropriately", {
  set1 <- 1:5
  set2 <- 4:8
  result <- set_operations(list(first = set1, second = set2))

  expect_equal(result$len_first, 5)
  expect_equal(result$len_second, 5)
  expect_equal(result$setdiff_first_vs_second, c(1, 2, 3))
  expect_equal(result$setdiff_second_vs_first, c(6, 7, 8))
})

test_that("set_operations max_show parameter works correctly", {
  set1 <- 1:10
  set2 <- 6:15
  max_show_value <- 3

  result <- set_operations(list(set1, set2), max_show = max_show_value)

  # Test if the number of elements shown for intersection and union is limited by max_show
  expect_length(result$intersect, max_show_value)
  expect_length(result$union, max_show_value)

  # Test if the lengths of intersection and union are still correctly calculated
  expect_equal(result$intersectlen, 5) # The actual intersection has 5 elements (6, 7, 8, 9, 10)
  expect_equal(result$unionlen, 15)    # The actual union has 15 elements
})

test_that("set_operations max_show parameter handles large values correctly", {
  set1 <- 1:10
  set2 <- 6:15
  max_show_value <- Inf

  result <- set_operations(list(set1, set2), max_show = max_show_value)

  # Test if all elements are shown when max_show is larger than the actual number of elements
  expect_length(result$intersect, 5) # The actual intersection has 5 elements
  expect_length(result$union, 15)    # The actual union has 15 elements
})


test_that("max_setdiff_show parameter works correctly", {
  set1 <- 1:10
  set2 <- 6:20
  max_setdiff_show_value <- 3

  result <- set_operations(list(set1, set2), max_setdiff_show = max_setdiff_show_value)

  # Test if the number of elements shown for set differences is limited by max_setdiff_show
  expect_length(result$setdiff_set1_vs_set2, max_setdiff_show_value)
  expect_length(result$setdiff_set2_vs_set1, max_setdiff_show_value)

  # Test if the lengths of set differences are still correctly calculated
  expect_equal(result$setdiff_set1_vs_set2_len, 5) # The actual set difference has 5 elements 1:5
  expect_equal(result$setdiff_set2_vs_set1_len, 10) # The actual set difference has 10 elements 11:20
})

test_that("set_operations handles empty sets", {
  set1 <- integer(0)  # Empty set
  set2 <- 1:3
  result <- set_operations(list(set1, set2))

  expect_equal(result$len_set1, 0)
  expect_equal(result$len_set2, 3)
  expect_equal(result$intersectlen, 0)
  expect_equal(result$intersect, integer(0))
  expect_equal(result$unionlen, 3)
  expect_equal(result$union, 1:3)
  expect_equal(result$setdiff_set1_vs_set2_len, 0)
  expect_equal(result$setdiff_set1_vs_set2, integer(0))
  expect_equal(result$setdiff_set2_vs_set1_len, 3)
  expect_equal(result$setdiff_set2_vs_set1, 1:3)
})

test_that("set_operations handles single-element sets", {
  set1 <- 5
  set2 <- 5
  result <- set_operations(list(set1, set2))

  expect_equal(result$intersect, 5)
  expect_equal(result$union, 5)
  expect_equal(result$setdiff_set1_vs_set2, integer(0))
  expect_equal(result$setdiff_set2_vs_set1, integer(0))
})

test_that("set_operations errors on invalid input", {
  expect_error(set_operations(NULL), "requires a list")
  expect_error(set_operations(list(1:5)), "list of length 2")
  expect_error(set_operations(list(1:5, 6:10), category_names = c("A")),
               "category_names must be a vector of length 2")
})



