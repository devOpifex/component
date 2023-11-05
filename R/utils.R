make_component_fn <- function(name, what) {
  paste0(".", name, "_", what)
}

make_ui <- function(params) {
  wl <- make_write_lines(params$path_r)
  on.exit(wl$c())

  wl$w("#' ", tools::toTitleCase(params$component), " generated UI")
  wl$w("#' ")
  wl$w("#' UI generated from: .", params$component, "_ui()")
  wl$w("#' ")
  wl$w("#' @param id ID of module")
  wl$w("#' @param ... Any arguments to pass to .", params$component, "_ui()")
  wl$w("#' ")
  wl$w("#' @keywords internal")
  wl$w(params$component, "_ui <- \\(id, ...){")
  wl$w("\tns <- shiny::NS(id)")
  wl$w("\tshiny::tagList(")
  wl$w("\t\tshiny::tags$head(")
  wl$w("\t\t\tshiny::tags$style(shiny::HTML(.", params$component, "_css(...) |> component::namespace(ns, list(...)) |> component::minify_css())),")
  wl$w("\t\t\tshiny::tags$script(shiny::HTML(.", params$component, "_javascript(...) |> (\\(.) c(\"$(() => {\", ., \"})\"))() |> component::namespace(ns, list(...)) |> component::minify_js()))")
  wl$w("\t\t),")
  wl$w("\t\t.", params$component, "_ui(ns, ...)")
  wl$w("\t)")
  wl$w("}")
  wl$w("")
}

make_server <- function(params) {
  wl <- make_write_lines(params$path_r)
  on.exit(wl$c())

  wl$w("#' ", tools::toTitleCase(params$component), " generated server")
  wl$w("#' ")
  wl$w("#' Server generated from: .", params$component, "_server()")
  wl$w("#' ")
  wl$w("#' @param id ID of module")
  wl$w("#' @param ... Any arguments to pass to .", params$component, "_server()")
  wl$w("#' ")
  wl$w("#' @keywords internal")
  wl$w(params$component, "_server <- \\(id, ...){")
  wl$w("\tshiny::moduleServer(id, .", params$component, "_server)")
  wl$w("}")
  wl$w("")
}

make_component_name <- function(name) {
  gsub("\\.R$", "", name) |>
    (\(.) gsub(" ", "", .))() |>
    trimws()
}
