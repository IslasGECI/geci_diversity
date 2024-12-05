write_jaccard_index_result <- function(options) {
  a_community <- readr::read_csv(options[["previous_count_path"]], show_col_types = FALSE)
  b_community <- readr::read_csv(options[["newest_count_path"]], show_col_types = FALSE)
  jaccard_index <- calculate_jaccard_index(a_community, b_community)
  A <- nrow(a_community)
  B <- nrow(b_community)
  C <- get_number_of_common_species(a_community, b_community)

  output_content <- list("A" = A, "B" = B, "C" = C, "jaccard_index" = jaccard_index)
  output_content |>
    rjson::toJSON() |>
    write(options[["results_path"]])
}
