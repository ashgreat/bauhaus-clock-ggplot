test_that("clock angles follow the time", {
  a <- bauhaus:::clock_angles("10:08:13")
  expect_equal(a[["minute"]], (8 + 13 / 60) * 6)
  expect_equal(a[["second"]], 13 * 6)
  expect_equal(a[["hour"]], (10 + 8 / 60 + 13 / 3600) * 30)
  expect_equal(bauhaus:::clock_angles("15:00")[["hour"]], 90)
  t <- as.POSIXct("2026-01-01 09:30:00", tz = "UTC")
  expect_equal(bauhaus:::clock_angles(t)[["hour"]], 285)
  expect_error(bauhaus:::clock_angles("noon"), "must be a date-time")
})

test_that("bauhaus_clock() builds a dial for every dial colour", {
  for (dial in c("white", "turquoise", "noir")) {
    p <- bauhaus_clock(dial)
    expect_s3_class(p, "ggplot")
    expect_no_error(ggplot2::ggplotGrob(p))
  }
  p <- bauhaus_clock("ocean", seconds = FALSE, hour_numerals = FALSE, minute_numerals = FALSE, grain = FALSE)
  expect_no_error(ggplot2::ggplotGrob(p))
})

test_that("shapes grow outwards", {
  sq <- data.frame(x = c(-1, 1, 1, -1), y = c(-1, -1, 1, 1), id = 1)
  expect_equal(max(bauhaus:::grow(sq, 0.5)$x), 1 + 0.5 / sqrt(2), tolerance = 0.01)
  expect_equal(max(bauhaus:::grow(sq[4:1, ], 0.5)$x), max(bauhaus:::grow(sq, 0.5)$x))
  expect_lt(max(bauhaus:::grow(sq, -0.5)$x), 1)
})
