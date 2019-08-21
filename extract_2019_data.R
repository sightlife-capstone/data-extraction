

# Read, filter, and format data -------------------------------------------

path_2019 <- file.path("data/2019 EBD Partner Metrics FINAL.xlsx")

raw_data_2019 <- path_2019 %>%
  excel_sheets() %>%
  purrr::set_names() %>%
  purrr::map(read_excel, path = path_2019, range = "A1:S79", col_names = FALSE)

rd2 <- raw_data_2019[-c(2, 20, 21, 31, 36, 37)]

cell_indices <- metric_cell_indices

data19 <- rd2 %>%
  purrr::map_dfr(~extract_sheet(data = .x, indices = cell_indices, d_cell_col = 7), .id = "sheet_name") %>%
  tidyr::gather(key = "month", value = "measure", -.data$sheet_name, -.data$metric_name)


# Add month start/end -----------------------------------------------------

data19_2 <- data19 %>%
  filter(
    .data$month %in% month.abb[1:4],
    !is.na(.data$metric_name),
  ) %>%
  mutate(metric_name = stringr::str_trim(.data$metric_name)) %>%
  add_month_start_end(.data$month, 2019)



# Regularize metric names -------------------------------------------------

data19_3 <- data19_2 %>%
  mutate(
    reg_ss_metric_names = case_when(
      .data$metric_name == "Other sourced donor tissue used (LSCT)" ~ "Other sourced donor tissue used",
      .data$metric_name == "Tissue recovered as MLC cases" ~ "Transplants that were recovered as MLC cases",
      .data$metric_name == "EDC Productivity (No of HCRP Transplants/No. of Active EDCs)" ~ "Number of Active EDCs",
      .data$metric_name == "No of EDCs" ~ "Number of Active EDCs",
      .data$metric_name == "No. of EDCs" ~ "Number of Active EDCs",
      .data$metric_name == "No. of EDCs." ~ "Number of Active EDCs",
      TRUE ~ .data$metric_name
    )
  )


# Add DB eye banks and metrics --------------------------------------------

eb_matching <- readr::read_csv("data/2019_eb_matching.csv")

data19_4 <- data19_3 %>%
  left_join(eb_matching, by = c("sheet_name" = "ss_eb_short")) %>%
  left_join(metrics_tbl, by = c("reg_ss_metric_names" = "file_metric_names"))


# Prep for DB insert ------------------------------------------------------

data19_for_db <- data19_4 %>%
  transmute(
    eye_bank_id = .data$eyebank_id,
    metric_id = .data$metric_id,
    date_start = .data$start_date,
    date_end = .data$end_date,
    measure = .data$measure
  ) %>%
  filter(!is.na(.data$measure))

readr::write_csv(data19_for_db, "data/output/2019_eyebank_metrics.csv")

