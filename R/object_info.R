#' @title Information about an R object
#' @description
#' Get information about an R object such as class, typeof, etc...
#'
#' @param obj An R object
#'
#' @return Nothing
#' @export
#' @importFrom methods is
#'
#' @examples
#' object_info("hello")
#' object_info(mtcars)
object_info = function(obj) {
  if(missing(obj)) {
    stop("obj param is missing")
  }
  message("is()"); print(is(obj))
  message("\nclass()"); print(class(obj))
  message("\ntypeof()"); print(typeof(obj))
  message("\nattributes()"); print(attributes(obj))
}


