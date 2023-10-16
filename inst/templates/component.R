#' @component COMPONENT
COMPONENT_javascript <- \() {
  c(
    "$(() => {",
      "console.log('hello, components!');",
    "})"
  )
}

COMPONENT_css <- \() {
  c(
    ".red{color:red;}",
    "h1{font-weight: bold;}"
  )
}

COMPONENT_ui <- \(id) {
  div(
    h1("Component", class = "red"),
    plotOutput(ns("plot"))
  )
}

COMPONENT_server <- \(id) {
  output$plot <- renderPlot(plot(runif(200)))
}
