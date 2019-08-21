extract_sheet <- function(data, indices, d_cell_col) {

  # Correct duplicate names
  data[[51, 4]] <- "suitable - Therapeutic, tectonic, KLAL, or K-pro only"
  data[[61, 4]] <- "distributed - Therapeutic, tectonic, KLAL, or K-pro only"

  metric_tbl <- purrr::map_dfr(
    indices,
    ~extract_row(data, .x, d_cell_col)
  )

}
