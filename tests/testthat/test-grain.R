test_that("the grain field is the screensaver's: zero mean, unit variance, horizontal streaks", {
  f <- bauhaus:::grain_field / 1000
  expect_equal(dim(f), c(512, 512))
  expect_lt(abs(mean(f)), 0.01)
  expect_equal(stats::sd(as.vector(f)), 1, tolerance = 0.02)
  horizontal <- stats::cor(as.vector(f[, -1]), as.vector(f[, -512]))
  vertical <- stats::cor(as.vector(f[-1, ]), as.vector(f[-512, ]))
  expect_gt(horizontal, 0.5)
  expect_gt(horizontal, vertical + 0.2)
})

test_that("grain images hold the plate plus sigma times the field", {
  img <- bauhaus:::grain_image("#808080", 10, 40, 60)
  expect_s3_class(img, "nativeRaster")
  expect_equal(dim(img), c(40L, 60L))
  # nativeRaster is row-major, packed as R + G * 2^8 + B * 2^16 + A * 2^24.
  packed <- matrix(as.vector(img), nrow = 40, byrow = TRUE)
  red <- packed %% 256
  expected <- pmin(pmax(round(128 + 10 * bauhaus:::grain_field[1:40, 1:60] / 1000), 0), 255)
  expect_equal(red, expected)
  green <- (packed %/% 256) %% 256
  expect_equal(green, red)
})

test_that("grain images tile seamlessly beyond 512 samples", {
  img <- bauhaus:::grain_image("#808080", 4, 2, 1030)
  packed <- matrix(as.vector(img), nrow = 2, byrow = TRUE)
  expect_equal(packed[, 1:6], packed[, 513:518])
})

test_that("element_grain inherits from element_rect", {
  el <- element_grain(fill = "#F1DAA6", sigma = 6, density = 100)
  expect_true(S7::S7_inherits(el, ggplot2::element_rect))
  expect_equal(el@fill, "#F1DAA6")
  expect_equal(el@sigma, 6)
  expect_equal(element_grain(color = "red")@colour, "red")
})

test_that("adding element_rect() keeps the grain unless it sets a fill", {
  th <- theme_bauhaus("beige")
  bordered <- th + ggplot2::theme(plot.background = ggplot2::element_rect(colour = "black"))
  bg <- ggplot2::calc_element("plot.background", bordered)
  expect_true(S7::S7_inherits(bg, element_grain))
  expect_equal(bg@colour, "black")
  expect_equal(bg@fill, bauhaus_colours("beige")[["paper"]])
  expect_equal(bg@sigma, 5.3)

  flat <- th + ggplot2::theme(plot.background = ggplot2::element_rect(fill = "white"))
  bg <- ggplot2::calc_element("plot.background", flat)
  expect_false(S7::S7_inherits(bg, element_grain))
  expect_equal(bg@fill, "white")

  stronger <- th + ggplot2::theme(plot.background = element_grain(sigma = 12))
  bg <- ggplot2::calc_element("plot.background", stronger)
  expect_equal(bg@sigma, 12)
  expect_equal(bg@fill, bauhaus_colours("beige")[["paper"]])
})

test_that("element_grain() can be added to any theme", {
  th <- ggplot2::theme_grey() + ggplot2::theme(plot.background = element_grain(fill = "#F1DAA6", sigma = 6))
  bg <- ggplot2::calc_element("plot.background", th)
  expect_true(S7::S7_inherits(bg, element_grain))
  expect_equal(bg@fill, "#F1DAA6")
  expect_equal(bg@colour, "white")
  expect_null(bg@density)

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::theme(plot.background = element_grain(fill = "#F1DAA6"))
  expect_no_error(ggplot2::ggplotGrob(p))
})

test_that("the grain grob draws a raster that can be switched off", {
  grob <- ggplot2::element_grob(element_grain(fill = "#AFF2F1", colour = NA, sigma = 3.8))
  expect_s3_class(grob, "bauhaus_grain")

  file <- withr::local_tempfile(fileext = ".png")
  grDevices::png(file, width = 200, height = 100)
  grid::grid.newpage()
  drawn <- grid::makeContent(grob)
  expect_true(any(vapply(drawn$children, inherits, logical(1), "rastergrob")))
  withr::local_options(bauhaus.grain = FALSE)
  flat <- grid::makeContent(grob)
  expect_false(any(vapply(flat$children, inherits, logical(1), "rastergrob")))
  grDevices::dev.off()
})
