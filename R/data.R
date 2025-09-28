#' Single cell RNAseq metadata from Segerstolpe Pancreas Data
#'
#' A subset of data from the Segerstolpe Pancreas Data. Four donors were removed to
#' simplify the data. 3 normal and 3 disease donors remain. Donor id is converted into a
#' 'sample' id (i.e. C1, D1) to signify normal (i.e. control) or disease. Note: there is
#' no cluster metadata.
#'
#' @format
#' A data.frame with 2,269 rows and 7 columns:
#' \describe{
#'   \item{donor}{The donor id (6 unique donors) (chr)}
#'   \item{sample}{Donor id is converted to C1, C2, and C3 for the normal donors and D1, D2, D3 for disease donors (chr)}
#'   \item{disease}{Disease status. Either 'normal' or 'type II diabetes mellitus' (chr)}
#'   \item{celltype}{The celltype of the cell (n = 14). Contains <NA>. (chr)}
#'   \item{sex}{Donor sex (chr)}
#'   \item{age}{Donor age (int)}
#'   \item{body_mass_index}{Donor BMI (num)}
#' }
#' @references Bioconductor scRNAseq package <https://bioconductor.org/packages/release/data/experiment/html/scRNAseq.html>
#' @references Segerstolpe A et al. (2016). Single-cell transcriptome profiling of
#' human pancreatic islets in health and type 2 diabetes. Cell Metab. 24(4), 593-607.
"sctdata"

#' Polychrome color palette (visual impact over colorblind accessibility)
#'
#' Philosophy: Maximizes perceptual distance between colors using algorithmic methods.
#' \itemize{
#'   \item Uses computational optimization to create colors as visually distinct as possible
#'   \item Starts from RGB primaries and creates maximum separation in color space
#'   \item Prioritizes visual impact and distinctness over colorblind accessibility
#'   \item More saturated/vibrant colors for high visual contrast
#'   \item Generated algorithmically rather than hand-curated
#'   \item Best for: When you need maximum color separation and colorblind accessibility is not primary concern
#' }
#'
#' @format A character vector of 25 hex color codes
#' @source Created with Polychrome::createPalette(25, c("#FF0000", "#00FF00", "#0000FF"), range = c(30, 80))
"colors_polychrome"

#' dittoSeq/Okabe-Ito (colorblind safe)
#'
#' Philosophy: Accessibility-first design optimized for scientific visualization.
#' \itemize{
#'   \item Based on Okabe-Ito colorblind-safe palette (first 8 colors)
#'   \item Specifically designed to be distinguishable by people with common colorblindness
#'   \item Extends base 8 colors through systematic brightness variations (-40%, -25%, +25%, +40%)
#'   \item Perceptually balanced colors with similar visual weights
#'   \item Maintains accessibility properties across all brightness levels
#'   \item Professional, publication-ready appearance suitable for scientific contexts
#'   \item Optimized for complex multi-group genomics visualizations (e.g., 20+ cell types)
#'   \item Prioritizes inclusivity and clarity over visual impact
#'   \item Best for: Scientific publications, collaborative research, colorblind-accessible visualizations
#' }
#'
#' @format A character vector of 40 hex color codes
#' @source \url{https://github.com/dtm2451/dittoSeq/blob/v0.3/R/dittoColors.R#L57-L67}
"colors_ditto"


