# Names of the Bauhaus dials

Names of the Bauhaus dials

## Usage

``` r
bauhaus_dial_names(display = FALSE)
```

## Arguments

- display:

  If `TRUE`, return display names (`"Signal Blue"`) instead of
  identifiers (`"signal_blue"`).

## Value

A character vector of the sixteen dials, in the screensaver's order.

## Examples

``` r
bauhaus_dial_names()
#>  [1] "white"       "turquoise"   "glacier"     "ocean"       "tennis"     
#>  [6] "signal_blue" "salmon"      "yellow"      "beige"       "pistachio"  
#> [11] "lavender"    "rose"        "sky_blue"    "cream"       "slate"      
#> [16] "noir"       
bauhaus_dial_names(display = TRUE)
#>  [1] "White"       "Turquoise"   "Glacier"     "Ocean"       "Tennis"     
#>  [6] "Signal Blue" "Salmon"      "Yellow"      "Beige"       "Pistachio"  
#> [11] "Lavender"    "Rose"        "Sky Blue"    "Cream"       "Slate"      
#> [16] "Noir"       
```
