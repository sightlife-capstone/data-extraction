
# load libraries ----------------------------------------------------------

library(dplyr)
library(tidyr)
library(readxl)
library(readr)
library(purrr)


# source files --------------------------------------------------------

func_dir <- "functions"
script_dir <- "scripts"

prepro_dir <- file.path("data", "prepro")
postpro_dir <- file.path("data", "postpro")

source(file.path(func_dir, "extract_row.R"))
source(file.path(func_dir, "extract_sheet.R"))
source(file.path(func_dir, "add_month_start_end.R"))

source(file.path(script_dir, "metric_cell_indices.R"))
source(file.path(script_dir, "rate_cell_indices.R"))

# source(file.path(script_dir, "eye_banks.R"))
# source(file.path(script_dir, "metrics.R"))


# load data ---------------------------------------------------------------

cell_indices <- rate_cell_indices

data_tbl <- prepro_dir %>%
  list.files(full.names = TRUE) %>%
  magrittr::set_names(list.files(prepro_dir)) %>%
  as.list() %>%
  purrr::map(~read_xlsx(path = .x, sheet = "Dashboard", range = "A1:S79", col_names = FALSE)) %>%
  purrr::map_dfr(~extract_sheet(data = .x, indices = cell_indices, d_cell_col = 7), .id = "file") %>%
  tidyr::gather(key = "month", value = "measure", -.data$file, -.data$metric_name)


#save(data_tbl, file = file.path(postpro_dir, "metric_table.RData"))


# Add eye banks and metrics -----------------------------------------------

# data_tbl2 <- data_tbl %>%
#   left_join(eb_tbl, by = "file") %>%
#   left_join(metrics_tbl, by = c("metric_name" = "file_metric_names")) %>%
#   filter(metricid != 34)

data_tbl2 <- data_tbl %>%
  left_join(eb_tbl, by = "file") %>%
  mutate(
    metric_id = case_when(
      metric_name == "HCRP Tissue Utilization Rate" ~ 38,
      metric_name == "Death Notification Rate (in units served during working hours)" ~ 39,
      metric_name == "Suitability Rate %" ~ 40,
      metric_name == "Consent Rate %" ~ 41,
      metric_name == "EDC Productivity (No of HCRP Transplants/No. of Active EDCs)" ~ 42,
      metric_name == "Overall Transplant Rate or Utilization Rate (Total Transplanted / Total Recovered):" ~ 75,
      TRUE ~ NA_real_
    )
  )


# Add start and end date --------------------------------------------------

data_tbl3 <- data_tbl2 %>%
  add_month_start_end(.data$month, 2018)


# Rename and export -------------------------------------------------------

data_tbl4 <- data_tbl3 %>%
  filter(!is.na(.data$measure)) %>%
  select(
    eye_bank_id = .data$eyebankid,
    # metric_id = .data$metricid,
    .data$metric_id,
    date_start = .data$start_date,
    date_end = .data$end_date,
    .data$measure
  )

write_csv(data_tbl4, "data/output/eyebank_metric_rates.csv")

