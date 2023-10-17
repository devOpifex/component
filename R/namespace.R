#' Namespace
#' 
#' Namespace a string.
#' 
#' @param strings Vector of string to namespace.
#' @param ns Namespace function.
#' @param env Environment to evaluate `strings`.
#' 
#' @section Transformers:
#' 
#' * `class`: transforms `{{ class red }}` into `.namespace-red`
#' * `id`: transforms `{{ id red }}` into `#namespace-red`
#' * `ns`: transforms `{{ ns red }}` into `namespace-red`
#' * `json`: transforms `{{ json letters[1:2] }}` into `['a', 'b']`
#' 
#' @importFrom glue identity_transformer glue
#' 
#' @export
namespace <- function(strings, ns, env = parent.frame()) {
  if(missing(strings))
    stop("missing `strings`")

  if(missing(ns))
    stop("missing `ns`")

  if(!is.function(ns))
    stop("`ns` must be a function")

  strings |>
    sapply(\(string) {
      glue(
        string, 
        .open = "{{", 
        .close = "}}", 
        .transformer = namespace_transformer(ns),
        .envir = env
      )
    }) |>
    (\(.) paste0(., collapse = "\n"))()
}

namespace_transformer <- function(ns, ...) {
  function(text, envir) {
    text <- trimws(text)

    text <- strsplit(text, " ")[[1]]

    if(length(text) == 1L)
      return(text[1] |> identity_transformer(envir))

    arg <- ns(paste0(text[2:length(text)], collapse = " "))

    prefix <- ""
    if(text[1] == "class")
      prefix <- "."

    if(text[1] == "id")
      prefix <- "#"

    if(text[1] == "json")
      arg <- text[2] |> 
        identity_transformer(envir) |> 
        jsonlite::toJSON(auto_unbox = TRUE) |> 
        as.character()

    paste0(prefix, arg, collapse = " ")
  }
}

