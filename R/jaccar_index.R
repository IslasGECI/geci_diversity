calculate_jaccard_index <- function(a_community, b_community) {
  A <- nrow(a_community)
  B <- nrow(b_community)
  C <- get_number_of_common_species(a_community, b_community)
  (C / (A + B - C)) * 100
}

get_number_of_common_species <- function(a_community, b_community) {
  list_unique_species_on_both(a_community, b_community) |> nrow()
}

list_unique_species_on_both <- function(a_community, b_community) {
  dplyr::inner_join(a_community, b_community)
}
