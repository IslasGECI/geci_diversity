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
  it("Transform enclosure-intercept data to vegan input format", {
    obtained <- transform_intercept_enclosure_to_vegan(point_line_data)
    expected_columns_with_all_vegetation_species_on_data <- c("tribulus_cistoides", "brickellia_peninsularis", "waltheria_indica", "canavalia_rosea")
    obtained_columns <- colnames(obtained)
    is_all_expected_columns_in_obtained <- all(expected_columns_with_all_vegetation_species_on_data %in% obtained_columns)
    is_all_obtained_columns_in_expected <- all(obtained_columns %in% expected_columns_with_all_vegetation_species_on_data)
    expect_true(is_all_expected_columns_in_obtained & is_all_obtained_columns_in_expected)
    expected_rows <- 4
    obtained_rows <- nrow(obtained)
    expect_equal(obtained_rows, expected_rows)

    obtained_count_in_cerco_1_transect_1_for_brickelia <- obtained["Cerco_1_1", "brickellia_peninsularis"][[1]]
    expected_count_in_cerco_1_transect_1_for_brickelia <- 5
    expect_equal(obtained_count_in_cerco_1_transect_1_for_brickelia, expected_count_in_cerco_1_transect_1_for_brickelia)

    obtained_count_in_cerco_1_transect_4_for_tribulus <- obtained["Cerco_1_4", "tribulus_cistoides"][[1]]
    expected_count_in_cerco_1_transect_4_for_tribulus <- 8
    expect_equal(obtained_count_in_cerco_1_transect_4_for_tribulus, expected_count_in_cerco_1_transect_4_for_tribulus)
  })
  it("Transform enclosure data to vegan input format", {
    obtained <- transform_enclosure_to_vegan(point_line_data)

    expected_columns_with_all_vegetation_species_on_data <- c("tribulus_cistoides", "brickellia_peninsularis", "waltheria_indica", "canavalia_rosea")
    obtained_columns <- colnames(obtained)
    is_all_expected_columns_in_obtained <- all(expected_columns_with_all_vegetation_species_on_data %in% obtained_columns)
    is_all_obtained_columns_in_expected <- all(obtained_columns %in% expected_columns_with_all_vegetation_species_on_data)
    expect_true(is_all_expected_columns_in_obtained & is_all_obtained_columns_in_expected)

    obtained_count_in_cerco_1_for_brickelia <- obtained["Cerco_1", "brickellia_peninsularis"][[1]]
    expected_count_in_cerco_1_for_brickelia <- 7
    expect_equal(obtained_count_in_cerco_1_for_brickelia, expected_count_in_cerco_1_for_brickelia)
    obtained_count_in_cerco_2_for_tribulus <- obtained["Cerco_2", "tribulus_cistoides"][[1]]
    expected_count_in_cerco_2_for_tribulus <- 7
    expect_equal(obtained_count_in_cerco_2_for_tribulus, expected_count_in_cerco_2_for_tribulus)
  })
})
