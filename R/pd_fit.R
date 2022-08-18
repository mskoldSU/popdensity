#' Fit spatial smooths (GAMs) of effort and intensity
#'
#' @param data Data containing the locations of individual captures, currently the package is expecting coordinates in SWEREF 99
#' @param region Survey region as an sf object
#' @param id_var Name of individual identifier field in data
#' @param coords Names of (planar) coordinates (eastings and northings)
#' @param basis_dimension Maximum basis dimension of spatial smooths
#' @param fixed_dim If TRUE, a non-penalised regression spline is used
#' @param cell_size Width and height of grid used to aggregate coordinates for intensity smooth
#' @param min_unit Name of minimal unit in data. For each combination of id_var and min_unit, a maximum of one capture is recorded.
#' @return An object of class "popdensity"
#' @importFrom rlang :=
#' @export
#' @examples
#' norrbotten <- pd_SWE_counties(county_name = "Norrbotten")
#' fit_2021 <- pd_fit(data = bears2021, region = norrbotten)
#' plot(fit_2021) + ggplot2::ggtitle("Animal density (females per square 10km)")
pd_fit <- function(data, region,
                   id_var = "id",
                   coords = c("east", "north"),
                   basis_dimension = 50,
                   fixed_dim = FALSE,
                   cell_size = c(10000, 10000),
                   min_unit = NULL){
  if (is.null(min_unit))
    min_unit <- "agg_id"

  if (!(sf::st_crs(region)$input %in% c("EPSG:3006", "SWEREF99 TM")))
    warning(paste0("region input has crs ", sf::st_crs(region)$input, ". pd_fit is designed for SWEREF 99."))

  data_sf <- sf::st_as_sf(data, coords = coords, crs = sf::st_crs(region)) |>
    dplyr::mutate(is_inside = sf::st_intersects(geometry, sf::st_union(region), sparse = FALSE) |> as.logical())

  if (sum(!data_sf$is_inside) > 0)
    warning(paste0("Data contains ", nrow(data), " records, but only ", sum(data_sf$is_inside), " falls within the region."))

  # Data aggregation

  agg_data <- data |>
    dplyr::group_by(.data[[id_var]]) |>
    dplyr::mutate(!!coords[1] := mean(.data[[coords[1]]]),
                  !!coords[2] := mean(.data[[coords[2]]]),
                  agg_id = 1:dplyr::n()) |>
    dplyr::ungroup() |>
    dplyr::select(dplyr::all_of(c(id_var, coords, min_unit))) |>
    dplyr::distinct() |>
    dplyr::count(.data[[id_var]], .data[[coords[1]]], .data[[coords[2]]]) |>
    dplyr::ungroup()

  gridcounts <- pd_gridcounts(agg_data, region,
                              coords = coords,
                              cell_size = cell_size)

  formula <- stats::as.formula(paste0("n ~ s(", coords[1], ", ", coords[2], ", k = ", basis_dimension, ", fx = ", fixed_dim, ")"))

  apparent_intensity_fit <- mgcv::gam(formula, data = gridcounts, family = "poisson")

  effort_fit <- mgcv::gam(formula, data = agg_data, family = countreg::ztpoisson)

  results <- list(apparent_intensity_fit = apparent_intensity_fit,
                  effort_fit = effort_fit,
                  coords = coords,
                  region = region)
  class(results) <- "popdensity"
  results
}
