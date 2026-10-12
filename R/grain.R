#' Paper grain theme element
#'
#' A rectangle theme element, like [ggplot2::element_rect()], whose fill carries the fine paper grain
#' of the Bauhaus Clock screensaver. The themes use it for `plot.background`, so the grain runs
#' under the whole plot, panels and legends included, the way the screensaver lays it under the
#' whole screen.
#'
#' The grain is the screensaver's own: the same 512 x 512 seamless tile, generated from the same
#' seed and passed through the same measured 7 x 5 kernel, which gives a zero-mean grain made of
#' short horizontal streaks, with no mottling or fibres. It is added equally to the red, green and
#' blue channels of `fill`, with standard deviation `sigma` in 8-bit code values, and drawn at a
#' fixed physical size, so it looks the same however large the plot is.
#'
#' The grain is drawn as a raster image when the plot is rendered, so it works on every graphics
#' device. Raster images make vector files (PDF, SVG) larger; set `options(bauhaus.grain = FALSE)`
#' to draw every grained background as a flat fill instead.
#'
#' Adding a plain [ggplot2::element_rect()] on top of an `element_grain()` keeps the grain unless
#' the new element sets a `fill`, so `theme(plot.background = element_rect(colour = "black"))`
#' adds a border to the grained background, while `element_rect(fill = "white")` replaces it.
#'
#' @param fill Base colour of the paper.
#' @param colour,color Border colour.
#' @param linewidth Border width in mm.
#' @param linetype Border line type.
#' @param linejoin Border line join.
#' @param sigma Strength of the grain: its standard deviation in 8-bit code values. The dials range
#'   from 2.6 (Cream) to 7.8 (Tennis). `0` draws a flat fill. When `NULL`, it is inherited from the
#'   parent element or defaults to 4.
#' @param density Grain samples per inch. The default, 150, matches the grain of the screensaver on
#'   a Retina laptop screen. Lower values give a coarser grain.
#' @param inherit.blank Should this element inherit the existence of an `element_blank()` among its
#'   parents?
#' @return A theme element object of class `bauhaus::element_grain`, which inherits from
#'   `ggplot2::element_rect`.
#' @usage element_grain(fill = NULL, colour = NULL, linewidth = NULL, linetype = NULL,
#'   linejoin = NULL, sigma = NULL, density = NULL, color = NULL, inherit.blank = FALSE)
#' @export
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
#'
#' # A grained background in any colour
#' p + theme(plot.background = element_grain(fill = "#F1DAA6", sigma = 6))
#'
#' # Stronger, coarser grain on a Bauhaus theme
#' p + theme_bauhaus("beige") +
#'   theme(plot.background = element_grain(sigma = 10, density = 80))
element_grain <- S7::new_class(
  "element_grain",
  parent = ggplot2::element_rect,
  package = "bauhaus",
  properties = list(
    sigma = S7::new_property(S7::new_union(S7::class_numeric, NULL)),
    density = S7::new_property(S7::new_union(S7::class_numeric, NULL))
  ),
  constructor = function(fill = NULL, colour = NULL, linewidth = NULL, linetype = NULL,
                         linejoin = NULL, sigma = NULL, density = NULL, color = NULL,
                         inherit.blank = FALSE) {
    S7::new_object(
      ggplot2::element_rect(
        fill = fill, colour = color %||% colour, linewidth = linewidth, linetype = linetype,
        linejoin = linejoin, inherit.blank = inherit.blank
      ),
      sigma = sigma,
      density = density
    )
  }
)

# Registered as an S3 method of ggplot2::element_grob() for class "bauhaus::element_grain" in
# .onLoad().
element_grob_grain <- function(element, x = 0.5, y = 0.5, width = 1, height = 1, fill = NULL,
                               colour = NULL, linewidth = NULL, linetype = NULL, linejoin = NULL,
                               ...) {
  as_npc <- function(u) if (grid::is.unit(u)) u else grid::unit(u, "npc")
  border <- ggplot2::gg_par(
    col = colour %||% element@colour,
    lwd = linewidth %||% element@linewidth,
    lty = linetype %||% element@linetype,
    linejoin = linejoin %||% element@linejoin
  )
  border$fill <- NA
  grid::gTree(
    x = as_npc(x), y = as_npc(y), width = as_npc(width), height = as_npc(height),
    fill = fill %||% element@fill %||% "white",
    sigma = element@sigma %||% 4,
    density = element@density %||% 150,
    border = border,
    cl = "bauhaus_grain"
  )
}

# ggplot2's S7 generic, declared so S7::methods_register() registers the method below on load.
merge_element_generic <- S7::new_external_generic("ggplot2", "merge_element", c("new", "old"))

# An element_grain() added on top of any rect element: fill in what it leaves unset.
S7::method(merge_element_generic, list(element_grain, ggplot2::element_rect)) <- function(new, old, ...) {
  merge_props(new, old)
}

# A plain element_rect() added on top of an element_grain(): keep the grain unless a fill is set.
S7::method(merge_element_generic, list(ggplot2::element_rect, element_grain)) <- function(new, old, ...) {
  if (!is.null(new@fill)) {
    return(merge_props(new, old))
  }
  set <- S7::props(new)
  set <- set[lengths(set) > 0]
  S7::props(old)[names(set)] <- set
  old
}

merge_props <- function(new, old) {
  idx <- S7::prop_names(new)[lengths(S7::props(new)) == 0]
  idx <- intersect(idx, S7::prop_names(old))
  S7::props(new)[idx] <- S7::props(old, idx)
  new
}

#' @exportS3Method grid::makeContent
makeContent.bauhaus_grain <- function(x) {
  base <- grid::rectGrob(
    x$x, x$y, x$width, x$height,
    gp = grid::gpar(fill = x$fill, col = NA)
  )
  children <- list(base)

  if (grain_wanted(x$fill, x$sigma)) {
    w <- grid::convertWidth(x$width, "inches", valueOnly = TRUE)
    h <- grid::convertHeight(x$height, "inches", valueOnly = TRUE)
    density <- x$density
    max_samples <- getOption("bauhaus.grain_max_samples", 2.5e7)
    if (w * h * density^2 > max_samples) density <- sqrt(max_samples / (w * h))
    nc <- max(1L, as.integer(ceiling(w * density)))
    nr <- max(1L, as.integer(ceiling(h * density)))
    image <- grain_image(x$fill, x$sigma, nr, nc)
    children <- c(children, list(grid::rasterGrob(
      image, x$x, x$y, x$width, x$height,
      interpolate = TRUE
    )))
  }

  if (!is.null(x$border$col) && !all(is.na(x$border$col))) {
    children <- c(children, list(grid::rectGrob(x$x, x$y, x$width, x$height, gp = x$border)))
  }

  grid::setChildren(x, do.call(grid::gList, children))
}

grain_wanted <- function(fill, sigma) {
  isTRUE(getOption("bauhaus.grain", TRUE)) &&
    is.numeric(sigma) && length(sigma) == 1 && sigma > 0 &&
    is.character(fill) && length(fill) == 1 && !is.na(fill) &&
    grDevices::col2rgb(fill, alpha = TRUE)[4] > 0
}

grain_cache <- new.env(parent = emptyenv())

# The plate tile as the screensaver bakes it: fill + sigma * grain, rounded and clamped per channel,
# tiled to nr x nc samples. Returned as a nativeRaster (row-major, packed RGBA) for fast drawing.
grain_image <- function(fill, sigma, nr, nc) {
  key <- paste(fill, sigma, nr, nc)
  if (!is.null(grain_cache[[key]])) {
    return(grain_cache[[key]])
  }
  n <- nrow(grain_field)
  rows <- (seq_len(nr) - 1L) %% n + 1L
  cols <- (seq_len(nc) - 1L) %% n + 1L
  g <- grain_field[rows, cols, drop = FALSE] * (sigma / 1000)
  rgba <- grDevices::col2rgb(fill, alpha = TRUE)[, 1]
  channel <- function(v) pmin(pmax(round(v + g), 0), 255)
  alpha <- rgba[[4]] * 16777216
  if (alpha >= 2147483648) alpha <- alpha - 4294967296
  packed <- channel(rgba[[1]]) + 256 * channel(rgba[[2]]) + 65536 * channel(rgba[[3]]) + alpha
  image <- structure(
    as.integer(t(packed)),
    dim = c(nr, nc),
    class = "nativeRaster",
    channels = 4L
  )
  if (length(ls(grain_cache)) >= 4) rm(list = ls(grain_cache), envir = grain_cache)
  assign(key, image, envir = grain_cache)
  image
}
