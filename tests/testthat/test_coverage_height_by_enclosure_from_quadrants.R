describe("calculate coverage and height by enclosure from quadrants data", {
  quadrants_data <- readr::read_csv("/workdir/tests/data/quadrants_vegetation_sampling.csv", show_col_types = FALSE)
  it("calculate coverage per species by enclosure from quadrants data", {
    obtained <- compute_species_percentage_coverage_by_enclosure(quadrants_data)
    obtained_coverage_cerco_2_walteria <- obtained["Cerco_2", "Waltheria indica"][[1]]
    expected_coverage_cerco_2_walteria <- 9 / 4
    expect_equal(obtained_coverage_cerco_2_walteria, expected_coverage_cerco_2_walteria)
    obtained_shape <- dim(obtained)
    expected_shape <- c(2, 5)
    expect_equal(expected_shape, obtained_shape)
  })
  it("calculate mean height per species by enclosure from quadrants data", {
    obtained <- compute_species_mean_height_by_enclosure(quadrants_data)
    obtained_height_cerco_1_brickellia <- obtained["Cerco_1", "Brickellia peninsularis"][[1]]
    expected_height_cerco_1_brickellia <- 320 / 3
    expect_equal(obtained_height_cerco_1_brickellia, expected_height_cerco_1_brickellia)
    obtained_shape <- dim(obtained)
    soil_not_in_df <- !"Suelo" %in% colnames(obtained)
    expect_true(soil_not_in_df)
  })
})
