add_month_start_end <- function(data,
                                month_col,
                                year,
                                start_name = "start_date",
                                end_name = "end_date") {

  month_col <- enquo(month_col)
  start_name <- quo_name(start_name)
  end_name <- quo_name(end_name)

  data %>% mutate(
    !!start_name := case_when(
      !!month_col == "Jan" ~ paste0(year, "-01-01"),
      !!month_col == "Feb" ~ paste0(year, "-02-01"),
      !!month_col == "Mar" ~ paste0(year, "-03-01"),
      !!month_col == "Apr" ~ paste0(year, "-04-01"),
      !!month_col == "May" ~ paste0(year, "-05-01"),
      !!month_col == "Jun" ~ paste0(year, "-06-01"),
      !!month_col == "Jul" ~ paste0(year, "-07-01"),
      !!month_col == "Aug" ~ paste0(year, "-08-01"),
      !!month_col == "Sep" ~ paste0(year, "-09-01"),
      !!month_col == "Oct" ~ paste0(year, "-10-01"),
      !!month_col == "Nov" ~ paste0(year, "-11-01"),
      !!month_col == "Dec" ~ paste0(year, "-12-01"),
      TRUE ~ "NA"
    ),
    !!end_name := case_when(
      !!month_col == "Jan" ~ paste0(year, "-01-31"),
      !!month_col == "Feb" ~ paste0(year, "-02-28"),
      !!month_col == "Mar" ~ paste0(year, "-03-31"),
      !!month_col == "Apr" ~ paste0(year, "-04-30"),
      !!month_col == "May" ~ paste0(year, "-05-31"),
      !!month_col == "Jun" ~ paste0(year, "-06-30"),
      !!month_col == "Jul" ~ paste0(year, "-07-31"),
      !!month_col == "Aug" ~ paste0(year, "-08-31"),
      !!month_col == "Sep" ~ paste0(year, "-09-30"),
      !!month_col == "Oct" ~ paste0(year, "-10-31"),
      !!month_col == "Nov" ~ paste0(year, "-11-30"),
      !!month_col == "Dec" ~ paste0(year, "-12-31"),
      TRUE ~ "NA"
    )
  )

}
