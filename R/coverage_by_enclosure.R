compute_species_coverage_by_enclosure <- function(quadrants_data) {
  total_coverage <- dplyr::summarise(
    quadrants_data,
    total_coverage = sum(Cobertura),
    .by = c(Cerco, Especie)
  )
  quadrats_per_enclosure <- dplyr::summarise(
    dplyr::distinct(quadrants_data, Cerco, Cuadrante),
    number_of_quadrats = dplyr::n(),
    .by = Cerco
  )
  coverage_by_enclosure_and_species <- dplyr::left_join(total_coverage, quadrats_per_enclosure, by = "Cerco") |>
    dplyr::mutate(coverage = total_coverage / number_of_quadrats)
  species_coverage_by_enclosure <- reshape2::dcast(
    coverage_by_enclosure_and_species,
    Cerco ~ Especie,
    value.var = "coverage"
  )
  rownames(species_coverage_by_enclosure) <- species_coverage_by_enclosure$Cerco
  species_coverage_by_enclosure$Cerco <- NULL
  return(species_coverage_by_enclosure)
}
