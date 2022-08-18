#' Generic to print a popdensity object
#'
#' @param x Object of class popdensity
#' @param ... Not passed
#' @return Basic printout
#' @export
print.popdensity <- function(x, ...){
  cat("Fit of apparent intensity:")
  mgcv::print.gam(x$apparent_intensity_fit)
  cat("\n\nFit of effort:")
  mgcv::print.gam(x$effort_fit)
}
