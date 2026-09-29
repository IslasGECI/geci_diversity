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

write_diversity_indexes_by_transect <- function(options) {
  line_intercept <- readr::read_csv(options[["line-intercept-path"]], show_col_types = FALSE)
  vegan_input_format <- transform_intercept_enclosure_to_vegan(line_intercept)
  diversity_indexes <- calculate_diversity_indexes(vegan_input_format)
  df <- diversity_indexes |>
    tibble::as_tibble(rownames = "enclosure_transect")
  readr::write_csv(df, options[["results-path"]])
}

write_species_abundance_from_line_intercept_by_enclosure <- function(options) {
  line_intercept <- readr::read_csv(options[["line-intercept-path"]], show_col_types = FALSE)
  species_stratum <- readr::read_csv(options[["species-stratum-path"]], show_col_types = FALSE)
  point_line_with_stratum <- join_point_line_with_vegetation_metadata(line_intercept, species_stratum)
  species_abundance <- calculate_species_abundance_by_enclousure(point_line_with_stratum)
  readr::write_csv(species_abundance, options[["results-path"]])
}

write_strata_abundance_from_line_intercept_by_enclosure <- function(options) {
  line_intercept <- readr::read_csv(options[["line-intercept-path"]], show_col_types = FALSE)
  species_stratum <- readr::read_csv(options[["species-stratum-path"]], show_col_types = FALSE)
  point_line_with_stratum <- join_point_line_with_vegetation_metadata(line_intercept, species_stratum)
  strata_abundance <- calculate_stratum_abundance_by_enclousure(point_line_with_stratum)
  readr::write_csv(strata_abundance, options[["results-path"]])
}
get_domain_specific_options <- function() {
  results_path <- gecioptparse::character_option(c("-r", "--results-path"), default = "/workdir/reports/tables/result.csv", help = "File path of the desire output")
  newest_path <- gecioptparse::character_option(c("-n", "--newest-count-path"), default = "", help = "File path of the newest count")
  previous_path <- gecioptparse::character_option(c("-p", "--previous-count-path"), default = "", help = "File path of the previous count")
  count_path_one <- gecioptparse::character_option(c("-o", "--count-path-one"), default = "", help = "One file path to join")
  count_path_two <- gecioptparse::character_option(c("-t", "--count-path-two"), default = "", help = "two file path to join")
  line_intercept_path <- gecioptparse::character_option(c("-i", "--line-intercept-path"), default = "", help = "File path of the line intercept sampling")
  species_stratum_path <- gecioptparse::character_option(c("-s", "--species-stratum-path"), default = "", help = "File path of the species and stratum metadata")
  option_names <- c(results_path, newest_path, previous_path, count_path_one, count_path_two, line_intercept_path, species_stratum_path)
  gecioptparse::get_options_from_vec(option_names)
}
