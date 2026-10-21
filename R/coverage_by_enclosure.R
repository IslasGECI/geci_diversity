compute_species_coverage_by_enclosure <- function(quadrants_data) {
  total_coverage <- compute_total_coverage_by_species(quadrants_data)
  n_quadrats <- compute_n_quadrats_by_enclosure(quadrants_data)
  coverage <- compute_mean_coverage_by_species(total_coverage, n_quadrats)
  reshape_coverage_by_enclosure(coverage)
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

reshape_coverage_by_enclosure <- function(coverage) {
  wide <- reshape2::dcast(coverage, Cerco ~ Especie, value.var = "coverage")
  rownames(wide) <- wide$Cerco
  wide$Cerco <- NULL
  wide
}
