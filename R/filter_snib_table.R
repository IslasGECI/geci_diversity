#' @export
get_observed_species_by_phylum <- function(snib_table, phylum) {
  snib_table |>
    filter_by_phylum(phylum) |>
    select_species_name_and_family() |>
    dplyr::distinct(especievalida, .keep_all = TRUE)
}

filter_by_phylum <- function(snib_data, phylum) {
  snib_data |> dplyr::filter(phylumdivisionvalido == phylum)
}

select_species_name_and_family <- function(snib_table) {
  snib_table |> dplyr::select(c("familiavalida", "especievalida"))
}
