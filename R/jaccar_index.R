get_number_of_common_species <- function(a_community, b_community) {
  dplyr::inner_join(a_community, b_community) |> nrow()
}
