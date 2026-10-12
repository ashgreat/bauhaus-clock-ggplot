# Builds `bauhaus_dials`, the colour table behind every theme.
#
# The values are the measured day-dial colours of the Bauhaus Clock screensaver. Plates are given in
# Display P3 and converted to sRGB here; the inks, steel, lume, hub and shadow colours were measured
# in sRGB and are used as they are. Night (lume) colours are deliberately left out.
#
# Run from the package root: Rscript data-raw/dials.R

p3_to_srgb <- function(r, g, b) {
  lin <- function(c) ifelse(c <= 0.04045, c / 12.92, ((c + 0.055) / 1.055)^2.4)
  enc <- function(c) {
    c <- pmin(pmax(c, 0), 1)
    ifelse(c <= 0.0031308, 12.92 * c, 1.055 * c^(1 / 2.4) - 0.055)
  }
  r <- lin(r); g <- lin(g); b <- lin(b)
  X <- 0.4865709 * r + 0.2656677 * g + 0.1982173 * b
  Y <- 0.2289746 * r + 0.6917385 * g + 0.0792869 * b
  Z <- 0.0451134 * g + 1.0439444 * b
  R <- 3.2404542 * X - 1.5371385 * Y - 0.4985314 * Z
  G <- -0.9692660 * X + 1.8760108 * Y + 0.0415560 * Z
  B <- 0.0556434 * X - 0.2040259 * Y + 1.0572252 * Z
  grDevices::rgb(enc(R), enc(G), enc(B))
}

dials <- read.table(header = TRUE, stringsAsFactors = FALSE, text = "
dial        name          plate_r plate_g plate_b numeral  track    steel    hand     lume     lume_hand hub      shadow_core shadow_ambient shadow_contact grain
white       White         1.000   1.000   1.000   #303334  #292B2B  #D7DBDD  #D5D9DA  #E7FCFA  #E3F8F3   #C7CCCD  #59676E     #566671        #546367        0
turquoise   Turquoise     0.690   0.890   0.890   #004F5D  #007C84  #CBD2D6  #CBD2D1  #E4FEFF  #DFFAFC   #BEC5C4  #009F9D     #01BBB9        #026F6E        3.8
glacier     Glacier       0.659   0.718   0.749   #1B3A49  #2E5B73  #D0DADC  #D1D7D9  #F4FFFB  #EEFDF8   #C3CACB  #31586A     #4C7186        #002842        4.8
ocean       Ocean         0.055   0.125   0.271   #D4FFF0  #6AF4D9  #C8C7D0  #C8CACE  #D4FFEF  #D0FDEC   #BBBEC1  #00041C     #01253E        #000000        5.3
tennis      Tennis        0.000   0.451   0.263   #A7FF01  #45FFBB  #D0DED5  #D0DCD5  #F6FFAA  #EDFEA4   #C3CEC7  #006400     #018101        #003700        7.8
signal_blue Signal_Blue   0.000   0.624   0.851   #FFFFFF  #9FFFFF  #C3CCCE  #C6CED1  #A7FFFF  #A1FEFB   #B9C2C3  #003C65     #1D547E        #00133C        4.0
salmon      Salmon        0.890   0.694   0.561   #531A03  #4C1200  #EAE6E6  #E4E3E1  #F6FFE9  #F1FCE5   #D6D7D4  #970000     #BA0F01        #660002        5.3
yellow      Yellow        0.949   0.745   0.000   #4A0305  #6E2C00  #DDD9D7  #D9D9D5  #EDFFE6  #E8FDE0   #CBCBC8  #970000     #BA0E01        #650002        4.45
beige       Beige         0.878   0.808   0.624   #4F3513  #856641  #E4E1DF  #E0E0DC  #ECFCFC  #E9F8F6   #D0D1CD  #9B7C00     #C09900        #684B02        5.3
pistachio   Pistachio     0.714   0.769   0.639   #233B13  #364F2F  #E0E2DE  #DCDFDA  #EEFDF5  #E9F7EF   #CCD2CC  #365D37     #4F784E        #052E09        4.4
lavender    Lavender      0.765   0.788   0.898   #364379  #6570A6  #E2E3E8  #DFE1E7  #EEFCFC  #E9F6F5   #D2D4DA  #5D6195     #787EB4        #2B366C        4.7
rose        Rose          0.898   0.757   0.796   #68353C  #AF566C  #E5E2E1  #E3E1E2  #FCEBED  #F4E6E7   #D6D3D4  #B20021     #D31C3F        #820000        4.4
sky_blue    Sky_Blue      0.733   0.851   0.941   #194770  #4D7EAE  #CDD8DC  #CFD8DB  #E4FFFF  #DEF8F9   #C2CCCE  #0072B8     #008ED3        #02438F        4.3
cream       Cream         0.859   0.851   0.827   #545351  #B8B8B5  #DADBD6  #E2E2DF  #FAFAF2  #F4F2ED   #D5D5D2  #8F5F44     #905A45        #916246        2.6
slate       Slate         0.275   0.278   0.290   #F4FBFF  #7E8186  #BAB6B8  #D1D0D2  #F6FCFE  #F0F5FD   #C5C4C6  #0D0D0D     #0F0F0F        #0B0B0B        3.9
noir        Noir          0.055   0.055   0.059   #E0E0DC  #9A9DA1  #C8C8C6  #D1D2CF  #DFDFDF  #DBDBDB   #C4C4C2  #000000     #000000        #000000        3.9
", comment.char = "")
dials$name <- gsub("_", " ", dials$name, fixed = TRUE)

# The screensaver lifts every grained plate by 13/255 before adding the grain (White: no lift, no grain).
lift <- ifelse(dials$grain > 0, 13 / 255, 0)
dials$plate <- p3_to_srgb(dials$plate_r, dials$plate_g, dials$plate_b)
dials$paper <- p3_to_srgb(dials$plate_r + lift, dials$plate_g + lift, dials$plate_b + lift)

# Dark dials carry light ink; it decides how the themes pick their accents.
lum <- function(hex) {
  m <- grDevices::col2rgb(hex) / 255
  m <- ifelse(m <= 0.04045, m / 12.92, ((m + 0.055) / 1.055)^2.4)
  colSums(m * c(0.2126, 0.7152, 0.0722))
}
dials$dark <- lum(dials$paper) < lum(dials$numeral)

bauhaus_dials <- dials[, c(
  "dial", "name", "dark", "paper", "plate", "numeral", "track", "steel", "hand", "lume",
  "lume_hand", "hub", "shadow_core", "shadow_ambient", "shadow_contact", "grain"
)]
rownames(bauhaus_dials) <- NULL

usethis::use_data(bauhaus_dials, overwrite = TRUE)
