# Vegetation Analysis TODO

## Progress

- [x] Join line-intercept points with species/stratum metadata (`join_point_line_with_vegetation_metadata`).
- [x] Compute species abundance by enclosure (`calculate_species_abundance_by_enclousure`).
- [x] Compute strata abundance by enclosure (`calculate_stratum_abundance_by_enclousure`), including bare ground (`Roca_Suelo`) and total vegetation.
- [x] Add line-intercept CLI writers (`write_species_abundance_from_line_intercept_by_enclosure`, `write_strata_abundance_from_line_intercept_by_enclosure`) and `--line-intercept-path` / `--species-stratum-path` options.
- [x] Implement line-intercept diversity indexes (Simpson and Shannon) by enclousure and transect.
- [x] Implement line-intercept diversity indexes (Simpson and Shannon) by enclousure.
- [ ] Implement quadrat cover, height, and diversity detail functions.
- [ ] Implement enclosure-level quadrat summaries and pooled gamma diversity.
- [ ] Add roxygen documentation and README examples.
- [ ] Add Rscript CLI entry point and full CLI contract tests.

## Common agreement: scope and delivery boundary

- Extend `gecidiversity` as a generic biological-diversity R package.
- Add a reusable vegetation-survey module; Clarión is the primary use case, but public names should be island-agnostic.
- Keep the existing Jaccard and SNIB functionality; this effort adds the vegetation module.
- The first implementation increment contains composable numeric metric functions only.
- Defer the high-level workflow contract, plotting, CLI orchestration, and file/report structure until the report design is decided.
- Assume input data has already been validated upstream. Do not add schema mapping, alias configuration, or broad validation.
- Do not include explicit matching safeguard for species that has no species/stratum metadata row. Assume data always has metadata for species/stratum.
- Use English function names, output columns, and documentation while accepting the documented Spanish input columns.
- Add roxygen documentation and concise README examples for the implemented API.
- Use the existing testthat infrastructure, focused unit tests, and realistic Clarión-style fixtures. Add full CLI contract tests when CLI work begins.

## Agreed public API shape

- Public analysis functions accept in-memory data frames/tibbles; later, the CLI will read three named CSVs.
- Expose one function per result table rather than a monolithic report-producing function.
- The planned first-increment function families are:
  - [x] line-intercept species abundance and vegetation-group abundance;
  - [x] line-intercept diversity indexes (Simpson and Shannon);
  - [ ] tidy quadrat cover, height, and diversity detail functions;
  - [ ] separate enclosure-level cover, height, median per-quadrant diversity, and pooled gamma diversity summary functions.
- Helper functions remain internal unless a distinct public use case emerges.
- High-level return structure remains intentionally deferred.

## Agreed input semantics

### Line-intercept table

- Data example at tests/data/points_line_sampling.csv
- Use `Cerco`, `Transecto`, `Punto`, `Distancia`, and `Especie` as documented.
- Each enclosure/transect/point combination represents exactly one surveyed point and has one row.
- Aggregate results by enclosure only; transect identifies the point but is not an output grouping.
- Ignore `Distancia` for calculations.

### Quadrat table

- Data example at tests/data/quadrants_sampling.csv
- Use `Cerco`, `Cuadrante`, `Especie`, `Cobertura`, and `Altura` as documented.
- Assume one species/category coverage row per enclosure–quadrant combination.
- Preserve the input height unit; do not convert or label it as centimeters, meters, or another unit.
- Treat `Cobertura` as percent cover on a 0–100 scale.

### Species/stratum table

- Data example at tests/data/species_stratum.csv
- Join survey records to `Especie` and `Estrato` metadata.
- Only `Herbáceo` and `Semileñoso` count as vegetation.
- Combine `Suelo` and `Roca` as bare ground in summarized outputs.
- Report `Hojarasca` separately.
- Keep original ground categories available in detailed cover outputs for later plotting.

## Agreed line-intercept calculations

- Vegetation denominator `N_veg`: points classified as `Herbáceo` or `Semileñoso`.
- Bare-ground and litter denominator `N_all`: all surveyed intercept points.
- Soil, rock, and litter never count as vegetation species.
- For each species, count points in that species and calculate `count / N_veg * 100`.
- For each vegetation stratum, count points in that stratum and calculate `count / N_veg * 100`.
- Calculate total vegetation from the combined herbaceous and semi-woody points using `N_veg`.
- Calculate bare ground by combining soil and rock and using `N_all`.
- Calculate litter separately using `N_all`.
- Return both raw counts and percentages.
- Return four separate wide tables, with one row per enclosure:
  1. [x] species abundance;
  2. [x] vegetation-group abundance;
  3. [x] vegetation diversity.
- Dynamic species/category headers are sanitized, alphabetically ordered, and clearly prefixed for count versus percent. Exact species text remains available in tidy outputs where applicable.
- Species absent from an enclosure receive missing count/percent values in the wide intercept table.
- Use `vegan` for diversity.
- Shannon uses base-2 logarithms.
- Simpson is `1 - sum(p^2)`.
- Exclude soil, rock, and litter from intercept richness, Shannon, and Simpson.

## Agreed quadrat calculations

### Per-quadrant results

- Calculate richness, Shannon, and Simpson from herbaceous and semi-woody cover only.
- Use percent cover as the abundance weight for Shannon and Simpson.
- Keep tidy per-quadrant results for cover, vegetation height, and diversity.
- Also provide one additional wide table with one row per enclosure–quadrant and dynamic category columns.
- The wide table includes:
  - vegetation cover;
  - combined soil/rock bare-ground cover;
  - litter cover;
  - total recorded cover across all categories;
  - vegetation-only richness, Shannon, and Simpson.
- Sanitize and alphabetically order dynamic columns.
- Fill a globally observed category’s absent per-quadrant cover with zero.
- Use missing values, not zero, for absent vegetation heights.
- Tidy detail tables contain only observed rows rather than manufacturing absent-species rows.
- Compute per-quadrat average vegetation height as the unweighted arithmetic mean of non-missing herbaceous and semi-woody heights.
- Omit missing plant heights and report relevant sample sizes.

### Enclosure-level quadrat summaries

- Every enclosure has more than one quadrat; implement a safe fallback for degenerate test input.
- Use the median as the central estimate for summaries calculated from per-quadrant cover, height, richness, Shannon, and Simpson values. Do not apply this rule to pooled gamma diversity.
- Use percentile-bootstrap confidence intervals for all numeric enclosure summaries where estimable.
- Default to 95% confidence and 2,000 resamples; expose confidence level and replicate count in public function arguments. CLI exposure is deferred with CLI work.
- Use fixed seed 42 independently at the start of each public summary function, preserve the caller’s RNG state, and keep the seed fixed rather than exposing it.
- For species/category cover, build a complete enclosure–quadrat matrix and treat absence as 0% cover.
- Create enclosure–species rows only for species/categories observed in that enclosure.
- Report both total quadrat count and presence count (`n_quadrats` and `n_present`).
- Summarize every observed category and add grouped vegetation, combined soil/rock, litter, and total-cover estimates.
- For species and mean vegetation height, summarize available per-quadrant values; do not turn absent species heights into zero.
- The median-based enclosure diversity table reports the median of per-quadrant richness, Shannon, and Simpson values, with bootstrap confidence intervals; keep it distinct from pooled gamma diversity.
- All median-based enclosure-level cover, height, richness, Shannon, and Simpson summaries receive median plus lower/upper confidence bounds where estimable.
- If only one usable quadrat or height value exists, return the observed estimate with missing interval bounds rather than a zero-width interval.

### Pooled enclosure/gamma diversity

- Return a separate gamma-diversity table with one row per enclosure; do not replace the per-quadrant or median-based enclosure results.
- Build a complete enclosure–quadrant–vegetation-species cover matrix, treating a species absent from a quadrat as 0% cover.
- Pool percent cover by summing each vegetation species’ `Cobertura` across quadrats within each enclosure. Use these pooled totals as abundance weights and normalize them to relative abundances; do not label the pooled totals as physical percent cover of the enclosure.
- Calculate gamma richness as the number of vegetation species with positive pooled cover.
- Calculate pooled gamma Shannon as `-sum(p * log2(p))` and pooled gamma Simpson as `1 - sum(p^2)`, using the normalized pooled vegetation abundances.
- Exclude soil, rock, and litter from gamma richness, Shannon, and Simpson.
- Do not calculate gamma diversity by averaging or summing the per-quadrant diversity indices.
- Report `n_quadrats` together with gamma richness, Shannon, and Simpson in the gamma-diversity table.
- Calculate gamma confidence intervals by resampling quadrats with replacement and recomputing the pooled cover totals and all three indices. Use the same confidence-level, resample-count, fixed-seed, and caller-RNG-state rules as the other enclosure summaries.
- If an enclosure has no positive vegetation cover, report gamma richness as 0 and Shannon and Simpson as missing because relative abundance is undefined.
- If only one usable quadrat exists, return the observed gamma estimate with missing interval bounds rather than a zero-width interval.

## Deferred visualization and CLI agreement

These decisions are recorded for the later report increment but are not part of the first implementation:

- Add only the specified distribution chart, not a larger collection of charts.
- Use one 100%-normalized stacked bar per enclosure–quadrant, faceted by enclosure and filled by observed recorded categories.
- Include vegetation, soil, rock, and litter categories in the chart.
- Do not add rows for categories absent from a quadrat.
- Write chart output as PNG.
- Provide an exported Rscript CLI entry point and three named CSV inputs: intercept, quadrat, and species/stratum tables.
- Write named CSV outputs and the PNG into one output directory.
- Create the output directory as needed and overwrite only known workflow files.

## Explicitly deferred or unresolved

- High-level workflow return type and orchestration.
- Complete report/artifact structure.
- Plot implementation and image-writing code.
- CLI implementation and tests.
- Package version for the feature release was not decided.
