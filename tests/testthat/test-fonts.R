test_that("the bundled fonts are present", {
  files <- bauhaus_font_files()
  expect_named(files, c("regular", "italic", "medium", "semibold", "bold", "bolditalic"))
  expect_true(all(file.exists(files)))
  expect_true(file.exists(system.file("fonts", "OFL.txt", package = "bauhaus")))
})

test_that("font family names", {
  expect_equal(bauhaus_font_family(), "Zalando Sans Expanded")
  expect_equal(bauhaus_font_family("medium"), "Zalando Sans Expanded Medium")
  expect_equal(bauhaus_font_family("semibold"), "Zalando Sans Expanded SemiBold")
  expect_error(bauhaus_font_family("black"))
})

test_that("the fonts are available to systemfonts", {
  for (family in c(bauhaus_font_family(), bauhaus_font_family("semibold"))) {
    match <- systemfonts::match_fonts(family)
    expect_match(basename(match$path), "^ZalandoSansExpanded", info = family)
  }
})
