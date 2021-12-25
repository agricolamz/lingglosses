#' Make a gloss list
#'
#' Creates a gloss list based on glosses used in \code{\link{gloss_example}}. This function tries to guess the meaning of used glosses based on some internal database or database provided by user. You shouldn't treat result as carved in stone: you can copy, modify and paste in your markdown document. If you want your glossing list to be created automatically with \code{make_gloss_list} you can compile your own table in the \code{definition_source} argument.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param definition_source dataframe with the columns \code{gloss} and \code{definition} that helps to automatic search for the gloss definitions.
#' @param all_possible_variants logical. Some glosses have multiple definitions.
#' @return a string with glosses and their definitions gathered from \code{definition_source} table.
#' @importFrom knitr asis_output
#' @importFrom rmarkdown metadata
#' @importFrom utils read.csv
#' @export

make_gloss_list <- function(definition_source = lingglosses::glosses_df,
                            all_possible_variants = FALSE){

  if(!("data.frame" %in% attr(definition_source, "class"))){
    stop("Argument 'definition_source' should have an attribute 'data.frame'.")
  }

  if(sum(c("gloss", "definition") %in% names(definition_source)) != 2){
    stop("'definition_source' should have columns 'gloss' and 'definition'.")
  }

  if(!("weight" %in% names(definition_source))){
    definition_source$weight <- 1
  }

  if(!("source" %in% names(definition_source))){
    definition_source$source <- ""
  }


  knitr::opts_current$set(results='asis')

  # get glosses
  gloss_list <- unlist(utils::read.csv(getOption("lingglosses.glosses_list")))
  # get definitions and sort them
  gloss_ld <- definition_source[definition_source$gloss %in% gloss_list,]
  if(length(gloss_list[!(gloss_list %in% definition_source$gloss)]) > 0){
    gloss_ld <- unique(rbind(
      gloss_ld,
      data.frame(gloss = gloss_list[!(gloss_list %in% definition_source$gloss)],
                 definition = "",
                 source = "",
                 weight = 1)))
  }

  # it is sorted in lingglosses::glosses, but may be not sorted in user's tables
  gloss_ld <- gloss_ld[order(gloss_ld$gloss),]

  if(isFALSE(all_possible_variants)){
    gloss_ld <- gloss_ld[gloss_ld$weight != 0,]
  }

  # generate non breacking space
  if(!is.null(rmarkdown::metadata$output) &&
     grepl("latex", unlist(rmarkdown::metadata$output))){
    gloss_sep = " --- "
  } else {
    gloss_sep = "\u00A0\u2014\u00A0"
  }

  # create an output
  res <- paste(lingglosses::small_caps(gloss_ld$gloss),
               gloss_ld$definition,
               sep = gloss_sep, collapse = "; ")
  knitr::asis_output(res)
}
