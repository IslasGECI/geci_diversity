describe("Calculate diversity indexes", {
  intercept_enclosure_data <- read.csv("/workdir/tests/data/enclosure_transects_vegan_input_format.csv", row.names = "cerco")
  obtained <- calculate_diversity_indexes(intercept_enclosure_data)
  obtained_simpson_value <- obtained["Cerco_2_2", "shannon"]
  expected_simpson_value <- 0.450561209
  expect_equal(obtained_simpson_value, expected_simpson_value)
  obtained_simpson_value <- obtained["Cerco_1_1", "simpson"]
  expected_simpson_value <- 0.62
  expect_equal(obtained_simpson_value, expected_simpson_value)
})

describe("Transform sampling data to vegan input format", {
  point_line_data <- readr::read_csv("/workdir/tests/data/points_line_sampling.csv", show_col_types = FALSE)
  obtained <- transform_intercept_enclosure_to_vegan(point_line_data)
  expected_columns_with_all_vegetation_species_on_data <- c("tribulus_cistoides", "brickellia_peninsularis", "waltheria_indica", "canavalia_rosea")

  obtained_columns <- colnames(obtained)
  is_all_expected_columns_in_obtained <- all(expected_columns_with_all_vegetation_species_on_data %in% obtained_columns)
  is_all_obtained_columns_in_expected <- all(obtained_columns %in% expected_columns_with_all_vegetation_species_on_data)
  expect_true(is_all_expected_columns_in_obtained & is_all_obtained_columns_in_expected)

  obtained_count_in_cerco_1_transect_1_for_brickelia <- obtained["Cerco_1_1", "brickellia_peninsularis"][[1]]
  expected_count_in_cerco_1_transect_1_for_brickelia <- 5
  expect_equal(obtained_count_in_cerco_1_transect_1_for_brickelia, expected_count_in_cerco_1_transect_1_for_brickelia)

  obtained_count_in_cerco_1_transect_4_for_tribulus <- obtained["Cerco_1_4", "tribulus_cistoides"][[1]]
  expected_count_in_cerco_1_transect_4_for_tribulus <- 8
  expect_equal(obtained_count_in_cerco_1_transect_4_for_tribulus, expected_count_in_cerco_1_transect_4_for_tribulus)
})

describe("Point line sampling", {
  it("Join point line data with vegetation metadata", {
    point_line_data <- readr::read_csv("/workdir/tests/data/points_line_sampling.csv", show_col_types = FALSE)
    vegetation_metadata <- readr::read_csv("/workdir/tests/data/species_stratum.csv", show_col_types = FALSE)
    joined_data <- join_point_line_with_vegetation_metadata(point_line_data, vegetation_metadata)
    expected_columns <- c("Cerco", "Transecto", "Punto", "Distancia", "Especie", "Estrato")
    expect_equal(colnames(joined_data), expected_columns)
  })
  data <- readr::read_csv("/workdir/tests/data/point_line_data_with_stratum.csv", show_col_types = FALSE)
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
    is_there_rock_or_soil_as_strata <- any(c("Roca", "Suelo") %in% obtained$Estrato)
    expect_false(is_there_rock_or_soil_as_strata)
  })
})
