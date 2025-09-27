#' Check Versions of Key Bioinformatics Packages
#'
#' This function checks and displays the version information for a predefined
#' set of commonly used bioinformatics and data analysis packages.
#'
#' @param packages Character vector of package names to check. If NULL (default),
#'   uses a predefined list of common bioinformatics packages.
#'
#' @return Invisibly returns a named character vector where names are package
#'   names and values are version strings (including GitHub SHA1 when available).
#'   Packages that are not installed will have "NOT INSTALLED" as their value.
#'
#' @details
#' The function checks the following information for each package:
#' \itemize{
#'   \item Package version number
#'   \item GitHub SHA1 commit hash (if available, truncated to 8 characters)
#'   \item Installation status
#' }
#'
#' The default package list includes commonly used packages in single-cell
#' genomics and bioinformatics workflows such as Seurat, scran, scater,
#' and various Bioconductor packages.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Check default package list
#' check_version_packages()
#'
#' # Check specific packages
#' check_version_packages(c("Seurat", "ggplot2", "dplyr"))
#' }
check_version_packages <- function(packages = NULL) {
  
  if (is.null(packages)) {
    packages <- sort(c(
      "batchelor", "bluster", "BiocParallel", "celldex", "DelayedArray", 
      "dittoSeq", "dplyr", "DropletUtils", "foobar", "ggplot2", "gridExtra", 
      "Matrix", "monocle3", "nvutils", "PCAtools", "pheatmap", "rlang", 
      "scater", "scran", "sct2", "Seurat", "SeuratObject", "SingleR"
    ))
  }
  
  version_info <- character(length(packages))
  names(version_info) <- packages
  
  for (pkg in packages) {
    desc <- suppressWarnings(
      utils::packageDescription(pkg, fields = c("Version", "GithubSHA1"))
    )
    
    if (!is.list(desc)) {   # desc is NA if package is not installed
      desc <- list(Version = "NOT INSTALLED", GithubSHA1 = NA)
    }
    
    # Truncate SHA1 to first 8 characters if it is not NA
    if (!is.na(desc$GithubSHA1)) { 
      desc$GithubSHA1 <- substr(desc$GithubSHA1, 1, 8) 
    }
    
    to_print <- paste0(pkg, ": ", desc$Version)
    if (!is.na(desc$GithubSHA1)) {
      to_print <- paste0(to_print, ", SHA1:", desc$GithubSHA1)
    }
    
    version_info[pkg] <- desc$Version
    print(to_print)
  }
  
  invisible(version_info)
}

