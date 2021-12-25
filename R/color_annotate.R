#' Make color
#'
#' Annotate with color.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @export
#' @importFrom rmarkdown metadata

color_annotate <- function(gloss){
  if(!is.null(rmarkdown::metadata$output) &&
     grepl("latex", unlist(rmarkdown::metadata$output))){
    paste(paste0('\\colorbox{cyan}{', gloss, '}'))
  } else {
    paste(paste0('<span style="background-color:#00d5ff;">', gloss, '</span>'))
  }
}
