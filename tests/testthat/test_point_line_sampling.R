describe("Transform sampling data to vegan input format", {
  point_line_data <- readr::read_csv("/workdir/tests/data/points_line_sampling.csv")
  obtained <- transform_intercpect_enclosure_to_vegan(point_line_data)
  expected_columns <- c("tribulus_cistoides", "brickellia_peninsularis", "waltheria_indica")
  obtained_columns <- colnames(obtained)
  expect_true(all(obtained_columns %in% expected_columns))
})

describe("Point line sampling", {
  it("Join point line data with vegetation metadata", {
    point_line_data <- readr::read_csv("/workdir/tests/data/points_line_sampling.csv")
    vegetation_metadata <- readr::read_csv("/workdir/tests/data/species_stratum.csv")
    joined_data <- join_point_line_with_vegetation_metadata(point_line_data, vegetation_metadata)
    expected_columns <- c("Cerco", "Transecto", "Punto", "Distancia", "Especie", "Estrato")
    expect_equal(colnames(joined_data), expected_columns)
  })
  data <- readr::read_csv("/workdir/tests/data/point_line_data_with_stratum.csv")
  it("species abundance by enclousure", {
    obtained <- calculate_species_abundance_by_enclousure(data)
    obtained_canavalia_relative_abundance <- obtained[obtained$Cerco == "Cerco_2" & obtained$Especie == "Canavalia rosea", ]$relative_abundance
    expected_canavalia_relative_abundace <- 4 / 12
    expect_equal(obtained_canavalia_relative_abundance, expected_canavalia_relative_abundace)
    obtained_tribulus_cistoides_abundance <- obtained[obtained$Cerco == "Cerco_2" & obtained$Especie == "Tribulus cistoides", ]$abundance
    expected_tribulus_cistoides_abundance <- 7
    expect_equal(obtained_tribulus_cistoides_abundance, expected_tribulus_cistoides_abundance)
  })
  it("statrum abundance by enclousure", {
    obtained <- calculate_stratum_abundance_by_enclousure(data)
    obtained_herbaceous_abundance <- obtained[obtained$Cerco == "Cerco_2" & obtained$Estrato == "Herbáceo", ]$abundance
    expected_herbaceous_abundance <- 16
    expect_equal(obtained_herbaceous_abundance, expected_herbaceous_abundance)
    obtained_semiwoody_abundance <- obtained[obtained$Cerco == "Cerco_1" & obtained$Estrato == "Semileñoso", ]$relative_abundance
    expected_semiwoody_abundance <- 7 / 22
    expect_equal(obtained_semiwoody_abundance, expected_semiwoody_abundance)
    obtained <- calculate_stratum_abundance_by_enclousure(data)
    obtained_soil_abundance <- obtained[obtained$Cerco == "Cerco_2" & obtained$Estrato == "Roca_Suelo", ]$abundance
    expected_soil_abundance <- 2
    expect_equal(obtained_soil_abundance, expected_soil_abundance)
    obtained_vegetation_relative_abundance <- obtained[obtained$Cerco == "Cerco_2" & obtained$Estrato == "total_vegetation", ]$relative_abundance
    expected_vegetation_relative_abundance <- 16 / 18
    expect_equal(obtained_vegetation_relative_abundance, expected_vegetation_relative_abundance)
    print(obtained)
    is_there_rock_or_soil_as_strata <- any(c("Roca", "Suelo") %in% obtained$Estrato)
    expect_false(is_there_rock_or_soil_as_strata)
  })
})
