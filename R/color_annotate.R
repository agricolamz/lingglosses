#' Make color
#'
#' Annotate with color.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @export
#' @importFrom knitr is_latex_output

color_annotate <- function(gloss){
  if(knitr::is_latex_output()){
    paste(paste0('\\colorbox{cyan}{', gloss, '}'))
  } else {
    paste(paste0('<span style="background-color:#00d5ff;">', gloss, '</span>'))
  }
}
