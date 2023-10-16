#' @component test
NULL

#' test javascript
#' 
#' test javascript component.
#' 
#' @param ... Any other argument.
#' 
#' @keywords internal
.test_javascript <- \(...) {
  c(
    "$(() => {",
      "$('{{class red}}').on('mouseenter', (e) => {",
        "$(e.target).toggleClass('{{ns red}}')",
      "})",
    "})"
  )
}

#' test css
#' 
#' test css component.
#' 
#' @param ... Any other argument.
#' 
#' @keywords internal
.test_css <- \(...) {
  c(
    "{{class red}}{color:red;}",
    "h1{font-weight: bold;}"
  )
}

#' test ui
#' 
#' test UI component.
#' 
#' @param ns Shiny's namespace function.
#' @param ... Any other argument.
#' 
#' @keywords internal
.test_ui <- \(ns, ...) {
  shiny::div(
    shiny::h1("Component", class = ns("red")),
    plotOutput(ns("plot"))
  )
}

#' test server
#' 
#' test server component.
#' 
#' @param input,output,session Arguments passed from mdoule's server.
#' @param ... Any other argument.
#' 
#' @keywords internal
.test_server <- \(input, output, session, ...) {
  output$plot <- shiny::renderPlot(plot(stats::runif(200)))
}
