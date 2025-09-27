#' Display R Environment Information
#'
#' This function provides a comprehensive overview of the current R environment,
#' including Bioconductor status, package versions, and library paths.
#'
#' @param local_lib Character string specifying the path to a local library
#'   to check for Seurat installation. Defaults to "~/projects/Seurat/packages".
#'
#' @return Invisibly returns NULL. The function is called for its side effects
#'   of printing environment information to the console.
#'
#' @details
#' The function checks and displays:
#' \itemize{
#'   \item Bioconductor installation validity
#'   \item Bioconductor version
#'   \item Library search paths
#'   \item Seurat version in default libraries
#'   \item Seurat version in specified local library (if it exists)
#'   \item Versions of select packages via \code{check_version_packages()}
#'   \item Current R version
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Display R environment info with default local library path
#' myRinfo()
#'
#' # Display R environment info with custom local library path
#' myRinfo(local_lib = "~/custom/lib/path")
#' }
#'
myRinfo <- function(local_lib = "~/projects/Seurat/packages") {

  if (requireNamespace("BiocManager", quietly = TRUE)) {
    message("\nIs Bioconductor valid?")
    print(suppressMessages(BiocManager::valid()))

    message("\nBioconductor version:")
    print(BiocManager::version())
  } else {
    message("\nBiocManager not available - skipping Bioconductor checks")
  }

  message("\nLibrary paths .libPaths():")
  print(.libPaths())

  message("\nSeurat version in .libpaths():")
  if (requireNamespace("Seurat", quietly = TRUE)) {
    print(utils::packageVersion('Seurat'))
  } else {
    print("Seurat not found in library paths")
  }

  message("\nChecking for Seurat in local library: ", local_lib)
  if (dir.exists(local_lib)) {
    tryCatch({
      res <- utils::packageDescription("Seurat", lib.loc = local_lib)
      print(paste0("Seurat version local: ", res[["Version"]]))
    }, error = function(e) {
      print(paste0("Seurat not found in local library: ", local_lib))
    })
  } else {
    print(paste0("Local library ", local_lib, " does not exist"))
  }

  message("\nVersion of select packages")
  check_version_packages()

  message("\nR version:")
  print(R.version.string)

  invisible(NULL)
}
