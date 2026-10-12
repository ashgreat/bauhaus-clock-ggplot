# Discrete palettes, eight colours per dial. Each one opens with the dial's own signature colour
# and ink, then borrows accents from the other dials of the screensaver (their plates, inks and
# shadow tints), chosen to stand out against this dial's plate.
discrete_palettes <- list(
  white       = c("#303334", "#D31C3F", "#0072B8", "#00753E", "#9B7C00", "#5D6195", "#8F5F44", "#59676E"),
  turquoise   = c("#007C84", "#D31C3F", "#9B7C00", "#004F5D", "#5D6195", "#00753E", "#970000", "#152D55"),
  glacier     = c("#2E5B73", "#BA0F01", "#684B02", "#1B3A49", "#00753E", "#5D6195", "#820000", "#152D55"),
  ocean       = c("#6AF4D9", "#FFC800", "#F9BB97", "#D4FFF0", "#00AFEC", "#F9CCD8", "#A7FF01", "#CFD6F5"),
  tennis      = c("#A7FF01", "#FFC800", "#F9CCD8", "#45FFBB", "#D4FFF0", "#F9BB97", "#9FFFFF", "#00133C"),
  signal_blue = c("#FFFFFF", "#00133C", "#FFC800", "#970000", "#9FFFFF", "#003700", "#4F3513", "#68353C"),
  salmon      = c("#BA0F01", "#0072B8", "#531A03", "#00753E", "#5D6195", "#684B02", "#152D55", "#007C84"),
  yellow      = c("#BA0E01", "#0072B8", "#4A0305", "#00753E", "#5D6195", "#6E2C00", "#152D55", "#007C84"),
  beige       = c("#856641", "#D31C3F", "#0072B8", "#4F3513", "#00753E", "#5D6195", "#152D55", "#970000"),
  pistachio   = c("#4F784E", "#D31C3F", "#0072B8", "#233B13", "#684B02", "#5D6195", "#152D55", "#820000"),
  lavender    = c("#6570A6", "#D31C3F", "#00753E", "#364379", "#684B02", "#8F5F44", "#007C84", "#970000"),
  rose        = c("#AF566C", "#0072B8", "#00753E", "#68353C", "#684B02", "#5D6195", "#152D55", "#007C84"),
  sky_blue    = c("#0072B8", "#D31C3F", "#9B7C00", "#194770", "#00753E", "#5D6195", "#970000", "#4D7EAE"),
  cream       = c("#8F5F44", "#0072B8", "#D31C3F", "#545351", "#00753E", "#9B7C00", "#5D6195", "#152D55"),
  slate       = c("#F4FBFF", "#FFC800", "#6AF4D9", "#F9BB97", "#A7FF01", "#F9CCD8", "#00AFEC", "#CFD6F5"),
  noir        = c("#E0E0DC", "#FFC800", "#00AFEC", "#D31C3F", "#A7FF01", "#F9BB97", "#6AF4D9", "#9A9DA1")
)

# Three anchors of the sequential palette, from low to high. Light dials run from the daylight lume
# through the signature colour to the numeral ink; dark dials rise from just above the plate through
# the minute-track ink to the numeral ink.
sequential_anchors <- function(dial) {
  row <- dial_row(dial)
  if (row$dark) {
    c(mix(row$paper, row$track, 0.35), row$track, row$numeral)
  } else if (row$dial == "white") {
    c(row$lume, row$shadow_core, row$numeral)
  } else {
    c(row$lume, discrete_palettes[[row$dial]][1], row$numeral)
  }
}

#' Bauhaus colour palettes
#'
#' `bauhaus_palette()` returns colours from a dial's palettes as a character vector.
#' `pal_bauhaus()` and `pal_bauhaus_c()` return palette functions in the style of the scales package,
#' for use with [ggplot2::discrete_scale()], [ggplot2::continuous_scale()] or a theme's
#' `palette.*` settings.
#'
#' Every dial has two palettes:
#'
#' * **Discrete** (8 colours): the dial's own signature colour and ink first, then accents borrowed
#'   from the other dials of the screensaver, picked to stand out against this dial's plate.
#' * **Sequential**: a smooth ramp built from the dial's own colours. On light dials it runs from the
#'   daylight lume through the signature colour to the hour-numeral ink; on dark dials it rises from
#'   just above the plate, through the minute-track ink, to the numeral ink.
#'
#' @inheritParams bauhaus_colours
#' @param n Number of colours. For the discrete palette at most 8; defaults to all 8. For the
#'   sequential palette any number; defaults to 7.
#' @param type `"discrete"` or `"sequential"`.
#' @param reverse If `TRUE`, reverse the order of the colours.
#' @return `bauhaus_palette()` returns a character vector of hex colours. `pal_bauhaus()` returns a
#'   discrete palette function of `n`; `pal_bauhaus_c()` returns a continuous palette function of
#'   values in \[0, 1\].
#' @seealso [scale_colour_bauhaus_d()] and friends to use the palettes in a plot.
#' @export
#' @examples
#' bauhaus_palette("turquoise")
#' bauhaus_palette("ocean", n = 3)
#' bauhaus_palette("salmon", type = "sequential", n = 5)
#'
#' pal <- pal_bauhaus("yellow")
#' pal(4)
#'
#' ramp <- pal_bauhaus_c("glacier")
#' ramp(c(0, 0.5, 1))
bauhaus_palette <- function(dial = "turquoise", n = NULL, type = c("discrete", "sequential"),
                            reverse = FALSE) {
  type <- rlang::arg_match(type)
  if (type == "discrete") {
    pal_bauhaus(dial, reverse = reverse)(n %||% 8L)
  } else {
    pal_bauhaus_c(dial, reverse = reverse)(seq(0, 1, length.out = n %||% 7L))
  }
}

#' @rdname bauhaus_palette
#' @export
pal_bauhaus <- function(dial = "turquoise", reverse = FALSE) {
  cols <- discrete_palettes[[match_dial(dial)]]
  if (isTRUE(reverse)) cols <- rev(cols)
  fun <- function(n) {
    if (n > length(cols)) {
      rlang::warn(sprintf(
        "The Bauhaus discrete palettes have %d colours; %d were requested.", length(cols), n
      ))
    }
    cols[seq_len(n)]
  }
  scales::new_discrete_palette(fun, type = "colour", nlevels = length(cols))
}

#' @rdname bauhaus_palette
#' @export
pal_bauhaus_c <- function(dial = "turquoise", reverse = FALSE) {
  anchors <- sequential_anchors(dial)
  if (isTRUE(reverse)) anchors <- rev(anchors)
  scales::pal_gradient_n(anchors)
}
