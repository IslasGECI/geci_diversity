# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-10-22

### Added

- Add `write_species_percentage_coverage_by_enclosure`command to write csv with mean species percentage coverage per quadrat by enclosure from quadrat sampling data.
- Add `write_vegetation_percentage_coverage_by_enclosure`command to write csv with vegetation and non-vegetation percentage coverage by enclosure, treating `Suelo`, `Roca`, and `Hojarasca` as non-vegetation.
- Add `write_species_mean_height_by_enclosure`command to write csv with mean vegetation height per species by enclosure from quadrat sampling data.
- Add `write_vegetation_mean_height_by_enclosure`command to write csv with mean vegetation height by enclosure from quadrat sampling data.

## [0.2.0] - 2026-09-30

### Added

- Add `write_diversity_indexes_by_transect` command to write Simpson and Shannon diversity indexes by enclosure-transect from line-intercept sampling data.
- Add `write_diversity_indexes_by_enclosure` command to write Simpson and Shannon diversity indexes by enclosure from line-intercept sampling.
- Add `write_diversity_indexes_by_enclosure_from_coverage` command to write Simpson and Shannon diversity indexes by enclosure from quadrat cover data.
- Add `write_diversity_indexes_by_quadrant` command to write Simpson and Shannon diversity indexes by enclosure-quadrant from quadrat cover data.
- Add `write_species_abundance_by_enclosure` command to write species abundance by enclosure.
- Add `write_strata_abundance_by_enclosure` command to write strata abundance (vegetation, bare ground, and total vegetation) by enclosure.

## [0.1.0] - 2024-10-03

[unreleased]: https://github.com/IslasGECI/geci.diversity/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/IslasGECI/geci.diversity/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/IslasGECI/geci.diversity/releases/tag/v0.1.0...v0.2.0
[0.1.0]: https://github.com/IslasGECI/geci.diversity/releases/tag/v0.1.0
