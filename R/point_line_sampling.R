join_point_line_with_vegetation_metadata <- function(point_line_data, vegetation_metadata) {
  dplyr::left_join(point_line_data, vegetation_metadata, by = "Especie")
}

calculate_species_abundance_by_enclousure <- function(data) {
  non_vegetation <- c("Suelo", "Roca", "Hojarasca")
  is_vegetation <- !data$Especie %in% non_vegetation
  vegetation <- data[is_vegetation, ]
  abundance_by_enclosure <- dplyr::count(vegetation, Cerco, Especie, name = "abundance_by_specie_on_enclosure")
  vegetation_points <- dplyr::count(vegetation, Cerco, name = "vegetation_points")
  abundance <- dplyr::left_join(abundance_by_enclosure, vegetation_points, by = "Cerco") |>
    dplyr::mutate(abundancia = abundance_by_specie_on_enclosure / vegetation_points)
  return(abundance)
}
