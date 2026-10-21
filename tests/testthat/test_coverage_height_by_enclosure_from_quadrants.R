describe("calculate coverage and height by enclosure from quadrants data", {
  quadrants_data <- readr::read_csv("/workdir/tests/data/quadrants_vegetation_sampling.csv", show_col_types = FALSE)
  it("calculate coverage per species by enclosure from quadrants data", {
    obtained <- compute_species_coverage_by_enclosure(quadrants_data)
    obtained_coverage_cerco_2_walteria <- obtained["Cerco_2", "Waltheria indica"][[1]]
    expected_coverage_cerco_2_walteria <- 9 / 4
    expect_equal(obtained_coverage_cerco_2_walteria, expected_coverage_cerco_2_walteria)
    print(obtained)
  })
})
