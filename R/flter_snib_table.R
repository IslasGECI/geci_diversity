filter_by_phylum <- function(snib_data, phylum) {
  snib_data |> dplyr::filter(phylumdivisionvalido == phylum)
}

select_species_name_and_family <- function(snib_table) {
  snib_table |> dplyr::select(c("familiavalida", "especievalida"))
}
