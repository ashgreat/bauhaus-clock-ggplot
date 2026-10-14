#' The Bauhaus typeface
#'
#' The themes set type in **Zalando Sans Expanded**, the typeface the Bauhaus Clock screensaver uses
#' for its dial numerals. The font is bundled with the package (SIL Open Font License 1.1) and
#' registered with \pkg{systemfonts} when the package loads, so it works without installing anything
#' on graphics devices that use systemfonts: [ragg][ragg::agg_png] (the default for
#' [ggplot2::ggsave()] when ragg is installed, and the "AGG" backend in RStudio and Positron) and
#' [svglite][svglite::svglite].
#'
#' Three families are registered:
#'
#' * `"Zalando Sans Expanded"`: regular, bold, italic and bold italic. Used for body text.
#' * `"Zalando Sans Expanded Medium"`: medium weight.
#' * `"Zalando Sans Expanded SemiBold"`: semibold weight. Used for titles.
#'
#' `bauhaus_font_family()` returns the family name to pass to `base_family`, `header_family` or a
#' geom's `family`. `bauhaus_font_files()` returns the paths of the bundled font files, if you want
#' to install them on your system. `bauhaus_showtext()` registers the fonts with \pkg{showtext}
#' instead, for devices that do not use systemfonts, such as [grDevices::pdf()] or the default
#' Windows and macOS screen devices.
#'
#' @param weight `"regular"`, `"medium"` or `"semibold"`.
#' @return `bauhaus_font_family()` returns a family name. `bauhaus_font_files()` returns a named
#'   character vector of file paths. `bauhaus_showtext()` is called for its side effects and returns
#'   the registered family names invisibly.
#' @export
#' @examples
#' bauhaus_font_family()
#' bauhaus_font_family("semibold")
#' basename(bauhaus_font_files())
bauhaus_font_family <- function(weight = c("regular", "medium", "semibold")) {
  weight <- rlang::arg_match(weight)
  switch(weight,
    regular = "Zalando Sans Expanded",
    medium = "Zalando Sans Expanded Medium",
    semibold = "Zalando Sans Expanded SemiBold"
  )
}

#' @rdname bauhaus_font_family
#' @export
bauhaus_font_files <- function() {
  styles <- c(
    regular = "Regular", italic = "Italic", medium = "Medium", semibold = "SemiBold",
    bold = "Bold", bolditalic = "BoldItalic"
  )
  files <- system.file(
    "fonts", paste0("ZalandoSansExpanded-", styles, ".ttf"),
    package = "bauhaus", mustWork = TRUE
  )
  stats::setNames(files, names(styles))
}

#' @rdname bauhaus_font_family
#' @param enable If `TRUE`, also call [showtext::showtext_auto()] so that showtext renders all text
#'   from now on.
#' @export
bauhaus_showtext <- function(enable = TRUE) {
  rlang::check_installed(c("showtext", "sysfonts"), reason = "to render the Bauhaus fonts with showtext.")
  f <- bauhaus_font_files()
  sysfonts::font_add(
    bauhaus_font_family("regular"),
    regular = f[["regular"]], bold = f[["bold"]],
    italic = f[["italic"]], bolditalic = f[["bolditalic"]]
  )
  sysfonts::font_add(bauhaus_font_family("medium"), regular = f[["medium"]], bold = f[["semibold"]])
  sysfonts::font_add(bauhaus_font_family("semibold"), regular = f[["semibold"]], bold = f[["bold"]])
  if (isTRUE(enable)) showtext::showtext_auto()
  invisible(vapply(c("regular", "medium", "semibold"), bauhaus_font_family, character(1)))
}

# Called from .onLoad(). Devices that do not use systemfonts need to know the family names too:
# pdf() and postscript() refuse unknown families, so the names are mapped to Helvetica there; the
# macOS quartz() device draws no text at all for a family it cannot find, so the names are mapped to
# its sans there unless the font is installed on the system; and on Windows they are added to the
# font database (Windows substitutes a default face if the font is not installed) to avoid a warning
# for every piece of text.
register_device_fallbacks <- function() {
  families <- vapply(c("regular", "medium", "semibold"), bauhaus_font_family, character(1))
  try(
    {
      missing <- setdiff(families, names(grDevices::pdfFonts()))
      if (length(missing)) {
        helvetica <- grDevices::pdfFonts()$Helvetica
        do.call(grDevices::pdfFonts, stats::setNames(rep(list(helvetica), length(missing)), missing))
      }
      missing <- setdiff(families, names(grDevices::postscriptFonts()))
      if (length(missing)) {
        helvetica <- grDevices::postscriptFonts()$Helvetica
        do.call(grDevices::postscriptFonts, stats::setNames(rep(list(helvetica), length(missing)), missing))
      }
    },
    silent = TRUE
  )
  if (Sys.info()[["sysname"]] == "Darwin") {
    try(
      {
        quartz_fonts <- get("quartzFonts", envir = asNamespace("grDevices"))
        installed <- tryCatch(systemfonts::system_fonts()$family, error = function(e) character())
        missing <- setdiff(families, c(names(quartz_fonts()), installed))
        if (length(missing)) {
          sans <- quartz_fonts()$sans
          do.call(quartz_fonts, stats::setNames(rep(list(sans), length(missing)), missing))
        }
      },
      silent = TRUE
    )
  }
  if (.Platform$OS.type == "windows") {
    try(
      {
        win_fonts <- get("windowsFonts", envir = asNamespace("grDevices"))
        win_font <- get("windowsFont", envir = asNamespace("grDevices"))
        missing <- setdiff(families, names(win_fonts()))
        if (length(missing)) {
          do.call(win_fonts, stats::setNames(lapply(missing, win_font), missing))
        }
      },
      silent = TRUE
    )
  }
  invisible()
}

# Called from .onLoad(). A family the user already has installed is left alone.
register_bauhaus_fonts <- function() {
  f <- bauhaus_font_files()
  installed <- tryCatch(systemfonts::system_fonts()$family, error = function(e) character())
  registered <- tryCatch(systemfonts::registry_fonts()$family, error = function(e) character())
  register <- function(name, ...) {
    if (name %in% c(installed, registered)) {
      return(invisible(FALSE))
    }
    tryCatch(
      {
        systemfonts::register_font(name, ...)
        invisible(TRUE)
      },
      error = function(e) invisible(FALSE)
    )
  }
  register(
    bauhaus_font_family("regular"),
    plain = f[["regular"]], bold = f[["bold"]],
    italic = f[["italic"]], bolditalic = f[["bolditalic"]]
  )
  register(bauhaus_font_family("medium"), plain = f[["medium"]], bold = f[["semibold"]])
  register(bauhaus_font_family("semibold"), plain = f[["semibold"]], bold = f[["bold"]])
}
