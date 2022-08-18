#' Generic to plot a popdensity object
#'
#' @param x Object of class popdensity
#' @param type Variable to be plotted
#' @return A ggplot object
#' @import ggplot2
#' @export
plot.popdensity <- function(x, type = c("pop_density", "mean_captures", "p_capture")){
  type <- match.arg(type)
  region_bbox <- sf::st_make_grid(sf::st_buffer(sf::st_union(x$region), dist = 10000), n = c(1, 1))
  region_cover <- sf::st_difference(region_bbox, x$region)
  predictions <- predict.popdensity(x, expand_grid = TRUE) |>
    dplyr::select(dplyr::all_of(c(x$coords, type)))

  ggplot() + geom_contour_filled(data = predictions,
                                 aes(x = .data[[x$coords[1]]], y = .data[[x$coords[2]]],
                                     z = .data[[type]])) +
    geom_sf(data = region_cover, fill = "white") +
    geom_point(data = x$effort_fit$model, aes(x = .data[[x$coords[1]]], y = .data[[x$coords[2]]]),
               color = "white", size = .05) +
    theme_void() + labs(fill = "")
}
