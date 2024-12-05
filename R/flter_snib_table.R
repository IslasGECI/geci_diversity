filter_by_phylum <- function(snib_data, phylum) {
  snib_data |> dplyr::filter(phylumdivisionvalido == phylum)
}
