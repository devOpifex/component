#' @component test
.test_javascript <- \() {
  c(
    "$(() => {",
      "console.log('hello, components!');",
    "})"
  )
}

.test_css <- \() {
  c(
    ".red{color:red;}",
    "h1{font-weight: bold;}"
  )
}

.test_ui <- \(ns) {
  shiny::div(
    shiny::h1("Component", class = "red"),
    shiny::plotOutput(ns("plot"))
  )
}

.test_server <- \(input, output, session) {
  ns <- session$ns
  output$plot <- shiny::renderPlot(plot(stats::runif(200)))
}
