
# Load db tables ----------------------------------------------------------

db_tbl_eyebank <-
  read_csv("data/db_tables/eye_bank-2019-06-04.csv") %>%
  filter(.data$eyebankid < 24)

db_tbl_metric <-
  read_csv("data/db_tables/metric-2019-06-04.csv")


# Load edc data -----------------------------------------------------------

edc_raw_data <- read_xlsx(
  "data/2018 Eye Bank Performance Google Doc.xlsx",
  sheet = "2018 HCRP Actuals",
  range = "A2:BV36",
  col_names = TRUE
)

edc_data <- edc_raw_data %>%
  rename("eye_bank" = .data$...1) %>%
  filter(!stringr::str_detect(.data$eye_bank, "Total")) %>%
  select(
    .data$eye_bank,
    contains("edc", ignore.case = TRUE),
    -contains("prod", ignore.case = TRUE)
  ) %>%
  magrittr::set_names(c("eye_bank", month.abb)) %>%
  mutate(
    eye_bank = case_when(
      .data$eye_bank == "Pondy" ~ "AEBAP",
      .data$eye_bank == "Tiru" ~ "RAEB",
      .data$eye_bank == "Chitrakoot" ~ "SNC",
      TRUE ~ .data$eye_bank
    )
  ) %>%
  gather(key = "month", value = "edc_num", -.data$eye_bank)


# Filter to 2018 India eye banks ------------------------------------------

edc_india_2018 <- edc_data %>%
  semi_join(db_tbl_eyebank, by = c("eye_bank" = "eyebankshortname")) %>%
  left_join(db_tbl_eyebank, by = c("eye_bank" = "eyebankshortname"))


# prep for db -------------------------------------------------------------


edc_metric_id <- db_tbl_metric %>%
  filter(.data$metricname == "Number of Active EDCs") %>%
  pull(.data$metricid)

edc_for_db <- edc_india_2018 %>%
  mutate(metric_id = edc_metric_id) %>%
  add_month_start_end(.data$month) %>%
  filter(!is.na(.data$edc_num)) %>%
  select(.data$eyebankid, .data$metric_id, .data$start_date, .data$end_date, .data$edc_num)

write_csv(edc_for_db, "data/output/2018_india_edc_data.csv")



