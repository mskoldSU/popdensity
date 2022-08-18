#' Locations of identified scat samples of bears
#'
#'
#' A dataset of locations of female bear scat samples collected
#' during the 2011 survey in Norrbotten county, Sweden
#'
#' @format A data frame with 715 rows and 4 variables:
#' \describe{
#'   \item{id}{Identifier of individual}
#'   \item{date}{Date scat sample was found}
#'   \item{east}{Easting in SWEREF99 TM coordinate system (meters)}
#'   \item{north}{Northing in SWEREF99 TM coordinate system (meters)}
#' }
#' @source \url{https://www.rovbase.se/}
"bears2021"

#' Boundaries of Swedish counties
#'
#' Boundaries of Sweden's 21 counties in (planar) coordinate system SWEREF99 TM
#'
#' @format An sf object with polygons describing boundaries of Sweden's 21 counties
#' \describe{
#'   \item{LnKod}{County integer code}
#'   \item{LnNamn}{County name}
#'   \item{geometry}{Polygon describing county boundaries}
#' }
#' @source \url{https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/}
#' @import sf
"SWEcounties"
