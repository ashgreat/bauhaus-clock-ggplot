#' Colours of the sixteen Bauhaus Clock dials
#'
#' One row per day dial of the Bauhaus Clock screensaver, with the colours the screensaver measured
#' for it. All colours are sRGB hex strings. The plates were defined in Display P3 and are converted
#' to sRGB (a few saturated plates, such as Tennis and Yellow, are clipped slightly in the process).
#'
#' @format A data frame with 16 rows and 16 columns:
#' \describe{
#'   \item{dial}{Identifier used throughout the package, e.g. `"signal_blue"`.}
#'   \item{name}{Display name, e.g. `"Signal Blue"`.}
#'   \item{dark}{`TRUE` for dials printed with light ink on a dark plate.}
#'   \item{paper}{The plate as it appears on screen: the plate colour lifted by 13/255, which is the
#'     base the paper grain is added to. This is the theme background.}
#'   \item{plate}{The nominal plate colour, before the lift.}
#'   \item{numeral}{Ink of the hour numerals. Used for titles and the default geom colour.}
#'   \item{track}{Ink of the minute track and minute numerals. Used for axis text and ticks.}
#'   \item{steel}{Base tone of the polished steel hour indices.}
#'   \item{hand}{Base tone of the hour and minute hands.}
#'   \item{lume}{Daylight colour of the luminous paint in the indices.}
#'   \item{lume_hand}{Daylight colour of the luminous paint in the hands.}
#'   \item{hub}{Tint of the lower half of the hub.}
#'   \item{shadow_core, shadow_ambient, shadow_contact}{Tints of the hand shadow, the soft index
#'     shadow and the tight contact shadow.}
#'   \item{grain}{Standard deviation of the paper grain in 8-bit code values. White has none and
#'     Tennis has the most.}
#' }
#' @seealso [bauhaus_colours()] for one dial as a named vector.
#' @examples
#' bauhaus_dials[, c("name", "paper", "numeral", "track")]
"bauhaus_dials"

#' Names of the Bauhaus dials
#'
#' @param display If `TRUE`, return display names (`"Signal Blue"`) instead of identifiers
#'   (`"signal_blue"`).
#' @return A character vector of the sixteen dials, in the screensaver's order.
#' @export
#' @examples
#' bauhaus_dial_names()
#' bauhaus_dial_names(display = TRUE)
bauhaus_dial_names <- function(display = FALSE) {
  if (isTRUE(display)) bauhaus::bauhaus_dials$name else bauhaus::bauhaus_dials$dial
}

#' Colours of one Bauhaus dial
#'
#' Returns the measured colours of a dial as a named character vector. See [bauhaus_dials] for what
#' each colour is.
#'
#' @param dial A dial name. Case, spaces, hyphens and underscores are ignored, so `"Signal Blue"`,
#'   `"signal-blue"` and `"signal_blue"` all work. See [bauhaus_dial_names()].
#' @return A named character vector of sRGB hex colours.
#' @export
#' @examples
#' bauhaus_colours("turquoise")
#' bauhaus_colours("Signal Blue")[c("paper", "numeral")]
bauhaus_colours <- function(dial = "turquoise") {
  row <- dial_row(dial)
  cols <- c(
    "paper", "plate", "numeral", "track", "steel", "hand", "lume", "lume_hand", "hub",
    "shadow_core", "shadow_ambient", "shadow_contact"
  )
  unlist(row[cols])
}

#' @rdname bauhaus_colours
#' @export
bauhaus_colors <- bauhaus_colours

# Internal ----------------------------------------------------------------------------------------

dial_key <- function(x) gsub("[^a-z]", "", tolower(x))

match_dial <- function(dial, arg = rlang::caller_arg(dial), call = rlang::caller_env()) {
  if (!rlang::is_string(dial)) {
    rlang::abort(
      sprintf("`%s` must be a single dial name, such as \"turquoise\".", arg),
      call = call
    )
  }
  ids <- bauhaus::bauhaus_dials$dial
  hit <- ids[dial_key(ids) == dial_key(dial)]
  if (length(hit) != 1) {
    rlang::abort(
      c(
        sprintf("Unknown dial \"%s\".", dial),
        i = paste0("Choose one of: ", paste0("\"", ids, "\"", collapse = ", "), ".")
      ),
      call = call
    )
  }
  hit
}

dial_row <- function(dial, call = rlang::caller_env()) {
  d <- bauhaus::bauhaus_dials
  as.list(d[d$dial == match_dial(dial, call = call), , drop = FALSE])
}
