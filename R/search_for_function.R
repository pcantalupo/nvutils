#' Search for Functions in a Package
#'
#' Search for functions matching a pattern within a specified R package.
#' Uses namespace loading to avoid attaching the package to the search path.
#'
#' @param query Character string or regular expression pattern to search for.
#'   Case-insensitive by default.
#' @param package Character string specifying the package name to search within.
#' @param ignore.case Logical. Should pattern matching be case-insensitive?
#'   Default is TRUE.
#' @param load_only Logical. If TRUE, only loads the namespace without attaching
#'   the package. If FALSE, uses require() to attach the package. Default is TRUE.
#'
#' @return Character vector of matching function names. Returns character(0) if
#'   no matches found or if package cannot be loaded.
#'
#' @examples
#' \dontrun{
#' # Search for "Find" functions in Seurat
#' search_for_function("Find", "Seurat")
#'
#' # Search for functions ending in "Plot"
#' search_for_function("Plot$", "Seurat")
#'
#' # Case-sensitive search
#' search_for_function("UMAP", "Seurat", ignore.case = FALSE)
#' }
#'
#' @export
search_for_function <- function(query, package, ignore.case = TRUE, load_only = TRUE) {
  # Input validation
  if (!is.character(query) || length(query) != 1) {
    stop("'query' must be a single character string")
  }

  if (!is.character(package) || length(package) != 1) {
    stop("'package' must be a single character string")
  }

  # Check if package is installed
  if (!requireNamespace(package, quietly = TRUE)) {
    warning(sprintf("Package '%s' is not installed or cannot be loaded", package))
    return(character(0))
  }

  # Load package namespace or attach package
  if (load_only) {
    # Load namespace only (doesn't attach to search path)
    tryCatch({
      loadNamespace(package)
      pkg_functions <- ls(asNamespace(package))
    }, error = function(e) {
      warning(sprintf("Could not load namespace for package '%s': %s",
                      package, e$message))
      return(character(0))
    })
  } else {
    # Attach package to search path
    if (!require(package, character.only = TRUE, quietly = TRUE)) {
      warning(sprintf("Could not load package '%s'", package))
      return(character(0))
    }
    pkg_functions <- ls(sprintf("package:%s", package))
  }

  # Search for matching functions
  matches <- grep(query, pkg_functions, value = TRUE, ignore.case = ignore.case)

  return(matches)
}


#' Search for Functions Across Multiple Packages
#'
#' Convenience wrapper to search for functions across multiple packages at once.
#'
#' @param query Character string or regular expression pattern to search for.
#' @param packages Character vector of package names to search within.
#' @param ignore.case Logical. Should pattern matching be case-insensitive?
#'   Default is TRUE.
#' @param load_only Logical. If TRUE, only loads namespaces. Default is TRUE.
#'
#' @return Named list where each element contains matching function names from
#'   that package. Only packages with matches are included in the output.
#'
#' @examples
#' \dontrun{
#' # Search common genomics packages
#' search_multiple_packages("FindMarkers", c("Seurat", "SingleCellExperiment"))
#'
#' # Search for plotting functions
#' genomics_pkgs <- c("Seurat", "dittoSeq", "scater")
#' search_multiple_packages("plot", genomics_pkgs)
#' }
#'
#' @export
search_multiple_packages <- function(query, packages, ignore.case = TRUE, load_only = TRUE) {
  results <- list()

  for (pkg in packages) {
    matches <- search_for_function(query, pkg, ignore.case, load_only)
    if (length(matches) > 0) {
      results[[pkg]] <- matches
    }
  }

  return(results)
}



#' Search Common Genomics Packages for Functions
#'
#' Pre-configured search across commonly used genomics/bioinformatics packages.
#'
#' @param query Character string or regular expression pattern to search for.
#' @param ignore.case Logical. Should pattern matching be case-insensitive?
#'   Default is TRUE.
#' @param additional_packages Character vector of additional package names to
#'   search beyond the default set.
#'
#' @return Named list where each element contains matching function names from
#'   that package. Only packages with matches are included in the output.
#'
#' @examples
#' \dontrun{
#' # Search for differential expression functions
#' search_genomics_packages("differential")
#'
#' # Search for UMAP functions
#' search_genomics_packages("UMAP")
#' }
#'
#' @export
search_genomics_packages <- function(query, ignore.case = TRUE, additional_packages = NULL) {
  # Default genomics packages to search
  default_packages <- c(
    "Seurat", "Signac",
    "BiocGenerics", "SummarizedExperiment", "SingleCellExperiment", "SpatialExperiment", "Biobase",
    "DESeq2", "edgeR", "limma", "scater", "scran",
    "GeomxTools", "NanoStringNCTools",
    "GenomicRanges", "IRanges", "S4Vectors",
    "rtracklayer", "Biostrings", "GenomicAlignments", "GenomicFeatures",
    "AnnotationDbi", "biomaRt", "GenomeInfoDb", "AnnotationHub", "ExperimentHub"
  )
  packages <- unique(c(default_packages, additional_packages))

  # Only search installed packages
  installed_pkgs <- rownames(installed.packages())
  packages <- intersect(packages, installed_pkgs)

  if (length(packages) == 0) {
    warning("None of the genomics packages are installed")
    return(list())
  }

  search_multiple_packages(query, packages, ignore.case, load_only = TRUE)
}

