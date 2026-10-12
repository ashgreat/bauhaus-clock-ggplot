#' Bauhaus Clock themes
#'
#' `theme_bauhaus()` styles a plot after one of the sixteen day dials of the Bauhaus Clock
#' screensaver:
#'
#' * **Background**: the dial's plate, lifted as the screensaver lifts it, with the screensaver's
#'   paper grain at the strength measured for that dial (see [element_grain()]).
#' * **Type**: Zalando Sans Expanded, the screensaver's typeface (see [bauhaus_font_family()]).
#'   Titles use the semibold weight.
#' * **Colour**: titles and the default geom colour use the hour-numeral ink; axis labels, ticks and
#'   grid lines use the minute-track ink, with round line ends like the track's ticks.
#' * **Palettes**: the dial's discrete and sequential palettes become the plot's default colour and
#'   fill scales (see [bauhaus_palette()]), and its accent colour is used for things like
#'   [ggplot2::geom_smooth()].
#'
#' Each dial also has its own shortcut, such as `theme_bauhaus_turquoise()`.
#'
#' @section Fonts:
#' The bundled fonts are registered with \pkg{systemfonts}, which the ragg and svglite devices use.
#' [ggplot2::ggsave()] uses ragg for PNG, JPEG and TIFF files when it is installed. For R Markdown
#' and Quarto, set the chunk option `dev = "ragg_png"`; in RStudio, choose the "AGG" graphics backend.
#' On other devices call [bauhaus_showtext()] first, or pass `base_family = "sans"`.
#'
#' @inheritParams bauhaus_colours
#' @param base_size Base font size, in points.
#' @param base_family Font family for body text.
#' @param header_family Font family for titles.
#' @param base_line_size Base size for line elements.
#' @param base_rect_size Base size for rect elements.
#' @param grain Paper grain. `TRUE` uses the grain strength measured for the dial, `FALSE` draws a
#'   flat plate, and a number sets the strength (standard deviation in 8-bit code values).
#' @param grain_density Grain samples per inch. Lower values give a coarser grain.
#' @param grid Which major grid lines to draw: `"xy"`, `"x"`, `"y"` or `"none"`.
#' @return A complete ggplot2 theme.
#' @seealso [scale_colour_bauhaus_d()] and friends for the matching scales, [bauhaus_colours()] for
#'   the raw colours.
#' @export
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mpg, aes(displ, hwy, colour = drv)) +
#'   geom_point(size = 2) +
#'   labs(
#'     title = "Fuel economy",
#'     subtitle = "Highway miles per gallon by engine size",
#'     x = "Displacement (litres)", y = "Highway mpg", colour = "Drive"
#'   )
#'
#' p + theme_bauhaus()
#' p + theme_bauhaus("ocean")
#' p + theme_bauhaus_yellow(grid = "y")
theme_bauhaus <- function(dial = "turquoise", base_size = 11,
                          base_family = bauhaus_font_family(),
                          header_family = bauhaus_font_family("semibold"),
                          base_line_size = base_size / 22, base_rect_size = base_size / 22,
                          grain = TRUE, grain_density = 150,
                          grid = c("xy", "x", "y", "none")) {
  dial <- match_dial(dial)
  grid <- rlang::arg_match(grid)
  col <- dial_row(dial)
  pal <- discrete_palettes[[dial]]

  ink <- col$numeral
  # Minute-track ink, darkened or lightened towards the numeral ink where it is too faint to read.
  track <- ensure_contrast(col$track, col$paper, toward = ink, target = 3.5)
  accent <- pal[2]

  sigma <- if (isTRUE(grain)) col$grain else if (isFALSE(grain)) 0 else as.numeric(grain)
  background <- if (sigma > 0) {
    element_grain(fill = col$paper, colour = NA, sigma = sigma, density = grain_density)
  } else {
    ggplot2::element_rect(fill = col$paper, colour = NA)
  }

  half <- base_size / 2
  gridline <- ggplot2::element_line(
    colour = scales::alpha(track, if (col$dark) 0.32 else 0.26),
    linewidth = ggplot2::rel(0.5),
    lineend = "round"
  )

  th <- ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family,
    header_family = header_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    ink = ink,
    paper = col$paper,
    accent = accent
  ) %+replace%
    ggplot2::theme(
      plot.background = background,
      panel.background = ggplot2::element_blank(),
      panel.grid = gridline,
      panel.grid.minor = ggplot2::element_blank(),
      panel.spacing = grid::unit(base_size, "pt"),

      text = ggplot2::element_text(
        family = base_family, face = "plain", colour = ink, size = base_size,
        lineheight = 0.95, hjust = 0.5, vjust = 0.5, angle = 0, margin = ggplot2::margin(),
        debug = FALSE
      ),
      title = ggplot2::element_text(family = header_family),
      axis.title = ggplot2::element_text(family = base_family, size = ggplot2::rel(0.85)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = half * 0.8), vjust = 1),
      axis.title.x.top = ggplot2::element_text(margin = ggplot2::margin(b = half * 0.8), vjust = 0),
      axis.title.y = ggplot2::element_text(
        angle = 90, margin = ggplot2::margin(r = half * 0.8), vjust = 1
      ),
      axis.title.y.right = ggplot2::element_text(
        angle = -90, margin = ggplot2::margin(l = half * 0.8), vjust = 1
      ),
      axis.text = ggplot2::element_text(colour = track, size = ggplot2::rel(0.75)),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = 0.3 * half), vjust = 1),
      axis.text.x.top = ggplot2::element_text(margin = ggplot2::margin(b = 0.3 * half), vjust = 0),
      axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = 0.3 * half), hjust = 1),
      axis.text.y.right = ggplot2::element_text(margin = ggplot2::margin(l = 0.3 * half), hjust = 0),
      axis.text.r = ggplot2::element_text(
        margin = ggplot2::margin(l = 0.3 * half, r = 0.3 * half), hjust = 0.5
      ),
      axis.ticks = ggplot2::element_line(
        colour = track, linewidth = ggplot2::rel(0.9), lineend = "round"
      ),
      axis.ticks.length = grid::unit(0.3 * half, "pt"),
      axis.line = ggplot2::element_blank(),

      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.title = ggplot2::element_text(size = ggplot2::rel(0.85), hjust = 0),
      legend.text = ggplot2::element_text(colour = track, size = ggplot2::rel(0.75)),
      legend.key.spacing = grid::unit(half * 0.6, "pt"),
      legend.margin = ggplot2::margin(0, 0, 0, 0),

      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(
        family = header_family, colour = ink, size = ggplot2::rel(0.85), hjust = 0,
        margin = ggplot2::margin(half * 0.8, half * 0.4, half * 0.8, half * 0.4)
      ),
      strip.text.y = ggplot2::element_text(angle = -90, hjust = 0.5),
      strip.text.y.left = ggplot2::element_text(angle = 90, hjust = 0.5),

      plot.title = ggplot2::element_text(
        size = ggplot2::rel(1.3), hjust = 0, vjust = 1, colour = ink,
        margin = ggplot2::margin(b = half)
      ),
      plot.title.position = "plot",
      plot.subtitle = ggplot2::element_text(
        family = base_family, size = ggplot2::rel(0.9), hjust = 0, vjust = 1, colour = track,
        margin = ggplot2::margin(b = half * 1.4)
      ),
      plot.caption = ggplot2::element_text(
        family = base_family, size = ggplot2::rel(0.7), hjust = 0, vjust = 1, colour = track,
        margin = ggplot2::margin(t = half * 1.2)
      ),
      plot.caption.position = "plot",
      plot.tag = ggplot2::element_text(size = ggplot2::rel(1.2), hjust = 0.5, vjust = 0.5),
      plot.margin = ggplot2::margin(base_size * 1.4, base_size * 1.4, base_size * 1.2, base_size * 1.4),

      geom = ggplot2::element_geom(
        ink = ink, paper = col$paper, accent = accent,
        linewidth = base_line_size, borderwidth = base_line_size,
        family = base_family, fontsize = base_size,
        pointsize = (base_size / 11) * 1.5, pointshape = 19
      ),
      palette.colour.discrete = pal_bauhaus(dial),
      palette.fill.discrete = pal_bauhaus(dial),
      palette.colour.continuous = pal_bauhaus_c(dial),
      palette.fill.continuous = pal_bauhaus_c(dial),

      complete = TRUE
    )

  if (grid %in% c("x", "none")) th <- th + ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
  if (grid %in% c("y", "none")) th <- th + ggplot2::theme(panel.grid.major.x = ggplot2::element_blank())
  th
}

#' Shortcuts for each dial
#'
#' One function per dial, equivalent to `theme_bauhaus(dial = ...)`.
#'
#' @param ... Arguments passed on to [theme_bauhaus()].
#' @return A complete ggplot2 theme.
#' @name theme_bauhaus_dials
#' @examples
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
#' p + theme_bauhaus_signal_blue()
#' p + theme_bauhaus_cream()
NULL

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_white <- function(...) theme_bauhaus("white", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_turquoise <- function(...) theme_bauhaus("turquoise", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_glacier <- function(...) theme_bauhaus("glacier", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_ocean <- function(...) theme_bauhaus("ocean", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_tennis <- function(...) theme_bauhaus("tennis", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_signal_blue <- function(...) theme_bauhaus("signal_blue", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_salmon <- function(...) theme_bauhaus("salmon", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_yellow <- function(...) theme_bauhaus("yellow", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_beige <- function(...) theme_bauhaus("beige", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_pistachio <- function(...) theme_bauhaus("pistachio", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_lavender <- function(...) theme_bauhaus("lavender", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_rose <- function(...) theme_bauhaus("rose", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_sky_blue <- function(...) theme_bauhaus("sky_blue", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_cream <- function(...) theme_bauhaus("cream", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_slate <- function(...) theme_bauhaus("slate", ...)

#' @rdname theme_bauhaus_dials
#' @export
theme_bauhaus_noir <- function(...) theme_bauhaus("noir", ...)
