#' Make a small caps
#'
#' Convert upper script to small caps.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param gloss vector of characters.
#' @return a strings small caps span html tags.
#' @export
#'
small_caps <- function(gloss){
  paste(paste0('<span style="font-variant:small-caps;">',
               tolower(gloss),
               '</span>'))
}
