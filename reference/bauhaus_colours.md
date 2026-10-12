# Colours of one Bauhaus dial

Returns the measured colours of a dial as a named character vector. See
[bauhaus_dials](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_dials.md)
for what each colour is.

## Usage

``` r
bauhaus_colours(dial = "turquoise")

bauhaus_colors(dial = "turquoise")
```

## Arguments

- dial:

  A dial name. Case, spaces, hyphens and underscores are ignored, so
  `"Signal Blue"`, `"signal-blue"` and `"signal_blue"` all work. See
  [`bauhaus_dial_names()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_dial_names.md).

## Value

A named character vector of sRGB hex colours.

## Examples

``` r
bauhaus_colours("turquoise")
#>          paper          plate        numeral          track          steel 
#>      "#AFF2F1"      "#A1E5E4"      "#004F5D"      "#007C84"      "#CBD2D6" 
#>           hand           lume      lume_hand            hub    shadow_core 
#>      "#CBD2D1"      "#E4FEFF"      "#DFFAFC"      "#BEC5C4"      "#009F9D" 
#> shadow_ambient shadow_contact 
#>      "#01BBB9"      "#026F6E" 
bauhaus_colours("Signal Blue")[c("paper", "numeral")]
#>     paper   numeral 
#> "#00AFEC" "#FFFFFF" 
```
