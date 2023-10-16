#' Test generated UI
#' 
#' UI generated from: .test_ui()
#' 
#' @param id ID of module
#' @param ... Any arguments to pass to .test_ui()
#' 
#' @keywords internal
test_ui <- \(id, ...){
	ns <- shiny::NS(id)
	shiny::tagList(
		shiny::tags$head(
			shiny::tags$style(shiny::HTML(.test_css(...) |> component::namespace(ns, list(...)))),
			shiny::tags$script(shiny::HTML(.test_javascript(...) |> (\(.) c("$(() => {", ., "})"))() |> component::namespace(ns, list(...))))
		),
		.test_ui(ns, ...)
	)
}

#' Test generated server
#' 
#' Server generated from: .test_server()
#' 
#' @param id ID of module
#' @param ... Any arguments to pass to .test_server()
#' 
#' @keywords internal
test_server <- \(id, ...){
	fn <- \(input, output, session) {test_server(input, output, session, ...)}
	shiny::moduleServer(id, .test_server)
}

