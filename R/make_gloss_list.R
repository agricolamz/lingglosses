#' Make a gloss list
#'
#' Creates a gloss list based on glosses used in \code{\link{gloss_example}}. This function tries to guess the meaning of used glosses based on some internal database or database provided by user. You shouldn't treat result as carved in stone: you can copy, modify and paste in your markdown document. If you want your glossing list to be created automatically with \code{make_gloss_list} you can compile your own table in the \code{definition_source} argument.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param definition_source dataframe with the columns \code{gloss} and \code{definition} that helps to automatic search for the gloss definitions.
#' @param all_possible_variants logical. Some glosses have multiple definitions.
#' @return a string with glosses and their definitions gathered from \code{definition_source} table.
#' @importFrom knitr asis_output
#' @importFrom knitr opts_current
#' @importFrom rmarkdown metadata
#' @importFrom utils read.csv
#' @export

make_gloss_list <- function(definition_source = lingglosses::glosses_df,
                            all_possible_variants = FALSE){

  knitr::opts_current$set(results='asis')

# checks for the user's dataset --------------------------------------------
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

# get glosses --------------------------------------------------------------

  gloss_list <- unlist(utils::read.csv(getOption("lingglosses.glosses_list")))

# create a temporal file with all glosses that will be modified ------------
  glosses_dataset <- lingglosses::glosses_df[lingglosses::glosses_df$gloss %in%
                                               gloss_list, ]

# change definition from lingglosses::glosses to user's values -------------
  res <- lapply(seq_along(definition_source$gloss), function(x){
    glosses_dataset[glosses_dataset$gloss ==
                             definition_source$gloss[x],
                           "definition"] <<- definition_source$definition[x]
  })

# keep only those that are present in the document -------------------------
  glosses_dataset <- glosses_dataset[glosses_dataset$gloss %in% gloss_list, ]

# for those glosses that are not present in our and user's database --------
  if(length(gloss_list[!(gloss_list %in% glosses_dataset$gloss)]) > 0){
    glosses_dataset <- unique(rbind(
      glosses_dataset,
      data.frame(gloss = gloss_list[!(gloss_list %in% glosses_dataset$gloss)],
                 definition = "",
                 source = "",
                 weight = 1)))
  }

  glosses_dataset <- glosses_dataset[order(glosses_dataset$gloss),]

  if(isFALSE(all_possible_variants)){
    glosses_dataset <- glosses_dataset[glosses_dataset$weight != 0,]
  }

  # generate non breacking space
  if(!is.null(rmarkdown::metadata$output) &&
     grepl("latex", unlist(rmarkdown::metadata$output))){
    gloss_sep = " --- "
  } else {
    gloss_sep = "\u00A0\u2014\u00A0"
  }

  # create an output
  res <- paste(lingglosses::small_caps(glosses_dataset$gloss),
               glosses_dataset$definition,
               sep = gloss_sep, collapse = "; ")
  knitr::asis_output(res)
}
