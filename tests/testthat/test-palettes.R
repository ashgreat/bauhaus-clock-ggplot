test_that("discrete palettes have eight colours, led by the dial's own colours", {
  for (dial in bauhaus_dial_names()) {
    pal <- bauhaus_palette(dial)
    expect_length(pal, 8)
    expect_false(anyDuplicated(pal) > 0, info = dial)
  }
  expect_equal(bauhaus_palette("turquoise", n = 1), bauhaus_colours("turquoise")[["track"]])
  expect_equal(bauhaus_palette("ocean", n = 1), bauhaus_colours("ocean")[["track"]])
})

test_that("discrete palette colours stand out against the plate", {
  for (dial in setdiff(bauhaus_dial_names(), c("signal_blue", "tennis"))) {
    paper <- bauhaus_colours(dial)[["paper"]]
    ratio <- bauhaus:::contrast_ratio(bauhaus_palette(dial, n = 6), paper)
    expect_true(all(ratio >= 3), info = dial)
  }
})

test_that("palette functions behave like scales palettes", {
  pal <- pal_bauhaus("yellow")
  expect_equal(pal(3), bauhaus_palette("yellow", n = 3))
  expect_equal(attr(pal, "nlevels"), 8)
  expect_warning(pal(9), "8 colours")
  expect_equal(pal_bauhaus("yellow", reverse = TRUE)(1), bauhaus_palette("yellow")[8])

  ramp <- pal_bauhaus_c("glacier")
  expect_length(ramp(c(0, 0.5, 1)), 3)
  expect_length(bauhaus_palette("glacier", type = "sequential"), 7)
  expect_equal(
    bauhaus_palette("glacier", type = "sequential", reverse = TRUE),
    rev(bauhaus_palette("glacier", type = "sequential"))
  )
})

test_that("sequential palettes end in the numeral ink", {
  for (dial in bauhaus_dial_names()) {
    ramp <- bauhaus_palette(dial, type = "sequential", n = 2)
    expect_equal(ramp[2], bauhaus_colours(dial)[["numeral"]], info = dial)
  }
})

test_that("scales map data to the dial palettes", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(cyl))) +
    ggplot2::geom_point() +
    scale_colour_bauhaus_d("rose")
  built <- ggplot2::ggplot_build(p)
  expect_setequal(unique(built$data[[1]]$colour), bauhaus_palette("rose", n = 3))

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, fill = hp)) +
    ggplot2::geom_point(shape = 21) +
    scale_fill_bauhaus_c("ocean")
  fills <- ggplot2::ggplot_build(p)$data[[1]]$fill
  expect_true(all(grepl("^#", fills)))

  expect_s3_class(scale_fill_bauhaus_b("salmon"), "ScaleBinned")
  expect_s3_class(scale_color_bauhaus_d(), "ScaleDiscrete")
  expect_s3_class(scale_fill_bauhaus_d(aesthetics = c("colour", "fill")), "ScaleDiscrete")
})
