write_jaccard_index_result <- function(options) {
  a_community <- readr::read_csv(options[["previous-count-path"]], show_col_types = FALSE)
  b_community <- readr::read_csv(options[["newest-count-path"]], show_col_types = FALSE)
  jaccard_index <- calculate_jaccard_index(a_community, b_community)
  A <- nrow(a_community)
  B <- nrow(b_community)
  C <- get_number_of_common_species(a_community, b_community)

  output_content <- list("A" = A, "B" = B, "C" = C, "jaccard_index" = jaccard_index)
  output_content |>
    rjson::toJSON() |>
    write(options[["results-path"]])
}

write_list_of_species_on_both <- function(options) {
  a_community <- readr::read_csv(options[["count-path-one"]], show_col_types = FALSE)
  b_community <- readr::read_csv(options[["count-path-two"]], show_col_types = FALSE)
  list_unique_species_on_both(a_community, b_community) |>
    readr::write_csv(options[["results-path"]])
}

get_domain_specific_options <- function() {
  results_path <- geci.optparse::character_option(c("-r", "--results-path"), default = "/workdir/reports/tables/result.csv", help = "File path of the desire output")
  option_names <- c(results_path)
  geci.optparse::get_options_from_vec(option_names)
}
