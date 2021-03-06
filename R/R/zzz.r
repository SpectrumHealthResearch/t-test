.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    paste(
      "This is a development version of `stt`",
      "======================================",
      "Functionality is incomplete:",
      "  - Only pooled and Satterthwaite methods are supported",
      "  - Calculation outputs have not been unit tested",
      "Please be sure to review all calculations for accuracy",
      "since this is provided AS IS with NO WARRANTY!",
      sep = "\n"
    )
  )
}
