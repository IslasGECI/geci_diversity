calculate_diversity_indexes <- function(sampling_data) {
  index_list <- c("simpson", "shannon")
  simpson_index <- vegan::diversity(sampling_data, index_list[1])
  shannon_index <- vegan::diversity(sampling_data, index_list[2])
  df <- cbind(simpson_index, shannon_index)
  colnames(df) <- index_list
  return(df)
}

transform_intercept_enclosure_to_vegan <- function(point_line_data) {
  vegetation <- drop_non_vegetation(point_line_data)
  sites <- sanitize_enclousure_transect_names(vegetation)
  initialized_community <- initialize_community_matrix(vegetation, sites)
  count_sighted_species(initialized_community, vegetation, sites)
}
transform_enclosure_to_vegan <- function(point_line_data) {
  vegetation <- drop_non_vegetation(point_line_data)
  sites <- vegetation$Cerco
  community <- initialize_community_matrix(vegetation, sites)
  count_sighted_species(community, vegetation, sites)
}

initialize_community_matrix <- function(vegetation, sites) {
  unique_and_sorted_sites <- sort(unique(sites))
  sorted_species <- sort(unique(vegetation$Especie))
  species <- sanitize_species_names(sorted_species)
  community <- matrix(
    0,
    nrow = length(unique_and_sorted_sites),
    ncol = length(species),
    dimnames = list(unique_and_sorted_sites, species)
  )
  return(community)
}

count_sighted_species <- function(community, vegetation, site_key) {
  species_key <- sanitize_species_names(vegetation$Especie)
  for (i in seq_along(species_key)) {
    community[site_key[i], species_key[i]] <- community[site_key[i], species_key[i]] + 1
  }
  return(community)
}
sanitize_species_names <- function(species_names) {
  gsub(" ", "_", tolower(species_names))
}
sanitize_enclousure_transect_names <- function(vegetation) {
  paste(vegetation$Cerco, vegetation$Transecto, sep = "_")
}
