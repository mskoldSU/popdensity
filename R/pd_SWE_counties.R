#' Loads sf boundaries of swedish counties in SWEREF99 TM
#'
#' @param county_name Vector of possibly partial county names to be loaded
#' @param county_nr Vector of county number to be loaded
#' @param ... Passed to st_read
#' @return An sf polygon
#' @export
pd_SWE_counties <- function(county_name = NA, county_nr = NA, ...){
  SWE_counties <- sf::st_read(system.file("LanSweref99TM", "Lan_Sweref99TM_region.shp", package = "popdensity"), ...)
  dplyr::filter(SWE_counties, stringr::str_detect(LnNamn, paste0(county_name, collapse = "|")) | (LnKod %in% county_nr))
}
