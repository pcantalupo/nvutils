test_that("peek returns 2 rows and 3 cols", {
  # checking that the last print() in peek returns the correct value
  expect_equal(peek(mtcars, row = 2, col = 3),
               structure(list(mpg = c(21, 21), cyl = c(6, 6), disp = c(160, 160)),
                         row.names = c("Mazda RX4", "Mazda RX4 Wag"), class = "data.frame"))
})

