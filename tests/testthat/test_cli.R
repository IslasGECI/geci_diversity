describe("Cli for module", {
  it("Cli for Jaccard Index", {
    a_community_counts_path <- "/workdir/tests/data/community_a_for_tests.csv"
    b_community_counts_path <- "/workdir/tests/data/community_b_for_tests.csv"
    output_path <- "/workdir/tests/data/jaccard_diversity.json"
    options <- list("newest_count_path" = a_community_counts_path, "previous_count_path" = b_community_counts_path, "results_path" = output_path)
    testtools::if_exist_remove(output_path)
    write_jaccard_index_result(options)
    expect_true(testtools::exist_output_file(output_path))
  })
})
