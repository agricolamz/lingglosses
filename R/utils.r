#' Create a variable for gloss list when the package is loaded
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd
#' @importFrom rmarkdown metadata
#' @export

.onLoad <- function(libname = find.package("lingglosses"),
                    pkgname = "lingglosses") {
  tmp_file <- tempfile(pattern = .get_variable_name(), fileext = ".csv")
  options("lingglosses.glosses_list" = tmp_file)
  invisible()
}

#' Creates a name of the hidden variable for tracking glosses
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd
#' @importFrom rmarkdown metadata
#' @export
.get_variable_name <- function(){
  gloss_variable <- gsub("\\W", "_", rmarkdown::metadata$title)
  gloss_variable <- gsub("\\d", "", gloss_variable)
  gloss_variable <- paste0(".list_of_glosses_for_", gloss_variable)
  gloss_variable
}
