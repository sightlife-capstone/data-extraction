
# Load db data ------------------------------------------------------------

edc_rates_raw <-
  read_csv(
    "data/db_tables/eye_bank_edc_rates-2019-06-04.csv",
    na = "NULL"
  ) %>%
  filter(!is.na(.data$measure))



# Calculate EDC rate ------------------------------------------------------

edc_prod <- edc_rates_raw %>%
  select(-metricname) %>%
  tidyr::spread(metricid, measure) %>%
  mutate(`42` = .data$`28` / .data$`34`) %>%
  select(startdate, enddate, eyebankid, .data$`42`) %>%
  tidyr::gather(metric_id, measure, -startdate, -enddate, -eyebankid) %>%
  filter(
    !is.na(measure),
    is.finite(measure)
  )

write_csv(edc_prod, "data/output/2018_india_edc_prod_data.csv")
