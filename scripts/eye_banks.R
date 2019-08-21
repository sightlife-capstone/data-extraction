file_names <- c(
  "2018 - Sight life report AIOB.xlsx",
  "AEBAP Monhtly report.xlsx",
  "EBAK-Monthly Report 2018 - Dec.xlsx",
  "EBSR - Monthly Statistical Report Dec-2018.xlsx",
  "HVD - Monthly Report 2018 - Dec.xlsx",
  "LIEB - Sight Life Monthly 2018 - Dec.xlsx",
  "Monthly Report DEC 2018 SNK.xlsx",
  "Monthly Report december 2018 SCEH.xlsx",
  "Monthly Report Format PGI.xlsx",
  "RAEB Monthly report  Sight Life Jan - Dec 2018 (1).xlsx",
  "RIEB Monthly statistical report_SL new template - 2018.xlsx",
  "Sahiyara - Monthly Report SL-2018t - Dec.xlsx",
  "SNC_EYE_BANK_Monthly Statistical  Report_December_2018.xlsx"
)



eb_name <- c(
  "AIOB",
  "AEBAP",
  "EBAK",
  "EBSR",
  "HVDEB",
  "LIEB",
  "SNK",
  "SCEH",
  "PGI",
  "RAEB",
  "RIEB",
  "Sahiyara",
  "SNC"
)

db_eyebanks_india <- read_csv("data/db_eyebanks_india.csv")

eb_tbl <-
  tibble(
    file = file_names,
    eb_name = eb_name
  ) %>%
  left_join(db_eyebanks_india, by = c("eb_name" = "eyebankshortname"))
