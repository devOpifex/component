<!-- badges: start -->
<!-- badges: end -->

# component

Creating components for [shiny](https://shiny.rstudio.com) inspired by [Vue](https://vuejs.org/)

It solves two "issues" with Shiny modules:

1. Generating scoped (namespaced) CSS and JavaScript code.
2. Places all the code for a module in a single file.
3. Bounds CSS, and JavaScript of a module to it

## Installation

You can install the development version of component from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/component")
```

## Create

From a package (see [lerprechaun](https://leprechaun.opifex.org) or 
[golem](https://thinkr-open.github.io/golem/)), create component.

``` r
# create a component
# give it a name
component::create("test")
```

This creates a new file in `R/` named `component-test.R`, see below.

## Component Anatomy

The default component as created by `create` looks something like the code below.

```r
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
  shiny:.div(
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
```

### Component tag

The `@component` tag indicates the name of the component,
in this example `test`.

### JavaScript and CSS

The `.test_javascript` and `.test_css` functions are used to generate
scoped code.

- `class`: transforms `{{ class red }}` into `.namespace-red`
- `id`: transforms `{{ id red }}` into `#namespace-red`
- `ns`: transforms `{{ ns red }}` into `namespace-red`
- `json`: transforms `{{ json letters[1:2] }}` into `['a', 'b']`

These functions should return a character vector of length one or more.

## UI and Server

Almost identical to the UI and server functions of a shiny module

### How to use

The created template cannot be used as-is, by documenting the code with 
`devtools::document()`.
Documenting creates another corresponding file with two new functions for the 
UI and server.

- `.test_ui` - `test_ui`
- `.test_server` - `test_server`

These are the functions that one should use in the application.
Always work on the functions starting with a dot (e.g.: `.test_ui`).

## Example

Example based on the abose "test" component, after running `devtools::document()`

```r
library(shiny)

ui <- fluidPage(
    title = "Test",
    test_ui("test")
)

server <- function(...){
    test_server("test")
}

shinyApp(ui, server)
```