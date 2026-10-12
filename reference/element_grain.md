# Paper grain theme element

A rectangle theme element, like
[`ggplot2::element_rect()`](https://ggplot2.tidyverse.org/reference/element.html),
whose fill carries the fine paper grain of the Bauhaus Clock
screensaver. The themes use it for `plot.background`, so the grain runs
under the whole plot, panels and legends included, the way the
screensaver lays it under the whole screen.

## Usage

``` r
element_grain(fill = NULL, colour = NULL, linewidth = NULL, linetype = NULL,
  linejoin = NULL, sigma = NULL, density = NULL, color = NULL, inherit.blank = FALSE)
```

## Arguments

- fill:

  Base colour of the paper.

- colour, color:

  Border colour.

- linewidth:

  Border width in mm.

- linetype:

  Border line type.

- linejoin:

  Border line join.

- sigma:

  Strength of the grain: its standard deviation in 8-bit code values.
  The dials range from 2.6 (Cream) to 7.8 (Tennis). `0` draws a flat
  fill. When `NULL`, it is inherited from the parent element or defaults
  to 4.

- density:

  Grain samples per inch. The default, 150, matches the grain of the
  screensaver on a Retina laptop screen. Lower values give a coarser
  grain.

- inherit.blank:

  Should this element inherit the existence of an
  [`element_blank()`](https://ggplot2.tidyverse.org/reference/element.html)
  among its parents?

## Value

A theme element object of class `bauhaus::element_grain`, which inherits
from
[`ggplot2::element_rect`](https://ggplot2.tidyverse.org/reference/element.html).

## Details

The grain is the screensaver's own: the same 512 x 512 seamless tile,
generated from the same seed and passed through the same measured 7 x 5
kernel, which gives a zero-mean grain made of short horizontal streaks,
with no mottling or fibres. It is added equally to the red, green and
blue channels of `fill`, with standard deviation `sigma` in 8-bit code
values, and drawn at a fixed physical size, so it looks the same however
large the plot is.

The grain is drawn as a raster image when the plot is rendered, so it
works on every graphics device. Raster images make vector files (PDF,
SVG) larger; set `options(bauhaus.grain = FALSE)` to draw every grained
background as a flat fill instead.

Adding a plain
[`ggplot2::element_rect()`](https://ggplot2.tidyverse.org/reference/element.html)
on top of an `element_grain()` keeps the grain unless the new element
sets a `fill`, so
`theme(plot.background = element_rect(colour = "black"))` adds a border
to the grained background, while `element_rect(fill = "white")` replaces
it.

## Examples

``` r
library(ggplot2)

p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()

# A grained background in any colour
p + theme(plot.background = element_grain(fill = "#F1DAA6", sigma = 6))


# Stronger, coarser grain on a Bauhaus theme
p + theme_bauhaus("beige") +
  theme(plot.background = element_grain(sigma = 10, density = 80))
```
