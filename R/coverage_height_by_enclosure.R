compute_species_percentage_coverage_by_enclosure <- function(quadrants_data) {
  total_coverage <- compute_total_coverage_by_species(quadrants_data)
  n_quadrats <- compute_n_quadrats_by_enclosure(quadrants_data)
  coverage <- compute_percentage_coverage_by_species(total_coverage, n_quadrats)
  reshape_by_enclosure(coverage, "percentage_coverage")
}

compute_vegetation_percentage_coverage_by_enclosure <- function(quadrants_data) {
  coverage_group <- dplyr::mutate(
    quadrants_data,
    Especie = dplyr::if_else(
      Especie %in% c("Suelo", "Roca", "Hojarasca"),
      "non_vegetation",
      "vegetation"
    )
  )
  compute_species_percentage_coverage_by_enclosure(coverage_group)
}

compute_species_mean_height_by_enclosure <- function(quadrants_data) {
  mean_height_by_species <- compute_mean_height_by_species(quadrants_data)
  reshape_by_enclosure(mean_height_by_species, "mean_height")
}

compute_vegetation_mean_height_by_enclosure <- function(quadrants_data) {
  mean_height_by_enclosure <- compute_mean_vegetation_height_by_enclosure(
    quadrants_data
  )
  as_enclosure_table(mean_height_by_enclosure)
}

compute_total_coverage_by_species <- function(quadrants_data) {
  dplyr::summarise(
    quadrants_data,
    total_coverage = sum(Cobertura),
    .by = c(Cerco, Especie)
  )
}

compute_n_quadrats_by_enclosure <- function(quadrants_data) {
  dplyr::summarise(
    dplyr::distinct(quadrants_data, Cerco, Cuadrante),
    n_quadrats = dplyr::n(),
    .by = Cerco
  )
}

compute_percentage_coverage_by_species <- function(total_coverage, n_quadrats) {
  dplyr::left_join(total_coverage, n_quadrats, by = "Cerco") |>
    dplyr::mutate(percentage_coverage = total_coverage / n_quadrats)
}

compute_mean_height_by_species <- function(quadrants_data) {
  dplyr::summarise(
    drop_non_vegetation(quadrants_data),
    mean_height = mean(Altura, na.rm = TRUE),
    .by = c(Cerco, Especie)
  )
}

compute_mean_vegetation_height_by_enclosure <- function(quadrants_data) {
  dplyr::summarise(
    drop_non_vegetation(quadrants_data),
    mean_height = mean(Altura, na.rm = TRUE),
    .by = Cerco
  )
}

as_enclosure_table <- function(summary_by_enclosure) {
  enclosure_table <- as.data.frame(summary_by_enclosure)
  rownames(enclosure_table) <- enclosure_table$Cerco
  enclosure_table$Cerco <- NULL
  enclosure_table
}

reshape_by_enclosure <- function(long_table, value_column) {
  wide <- reshape2::dcast(long_table, Cerco ~ Especie, value.var = value_column)
  as_enclosure_table(wide)
}
