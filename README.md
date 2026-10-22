<a href="https://www.islas.org.mx"><img src="https://www.islas.org.mx/img/logo.svg" align="right" width="256" /></a>

# Biological diversity R package
[![codecov](https://codecov.io/gh/IslasGECI/geci_diversity/graph/badge.svg?token=wyxnwZypMA)](https://codecov.io/gh/IslasGECI/geci_diversity)
![example branch
parameter](https://github.com/IslasGECI/geci_diversity/actions/workflows/actions.yml/badge.svg)
![licencia](https://img.shields.io/github/license/IslasGECI/geci_diversity)
![languages](https://img.shields.io/github/languages/top/IslasGECI/geci_diversity)
![commits](https://img.shields.io/github/commit-activity/y/IslasGECI/geci_diversity)
![R-version](https://img.shields.io/github/r-package/v/IslasGECI/geci_diversity)

`gecidiversity` reads biological survey data (community counts, line-intercept points, and quadrat sampling) and writes diversity summaries as CSV or JSON files.

## Command-line entrypoints

Every entrypoint in `R/cli.R` takes an `options` list and writes its result to `results-path`.

### Community comparison

- `write_jaccard_index_result` — writes the Jaccard index and the A, B, C counts as JSON.
- `write_list_of_species_on_both` — writes the species shared by two community counts as CSV.

### Diversity indexes

Simpson and Shannon indexes are calculated with `vegan`.

- `write_diversity_indexes_by_transect` — from line-intercept data, by enclosure and transect.
- `write_diversity_indexes_by_enclosure` — from line-intercept data, by enclosure.
- `write_diversity_indexes_by_enclosure_from_coverage` — from quadrat cover data, by enclosure.
- `write_diversity_indexes_by_quadrant` — from quadrat cover data, by enclosure and quadrant.

### Vegetation abundance

- `write_species_abundance_by_enclosure` — species abundance from line-intercept data.
- `write_strata_abundance_by_enclosure` — strata abundance, including bare ground and total vegetation.

### Quadrat coverage and height

- `write_species_percentage_coverage_by_enclosure` — mean percentage cover per species by enclosure.
- `write_vegetation_percentage_coverage_by_enclosure` — mean vegetation and non-vegetation cover by enclosure.
- `write_species_mean_height_by_enclosure` — mean vegetation height per species by enclosure.
- `write_vegetation_mean_height_by_enclosure` — mean vegetation height by enclosure.

## Step to use

```r
options <- list(
  "sampling-data-path" = "tests/data/quadrants_vegetation_sampling.csv",
  "results-path" = "species_coverage_by_enclosure.csv"
)

write_species_percentage_coverage_by_enclosure(options)
```
