describe("Filter SNIB table", {
  snib_table <- readr::read_csv("/workdir/tests/data/snib_table_for_tests.csv", show_col_type = FALSE)
  phylum <- "Tracheophyta"
  it("Get unique list of species and family by phylum", {
    obtained <- get_observed_species_by_phylum(snib_table, phylum)
    expected_n_rows <- 3
    expect_equal(nrow(obtained), expected_n_rows)

    expected_columns <- c("familiavalida", "especievalida")
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_columns)
  })
  it("Filter table by phylum", {
    obtained <- filter_by_phylum(snib_table, phylum)
    expected_n_rows <- 4
    expect_equal(nrow(obtained), expected_n_rows)
  })
  it("Select columns of interes", {
    obtained <- select_species_name_and_family(snib_table)
    expected_columns <- c("familiavalida", "especievalida")
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_columns)
  })
})
