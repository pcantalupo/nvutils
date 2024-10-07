#' Perform Set Operations on Two Elements of a List
#'
#' This function takes a list of two elements and performs set operations
#' (intersection, union, and set difference) on these elements. It allows
#' controlling the output length for intersection, union, and set difference
#' results.
#'
#' @param x A list containing exactly two elements to perform set operations on.
#' @param category_names Optional character vector of length 2 specifying the
#' names to be assigned to the elements of \code{x}. If \code{NULL}, default
#' names "set1" and "set2" are used.
#' @param max_show Maximum number of items to show for the intersection and
#' union results. If the actual number of items is more than \code{max_show},
#' only the first \code{max_show} items are displayed.
#' @param max_setdiff_show Maximum number of items to show for set difference
#' results. Similar to \code{max_show}, but applies to set differences.
#'
#' @return A list containing the lengths and actual values (subject to
#' \code{max_show} and \code{max_setdiff_show}) for each of the set operations
#' (intersection, union, set difference of set1 from set2, and set difference
#' of set2 from set1).
#' @export
#'
#' @examples
#' set1 <- letters[1:5]
#' set2 <- letters[3:8]
#' results <- set_operations(list(set1, set2))
#' results
set_operations = function (x, category_names = NULL, max_show = 10,
                           max_setdiff_show = Inf) {
  if (!is.list(x) || length(x) != 2) {
    stop("set_operations() requires a list of length 2")
  }

  # Use the names of list 'x' if they exist, or use category_names or default names
  if (!is.null(names(x))) {
    category_names = names(x)
  } else if (is.null(category_names)) {
    category_names = c("set1", "set2")
    names(x) <- category_names
  } else {
    if (length(category_names) != 2) {
      stop("category_names must be a vector of length 2.")
    }
    names(x) <- category_names
  }

  # Calculate set operations
  set1 = x[[category_names[1]]]
  set2 = x[[category_names[2]]]

  i = intersect(set1, set2)
  ilen = length(i)
  if (ilen > max_show) {
    message("Only showing the first ", max_show, " intersection values")
    i = i[1:max_show]
  }

  u = union(set1, set2)
  ulen = length(u)
  if (ulen > max_show) {
    message("Only showing the first ", max_show, " union values")
    u = u[1:max_show]
  }

  sdname12 = paste0("setdiff_",   paste(category_names, collapse = "_vs_"))
  sdname12len = paste0(sdname12, "_len")
  sdname21 = paste0("setdiff_",   paste(rev(category_names), collapse = "_vs_"))
  sdname21len = paste0(sdname21, "_len")

  sd1 = setdiff(set1, set2)
  sd1len = length(sd1)
  if (sd1len > max_setdiff_show) {
    message("Only showing the first ", max_setdiff_show, " ", sdname12, " setdiff values")
    sd1 = sd1[1:max_setdiff_show]
  }

  sd2 = setdiff(set2, set1)
  sd2len = length(sd2)
  if (sd2len > max_setdiff_show) {
    message("Only showing the first ", max_setdiff_show, " ", sdname21, " setdiff values")
    sd2 = sd2[1:max_setdiff_show]
  }

  # Put results in a list
  result = list(length(set1),
                length(set2),
                ilen, i,
                ulen, u,
                sd1len, sd1,
                sd2len, sd2
                )

  # Determine names for the results list
  listnames = c(paste0("len_", category_names[1]),
                paste0("len_", category_names[2]),
                "intersectlen", "intersect",
                "unionlen", "union",
                sdname12len, sdname12,
                sdname21len, sdname21)
  names(result) = listnames

  return(result)
}


