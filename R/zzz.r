#' Create a temporal file for gloss list when the package is loaded
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd

.onLoad <- function(libname = find.package("lingglosses"),
                    pkgname = "lingglosses") {
  tmp_file <- tempfile(pattern = get_variable_name(), fileext = ".csv")
  options("lingglosses.glosses_list" = tmp_file)
  options("lingglosses.refresh_glosses_list" = TRUE)
  invisible()
}

#' Creates a name of the hidden variable for tracking glosses
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd
#' @importFrom rmarkdown metadata

get_variable_name <- function(){
  gloss_variable <- gsub("\\W", "_", rmarkdown::metadata$title)
  gloss_variable <- gsub("\\d", "", gloss_variable)
  gloss_variable <- paste0(".list_of_glosses_for_", gloss_variable)
  gloss_variable
}

#' Make a small caps
#'
#' Convert upper script to small caps.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @noRd
#' @examples
#' small_caps("NOM")
#' @importFrom knitr is_latex_output

small_caps <- function(gloss){
  if(knitr::is_latex_output()){
    paste(paste0('\\textsc{', tolower(gloss), '}'))
  } else {
    paste(paste0('<span style="font-variant:small-caps;">',
                 tolower(gloss),
                 '</span>'))
  }
}

#' Make color
#'
#' Annotate with color.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @noRd
#' @examples
#' color_annotate("NOM")
#' @importFrom knitr is_latex_output

color_annotate <- function(gloss){
  if(knitr::is_latex_output()){
    paste(paste0('\\colorbox{cyan}{', gloss, '}'))
  } else {
    paste(paste0('<span style="background-color:#00d5ff;">', gloss, '</span>'))
  }
}

