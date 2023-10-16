#' Component
#'
#' Generate Component
#'
#' @importFrom roxygen2 roclet roxy_tag_warning block_get_tags roclet_output
#' @importFrom roxygen2 roclet_process roxy_tag_parse rd_section roxy_tag_rd
#'
#' @rdname roclets
#' @export
roclet_component <- function() {
  roclet("component")
}

#' @export
roclet_process.roclet_component <- function(x, blocks, env, base_path, ...) {
  results <- list()
  
  for (block in blocks) {
    tags <- block_get_tags(block, "component")

    for (tag in tags) {
      res <- tag$val
      res$fn_js <- env[[make_component_fn(res$component, "javascript")]]
      res$fn_css <- env[[make_component_fn(res$component, "css")]]

      res$file_js <- make_file(res$component, "js")
      res$file_css <- make_file(res$component, "css")
      res$file_r <- make_file(res$component, "R")

      res$path_js <- make_output_file(res$component, "js", dir = sprintf("inst/%s", res$component))
      res$path_css <- make_output_file(res$component, "css", dir = sprintf("inst/%s", res$component))
      res$path_r <- make_output_file(paste0("component-generated-", res$component), "R", dir = "R")

      results <- append(
        results, 
        list(res)
      )
    }
  }
  
  results
}

#' @export
roclet_output.roclet_component <- function(x, results, base_path, ...) {
  roxygen2::load_pkgload(base_path)

  for (component in results) {
    remove_file_if_exists(component$path_r)

    make_ui(component)
    make_server(component)
  }

  invisible(NULL)
}

#' @export
roxy_tag_parse.roxy_tag_component <- function(x) {
  component <- x$raw |> trimws()

  x$val <- list(
    file = x$file,
    component = component
  )

  return(x)
}

#' @export
roxy_tag_rd.roxy_tag_component <- function(x, base_path, env) {
  rd_section("component", x$val)
}

#' @export
format.rd_section_component <- function(x, ...) {
  paste0(
    "\\section{Component}{\n",
    "Generated Component\n",
    "}\n"
  )
}

