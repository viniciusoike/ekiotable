## code to prepare `DATASET` dataset goes here
library(dplyr)
library(stringr)
import::from(sidrar, get_sidra)
import::from(forcats, fct_reorder)

pop <- get_sidra(9514)

tbl_pop <- pop |>
  as_tibble() |>
  janitor::clean_names()

codes <- 6558:6659

generations_brazil <- tbl_pop |>
  filter(
    forma_de_declaracao_da_idade == "Total",
    idade_codigo %in% codes
  ) |>
  select(sexo, idade, valor) |>
  mutate(
    age = as.numeric(str_remove(idade, "(ano$)|(anos$)|(anos ou mais$)")),
    generation = case_when(
      age < 12 ~ "Alpha",
      age >= 12 & age < 28 ~ "Gen Z",
      age >= 28 & age < 44 ~ "Millennial",
      age >= 44 & age < 60 ~ "Gen X",
      age >= 60 & age < 80 ~ "Boomers",
      age >= 80 ~ "Elder"
    ),
    generation = factor(generation),
    generation = fct_reorder(generation, age)
  )

usethis::use_data(generations_brazil, overwrite = TRUE)
