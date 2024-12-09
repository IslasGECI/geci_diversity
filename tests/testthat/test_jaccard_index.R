a_community <- tibble::tibble(Especie = c("sp_1", "sp_2", "sp_3", "sp_4"))
b_community <- tibble::tibble(Especie = c("sp_1", "sp_3", "sp_4", "sp_5"))
describe("Calculate Jaccard index", {
  it("calculate jaccard index", {
    obtained_index <- calculate_jaccard_index(a_community, b_community)
    expected_index <- (3 / 5) * 100
    expect_equal(obtained_index, expected_index)
  })
  it("Get common species (C parameter)", {
    obatined <- get_number_of_common_species(a_community, b_community)
    expected <- 3
    expect_equal(obatined, expected)
  })
})

describe("Get full list of species from two lists", {
  it("Get all unique species", {
    obtained <- list_unique_species_on_both(a_community, b_community)
    expected_nrow <- 5
    expect_equal(nrow(obtained), expected_nrow)
  })
})
