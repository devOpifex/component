#' Remove component
#' 
#' Remove a component from the package.
#' 
#' @param name Name of component to detele.
#' @param check Whether to run an interactive check.
#' 
#' @export 
remove_component <- function(name, check = interactive()) {
  name <- make_component_name(name)

  comp <- sprintf("R/component-%s.R", name)
  comp_generated <- sprintf("R/component-generated-%s.R", name)

  if(check){
    cat(
      "Are you sure you want to delete",
      comp,
      "and",
      comp_generated,
      "?"
    )

    ans <- utils::menu(c("y", "n"))

    if(ans != 1L) {
      cat("Aborting\n")
      return(invisible(FALSE))
    }
  }

  comp |>
    file.remove() |>
    suppressWarnings()

  comp_generated |>
    file.remove() |>
    suppressWarnings()

  cat(
    "Deleted",
    comp,
    "and",
    comp_generated,
    "\n"
  )

  invisible(TRUE)
}
