# bauhaus 0.1.0

* First release.
* `theme_bauhaus()` and one shortcut per dial: sixteen ggplot2 themes from the day dials of the
  Bauhaus Clock screensaver, with the screensaver's paper grain, typeface and measured colours.
* `element_grain()`, the paper grain as a theme element that works in any theme.
* Discrete, continuous and binned colour scales (`scale_colour_bauhaus_d()` and friends) and the
  palettes behind them (`bauhaus_palette()`, `pal_bauhaus()`, `pal_bauhaus_c()`).
* `bauhaus_colours()` and `bauhaus_dials`, the measured colours of every dial.
* Zalando Sans Expanded is bundled and registered with systemfonts on load; `bauhaus_showtext()`
  covers devices that don't use systemfonts.
* `bauhaus_clock()` draws the dial itself.
