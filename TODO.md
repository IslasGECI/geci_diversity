# Vegetation Analysis TODO

## Common agreement: scope and delivery boundary

- Extend `gecidiversity` as a generic biological-diversity R package.
- Add a reusable vegetation-survey module; Clarión is the primary use case, but public names should be island-agnostic.
- Keep the existing Jaccard and SNIB functionality; this effort adds the vegetation module.
- The first implementation increment contains composable numeric metric functions only.
- Defer the high-level workflow contract, plotting, CLI orchestration, and file/report structure until the report design is decided.
- Assume input data has already been validated upstream. Do not add schema mapping, alias configuration, or broad validation.
- Keep the one explicit matching safeguard: stop with a clear error when a survey species has no species/stratum metadata row.
- Use English function names, output columns, and documentation while accepting the documented Spanish input columns.
- Add roxygen documentation and concise README examples for the implemented API.
- Use the existing testthat infrastructure, focused unit tests, and realistic Clarión-style fixtures. Add full CLI contract tests when CLI work begins.

## Agreed public API shape

- Public analysis functions accept in-memory data frames/tibbles; later, the CLI will read three named CSVs.
- Expose one function per result table rather than a monolithic report-producing function.
- The planned first-increment function families are:
  - four line-intercept summaries: species abundance, vegetation-group abundance, ground/litter abundance, and diversity;
  - tidy quadrat cover, height, and diversity detail functions;
  - separate enclosure-level cover, height, and diversity summary functions.
- Helper functions remain internal unless a distinct public use case emerges.
- High-level return structure remains intentionally deferred.

## Agreed input semantics

### Line-intercept table

- Use `Cerco`, `Transecto`, `Punto`, `Distancia`, and `Especie` as documented.
- Each enclosure/transect/point combination represents exactly one surveyed point and has one row.
- Aggregate results by enclosure only; transect identifies the point but is not an output grouping.
- Ignore `Distancia` for calculations.

### Quadrat table

- Use `Cerco`, `Cuadrante`, `Especie`, `Cobertura`, and `Altura` as documented.
- Assume one species/category coverage row per enclosure–quadrant combination.
- Preserve the input height unit; do not convert or label it as centimeters, meters, or another unit.
- Treat `Cobertura` as percent cover on a 0–100 scale.

### Species/stratum table

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
  1. species abundance;
  2. vegetation-group abundance;
  3. bare-ground and litter abundance;
  4. vegetation richness and diversity.
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
  - dynamic cover columns for all observed categories;
  - dynamic height columns for vegetation categories only;
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
- Use the median as the central estimate for every enclosure-level quadrat summary, replacing earlier mean-based wording.
- Use percentile-bootstrap confidence intervals for all numeric enclosure summaries where estimable.
- Default to 95% confidence and 2,000 resamples; expose confidence level and replicate count in public function arguments. CLI exposure is deferred with CLI work.
- Use fixed seed 42 independently at the start of each public summary function, preserve the caller’s RNG state, and keep the seed fixed rather than exposing it.
- For species/category cover, build a complete enclosure–quadrat matrix and treat absence as 0% cover.
- Create enclosure–species rows only for species/categories observed in that enclosure.
- Report both total quadrat count and presence count (`n_quadrats` and `n_present`).
- Summarize every observed category and add grouped vegetation, combined soil/rock, litter, and total-cover estimates.
- For species and mean vegetation height, summarize available per-quadrant values; do not turn absent species heights into zero.
- Enclosure diversity is the median of per-quadrat richness, Shannon, and Simpson values, with bootstrap confidence intervals.
- All enclosure-level cover, height, richness, Shannon, and Simpson summaries receive median plus lower/upper confidence bounds where estimable.
- If only one usable quadrat or height value exists, return the observed estimate with missing interval bounds rather than a zero-width interval.

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
