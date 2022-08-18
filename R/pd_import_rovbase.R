#' Cleans and renames file exported from RovBase
#'
#' Samples without id (filled Individ) are not included
#'
#' @param file Filename of RovBase Excel export
#' @return A data-frame with fields date, id, species, sex, sample_type, east, north, county, collector
#' @export
pd_import_rovbase <- function(file){
  raw <- readxl::read_excel(file, guess_max = 100000)
  raw |> dplyr::select(date = Funnetdato,
                id = Individ,
                species = `Art (Analyse)`,
                sex = Kjønn,
                sample_type = Prøvetype,
                east = `Øst (UTM33/SWEREF99 TM)`,
                north = `Nord (UTM33/SWEREF99 TM)`,
                county = Fylke,
                collector = PrøveinnsamlerNavn) |>
    dplyr::filter(!is.na(id)) |>
    dplyr::mutate(date = as.Date(date))
}
