#' Expands a grid to reduce border effect when plotting
#'
#' Mainly for internal use
#' @param grid A grid
#' @param coords Names of (planar) coordinates (eastings and northings)
#' @return An expanded grid
#' @export
pd_expand_grid <- function(grid, coords = c("east", "north")){
  x_coords <- grid[[coords[1]]] |>
    unique() |>
    sort()
  y_coords <- grid[[coords[2]]] |>
    unique() |>
    sort()
  dx <- min(diff(x_coords))
  dy <- min(diff(y_coords))
  boxed_grid <- expand.grid(c(min(x_coords) - dx, x_coords, max(x_coords) + dx),
                            c(min(y_coords) - dy, y_coords, max(y_coords) + dy))
  names(boxed_grid) <- coords
  boxed_grid
}
