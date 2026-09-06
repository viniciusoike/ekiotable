# generations_brazil ----

#' Brazilian resident population by age and sex, 2022 Census
#'
#' Resident population of Brazil by single year of age and sex at the 2022
#' Census, with each age assigned to a generation.
#'
#' @format A tibble with 300 rows and 5 variables:
#' \describe{
#'   \item{sexo}{Sex, as recorded by IBGE: `Total`, `Homens` (men), or
#'     `Mulheres` (women).}
#'   \item{idade}{Age label in Portuguese, as recorded by IBGE, e.g.
#'     `"1 ano"`, `"2 anos"`, `"100 anos ou mais"`.}
#'   \item{valor}{Number of residents at that age and sex.}
#'   \item{age}{Age in years, parsed from `idade`. Ranges from 1 to 100; the
#'     source table has no age 0.}
#'   \item{generation}{Factor with levels ordered from youngest to oldest:
#'     `Alpha` (1 to 11), `Gen Z` (12 to 27), `Millennial` (28 to 43),
#'     `Gen X` (44 to 59), `Boomers` (60 to 79), `Elder` (80 or more).}
#' }
#' @source IBGE, Censo Demográfico 2022, SIDRA table 9514,
#'   <https://sidra.ibge.gov.br/tabela/9514>. Rows keep the total declared age
#'   (`Forma de declaração da idade = "Total"`) and single-year ages.
#' @examples
#' generations_brazil
"generations_brazil"
