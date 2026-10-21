compute_species_coverage_by_enclosure <- function(quadrants_data) {
  total_coverage <- compute_total_coverage_by_species(quadrants_data)
  n_quadrats <- compute_n_quadrats_by_enclosure(quadrants_data)
  coverage <- compute_mean_coverage_by_species(total_coverage, n_quadrats)
  reshape_by_enclosure(coverage, "coverage")
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

compute_mean_coverage_by_species <- function(total_coverage, n_quadrats) {
  dplyr::left_join(total_coverage, n_quadrats, by = "Cerco") |>
    dplyr::mutate(coverage = total_coverage / n_quadrats)
}

compute_species_mean_height_by_enclosure <- function(quadrants_data) {
  mean_height_by_species <- compute_mean_height_by_species(quadrants_data)
  reshape_by_enclosure(mean_height_by_species, "mean_height")
}

compute_mean_height_by_species <- function(quadrants_data) {
  dplyr::summarise(
    drop_non_vegetation(quadrants_data),
    mean_height = mean(Altura, na.rm = TRUE),
    .by = c(Cerco, Especie)
  )
}

reshape_by_enclosure <- function(long_table, value_column) {
  wide <- reshape2::dcast(long_table, Cerco ~ Especie, value.var = value_column)
  rownames(wide) <- wide$Cerco
  wide$Cerco <- NULL
  wide
}
