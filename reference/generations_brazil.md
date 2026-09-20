# Brazilian resident population by age and sex, 2022 Census

Resident population of Brazil by single year of age and sex at the 2022
Census, with each age assigned to a generation.

## Usage

``` r
generations_brazil
```

## Format

A tibble with 300 rows and 5 variables:

- sexo:

  Sex, as recorded by IBGE: `Total`, `Homens` (men), or `Mulheres`
  (women).

- idade:

  Age label in Portuguese, as recorded by IBGE, e.g. `"1 ano"`,
  `"2 anos"`, `"100 anos ou mais"`.

- valor:

  Number of residents at that age and sex.

- age:

  Age in years, parsed from `idade`. Ranges from 1 to 100; the source
  table has no age 0.

- generation:

  Factor with levels ordered from youngest to oldest: `Alpha` (1 to 11),
  `Gen Z` (12 to 27), `Millennial` (28 to 43), `Gen X` (44 to 59),
  `Boomers` (60 to 79), `Elder` (80 or more).

## Source

IBGE, Censo Demográfico 2022, SIDRA table 9514
(sidra.ibge.gov.br/tabela/9514). Rows keep the total declared age
(`Forma de declaração da idade = "Total"`) and single-year ages.

## Examples

``` r
generations_brazil
#> # A tibble: 300 × 5
#>    sexo  idade     valor   age generation
#>    <chr> <chr>     <dbl> <dbl> <fct>     
#>  1 Total 1 ano   2353945     1 Alpha     
#>  2 Total 2 anos  2563419     2 Alpha     
#>  3 Total 3 anos  2699784     3 Alpha     
#>  4 Total 4 anos  2729447     4 Alpha     
#>  5 Total 5 anos  2640786     5 Alpha     
#>  6 Total 6 anos  2771512     6 Alpha     
#>  7 Total 7 anos  2831711     7 Alpha     
#>  8 Total 8 anos  2740900     8 Alpha     
#>  9 Total 9 anos  2764531     9 Alpha     
#> 10 Total 10 anos 2701639    10 Alpha     
#> # ℹ 290 more rows
```
