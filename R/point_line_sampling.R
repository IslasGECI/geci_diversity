join_point_line_with_vegetation_metadata <- function(point_line_data, vegetation_metadata) {
  dplyr::left_join(point_line_data, vegetation_metadata, by = "Especie")
}

calculate_species_abundance_by_enclousure <- function(data) {
  non_vegetation <- c("Suelo", "Roca", "Hojarasca")
  is_vegetation <- !data$Especie %in% non_vegetation
  vegetation <- data[is_vegetation, ]
  counts_by_enclosure <- dplyr::count(vegetation, Cerco, Especie, name = "number_of_individuals_by_species")
  vegetation_points <- dplyr::count(vegetation, Cerco, name = "vegetation_points")
  abundance <- dplyr::left_join(counts_by_enclosure, vegetation_points, by = "Cerco") |>
    dplyr::mutate(abundance = number_of_individuals_by_species, relative_abundance = number_of_individuals_by_species / vegetation_points)
  return(abundance)
}

calculate_stratum_abundance_by_enclousure <- function(data) {
  dplyr::count(data, Cerco, Estrato, name = "abundance")
}
