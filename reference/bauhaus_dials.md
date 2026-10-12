# Colours of the sixteen Bauhaus Clock dials

One row per day dial of the Bauhaus Clock screensaver, with the colours
the screensaver measured for it. All colours are sRGB hex strings. The
plates were defined in Display P3 and are converted to sRGB (a few
saturated plates, such as Tennis and Yellow, are clipped slightly in the
process).

## Usage

``` r
bauhaus_dials
```

## Format

A data frame with 16 rows and 16 columns:

- dial:

  Identifier used throughout the package, e.g. `"signal_blue"`.

- name:

  Display name, e.g. `"Signal Blue"`.

- dark:

  `TRUE` for dials printed with light ink on a dark plate.

- paper:

  The plate as it appears on screen: the plate colour lifted by 13/255,
  which is the base the paper grain is added to. This is the theme
  background.

- plate:

  The nominal plate colour, before the lift.

- numeral:

  Ink of the hour numerals. Used for titles and the default geom colour.

- track:

  Ink of the minute track and minute numerals. Used for axis text and
  ticks.

- steel:

  Base tone of the polished steel hour indices.

- hand:

  Base tone of the hour and minute hands.

- lume:

  Daylight colour of the luminous paint in the indices.

- lume_hand:

  Daylight colour of the luminous paint in the hands.

- hub:

  Tint of the lower half of the hub.

- shadow_core, shadow_ambient, shadow_contact:

  Tints of the hand shadow, the soft index shadow and the tight contact
  shadow.

- grain:

  Standard deviation of the paper grain in 8-bit code values. White has
  none and Tennis has the most.

## See also

[`bauhaus_colours()`](https://ashgreat.github.io/bauhaus-clock-ggplot/reference/bauhaus_colours.md)
for one dial as a named vector.

## Examples

``` r
bauhaus_dials[, c("name", "paper", "numeral", "track")]
#>           name   paper numeral   track
#> 1        White #FFFFFF #303334 #292B2B
#> 2    Turquoise #AFF2F1 #004F5D #007C84
#> 3      Glacier #B1C5CD #1B3A49 #2E5B73
#> 4        Ocean #152D55 #D4FFF0 #6AF4D9
#> 5       Tennis #00824B #A7FF01 #45FFBB
#> 6  Signal Blue #00AFEC #FFFFFF #9FFFFF
#> 7       Salmon #F9BB97 #531A03 #4C1200
#> 8       Yellow #FFC800 #4A0305 #6E2C00
#> 9        Beige #F1DAA6 #4F3513 #856641
#> 10   Pistachio #C0D2AD #233B13 #364F2F
#> 11    Lavender #CFD6F5 #364379 #6570A6
#> 12        Rose #F9CCD8 #68353C #AF566C
#> 13    Sky Blue #C0E7FF #194770 #4D7EAE
#> 14       Cream #E8E6DF #545351 #B8B8B5
#> 15       Slate #535457 #F4FBFF #7E8186
#> 16        Noir #1B1B1C #E0E0DC #9A9DA1
```
