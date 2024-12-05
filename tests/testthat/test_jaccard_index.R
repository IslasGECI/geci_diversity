describe("Calculate Jaccard index", {
  it("Get common species (C parameter)", {
    a_community <- tibble::tibble(Especie = c("sp_1", "sp_2", "sp_3", "sp_4"))
    b_community <- tibble::tibble(Especie = c("sp_1", "sp_3", "sp_4", "sp_5"))
    obatined <- get_number_of_common_species(a_community, b_community)
    expected <- 3
    expect_equal(obatined, expected)
  })
})
