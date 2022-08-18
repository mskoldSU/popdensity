#' Plots a rootogram of either the intensity or effort fit
#'
#' @param fit Object of class popdensity
#' @param type Variable to be plotted
#' @return A ggplot object
#' @import ggplot2
#' @export
#' @examples
#' norrbotten <- pd_SWE_counties(county_name = "Norrbotten")
#' fit_2021 <- pd_fit(data = bears2021, region = norrbotten)
#' # Poisson distribution of individuals per grid cell seems ok
#' pd_rootogram(fit_2021, type = "apparent_intensity")
#' # Zero-truncated Poisson distribution captures per individuals
#' # does not capture all individual heterogeneity
#' pd_rootogram(fit_2021, type = "effort")
pd_rootogram <- function(fit, type = c("effort", "apparent_intensity")){
  type <- match.arg(type)

  if (type == "apparent_intensity"){
    data <- fit$apparent_intensity$model |>
      dplyr::mutate(individuals = factor(n, levels = 0:max(n))) |>
      dplyr::count(individuals, .drop = FALSE) |>
      dplyr::mutate(individuals = as.numeric(as.character(individuals))) |>
      dplyr::rowwise() |>
      dplyr::mutate(freq = sum(stats::dpois(individuals, lambda = exp(mgcv::predict.gam(fit$apparent_intensity_fit)))))
    p <- ggplot(data, aes(x = individuals, y = sqrt(freq))) +
      geom_rect(aes(xmin = individuals-.4, xmax = individuals+.4, ymax = sqrt(freq), ymin = sqrt(freq) - sqrt(n)), fill = "grey") +
      geom_point() + geom_line() +
      geom_hline(yintercept = 0) +
      theme_bw() + scale_x_continuous(breaks = 0:max(data$individuals)) + labs(x = "Number of individuals per grid cell")
  }
  if (type == "effort"){
    data <- fit$effort_fit$model |>
      dplyr::mutate(captures = factor(n, levels = 1:max(n))) |>
      dplyr::count(captures, .drop = FALSE) |>
      dplyr::mutate(captures = as.numeric(as.character(captures))) |>
      dplyr::rowwise() |>
      dplyr::mutate(freq = sum(countreg::dztpois(captures, lambda = exp(mgcv::predict.gam(fit$effort_fit)))))
    p <- ggplot(data, aes(x = captures, y = sqrt(freq))) +
      geom_rect(aes(xmin = captures-.4, xmax = captures+.4, ymax = sqrt(freq), ymin = sqrt(freq) - sqrt(n)), fill = "grey") +
      geom_point() + geom_line() +
      geom_hline(yintercept = 0) +
      theme_bw() + scale_x_continuous(breaks = 1:max(data$captures)) + labs(x = "Number of captures per individual")
  }
  p
}
