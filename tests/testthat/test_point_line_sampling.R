describe("Point line sampling", {
  it("Join point line data with vegetation metadata", {
    point_line_data <- readr::read_csv("/workdir/tests/data/points_line_sampling.csv")
    vegetation_metadata <- readr::read_csv("/workdir/tests/data/species_stratum.csv")
    joined_data <- join_point_line_with_vegetation_metadata(point_line_data, vegetation_metadata)
    expected_columns <- c("Cerco", "Transecto", "Punto", "Distancia", "Especie", "Estrato")
    expect_equal(colnames(joined_data), expected_columns)
    readr::write_csv(joined_data, "/workdir/tests/data/point_line_data_with_stratum.csv")
  })
  it("species abundance by enclousure", {
    data <- readr::read_csv("/workdir/tests/data/point_line_data_with_stratum.csv")
    obtained <- calculate_species_abundance_by_enclousure(data)
    obtained_canavalia_abundance <- obtained[obtained$Cerco == "Cerco_2" & obtained$Especie == "Canavalia rosea", ]
    expected_canavalia_abundace <- 4 / 12
    expect_equal(obtained_canavalia_abundance, expected_canavalia_abundace)
  })
})
