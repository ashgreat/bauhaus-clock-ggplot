test_that("the dial table has sixteen dials with valid colours", {
  expect_equal(nrow(bauhaus_dials), 16)
  expect_equal(bauhaus_dial_names()[1:2], c("white", "turquoise"))
  expect_true("Signal Blue" %in% bauhaus_dial_names(display = TRUE))
  colour_cols <- setdiff(names(bauhaus_dials), c("dial", "name", "dark", "grain"))
  for (col in colour_cols) {
    expect_match(bauhaus_dials[[col]], "^#[0-9A-F]{6}$", info = col)
  }
  expect_equal(bauhaus_dials$grain[bauhaus_dials$dial == "white"], 0)
  expect_equal(max(bauhaus_dials$grain), bauhaus_dials$grain[bauhaus_dials$dial == "tennis"])
})

test_that("the paper is the plate lifted by 13/255", {
  turquoise <- bauhaus_colours("turquoise")
  lift <- grDevices::col2rgb(turquoise[["paper"]]) - grDevices::col2rgb(turquoise[["plate"]])
  expect_true(all(lift >= 10 & lift <= 15))
  white <- bauhaus_colours("white")
  expect_equal(white[["paper"]], white[["plate"]])
})

test_that("dial names are matched loosely", {
  expect_equal(bauhaus_colours("Signal Blue"), bauhaus_colours("signal_blue"))
  expect_equal(bauhaus_colours("SKY-BLUE"), bauhaus_colours("sky_blue"))
  expect_equal(bauhaus_colors("ocean"), bauhaus_colours("ocean"))
  expect_named(bauhaus_colours("noir"), c(
    "paper", "plate", "numeral", "track", "steel", "hand", "lume", "lume_hand", "hub",
    "shadow_core", "shadow_ambient", "shadow_contact"
  ))
})

test_that("unknown dials give a helpful error", {
  expect_error(bauhaus_colours("purple"), "Unknown dial")
  expect_error(theme_bauhaus("night"), "Unknown dial")
  expect_error(bauhaus_colours(c("white", "noir")), "single dial name")
})
