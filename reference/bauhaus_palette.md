# Bauhaus colour palettes

`bauhaus_palette()` returns colours from a dial's palettes as a
character vector. `pal_bauhaus()` and `pal_bauhaus_c()` return palette
functions in the style of the scales package, for use with
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html),
[`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html)
or a theme's `palette.*` settings.

## Usage

``` r
bauhaus_palette(
  dial = "turquoise",
  n = NULL,
  type = c("discrete", "sequential"),
  reverse = FALSE
)

pal_bauhaus(dial = "turquoise", reverse = FALSE)

pal_bauhaus_c(dial = "turquoise", reverse = FALSE)
```

## Arguments

- dial:

  A dial name. Case, spaces, hyphens and underscores are ignored, so
  `"Signal Blue"`, `"signal-blue"` and `"signal_blue"` all work. See
  [`bauhaus_dial_names()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_dial_names.md).

- n:

  Number of colours. For the discrete palette at most 8; defaults to
  all 8. For the sequential palette any number; defaults to 7.

- type:

  `"discrete"` or `"sequential"`.

- reverse:

  If `TRUE`, reverse the order of the colours.

## Value

`bauhaus_palette()` returns a character vector of hex colours.
`pal_bauhaus()` returns a discrete palette function of `n`;
`pal_bauhaus_c()` returns a continuous palette function of values in
\[0, 1\].

## Details

Every dial has two palettes:

- **Discrete** (8 colours): the dial's own signature colour and ink
  first, then accents borrowed from the other dials of the screensaver,
  picked to stand out against this dial's plate.

- **Sequential**: a smooth ramp built from the dial's own colours. On
  light dials it runs from the daylight lume through the signature
  colour to the hour-numeral ink; on dark dials it rises from just above
  the plate, through the minute-track ink, to the numeral ink.

## See also

[`scale_colour_bauhaus_d()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/scale_bauhaus.md)
and friends to use the palettes in a plot.

## Examples

``` r
bauhaus_palette("turquoise")
#> [1] "#007C84" "#D31C3F" "#9B7C00" "#004F5D" "#5D6195" "#00753E" "#970000"
#> [8] "#152D55"
bauhaus_palette("ocean", n = 3)
#> [1] "#6AF4D9" "#FFC800" "#F9BB97"
bauhaus_palette("salmon", type = "sequential", n = 5)
#> [1] "#F6FFE9" "#E79472" "#BA0F01" "#851B04" "#531A03"

pal <- pal_bauhaus("yellow")
pal(4)
#> [1] "#BA0E01" "#0072B8" "#4A0305" "#00753E"

ramp <- pal_bauhaus_c("glacier")
ramp(c(0, 0.5, 1))
#> [1] "#F4FFFB" "#2E5B73" "#1B3A49"
```
