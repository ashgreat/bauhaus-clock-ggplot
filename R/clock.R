#' Draw a Bauhaus Clock dial
#'
#' Draws the dial of the Bauhaus Clock screensaver as a ggplot: the minute track and its numerals,
#' the steel hour indices with their lume inlays, the hour numerals, and the hour, minute and seconds
#' hands with their soft shadows, on the dial's grained plate.
#'
#' Geometry follows the screensaver's measured design, with every length a fraction of R, the
#' distance from the centre to the outer end of the 12 o'clock index. The numerals are the outlines
#' of the screensaver's typeface, except that every "1" is a plain capsule, as on the dial. Everything
#' is drawn as shapes in data coordinates, so the dial scales cleanly to any size; save it square.
#' The steel is drawn flat, without the screensaver's per-pixel shading.
#'
#' @inheritParams bauhaus_colours
#' @param time The time to show: a `POSIXt` date-time, or a string `"HH:MM"` or `"HH:MM:SS"`.
#'   Defaults to 10:08:13, the time the screensaver's reference renders show.
#' @param seconds Draw the seconds hand?
#' @param hour_numerals Draw the hour numerals (1 to 12)?
#' @param minute_numerals Draw the minute numerals ("05" to "60") outside the track?
#' @param grain Paper grain, as in [theme_bauhaus()].
#' @return A ggplot object. Its axes run from -1.16 to 1.16 (from -1.04 without minute numerals),
#'   with the centre of the dial at the origin and R = 1.
#' @export
#' @examples
#' \donttest{
#' bauhaus_clock("turquoise")
#' bauhaus_clock("noir", time = "16:42", seconds = FALSE)
#' }
#' if (FALSE) {
#'   ggplot2::ggsave("ocean.png", bauhaus_clock("ocean"), width = 6, height = 6)
#' }
bauhaus_clock <- function(dial = "turquoise", time = "10:08:13", seconds = TRUE,
                          hour_numerals = TRUE, minute_numerals = TRUE, grain = TRUE) {
  dial <- match_dial(dial)
  col <- bauhaus_colours(dial)
  angles <- clock_angles(time)
  extent <- if (minute_numerals) 1.16 else 1.04

  # Polished steel reads as a light body inside a thin darker edge.
  steel_fill <- mix(col[["steel"]], "#FFFFFF", 0.55)
  hand_fill <- mix(col[["hand"]], "#FFFFFF", 0.55)
  edge <- mix(col[["steel"]], "#7A7A7A", 0.55)
  steel <- function(shape, fill, width = 0.0028) {
    list(polygon_layer(shape, edge), polygon_layer(grow(shape, -width), fill))
  }

  # Minute track: 48 round-capped ticks, skipping the hour positions.
  minutes <- setdiff(0:59, seq(0, 55, by = 5))
  ticks <- do.call(rbind, lapply(minutes, function(m) capsule(0.9247, 0.9847, 0.0046, m * 6, id = m)))

  # Hour indices: steel capsules with lume inlays.
  frames <- do.call(rbind, lapply(0:11, function(h) capsule(0.812, 1.000, 0.02015, h * 30, id = h)))
  inlays <- do.call(rbind, lapply(0:11, function(h) capsule(0.8229, 0.9892, 0.00925, h * 30, id = h)))

  hour_hand <- rotate(hand_shape(0.02071, 0.56728, c(0.02071, 0.59389), c(0.00879, 0.6395), 0.6395), angles[["hour"]])
  minute_hand <- rotate(hand_shape(0.01872, 0.9055, c(0.01872, 0.91894), c(0.01018, 0.97034), 0.97034), angles[["minute"]])
  hour_lume <- rotate(capsule(0.1622, 0.5601, 0.0086, 0), angles[["hour"]])
  minute_lume <- rotate(capsule(0.162, 0.890, 0.0086, 0), angles[["minute"]])
  second_hand <- rotate(seconds_shape(), angles[["second"]])
  hub <- circle(0.062)

  layers <- list(
    polygon_layer(ticks, col[["track"]]),
    shadow_layers(frames, 0.0195, 0.0270, 0.32, col[["shadow_ambient"]], 0.02015),
    shadow_layers(frames, 0.0049, 0.0028, 0.41, col[["shadow_contact"]], 0.02015),
    steel(frames, steel_fill),
    steel(inlays, col[["lume"]], 0.0016),
    if (hour_numerals) numeral_layers(hour_numeral_labels(), col[["numeral"]], minute = FALSE),
    if (minute_numerals) numeral_layers(minute_numeral_labels(), col[["track"]], minute = TRUE),
    shadow_layers(hub, 0.0359, 0.0194, 0.38, col[["shadow_core"]], 0.062),
    shadow_layers(hour_hand, 0.0359, 0.0194, 0.34, col[["shadow_core"]], 0.02071),
    shadow_layers(minute_hand, 0.0690, 0.0260, 0.32, col[["shadow_core"]], 0.01872),
    if (seconds) shadow_layers(second_hand, 0.0910, 0.0360, 0.34, col[["shadow_core"]], 0.007),
    steel(hub, hand_fill),
    steel(hour_hand, hand_fill),
    steel(hour_lume, col[["lume_hand"]], 0.0016),
    steel(circle(0.0545), hand_fill),
    steel(minute_hand, hand_fill),
    steel(minute_lume, col[["lume_hand"]], 0.0016),
    if (seconds) steel(second_hand, hand_fill, 0.0016),
    if (seconds) steel(circle(0.0442), hand_fill),
    polygon_layer(circle(0.0159), mix(col[["hub"]], "#000000", 0.35)),
    polygon_layer(circle(0.0089, y0 = 0.0044), mix(col[["hand"]], "#FFFFFF", 0.7))
  )

  ggplot2::ggplot() +
    layers +
    ggplot2::coord_fixed(xlim = c(-extent, extent), ylim = c(-extent, extent), expand = FALSE) +
    theme_bauhaus(dial, grain = grain) +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.ticks.length = grid::unit(0, "pt"),
      panel.grid = ggplot2::element_blank(),
      plot.margin = ggplot2::margin(0, 0, 0, 0)
    )
}

# Geometry helpers. Angles are clockwise from 12 o'clock, in degrees; lengths are fractions of R,
# the distance from the centre to the outer end of the 12 o'clock index.

clock_angles <- function(time) {
  if (inherits(time, "POSIXt")) {
    lt <- as.POSIXlt(time)
    h <- lt$hour
    m <- lt$min
    s <- floor(lt$sec)
  } else {
    parts <- suppressWarnings(as.numeric(strsplit(as.character(time), ":", fixed = TRUE)[[1]]))
    if (length(parts) < 2 || length(parts) > 3 || anyNA(parts)) {
      rlang::abort("`time` must be a date-time or a string like \"10:08\" or \"10:08:13\".")
    }
    h <- parts[1]
    m <- parts[2]
    s <- if (length(parts) == 3) parts[3] else 0
  }
  c(
    hour = ((h %% 12) + m / 60 + s / 3600) * 30,
    minute = (m + s / 60) * 6,
    second = s * 6
  )
}

# A capsule along the ray at `angle`, spanning radii r0..r1 including its round ends.
capsule <- function(r0, r1, hw, angle, id = 1, n = 16) {
  a <- seq(0, pi, length.out = n)
  # Local frame: +y along the ray.
  top <- cbind(hw * cos(a), (r1 - hw) + hw * sin(a))
  bottom <- cbind(-hw * cos(a), (r0 + hw) - hw * sin(a))
  rotate(data.frame(x = c(top[, 1], bottom[, 1]), y = c(top[, 2], bottom[, 2]), id = id), angle)
}

circle <- function(r, x0 = 0, y0 = 0, n = 64) {
  a <- seq(0, 2 * pi, length.out = n + 1)[-1]
  data.frame(x = x0 + r * cos(a), y = y0 + r * sin(a), id = 1)
}

bezier <- function(p0, c1, c2, p1, n = 12) {
  t <- seq(0, 1, length.out = n)
  b <- function(i) (1 - t)^3 * p0[i] + 3 * (1 - t)^2 * t * c1[i] + 3 * (1 - t) * t^2 * c2[i] + t^3 * p1[i]
  cbind(b(1), b(2))
}

# Hour and minute hands, hand-up frame: straight flanks from the pivot, then a curved tip.
hand_shape <- function(hw, flank_end, c1, c2, tip) {
  right <- rbind(c(hw, 0), bezier(c(hw, flank_end), c1, c2, c(0, tip)))
  left <- right[rev(seq_len(nrow(right)))[-1], , drop = FALSE]
  left[, 1] <- -left[, 1]
  data.frame(x = c(right[, 1], left[, 1]), y = c(right[, 2], left[, 2]), id = 1)
}

# Seconds hand: a tapered needle with a round tip and a flared paddle tail.
seconds_shape <- function() {
  d <- seq(0.0431, 0.9788, length.out = 20)
  needle_hw <- 0.00983 - 0.00499 * d
  tip <- seq(0, pi, length.out = 12)
  tail_d <- seq(0.0431, 0.2417, length.out = 10)
  tail_hw <- 0.00909 + 0.02873 * tail_d
  cap <- seq(0, pi, length.out = 16)
  x <- c(
    needle_hw, 0.00494 * cos(tip), -rev(needle_hw),
    -rev(tail_hw), -0.016 * cos(cap), tail_hw
  )
  y <- c(
    d, 0.9788 + 0.00494 * sin(tip), rev(d),
    -rev(tail_d), -0.2417 - 0.016 * sin(cap), -tail_d
  )
  data.frame(x = x, y = y, id = 1)
}

rotate <- function(shape, angle) {
  th <- angle * pi / 180
  x <- shape$x * cos(th) + shape$y * sin(th)
  y <- -shape$x * sin(th) + shape$y * cos(th)
  shape$x <- x
  shape$y <- y
  shape
}

# Offsets each polygon outwards (or inwards, for negative `d`) along its vertex normals.
grow <- function(shape, d) {
  if (d == 0) {
    return(shape)
  }
  out <- lapply(split(shape, shape$id), function(s) {
    n <- nrow(s)
    nxt <- c(seq_len(n)[-1], 1)
    prv <- c(n, seq_len(n - 1))
    # Edge normals, then averaged at the vertices.
    ex <- s$x[nxt] - s$x
    ey <- s$y[nxt] - s$y
    len <- sqrt(ex^2 + ey^2)
    len[len == 0] <- 1
    nx <- ey / len
    ny <- -ex / len
    vx <- nx + nx[prv]
    vy <- ny + ny[prv]
    vlen <- sqrt(vx^2 + vy^2)
    vlen[vlen == 0] <- 1
    # The right-hand normals point outwards on counter-clockwise polygons.
    area <- sum(s$x * s$y[nxt] - s$x[nxt] * s$y) / 2
    sign <- if (area > 0) 1 else -1
    s$x <- s$x + sign * d * vx / vlen
    s$y <- s$y + sign * d * vy / vlen
    s
  })
  do.call(rbind, out)
}

polygon_layer <- function(shape, fill, alpha = 1, colour = NA, linewidth = 0) {
  ggplot2::geom_polygon(
    ggplot2::aes(x = .data$x, y = .data$y, group = .data$id),
    data = shape, fill = fill, colour = colour, linewidth = linewidth, alpha = alpha,
    inherit.aes = FALSE
  )
}

# A soft drop shadow: translucent copies of the shape, offset down and grown in steps across the
# blur radius. The peak opacity is scaled down for shapes narrower than the blur, as a real Gaussian
# blur would spread them out.
shadow_layers <- function(shape, offset, sigma, opacity, colour, half_width, steps = 6) {
  shape$y <- shape$y - offset
  peak <- opacity * (2 * stats::pnorm(half_width / sigma) - 1)
  growth <- seq(-min(1.2 * sigma, 0.8 * half_width), 1.8 * sigma, length.out = steps)
  alpha <- 1 - (1 - peak)^(1 / steps)
  lapply(growth, function(g) polygon_layer(grow(shape, g), colour, alpha))
}

hour_numeral_labels <- function() {
  h <- 1:12
  th <- h * 30 * pi / 180
  data.frame(x = 0.6565 * sin(th), y = 0.6565 * cos(th), label = as.character(h), angle = 0)
}

minute_numeral_labels <- function() {
  m <- seq(5, 60, by = 5)
  th <- m * 6
  rad <- th * pi / 180
  bottom <- m %in% c(20, 25, 30, 35, 40)
  # Tops point outwards and the labels read clockwise, except at the bottom, where they turn
  # upright. The label's cap box sits 0.0019 R towards its baseline.
  angle <- ifelse(bottom, th - 180, th)
  data.frame(
    x = 1.0891 * sin(rad) + 0.0019 * sin(angle * pi / 180 + pi),
    y = 1.0891 * cos(rad) + 0.0019 * cos(angle * pi / 180 + pi),
    label = sprintf("%02d", m), angle = angle
  )
}

# Digit outlines from the bundled typeface, in em units with the baseline at y = 0, cached.
digit_cache <- new.env(parent = emptyenv())

digit_outline <- function(ch) {
  if (is.null(digit_cache[[ch]])) {
    path <- bauhaus_font_files()[["regular"]]
    info <- systemfonts::glyph_info(ch, path = path, size = 1000)
    out <- systemfonts::glyph_outline(info$index, path = path, size = 1000, tolerance = 0.5)
    out <- data.frame(x = out$x / 1000, y = out$y / 1000, contour = out$contour)
    assign(ch, out, envir = digit_cache)
  }
  digit_cache[[ch]]
}

# Numerals as the screensaver sets them: the typeface's digits, but every '1' a plain capsule, each
# label laid out by its ink box and centred on its anchor. `angle` is the clockwise rotation of the
# label. Everything is returned as polygons, so the numerals scale with the plot.
numeral_layers <- function(labels, colour, minute) {
  em <- if (minute) 0.06779 else 0.14706
  cap <- if (minute) 0.0484 else 0.1050
  one <- if (minute) 0.0074 else 0.0162
  gap_after_one <- if (minute) 0.0106 else 0.0148
  gap_one_one <- if (minute) 0.0106 else 0.0391
  gap_digits <- 0.0072

  pieces <- list()
  for (i in seq_len(nrow(labels))) {
    chars <- strsplit(labels$label[i], "")[[1]]
    glyphs <- lapply(chars, function(ch) if (ch == "1") NULL else digit_outline(ch))
    widths <- vapply(seq_along(chars), function(k) {
      if (chars[k] == "1") one else em * diff(range(glyphs[[k]]$x))
    }, numeric(1))
    gaps <- numeric(max(0, length(chars) - 1))
    for (k in seq_along(gaps)) {
      gaps[k] <- if (chars[k] == "1" && chars[k + 1] == "1") {
        gap_one_one
      } else if (chars[k] == "1") {
        gap_after_one
      } else {
        gap_digits
      }
    }
    left <- -sum(widths, gaps) / 2 + cumsum(c(0, widths[-length(widths)] + gaps))
    for (k in seq_along(chars)) {
      id <- paste(i, k)
      if (chars[k] == "1") {
        piece <- capsule(-cap / 2, cap / 2, one / 2, 0, id = id)
        piece$x <- piece$x + left[k] + one / 2
        piece$contour <- 1
      } else {
        g <- glyphs[[k]]
        piece <- data.frame(
          x = (g$x - min(g$x)) * em + left[k],
          y = g$y * em - cap / 2,
          id = id,
          contour = g$contour
        )
      }
      piece <- rotate(piece, labels$angle[i])
      piece$x <- piece$x + labels$x[i]
      piece$y <- piece$y + labels$y[i]
      pieces[[length(pieces) + 1]] <- piece
    }
  }
  ggplot2::geom_polygon(
    ggplot2::aes(x = .data$x, y = .data$y, group = .data$id, subgroup = .data$contour),
    data = do.call(rbind, pieces), fill = colour, colour = NA, rule = "winding",
    inherit.aes = FALSE
  )
}
