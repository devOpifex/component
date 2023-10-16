check: document
	Rscript -e "devtools::check()"

document: 
	Rscript -e "devtools::document()"

install: document
	Rscript -e "devtools::install()"

run: document
	Rscript test.R

