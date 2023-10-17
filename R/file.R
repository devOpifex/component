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

make_write_lines <- \(file){
  CON <- file(file, "a")

  list(
    w = \(...){
      paste0(...) |>
        writeLines(con = CON)
    },
    c = \(){
      close(CON)
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

