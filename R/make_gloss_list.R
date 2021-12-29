#' Make a gloss list
#'
#' Creates a gloss list based on glosses used in \code{\link{gloss_example}}. This function tries to guess the meaning of used glosses based on some internal database or database provided by user. You shouldn't treat result as carved in stone: you can copy, modify and paste in your markdown document. If you want your glossing list to be created automatically with \code{make_gloss_list} you can compile your own table in the \code{definition_source} argument.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param definition_source dataframe with the columns \code{gloss} and \code{definition} that helps to automatic search for the gloss definitions.
#' @param all_possible_variants logical. Some glosses have multiple definitions.
#' @param annotate_problematic logical. Whether emphasize duplicaded and definitionless glosses
#' @return a string with glosses and their definitions gathered from \code{definition_source} table.
#' @importFrom knitr asis_output
#' @importFrom knitr opts_current
#' @importFrom knitr is_latex_output
#' @importFrom utils read.table
#' @export

make_gloss_list <- function(definition_source = lingglosses::glosses_df,
                            all_possible_variants = FALSE,
                            annotate_problematic = TRUE){

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

  gloss_list <- sort(unique(unlist(utils::read.table(
    getOption("lingglosses.glosses_list"), header = FALSE, encoding = "UTF-8"))))

# create a temporal file with all glosses that will be modified ------------
  glosses_dataset <- unique(lingglosses::glosses_df[
    lingglosses::glosses_df$gloss %in% gloss_list, ])

# change definition from lingglosses::glosses to user's values -------------
  if(!identical(definition_source, lingglosses::glosses_df)){
    glosses_dataset$definition <- unlist(
      lapply(seq_along(glosses_dataset$gloss), function(i){
        id <- which(definition_source$gloss %in% glosses_dataset$gloss[i])
        ifelse(length(id) > 0,
               definition_source$definition[id],
               glosses_dataset$definition[i])
      })
    )
  }

  # keep only those that are present in the document -------------------------
  glosses_dataset <- glosses_dataset[glosses_dataset$gloss %in% gloss_list, ]

# for those glosses that are not present in our and user's database --------
  definitionless <- gloss_list[!(gloss_list %in% glosses_dataset$gloss)]

  if(length(definitionless) > 0){
    glosses_dataset <- unique(rbind(
      glosses_dataset,
      data.frame(gloss = definitionless,
                 definition = "",
                 source = "",
                 weight = 1)))
  }

# sort after addition definitionless glosses -------------------------------
  glosses_dataset <- glosses_dataset[order(glosses_dataset$gloss),]

  if(isFALSE(all_possible_variants)){
    glosses_dataset <- glosses_dataset[glosses_dataset$weight != 0,]
  }

# annotate -----------------------------------------------------------------
  if(isTRUE(annotate_problematic) && length(definitionless) > 0){
    change <- which(glosses_dataset$gloss %in% definitionless)
    glosses_dataset$gloss[change] <- color_annotate(
      glosses_dataset$gloss[change])
  }

  duplicated_glosses <- glosses_dataset$gloss[duplicated(glosses_dataset$gloss)]

  if(isTRUE(annotate_problematic) && length(duplicated_glosses) > 0){
    change <- which(glosses_dataset$gloss %in% duplicated_glosses)
    glosses_dataset$gloss[change] <- color_annotate(
      glosses_dataset$gloss[change])
  }

# generate non breaking space ----------------------------------------------
  if(knitr::is_latex_output()){
    gloss_sep = " --- "
  } else {
    gloss_sep = "\u00A0\u2014\u00A0"
  }

  # create an output
  res <- paste(small_caps(glosses_dataset$gloss),
               glosses_dataset$definition,
               sep = gloss_sep, collapse = "; ")
  knitr::asis_output(res)
}
