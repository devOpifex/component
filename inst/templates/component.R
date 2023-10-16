#' @component COMPONENT
NULL

#' COMPONENT javascript
#' 
#' COMPONENT javascript component.
#' 
#' @param ... Any other argument.
#' 
#' @keywords internal
.COMPONENT_javascript <- \(...) {
  "$(() => {
    $('{{class red}}').on('mouseenter', (e) => {
      $(e.target).toggleClass('{{ns red}}')
    })
  })"
}

#' COMPONENT css
#' 
#' COMPONENT css component.
#' 
#' @param ... Any other argument.
#' 
#' @keywords internal
.COMPONENT_css <- \(...) {
  c(
    "{{class red}}{color:red;}",
    "h1{font-weight: bold;}"
  )
}

#' COMPONENT ui
#' 
#' COMPONENT UI component.
#' 
#' @param ns Shiny's namespace function.
#' @param ... Any other argument.
#' 
#' @keywords internal
.COMPONENT_ui <- \(ns, ...) {
  shiny::div(
    shiny::h1("Component", class = ns("red")),
    shiny::plotOutput(ns("plot"))
  )
}

#' COMPONENT server
#' 
#' COMPONENT server component.
#' 
#' @param input,output,session Arguments passed from mdoule's server.
#' @param ... Any other argument.
#' 
#' @keywords internal
.COMPONENT_server <- \(input, output, session, ...) {
  output$plot <- shiny::renderPlot(plot(stats::runif(200)))
}
