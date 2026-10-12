# Bauhaus Clock themes

`theme_bauhaus()` styles a plot after one of the sixteen day dials of
the Bauhaus Clock screensaver:

## Usage

``` r
theme_bauhaus(
  dial = "turquoise",
  base_size = 11,
  base_family = bauhaus_font_family(),
  header_family = bauhaus_font_family("semibold"),
  base_line_size = base_size/22,
  base_rect_size = base_size/22,
  grain = TRUE,
  grain_density = 150,
  grid = c("xy", "x", "y", "none")
)
```

## Arguments

- dial:

  A dial name. Case, spaces, hyphens and underscores are ignored, so
  `"Signal Blue"`, `"signal-blue"` and `"signal_blue"` all work. See
  [`bauhaus_dial_names()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_dial_names.md).

- base_size:

  Base font size, in points.

- base_family:

  Font family for body text.

- header_family:

  Font family for titles.

- base_line_size:

  Base size for line elements.

- base_rect_size:

  Base size for rect elements.

- grain:

  Paper grain. `TRUE` uses the grain strength measured for the dial,
  `FALSE` draws a flat plate, and a number sets the strength (standard
  deviation in 8-bit code values).

- grain_density:

  Grain samples per inch. Lower values give a coarser grain.

- grid:

  Which major grid lines to draw: `"xy"`, `"x"`, `"y"` or `"none"`.

## Value

A complete ggplot2 theme.

## Details

- **Background**: the dial's plate, lifted as the screensaver lifts it,
  with the screensaver's paper grain at the strength measured for that
  dial (see
  [`element_grain()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/element_grain.md)).

- **Type**: Zalando Sans Expanded, the screensaver's typeface (see
  [`bauhaus_font_family()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_font_family.md)).
  Titles use the semibold weight.

- **Colour**: titles and the default geom colour use the hour-numeral
  ink; axis labels, ticks and grid lines use the minute-track ink, with
  round line ends like the track's ticks.

- **Palettes**: the dial's discrete and sequential palettes become the
  plot's default colour and fill scales (see
  [`bauhaus_palette()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_palette.md)),
  and its accent colour is used for things like
  [`ggplot2::geom_smooth()`](https://ggplot2.tidyverse.org/reference/geom_smooth.html).

Each dial also has its own shortcut, such as
[`theme_bauhaus_turquoise()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/theme_bauhaus_dials.md).

## Fonts

The bundled fonts are registered with systemfonts, which the ragg and
svglite devices use.
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
uses ragg for PNG, JPEG and TIFF files when it is installed. For R
Markdown and Quarto, set the chunk option `dev = "ragg_png"`; in
RStudio, choose the "AGG" graphics backend. On other devices call
[`bauhaus_showtext()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_font_family.md)
first, or pass `base_family = "sans"`.

## See also

[`scale_colour_bauhaus_d()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/scale_bauhaus.md)
and friends for the matching scales,
[`bauhaus_colours()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_colours.md)
for the raw colours.

## Examples

``` r
library(ggplot2)

p <- ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point(size = 2) +
  labs(
    title = "Fuel economy",
    subtitle = "Highway miles per gallon by engine size",
    x = "Displacement (litres)", y = "Highway mpg", colour = "Drive"
  )

p + theme_bauhaus()

p + theme_bauhaus("ocean")

p + theme_bauhaus_yellow(grid = "y")
```
