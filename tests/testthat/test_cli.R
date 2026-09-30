describe("Cli for module", {
  a_community_counts_path <- "/workdir/tests/data/community_a_for_tests.csv"
  b_community_counts_path <- "/workdir/tests/data/community_b_for_tests.csv"
  it("Cli for Jaccard Index", {
    output_path <- "/workdir/tests/data/jaccard_diversity.json"
    options <- list("newest-count-path" = a_community_counts_path, "previous-count-path" = b_community_counts_path, "results-path" = output_path)
    testtools::if_exist_remove(output_path)
    write_jaccard_index_result(options)
    expect_true(testtools::exist_output_file(output_path))
    testtools::if_exist_remove(output_path)
  })
  it("Cli for write_list_of_species_on_both", {
    output_path <- "/workdir/tests/data/unique_species_on_both_lists.csv"
    options <- list("count-path-one" = a_community_counts_path, "count-path-two" = b_community_counts_path, "results-path" = output_path)
    testtools::if_exist_remove(output_path)
    write_list_of_species_on_both(options)
    expect_true(testtools::exist_output_file(output_path))
    testtools::if_exist_remove(output_path)
  })
  it("Defines domain specific options", {
    obtained_options <- get_domain_specific_options()
    expected_options <- c("results-path", "newest-count-path", "previous-count-path", "count-path-one", "count-path-two", "line-intercept-path", "species-stratum-path")
    expect_true(all(expected_options %in% names(obtained_options)))
  })
})
describe("Vegetation diversity indexes", {
  line_intercept_path <- "/workdir/tests/data/points_line_sampling.csv"
  it("write_diversity_indexes_by_enclosure", {
    output_path <- "/workdir/tests/diversity_index_from_line_intercept.csv"
    testtools::if_exist_remove(output_path)
    options <- list("line-intercept-path" = line_intercept_path, "results-path" = output_path)
    write_diversity_indexes_by_enclosure(options)
    expect_true(testtools::exist_output_file(output_path))
  })
  it("write_diversity_indexes_by_transect", {
    output_path <- "/workdir/tests/diversity_index_from_line_intercept.csv"
    testtools::if_exist_remove(output_path)
    options <- list("line-intercept-path" = line_intercept_path, "results-path" = output_path)
    write_diversity_indexes_by_transect(options)
    expect_true(testtools::exist_output_file(output_path))
    testtools::if_exist_remove(output_path)
  })
})
describe("Vegetation abundance", {
  line_intercept_path <- "/workdir/tests/data/points_line_sampling.csv"
  species_stratum_path <- "/workdir/tests/data/species_stratum.csv"
  it("write_species_abundance_by_enclousure", {
    output_path <- "/workdir/tests/species_abundance_from_line_intercept.csv"
    testtools::if_exist_remove(output_path)
    options <- list("line-intercept-path" = line_intercept_path, "species-stratum-path" = species_stratum_path, "results-path" = output_path)
    write_species_abundance_from_line_intercept_by_enclosure(options)
    expect_true(testtools::exist_output_file(output_path))
    testtools::if_exist_remove(output_path)
  })
  it("write_strata_abundance_from_line_intercept_by_enclosure", {
    output_path <- "/workdir/tests/strata_abundance_from_line_intercept.csv"
    testtools::if_exist_remove(output_path)
    options <- list("line-intercept-path" = line_intercept_path, "species-stratum-path" = species_stratum_path, "results-path" = output_path)
    write_strata_abundance_from_line_intercept_by_enclosure(options)
    expect_true(testtools::exist_output_file(output_path))
    testtools::if_exist_remove(output_path)
  })
})
