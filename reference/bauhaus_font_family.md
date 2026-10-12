# The Bauhaus typeface

The themes set type in **Zalando Sans Expanded**, the typeface the
Bauhaus Clock screensaver uses for its dial numerals. The font is
bundled with the package (SIL Open Font License 1.1) and registered with
systemfonts when the package loads, so it works without installing
anything on graphics devices that use systemfonts:
[ragg](https://ragg.r-lib.org/reference/agg_png.html) (the default for
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
when ragg is installed, and the "AGG" backend in RStudio and Positron)
and svglite.

## Usage

``` r
bauhaus_font_family(weight = c("regular", "medium", "semibold"))

bauhaus_font_files()

bauhaus_showtext(enable = TRUE)
```

## Arguments

- weight:

  `"regular"`, `"medium"` or `"semibold"`.

- enable:

  If `TRUE`, also call
  [`showtext::showtext_auto()`](https://rdrr.io/pkg/showtext/man/showtext_auto.html)
  so that showtext renders all text from now on.

## Value

`bauhaus_font_family()` returns a family name. `bauhaus_font_files()`
returns a named character vector of file paths. `bauhaus_showtext()` is
called for its side effects and returns the registered family names
invisibly.

## Details

Three families are registered:

- `"Zalando Sans Expanded"`: regular, bold, italic and bold italic. Used
  for body text.

- `"Zalando Sans Expanded Medium"`: medium weight.

- `"Zalando Sans Expanded SemiBold"`: semibold weight. Used for titles.

`bauhaus_font_family()` returns the family name to pass to
`base_family`, `header_family` or a geom's `family`.
`bauhaus_font_files()` returns the paths of the bundled font files, if
you want to install them on your system. `bauhaus_showtext()` registers
the fonts with showtext instead, for devices that do not use
systemfonts, such as
[`grDevices::pdf()`](https://rdrr.io/r/grDevices/pdf.html) or the
default Windows and macOS screen devices.

## Examples

``` r
bauhaus_font_family()
#> [1] "Zalando Sans Expanded"
bauhaus_font_family("semibold")
#> [1] "Zalando Sans Expanded SemiBold"
basename(bauhaus_font_files())
#> [1] "ZalandoSansExpanded-Regular.ttf"    "ZalandoSansExpanded-Italic.ttf"    
#> [3] "ZalandoSansExpanded-Medium.ttf"     "ZalandoSansExpanded-SemiBold.ttf"  
#> [5] "ZalandoSansExpanded-Bold.ttf"       "ZalandoSansExpanded-BoldItalic.ttf"
```
