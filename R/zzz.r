#' Create a temporal file for gloss list when the package is loaded
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd
#' @importFrom knitr knit_hooks
#' @importFrom htmltools tags

.onLoad <- function(libname = find.package("lingglosses"),
                    pkgname = "lingglosses") {
  tmp_file1 <- tempfile(pattern = get_variable_name(), fileext = ".csv")
  options("lingglosses.glosses_list" = tmp_file1)
  tmp_file2 <- tempfile(pattern = "lingglosses.example.table", fileext = ".csv")
  options("lingglosses.example_table" = tmp_file2)
  tmp_file3 <- tempfile(pattern = "lingglosses.example.counter", fileext = ".csv")
  write.table(x = 0, file = tmp_file3, row.names = FALSE, col.names = FALSE,
              fileEncoding = "UTF-8")
  options("lingglosses.example_counter" = 0)
  options("lingglosses.refresh_glosses_list" = TRUE)
  hook_output <- knitr::knit_hooks$get("output")
  htmltools::tags$script("function lingglosses_sound_play(x) {var audio = new Audio();audio.src = x;audio.play();} function lingglosses_resize(elem, percent) {elem.style.fontSize = percent;}")
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

#' Create audio play objects for html viewer
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @param snd_src string or vector of strings with a image(s) path(s).
#' @param text string o vector of strings that will be displayed as view link.
#' @noRd
#' @importFrom htmltools tagList
#' @importFrom htmltools a
#' @importFrom htmltools tags
#' @return a string or vector of strings

create_sound_play <- function(snd_src, text = "\u266A") {
  htmltools::tagList(htmltools::a(
    onmouseover = "lingglosses_resize(this, '150%')",
    onmouseout = "lingglosses_resize(this, '100%')",
    onclick = paste0("lingglosses_sound_play('", snd_src, "')"),
    text),
    htmltools::tags$script("function lingglosses_sound_play(x) {var audio = new Audio(); audio.src = x; audio.play();} function lingglosses_resize(elem, percent) {elem.style.fontSize = percent;}"))
}
