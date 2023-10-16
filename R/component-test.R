#' @component test
test_javascript <- \() {
  c(
    "$(() => {",
      "console.log('hello, components!');",
    "})"
  )
}

test_css <- \() {
  c(
    ".red{color:red;}",
    "h1{font-weight: bold;}"
  )
}

test_ui <- \(id) {
  div(
    h1("Component", class = "red"),
    plotOutput(ns("plot"))
  )
}

test_server <- \(id) {
  output$plot <- renderPlot(plot(runif(200)))
}
