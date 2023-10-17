#' Minify CSS
#' 
#' Minify CSS
#' 
#' @param css CSS string to minify.
#' 
#' @importFrom sass sass sass_options
#' 
#' @export
minify_css <- function(css){
  sass(css, options = sass_options(output_style = "compressed"))
}

#' Minify JavaScript
#' 
#' Minify JavaScript
#' 
#' @param js JavaScript string to minify.
#' 
#' @export
minify_js <- function(js){
  cmd <- Sys.which("uglifyjs")

  if(cmd == "")
    return(js)

  temp_in <- tempfile(fileext = ".js")
  temp_out <- tempfile(fileext = ".js")

  on.exit({
    unlist(temp_in)
    unlist(temp_out)
  })

  writeLines(js, con = temp_in)

  system2(
    cmd,
    paste0("--compress --mangle --output ", temp_out, " -- ", temp_in)
  )

  temp_out |>
    readLines() |>
    suppressWarnings()
}
