describe("Filter SNIB table", {
  it("Filter table by phylum", {
    snib_table <- readr::read_csv("/workdir/geci_diversity/tests/data/snib_table_for_tests.csv", show_col_type = FALSE)
    phylum <- "Tracheophyta"
    obtained <- filter_by_phylum(snib_table, phylum)
    expected_n_rows <- 4
    expect_equal(nrow(obtained), expected_n_rows)
  })
})
