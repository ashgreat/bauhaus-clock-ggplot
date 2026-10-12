# Changelog

## bauhaus 0.1.0

- First release.
- [`theme_bauhaus()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/theme_bauhaus.md)
  and one shortcut per dial: sixteen ggplot2 themes from the day dials
  of the Bauhaus Clock screensaver, with the screensaver’s paper grain,
  typeface and measured colours.
- [`element_grain()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/element_grain.md),
  the paper grain as a theme element that works in any theme.
- Discrete, continuous and binned colour scales
  ([`scale_colour_bauhaus_d()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/scale_bauhaus.md)
  and friends) and the palettes behind them
  ([`bauhaus_palette()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_palette.md),
  [`pal_bauhaus()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_palette.md),
  [`pal_bauhaus_c()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_palette.md)).
- [`bauhaus_colours()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_colours.md)
  and `bauhaus_dials`, the measured colours of every dial.
- Zalando Sans Expanded is bundled and registered with systemfonts on
  load;
  [`bauhaus_showtext()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_font_family.md)
  covers devices that don’t use systemfonts.
- [`bauhaus_clock()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_clock.md)
  draws the dial itself.
