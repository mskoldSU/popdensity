#' Generic to summarise a popdensity object
#'
#' @param x Object of class popdensity
#' @param ... Not passed
#' @return Summaries of the fitted objects
#' @export
summary.popdensity <- function(x, ...){
  cat("Fit of apparent intensity:")
  mgcv::summary.gam(x$apparent_intensity_fit) |> print()
  cat("\n\nFit of effort:")
  mgcv::summary.gam(x$effort_fit) |> print()
}
