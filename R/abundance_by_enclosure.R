join_sampling_with_vegetation_metadata <- function(point_line_data, vegetation_metadata) {
  dplyr::left_join(point_line_data, vegetation_metadata, by = "Especie")
}

calculate_species_abundance_by_enclousure <- function(data) {
  vegetation <- drop_non_vegetation(data)
  counts_by_enclosure <- dplyr::count(vegetation, Cerco, Especie, name = "abundance")
  vegetation_points <- dplyr::count(vegetation, Cerco, name = "vegetation_points")
  abundance <- dplyr::left_join(counts_by_enclosure, vegetation_points, by = "Cerco") |>
    dplyr::mutate(relative_abundance = abundance / vegetation_points)
  return(abundance)
}
drop_non_vegetation <- function(point_line_data) {
  non_vegetation <- c("Suelo", "Roca", "Hojarasca")
  vegetation <- point_line_data[!point_line_data$Especie %in% non_vegetation, ]
  return(vegetation)
}

combine_bare_ground_strata <- function(data) {
  is_soil_or_rock <- data$Estrato %in% c("Suelo", "Roca")
  data |>
    dplyr::mutate(Estrato = dplyr::if_else(is_soil_or_rock, "Roca_Suelo", Estrato))
}

combine_vegetation_strata <- function(data) {
  is_vegetation <- data$Estrato %in% c("Herbáceo", "Semileñoso")
  data |>
    dplyr::mutate(Estrato = dplyr::if_else(is_vegetation, "total_vegetation", Estrato)) |>
    dplyr::filter(Estrato == "total_vegetation")
}

calculate_stratum_abundance_by_enclousure <- function(data) {
  renamed_strata <- combine_bare_ground_strata(data)
  counts <- dplyr::count(renamed_strata, Cerco, Estrato, name = "abundance")
  total_points <- dplyr::count(renamed_strata, Cerco, name = "number_of_points")
  stratum_abundance <- dplyr::left_join(counts, total_points, by = "Cerco") |>
    dplyr::mutate(relative_abundance = abundance / number_of_points)

  vegetation_points <- combine_vegetation_strata(data) |>
    dplyr::count(Cerco, Estrato, name = "abundance")
  total_vegetation <- dplyr::left_join(vegetation_points, total_points, by = "Cerco") |>
    dplyr::mutate(
      relative_abundance = abundance / number_of_points,
    )

  dplyr::bind_rows(stratum_abundance, total_vegetation)
}
