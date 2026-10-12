#' Bauhaus colour scales
#'
#' Colour and fill scales built from the dial palettes (see [bauhaus_palette()]):
#'
#' * `_d` scales are discrete, with up to eight colours.
#' * `_c` scales are continuous, using the dial's sequential ramp.
#' * `_b` scales are binned versions of the sequential ramp.
#'
#' Every [theme_bauhaus()] already sets these palettes as the plot's defaults, so you only need a
#' scale to use another dial's palette, to reverse one, or to pass other scale arguments such as
#' `name`, `labels` or `limits`.
#'
#' @inheritParams bauhaus_palette
#' @param ... Other arguments passed on to [ggplot2::discrete_scale()],
#'   [ggplot2::continuous_scale()] or [ggplot2::binned_scale()].
#' @param na.value Colour for missing values. Defaults to a muted tint of the dial's minute-track
#'   ink.
#' @param guide Guide to use for the legend.
#' @param aesthetics The aesthetics this scale works with. Use `c("colour", "fill")` to set both
#'   at once.
#' @return A ggplot2 scale.
#' @name scale_bauhaus
#' @examples
#' library(ggplot2)
#'
#' ggplot(mpg, aes(displ, hwy, colour = drv)) +
#'   geom_point(size = 2) +
#'   scale_colour_bauhaus_d("salmon") +
#'   theme_bauhaus("salmon")
#'
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_bauhaus_c("ocean") +
#'   theme_bauhaus("ocean")
NULL

#' @rdname scale_bauhaus
#' @export
scale_colour_bauhaus_d <- function(dial = "turquoise", ..., reverse = FALSE, na.value = NULL,
                                   aesthetics = "colour") {
  ggplot2::discrete_scale(
    aesthetics,
    palette = pal_bauhaus(dial, reverse = reverse),
    na.value = na.value %||% na_colour(dial),
    ...
  )
}

#' @rdname scale_bauhaus
#' @export
scale_fill_bauhaus_d <- function(dial = "turquoise", ..., reverse = FALSE, na.value = NULL,
                                 aesthetics = "fill") {
  scale_colour_bauhaus_d(dial, ..., reverse = reverse, na.value = na.value, aesthetics = aesthetics)
}

#' @rdname scale_bauhaus
#' @export
scale_colour_bauhaus_c <- function(dial = "turquoise", ..., reverse = FALSE, na.value = NULL,
                                   guide = "colourbar", aesthetics = "colour") {
  ggplot2::continuous_scale(
    aesthetics,
    palette = pal_bauhaus_c(dial, reverse = reverse),
    na.value = na.value %||% na_colour(dial),
    guide = guide,
    ...
  )
}

#' @rdname scale_bauhaus
#' @export
scale_fill_bauhaus_c <- function(dial = "turquoise", ..., reverse = FALSE, na.value = NULL,
                                 guide = "colourbar", aesthetics = "fill") {
  scale_colour_bauhaus_c(
    dial, ..., reverse = reverse, na.value = na.value, guide = guide, aesthetics = aesthetics
  )
}

#' @rdname scale_bauhaus
#' @export
scale_colour_bauhaus_b <- function(dial = "turquoise", ..., reverse = FALSE, na.value = NULL,
                                   guide = "coloursteps", aesthetics = "colour") {
  ggplot2::binned_scale(
    aesthetics,
    palette = pal_bauhaus_c(dial, reverse = reverse),
    na.value = na.value %||% na_colour(dial),
    guide = guide,
    ...
  )
}

#' @rdname scale_bauhaus
#' @export
scale_fill_bauhaus_b <- function(dial = "turquoise", ..., reverse = FALSE, na.value = NULL,
                                 guide = "coloursteps", aesthetics = "fill") {
  scale_colour_bauhaus_b(
    dial, ..., reverse = reverse, na.value = na.value, guide = guide, aesthetics = aesthetics
  )
}

#' @rdname scale_bauhaus
#' @export
scale_color_bauhaus_d <- scale_colour_bauhaus_d

#' @rdname scale_bauhaus
#' @export
scale_color_bauhaus_c <- scale_colour_bauhaus_c

#' @rdname scale_bauhaus
#' @export
scale_color_bauhaus_b <- scale_colour_bauhaus_b

na_colour <- function(dial) {
  row <- dial_row(dial)
  mix(row$paper, row$track, 0.35)
}
