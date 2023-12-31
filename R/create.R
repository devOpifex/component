#' Create
#' 
#' Create component
#' 
#' @param name Name of component.
#' 
#' @export
create <- \(name) {
  if(missing(name))
    stop("missing `name`")

  name <- make_component_name(name)

  file <- pkg_file("templates/component.R") |>
    readLines() |>
    (\(.) gsub("COMPONENT", name, .))()

  con <- sprintf("R/component-%s.R", name)
  writeLines(file, con)

  cat(con, "created!\n")

  usethis::use_package("component")

  invisible(con)
}
