# Shortcuts for each dial

One function per dial, equivalent to `theme_bauhaus(dial = ...)`.

## Usage

``` r
theme_bauhaus_white(...)

theme_bauhaus_turquoise(...)

theme_bauhaus_glacier(...)

theme_bauhaus_ocean(...)

theme_bauhaus_tennis(...)

theme_bauhaus_signal_blue(...)

theme_bauhaus_salmon(...)

theme_bauhaus_yellow(...)

theme_bauhaus_beige(...)

theme_bauhaus_pistachio(...)

theme_bauhaus_lavender(...)

theme_bauhaus_rose(...)

theme_bauhaus_sky_blue(...)

theme_bauhaus_cream(...)

theme_bauhaus_slate(...)

theme_bauhaus_noir(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`theme_bauhaus()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/theme_bauhaus.md).

## Value

A complete ggplot2 theme.

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
p + theme_bauhaus_signal_blue()

p + theme_bauhaus_cream()
```
