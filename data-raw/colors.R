# Polychrome colors (not colorblind friendly)
# set.seed(42); createPalette(25, c("#FF0000", "#00FF00", "#0000FF"), range = c(30, 80))
colors_polychrome = c(
  "#F60D16", "#00E416", "#001CFF", "#E9B9C4", "#FF0DEA",
  "#16CBFC", "#FD970D", "#008A5F", "#CB2271", "#CACD16",
  "#761C90", "#7F3B00", "#556E88", "#C626FF", "#F783D7",
  "#8D94F9", "#857F3D", "#C03200", "#89D76A", "#D8B5F5",
  "#FE9297", "#32DBD6", "#763556", "#F1BE69", "#AFCDC0")

# dittoSeq colors (colorblind friendly)
# https://github.com/dtm2451/dittoSeq/blob/v0.3/R/dittoColors.R#L57-L67
colors_ditto = c(
    "#E69F00", "#56B4E9", "#009E73", "#F0E442",
    "#0072B2", "#D55E00", "#CC79A7", "#666666",
    "#AD7700", "#1C91D4", "#007756", "#D5C711",
    "#005685", "#A04700", "#B14380", "#4D4D4D",
    "#FFBE2D", "#80C7EF", "#00F6B3", "#F4EB71",
    "#06A5FF", "#FF8320", "#D99BBD", "#8C8C8C",
    "#FFCB57", "#9AD2F2", "#2CFFC6", "#F6EF8E",
    "#38B7FF", "#FF9B4D", "#E0AFCA", "#A3A3A3",
    "#8A5F00", "#1674A9", "#005F45", "#AA9F0D",
    "#00446B", "#803800", "#8D3666", "#3D3D3D")


# Create RDA files for each color vector
usethis::use_data(colors_polychrome, colors_ditto, overwrite = TRUE)
