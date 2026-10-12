# Small colour helpers. All inputs and outputs are sRGB hex strings.

hex_to_rgb <- function(x) grDevices::col2rgb(x) / 255

rgb_to_hex <- function(m) {
  m <- pmin(pmax(m, 0), 1)
  grDevices::rgb(m[1, ], m[2, ], m[3, ])
}

# Linear interpolation in gamma-encoded sRGB, the way the screensaver mixes its inks.
mix <- function(a, b, t) {
  rgb_to_hex(hex_to_rgb(a) * (1 - t) + hex_to_rgb(b) * t)
}

relative_luminance <- function(x) {
  m <- hex_to_rgb(x)
  m <- ifelse(m <= 0.04045, m / 12.92, ((m + 0.055) / 1.055)^2.4)
  colSums(m * c(0.2126, 0.7152, 0.0722))
}

contrast_ratio <- function(a, b) {
  la <- relative_luminance(a)
  lb <- relative_luminance(b)
  (pmax(la, lb) + 0.05) / (pmin(la, lb) + 0.05)
}

# Moves `col` towards `toward` until it reaches `target` contrast against `bg`. Used for the few
# dials whose minute-track ink is too faint to set axis labels in (Cream and Slate).
ensure_contrast <- function(col, bg, toward, target = 3.5) {
  if (contrast_ratio(col, bg) >= target) {
    return(col)
  }
  for (t in seq(0.05, 1, by = 0.05)) {
    out <- mix(col, toward, t)
    if (contrast_ratio(out, bg) >= target) {
      return(out)
    }
  }
  toward
}
