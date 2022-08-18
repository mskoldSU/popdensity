#' Generic to predict a popdensity object on grid
#'
#' @param object Object of class popdensity
#' @param type Variables to be predicted
#' @param expand_grid Should grid be expanded?
#' @param ... Passed to mgcv::predict.gam
#' @return A table with locations
#' @export
predict.popdensity <- function(object, type = c("all", "pop_density", "mean_captures", "p_capture"), expand_grid = FALSE, ...){
  type <- match.arg(type)
  if (expand_grid == TRUE){
    newdata <- object$apparent_intensity_fit$model |>
      pd_expand_grid()
  }
  else
    newdata <- object$apparent_intensity_fit$model
  newdata |>
    dplyr::mutate(mean_captures = exp(mgcv::predict.gam(object$effort_fit, newdata = newdata, ...)),
                  p_capture = 1 - exp(-mean_captures),
                  pop_density = exp(mgcv::predict.gam(object$apparent_intensity_fit, newdata = newdata, ...)) / p_capture)
}
