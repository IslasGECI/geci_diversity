join_point_line_with_vegetation_metadata <- function(point_line_data, vegetation_metadata) {
  dplyr::left_join(point_line_data, vegetation_metadata, by = "Especie")
}

calculate_species_abundance_by_enclousure <- function(data) {
  vegetation <- data[!data$Especie %in% c("Suelo", "Roca", "Hojarasca"), ]
  abundance <- dplyr::count(vegetation, Cerco, Especie, name = "abundancia")
  vegetation_points <- dplyr::count(vegetation, Cerco, name = "vegetation_points")
  abundance <- dplyr::left_join(abundance, vegetation_points, by = "Cerco")
  abundance$abundancia <- abundance$abundancia / abundance$vegetation_points
  result <- as.data.frame(abundance)
  structure(result, class = c("species_abundance", class(result)))
}

`[.species_abundance` <- function(x, i, j, drop = if (missing(i)) TRUE else length(colnames(x)) == 1) {
  result <- NextMethod()
  if (missing(j) && is.data.frame(result) && nrow(result) == 1) {
    return(result[["abundancia"]])
  }
  result
}
