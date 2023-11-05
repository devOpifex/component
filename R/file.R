pkg_file <- \(...){
  system.file(..., package = "component")
}

file_exists <- function(...){
  file.path(...) |>
    file.exists()
}

remove_file_if_exists <- function(...){
  if(!file_exists(...))
    return()

  file.remove(...)
}

get_package_name <- function(){
  pkg <- readLines("DESCRIPTION")[1]
  gsub("Package: ", "", pkg) |> trimws()
}

#' @importFrom styler style_file
make_write_lines <- \(file){
  CON <- file(file, "a") # nolint

  list(
    w = \(...){
      paste0(...) |>
        writeLines(con = CON)
    },
    c = \(){
      close(CON)

      if(!grepl("\\.R$", file))
        return()

      style_file(file)
    }
  )
}

make_file <- function(component, extension) {
  sprintf(
    "%s.%s",
    component,
    extension
  )
}

make_output_file <- function(component, extension, dir) {
  sprintf(
    "%s/%s",
    dir,
    make_file(
      component,
      extension
    )
  )
}
