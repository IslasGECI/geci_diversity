join_point_line_with_vegetation_metadata <- function(point_line_data, vegetation_metadata) {
  dplyr::left_join(point_line_data, vegetation_metadata, by = "Especie")
}

calculate_species_abundance_by_enclousure <- function(data) {
  non_vegetation <- c("Suelo", "Roca", "Hojarasca")
  is_vegetation <- !data$Especie %in% non_vegetation
  vegetation <- data[is_vegetation, ]
  counts_by_enclosure <- dplyr::count(vegetation, Cerco, Especie, name = "abundance")
  vegetation_points <- dplyr::count(vegetation, Cerco, name = "vegetation_points")
  abundance <- dplyr::left_join(counts_by_enclosure, vegetation_points, by = "Cerco") |>
    dplyr::mutate(relative_abundance = abundance / vegetation_points)
  return(abundance)
}

calculate_stratum_abundance_by_enclousure <- function(data) {
  is_soil_or_rock <- data$Estrato %in% c("Suelo", "Roca")
  renamed_stratum_df <- data |>
    dplyr::mutate(Estrato = dplyr::if_else(is_soil_or_rock, "Roca_Suelo", Estrato))
  counts <- dplyr::count(renamed_stratum_df, Cerco, Estrato, name = "abundance")
  total_points <- dplyr::count(renamed_stratum_df, Cerco, name = "number_of_points")
  stratum_abundance <- dplyr::left_join(counts, total_points, by = "Cerco") |>
    dplyr::mutate(relative_abundance = abundance / number_of_points)

  vegetation_points <- dplyr::filter(renamed_stratum_df, Estrato %in% c("Herbáceo", "Semileñoso")) |>
    dplyr::count(Cerco, name = "abundance")
  total_vegetation <- dplyr::left_join(vegetation_points, total_points, by = "Cerco") |>
    dplyr::mutate(
      Estrato = "total_vegetation",
      relative_abundance = abundance / number_of_points,
      abundance = relative_abundance
    )

  dplyr::bind_rows(stratum_abundance, total_vegetation)
}
