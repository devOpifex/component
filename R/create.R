#' Create
#' 
#' Create component
#' 
#' @export
create <- \(name) {
  if(missing(name))
    stop("missing `name`")

  file <- pkg_file("templates/component.R") |>
    readLines() |>
    (\(.) gsub("COMPONENT", name, .))()

  con <- sprintf("R/component-%s.R", name)
  writeLines(file, con)

  cat(con, "created!")

  invisible(con)
}
