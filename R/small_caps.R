#' Make a small caps
#'
#' Convert upper script to small caps.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @export
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
