# Builds man/figures/logo.png: the Turquoise dial cut into a hexagon.
#
# Run from the package root, with the package installed: Rscript data-raw/logo.R

library(ggplot2)
library(bauhaus)

col <- bauhaus_colours("turquoise")
size <- 7 # inches; the hexagon is cut from the middle
res <- 64

dial <- bauhaus_clock("turquoise", hour_numerals = FALSE, minute_numerals = FALSE) +
  annotate("text",
    x = 0, y = -0.43, label = "bauhaus", colour = col[["numeral"]],
    family = bauhaus_font_family("semibold"), size = 17
  ) +
  coord_fixed(xlim = c(-1.16, 1.16), ylim = c(-1.16, 1.16), expand = FALSE)

file <- tempfile(fileext = ".png")
ggsave(file, dial, width = size, height = size, dpi = res, device = ragg::agg_png)
img <- png::readPNG(file)

# Pointy-topped hexagon inscribed in the square, with a border in the track ink.
n <- dim(img)[1]
height <- n
width <- round(height * sqrt(3) / 2)
x0 <- (n - width) / 2
out <- array(0, c(height, width, 4))
border <- 0.035 * height
track <- grDevices::col2rgb(col[["track"]]) / 255
cx <- width / 2
cy <- height / 2
r <- height / 2
inside <- function(px, py, rr) {
  dx <- abs(px - cx)
  dy <- abs(py - cy)
  dx <= rr * sqrt(3) / 2 & dy <= rr - dx / sqrt(3)
}
for (i in seq_len(height)) {
  py <- i - 0.5
  px <- seq_len(width) - 0.5
  outer <- inside(px, py, r - 1)
  inner <- inside(px, py, r - border)
  out[i, , 1:3] <- img[i, round(x0) + seq_len(width), 1:3]
  for (c in 1:3) out[i, outer & !inner, c] <- track[c]
  out[i, , 4] <- as.numeric(outer)
}
png::writePNG(out, "man/figures/logo.png")
