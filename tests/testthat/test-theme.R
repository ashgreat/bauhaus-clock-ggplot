plot_bg <- function(theme) ggplot2::calc_element("plot.background", ggplot2::theme_grey() + theme)

test_that("every dial gives a complete theme on a grained plate", {
  for (dial in bauhaus_dial_names()) {
    th <- theme_bauhaus(dial)
    expect_true(isTRUE(attr(th, "complete")), info = dial)
    bg <- plot_bg(th)
    expect_equal(bg@fill, bauhaus_colours(dial)[["paper"]], info = dial)
    if (dial == "white") {
      expect_false(S7::S7_inherits(bg, element_grain))
    } else {
      expect_true(S7::S7_inherits(bg, element_grain), info = dial)
      expect_equal(bg@sigma, bauhaus_dials$grain[bauhaus_dials$dial == dial])
    }
  }
})

test_that("the shortcuts match theme_bauhaus()", {
  expect_equal(plot_bg(theme_bauhaus_ocean())@fill, plot_bg(theme_bauhaus("ocean"))@fill)
  expect_equal(plot_bg(theme_bauhaus_signal_blue(grain = 2))@sigma, 2)
})

test_that("grain can be switched off or set", {
  expect_false(S7::S7_inherits(plot_bg(theme_bauhaus("tennis", grain = FALSE)), element_grain))
  expect_equal(plot_bg(theme_bauhaus("tennis", grain = 9))@sigma, 9)
  expect_equal(plot_bg(theme_bauhaus("tennis", grain_density = 80))@density, 80)
})

test_that("text and lines use the dial's inks", {
  th <- theme_bauhaus("salmon")
  col <- bauhaus_colours("salmon")
  expect_equal(ggplot2::calc_element("plot.title", th)@colour, col[["numeral"]])
  expect_equal(ggplot2::calc_element("axis.text.x.bottom", th)@colour, col[["track"]])
  expect_equal(ggplot2::calc_element("axis.ticks.x.bottom", th)@colour, col[["track"]])
  expect_equal(ggplot2::calc_element("axis.ticks.x.bottom", th)@lineend, "round")
  expect_equal(ggplot2::calc_element("text", th)@family, bauhaus_font_family())
  expect_equal(ggplot2::calc_element("plot.title", th)@family, bauhaus_font_family("semibold"))
})

test_that("faint track inks are strengthened for axis labels", {
  for (dial in c("cream", "slate")) {
    th <- theme_bauhaus(dial)
    col <- bauhaus_colours(dial)
    axis <- ggplot2::calc_element("axis.text.x.bottom", th)@colour
    expect_false(axis == col[["track"]])
    expect_gte(bauhaus:::contrast_ratio(axis, col[["paper"]]), 3.5)
  }
})

test_that("grid lines can be limited to one direction", {
  expect_true(ggplot2::is_theme_element(
    ggplot2::calc_element("panel.grid.major.x", theme_bauhaus(grid = "y")), "blank"
  ))
  expect_false(ggplot2::is_theme_element(
    ggplot2::calc_element("panel.grid.major.y", theme_bauhaus(grid = "y")), "blank"
  ))
  th <- theme_bauhaus(grid = "none")
  expect_true(ggplot2::is_theme_element(ggplot2::calc_element("panel.grid.major.x", th), "blank"))
  expect_true(ggplot2::is_theme_element(ggplot2::calc_element("panel.grid.major.y", th), "blank"))
})

test_that("the theme sets the dial's palettes and geom defaults", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(gear))) +
    ggplot2::geom_point() +
    theme_bauhaus("lavender")
  built <- ggplot2::ggplot_build(p)
  expect_setequal(unique(built$data[[1]]$colour), bauhaus_palette("lavender", n = 3))

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point() + theme_bauhaus("noir")
  expect_equal(unique(ggplot2::ggplot_build(p)$data[[1]]$colour), bauhaus_colours("noir")[["numeral"]])

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = hp)) +
    ggplot2::geom_point() +
    theme_bauhaus("pistachio")
  cols <- ggplot2::ggplot_build(p)$data[[1]]$colour
  top <- cols[which.max(mtcars$hp)]
  expect_equal(toupper(top), bauhaus_colours("pistachio")[["numeral"]])
})

test_that("plots with the theme render", {
  skip_if_not_installed("ragg")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(cyl))) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~am) +
    ggplot2::labs(title = "Title", subtitle = "Subtitle", caption = "Caption") +
    theme_bauhaus("glacier")
  file <- withr::local_tempfile(fileext = ".png")
  ragg::agg_png(file, width = 600, height = 400)
  expect_no_error(print(p))
  grDevices::dev.off()
  expect_gt(file.size(file), 1000)
})

test_that("plots with the theme render on the pdf device", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "Title") +
    theme_bauhaus("rose")
  file <- withr::local_tempfile(fileext = ".pdf")
  grDevices::pdf(file)
  expect_no_error(print(p))
  grDevices::dev.off()
  expect_gt(file.size(file), 1000)
})
