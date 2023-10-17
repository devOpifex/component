<!-- badges: start -->
<!-- badges: end -->

# component

Creating components for [shiny](https://shiny.rstudio.com) inspired by [Vue](https://vuejs.org/)

It solves three "issues" with Shiny modules:

1. Generating scoped (namespaced) CSS and JavaScript code.
2. Places all the code for a module in a single file.
3. Bounds CSS, and JavaScript of a module to it

This is inspired from Vue where one defines a component in a single file.

```vue
<script setup>
import { ref } from 'vue'
const count = ref(0)
</script>

<template>
  <button @click="count++">Count is: {{ count }}</button>
</template>

<style scoped>
button {
  font-weight: bold;
}
</style>
```

Where the file includes the style, script, and template.
We reproduce the same with R with the addition of the server component.

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

Components generate code via `devtools::document()` (more on that later)
add the roxygen2 roclet to your `DESCRIPTION`, e.g.:

```
Roxygen: list(markdown = TRUE, roclets = c("collate", "namespace", "rd", "component::roclet_component"))
```

## Component Anatomy

The default component as created by `component::create()` looks something like the code below.

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
    "$('{{class red}}').on('mouseenter', (e) => {
        $(e.target).toggleClass('{{ns red}}');
    })"
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
```

### Component tag

The `@component` tag indicates the name of the component,
in this example `test`.
This tells component which functions to scan for:

- `.<component>_javascript`
- `.<component>_css`
- `.<component>_server`
- `.<component>_ui`

### JavaScript and CSS

The `.test_javascript` and `.test_css` functions are used to generate
scoped code.

- `class`: transforms `{{ class red }}` into `.namespace-red`
- `id`: transforms `{{ id red }}` into `#namespace-red`
- `ns`: transforms `{{ ns red }}` into `namespace-red`
- `json`: transforms `{{ json letters[1:2] }}` into `['a', 'b']`
- You may still use `{{ x }}` in which case it will evaluate `x` 
(passed `*ui` or `*server` function).

These functions should return a character vector of length one or more.

The CSS is minified using [sass](https://github.com/rstudio/sass/), if you have 
[uglifyjs](https://www.npmjs.com/package/uglify-js) installed
it is used to minify the JavaScript otherwise it is not
(install it with `npm install uglify-js -g`).

## UI and Server

Almost identical to the UI and server functions of a shiny module

### How to use

The created template __cannot__ be used as-is, by documenting the code with 
`devtools::document()` we create  a new file (`R/component-generated-<component>.R`)
which contains:

- `<component>_ui`
- `<component>_server`

In this example, `test_ui`, and `server_ui`.

These are the functions that one should use in the application.
Always work on/edit the functions starting with a dot (e.g.: `.test_ui`),
as the generated files get regenerated at every `devtools::document()` call.

Example based on the abose "test" component, after running `devtools::document()`.

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

## Example

Here is the classic counter example but scoped and using JavaScript only.

```r
#' @component counter
NULL

#' counter javascript
#' 
#' counter javascript component.
#' 
#' @param ... Any other argument.
#' 
#' @keywords internal
.counter_javascript <- \(...) {
  "$(() => {
    let index = 0;
    $('{{id button}}').on('click', (e) => {
      index++;
      $('{{id output}}').html(index);
      $('{{id output}}').toggleClass('{{ns criminal}}');
    })
  })"
}

#' counter css
#' 
#' counter css component.
#' 
#' @param ... Any other argument.
#' 
#' @keywords internal
.counter_css <- \(...) {
  "{{class criminal}}{
    color: {{color}};
    font-weight: bold;
  }"
}

#' counter ui
#' 
#' counter UI component.
#' 
#' @param ns Shiny's namespace function.
#' @param ... Any other argument.
#' 
#' @keywords internal
.counter_ui <- \(ns, ...) {
  shiny::div(
    shiny::h1("Counter"),
    shiny::tags$button(
      class = "btn btn-sm btn-primary",
      id = ns("button"),
      "Counter"
    ),
    shiny::p(
      id = ns("output"), 
      0L
    )
  )
}

#' counter server
#' 
#' counter server component.
#' 
#' @param input,output,session Arguments passed from mdoule's server.
#' @param ... Any other argument.
#' 
#' @keywords internal
.counter_server <- \(input, output, session, ...) {}
```

Then, after documenting, it can be used as.

```r
library(shiny)

ui <- fluidPage(
    title = "Test",
    counter_ui("c1", color = "red"),
    counter_ui("c2", color = "blue"),
)

server <- function(...){
    counter_server("c1")
    counter_server("c2")
}

shinyApp(ui, server)
```

