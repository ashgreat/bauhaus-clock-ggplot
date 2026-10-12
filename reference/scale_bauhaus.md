# Bauhaus colour scales

Colour and fill scales built from the dial palettes (see
[`bauhaus_palette()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_palette.md)):

## Usage

``` r
scale_colour_bauhaus_d(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  aesthetics = "colour"
)

scale_fill_bauhaus_d(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  aesthetics = "fill"
)

scale_colour_bauhaus_c(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  guide = "colourbar",
  aesthetics = "colour"
)

scale_fill_bauhaus_c(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  guide = "colourbar",
  aesthetics = "fill"
)

scale_colour_bauhaus_b(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  guide = "coloursteps",
  aesthetics = "colour"
)

scale_fill_bauhaus_b(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  guide = "coloursteps",
  aesthetics = "fill"
)

scale_color_bauhaus_d(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  aesthetics = "colour"
)

scale_color_bauhaus_c(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  guide = "colourbar",
  aesthetics = "colour"
)

scale_color_bauhaus_b(
  dial = "turquoise",
  ...,
  reverse = FALSE,
  na.value = NULL,
  guide = "coloursteps",
  aesthetics = "colour"
)
```

## Arguments

- dial:

  A dial name. Case, spaces, hyphens and underscores are ignored, so
  `"Signal Blue"`, `"signal-blue"` and `"signal_blue"` all work. See
  [`bauhaus_dial_names()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_dial_names.md).

- ...:

  Other arguments passed on to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html),
  [`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html)
  or
  [`ggplot2::binned_scale()`](https://ggplot2.tidyverse.org/reference/binned_scale.html).

- reverse:

  If `TRUE`, reverse the order of the colours.

- na.value:

  Colour for missing values. Defaults to a muted tint of the dial's
  minute-track ink.

- aesthetics:

  The aesthetics this scale works with. Use `c("colour", "fill")` to set
  both at once.

- guide:

  Guide to use for the legend.

## Value

A ggplot2 scale.

## Details

- `_d` scales are discrete, with up to eight colours.

- `_c` scales are continuous, using the dial's sequential ramp.

- `_b` scales are binned versions of the sequential ramp.

Every
[`theme_bauhaus()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/theme_bauhaus.md)
already sets these palettes as the plot's defaults, so you only need a
scale to use another dial's palette, to reverse one, or to pass other
scale arguments such as `name`, `labels` or `limits`.

## Examples

``` r
library(ggplot2)

ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point(size = 2) +
  scale_colour_bauhaus_d("salmon") +
  theme_bauhaus("salmon")


ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_bauhaus_c("ocean") +
  theme_bauhaus("ocean")
```
