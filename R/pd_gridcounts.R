#' Counts individuals on a grid
#'
#' @param data Data containing the locations individual activity centers, currently the package is expecting coordinates in SWEREF 99
#' @param region Survey region as an sf object
#' @param coords Names of (planar) coordinates (eastings and northings)
#' @param cell_size Width and height of grid used to aggregate coordinates for intensity smooth
#' @return A data-frame with locations (grid centers) and counts
#' @export
pd_gridcounts <- function(data, region, coords = c("east", "north"), cell_size = c(10000, 10000)){

  # A grid of rectangles covering region
  grid <- sf::st_make_grid(region, cellsize = cell_size) |>
    sf::st_as_sf() |>
    dplyr::mutate(in_region = sf::st_intersects(x, sf::st_union(region), sparse = FALSE) |> as.logical(),
                  grid_id = 1:dplyr::n()) |>
    dplyr::filter(in_region == TRUE) |> # Drop rectangles that do not intersect with region
    dplyr::select(-in_region)

  # Counts number of points in data that fall into each grid rectangle,
  # drops geometry but keeps centroid coordinates
  grid_counts <- data |>
    sf::st_as_sf(coords = coords, crs = sf::st_crs(region)) |>
    sf::st_join(grid) |>
    dplyr::as_tibble() |>
    dplyr::count(grid_id) |>
    dplyr::right_join(grid, by = "grid_id") |>
    dplyr::rowwise() |>
    dplyr::mutate(!!coords[1] := mean(sf::st_coordinates(x)[-1, 1]),
                  !!coords[2] := mean(sf::st_coordinates(x)[-1, 2])) |>
    dplyr::select(-x) |>
    dplyr::ungroup() |>
    dplyr::mutate(n = ifelse(is.na(n), 0, n))
  grid_counts
}
