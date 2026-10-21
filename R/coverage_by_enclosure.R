calculate_species_coverage_by_enclosure <- function(quadrants_data) {
  total_coverage <- dplyr::summarise(
    quadrants_data,
    total_cobertura = sum(Cobertura),
    .by = c(Cerco, Especie)
  )
  quadrats_per_enclosure <- dplyr::summarise(
    dplyr::distinct(quadrants_data, Cerco, Cuadrante),
    number_of_quadrats = dplyr::n(),
    .by = Cerco
  )
  coverage <- dplyr::left_join(total_coverage, quadrats_per_enclosure, by = "Cerco") |>
    dplyr::mutate(coverage = total_cobertura / number_of_quadrats)
  coverage_by_species <- reshape2::dcast(
    as.data.frame(coverage),
    Cerco ~ Especie,
    value.var = "coverage"
  )
  rownames(coverage_by_species) <- coverage_by_species$Cerco
  coverage_by_species$Cerco <- NULL
  return(coverage_by_species)
}
