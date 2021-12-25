#' Make a small caps
#'
#' Convert upper script to small caps.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @return a strings small caps span html tags.
#' @export
#' @importFrom rmarkdown metadata

small_caps <- function(gloss){
  if(!is.null(rmarkdown::metadata$output) &&
     grepl("latex", unlist(rmarkdown::metadata$output))){
    paste(paste0('\\textsc{', tolower(gloss), '}'))
  } else {
  paste(paste0('<span style="font-variant:small-caps;">',
               tolower(gloss),
               '</span>'))
}
}
