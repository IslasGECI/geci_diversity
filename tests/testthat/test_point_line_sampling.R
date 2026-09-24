describe("Point line sampling", {
  it("Join point line data with vegetation metadata", {
    point_line_data <- readr::read_csv("/workdir/tests/data/point_line_sampling.csv")
    vegetation_metadata <- readr::read_csv("/workdir/tests/data/species_stratum.csv")
    joined_data <- join_point_line_with_vegetation_metadata(point_line_data, vegetation_metadata)
    expected_columns <- c("Cerco", "Transecto", "Punto", "Distancia", "Especie", "Estrato")
    expect_equal(colnames(joined_data), expected_columns)
  })
})
