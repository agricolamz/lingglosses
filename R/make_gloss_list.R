#' Make a gloss list
#'
#' Creates a gloss list based on glosses used in \code{\link{gloss_example}}. This function tries to guess the meaning of used glosses based on some internal database or database provided by user. You shouldn't treat result as carved in stone: you can copy, modify and paste in your markdown document. If you want your glossing list to be created automatically with \code{make_gloss_list} you can compile your own table in the \code{definition_source} argument.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param definition_source dataframe with the columns \code{gloss} and \code{definition} that helps to automatic search for the gloss definitions.
#' @param remove_glosses character vector that contains glosses that should be removed from the abbreviation list.
#' @param all_possible_variants logical. Some glosses have multiple definitions.
#' @param annotate_problematic logical. Whether emphasize duplicated and definitionless glosses
#' @return a string with glosses and their definitions gathered from \code{definition_source} table.
#' @importFrom knitr asis_output
#' @importFrom knitr opts_current
#' @importFrom knitr is_latex_output
#' @importFrom rmarkdown metadata
#' @importFrom utils read.table
#' @export

make_gloss_list <- function(definition_source = lingglosses::glosses_df,
                            remove_glosses = "",
                            all_possible_variants = FALSE,
                            annotate_problematic = TRUE){

# arg checks ---------------------------------------------------------------
  if(typeof(remove_glosses) != "character"){
    warning("The remove_glosses should be character.")
  } else {
    remove_glosses <- toupper(remove_glosses)
  }

  if(typeof(all_possible_variants) != "logical"){
    warning("The remove_glosses should be logical.")
  }

  if(typeof(annotate_problematic) != "logical"){
    warning("The annotate_problematic should be logical.")
  }

  # checks for the user's dataset --------------------------------------------
  if(!("data.frame" %in% attr(definition_source, "class"))){
    stop("Argument 'definition_source' should have an attribute 'data.frame'.")
  }

  if(sum(c("gloss", "definition_en") %in% names(definition_source)) != 2){
    stop("'definition_source' should have columns 'gloss' and 'definition_en'.")
  }

  if(!("weight" %in% names(definition_source))){
    definition_source$weight <- 1
  }

  if(!("source" %in% names(definition_source))){
    definition_source$source <- "from the user"
  }

  # get glosses --------------------------------------------------------------
  gloss_file_name <- getOption("lingglosses.glosses_list")
  if(file.exists(gloss_file_name) && file.size(gloss_file_name) > 0){
    gloss_list <- sort(unique(unlist(utils::read.table(gloss_file_name,
                                                       header = FALSE,
                                                       encoding = "UTF-8"))))

    # remove glosses with punctuation -----------------------------------------
    gloss_list <- gsub("\\W", "", gloss_list)
    gloss_list <- gloss_list[gloss_list != ""]

    # refresh glosses ----------------------------------------------------------
    if(getOption("lingglosses.refresh_glosses_list")){
      write.table(x = NULL, file = gloss_file_name, row.names = FALSE,
                  col.names = FALSE, append = FALSE, fileEncoding = "UTF-8")
    }

    # create a variable with all glosses that will be modified -----------------
    glosses_dataset <- unique(
      rbind(definition_source[definition_source$gloss %in% gloss_list, ],
      lingglosses::glosses_df[lingglosses::glosses_df$gloss %in% gloss_list, ]))

    glosses_dataset <- glosses_dataset[!duplicated(glosses_dataset[, 1:2]),]


    # change definition from lingglosses::glosses to user's values -------------
    if(!identical(definition_source, lingglosses::glosses_df)){
      from_user <- glosses_dataset[glosses_dataset$source == "from the user",]$gloss
      glosses_dataset <-
        rbind(glosses_dataset[glosses_dataset$gloss %in% from_user &
                                glosses_dataset$source == "from the user",],
              glosses_dataset[!(glosses_dataset$gloss %in% from_user),])
    }

    # keep only those that are present in the document -------------------------
    glosses_dataset <- glosses_dataset[glosses_dataset$gloss %in% gloss_list, ]

    # for those glosses that are not present in our and user's database --------
    definitionless <- gloss_list[!(gloss_list %in% glosses_dataset$gloss)]

    if(length(definitionless) > 0){
      warning(paste0("There are some glosses that lack definition: ",
                     paste0(definitionless, collapse = ", ")))

      glosses_dataset <- unique(rbind(
        glosses_dataset,
        data.frame(gloss = definitionless,
                   definition_en = "",
                   source = "",
                   weight = 1)))
    }

    glosses_dataset

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

    if(length(remove_glosses) > 0){
      keep <- which(!(glosses_dataset$gloss %in% remove_glosses))
      glosses_dataset <- glosses_dataset[keep,]
    }

    # generate non breaking space ----------------------------------------------
    if(knitr::is_latex_output()){
      gloss_sep = " --- "
    } else {
      gloss_sep = "\u00A0\u2014\u00A0"
    }

    # create an output
    res <- paste(small_caps(glosses_dataset$gloss),
                 glosses_dataset$definition_en,
                 sep = gloss_sep, collapse = "; ")
    knitr::asis_output(res)

  } else{
    warning(paste0("There is no glosses in document ",
                   rmarkdown::metadata$title,
                   " or its fragment."))
  }
}
