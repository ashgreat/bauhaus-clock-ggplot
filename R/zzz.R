.onLoad <- function(libname, pkgname) {
  S7::methods_register()
  registerS3method(
    "element_grob", "bauhaus::element_grain", element_grob_grain,
    envir = asNamespace("ggplot2")
  )
  register_bauhaus_fonts()
  register_device_fallbacks()
  invisible()
}
