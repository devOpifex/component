#' Namespace
#' 
#' Namespace a string.
#' 
#' @param strings Vector of string to namespace.
#' @param ns Namespace function.
#' 
#' @section Transformers:
#' 
#' * `class`: transforms `{{ class red }}` into `.namespace-red`
#' * `id`: transforms `{{ id red }}` into `#namespace-red`
#' * `ns`: transforms `{{ ns red }}` into `namespace-red`
#' * `json`: transforms `{{ json letters[1:2] }}` into `['a', 'b']`
#' 
#' @export
namespace <- function(strings, ns) {
  strings |>
    sapply(\(string) {
      glue::glue(string, .open = "{{", .close = "}}", .transformer = namespace_transformer(ns))
    }) |>
    (\(.) paste0(., collapse = "\n"))()
}

namespace_transformer <- function(ns, ...) {
  function(text, envir) {
    text <- trimws(text)

    text <- strsplit(text, " ")[[1]]

    arg <- ns(paste0(text[2:length(text)], collapse = " "))

    prefix <- ""
    if(text[1] == "class")
      prefix <- "."

    if(text[1] == "id")
      prefix <- "#"

    if(text[1] == "json")
      arg <- text[2] |> 
        glue::identity_transformer(envir) |> 
        jsonlite::toJSON(auto_unbox = TRUE) |> 
        as.character()

    paste0(prefix, arg, collapse = " ")
  }
}

