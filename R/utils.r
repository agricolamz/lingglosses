#' Create a variable for gloss list when the package is loaded
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd
#' @importFrom rmarkdown metadata
#' @export

.onLoad <- function(...) {
  # get document title
  title <- gsub("\\W", "_", rmarkdown::metadata$title)
  title <- gsub("\\d", "", title)
  title <- paste0(".list_of_glosses_for_", title)
  # write a hidden variable to the global environment
  assign(title, character(), envir = .GlobalEnv)
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
