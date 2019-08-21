
eb_matching <- readr::read_csv("data/2019_eb_matching.csv")

edc_prod19_raw <- readxl::read_xlsx(
  "data/2019 EBD Partner Metrics FINAL.xlsx",
  sheet = "HCRP (Actuals)",
  range = "A3:AU38",
  col_names = TRUE
)

edc_prod19_1 <- edc_prod19_raw %>%
  select(`...1`, contains("EDC"), -contains("40")) %>%
  magrittr::set_colnames(c("ss_eb_short", month.abb[1:4])) %>%
  filter(
    !stringr::str_detect(.data$ss_eb_short, "Total"),
    !stringr::str_detect(.data$ss_eb_short, "ZOC")
  ) %>%
  tidyr::gather(key = "month", value = "measure", -.data$ss_eb_short) %>%
  add_month_start_end(.data$month, 2019)

edc_prod19_2 <- edc_prod19_1 %>%
  left_join(eb_matching, by = "ss_eb_short") %>%
  mutate(metric_id = 42)

edc_prod19_for_db <- edc_prod19_2 %>%
  transmute(
    eye_bank_id = .data$eyebank_id,
    metric_id = .data$metric_id,
    date_start = .data$start_date,
    date_end = .data$end_date,
    measure = .data$measure
  ) %>%
  filter(!is.na(.data$measure))

readr::write_csv(edc_prod19_for_db, "data/output/2019_edc_prod.csv")
