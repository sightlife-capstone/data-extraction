extract_row <- function(data, cell, d_cell_col) {

  row_name <- data[[cell[1], cell[2]]]
  months <- month.abb

  d_cell <- c(cell[1], d_cell_col)

  metric_values <- data %>%
    magrittr::extract(d_cell[1], d_cell[2]:(d_cell[2] + 11)) %>%
    magrittr::set_colnames(months) %>%
    dplyr::mutate_all(as.numeric) %>%
    dplyr::mutate(metric_name = row_name)

}
