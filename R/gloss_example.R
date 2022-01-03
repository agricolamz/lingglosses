#' Gloss an example
#'
#' Creates an interlinear glossed example for linguistics.
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @param transliteration character vector of the length one for the transliteration line.
#' @param glosses character vector of the length one for the glosses line.
#' @param free_translation character vector of the length one for the free translation line.
#' @param orthography character vector of the length one for the orthography line (above translation).
#' @param comment character vector of the length one for the comment line (under the free translation line).
#' @param line_length integer vector of the length one that denotes maximum number of characters per one line.
#' @param italic_transliteration logical variable that denotes, whether user wants to italicize your example.
#' @param drop_transliteration logical variable that denotes, whether user wants to have an example without tranliteration.
#' @param intext logical variable that denotes, whether example should be considered as part of the text (\code{TRUE}) or as a standalone paragraph (\code{FALSE})
#'
#' @examples
#' \dontrun{
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'                "fly-NPST-**INF** know-HAB-NEG",
#'                "I cannot fly. (Zilo Andi, East Caucasian)",
#'                comment = "(lit. do not know how to)")
#' }
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'                "fly-NPST-**INF** know-HAB-NEG",
#'                "I cannot fly.",
#'                intext = TRUE)
#' @importFrom knitr is_latex_output
#' @importFrom kableExtra kable_minimal
#' @importFrom kableExtra kbl
#' @importFrom kableExtra footnote
#' @importFrom utils write.table
#' @export

gloss_example <- function(transliteration,
                          glosses,
                          free_translation = "",
                          comment = "",
                          orthography = "",
                          line_length = 70,
                          italic_transliteration = TRUE,
                          drop_transliteration = FALSE,
                          intext = FALSE){

# fix for multiple glosses line --------------------------------------------
  length_glosses <- length(glosses)
  if(length_glosses > 1){
    glosses <- c(paste0(glosses[-length_glosses], " "), glosses[length_glosses])
  }

# check arguments ----------------------------------------------------------
  # lapply(names(formals(gloss_example))[1:2],
  #        function(argument){
  #          if(length(eval(parse(text = argument))) != 1 |
  #             typeof(eval(parse(text = argument))) != "character"){
  #            stop(paste0(argument,
  #                        " argument should be a character vector of length 1"))
  #          }
  #        })

  if(length(line_length) != 1 | typeof(line_length) != "double"){
    stop(paste0("line_length",
                " argument should be a character vector of length 1"))
  }

# split arguments by spaces ------------------------------------------------
  if(drop_transliteration){
    transliteration <- glosses
  }

  transliteration <- unlist(strsplit(transliteration, " "))
  glosses_by_word <- unlist(strsplit(glosses, " "))


  if(length(orthography) > 0){
    orthography <- unlist(strsplit(orthography, " "))
  }

# prepare vector of splits of the glosses by line --------------------------
  longest <- if(sum(nchar(transliteration)) > sum(nchar(glosses))){
    transliteration
  } else {
    glosses_by_word
  }

# check that glosses and transliteration have the same length --------------
  # if(length(transliteration) != length(glosses_by_word)){
  #   stop(paste0("There is a different number of words and glosses in the
  #               following example: ", paste0(transliteration, collapse = " ")))
  # }
  #

  if(length(orthography) > 0 & length(transliteration) != length(orthography)){
    stop(paste0("There is a different number of words in orthography and
                transliteration in the following example: ",
                paste0(transliteration, collapse = " ")))
  }

# add glosses to the document gloss list -----------------------------------
  single_gl <- unlist(strsplit(glosses_by_word, "[-\\.=:\\)\\(!\\?]"))
  single_gl <- lingglosses::add_gloss(single_gl)

# get delimeters back ------------------------------------------------------
  delimeters <- unlist(strsplit(glosses, "[^-:\\.= \\)\\(!\\?]"))
  delimeters <- c(delimeters[delimeters != ""], "")
  glosses <- paste0(single_gl, delimeters, collapse = "")
  glosses <- gsub("<span style=", "<span_style=", glosses)
  glosses <- unlist(strsplit(glosses, " "))
  glosses <- gsub("<span_style=", "<span style=", glosses)

# italic of the language line ----------------------------------------------
  if(isTRUE(italic_transliteration) & !drop_transliteration){
    if(knitr::is_latex_output()){
      transliteration <- paste0("\\textit{", transliteration, "}")
    } else {
      transliteration <- paste0("*", transliteration, "*")
    }
  }

# long line splitting ------------------------------------------------------
  splits_by_line <- as.double(cut(cumsum(nchar(longest)),
                                  breaks = 0:1e5*line_length))

# for inline examples ------------------------------------------------------
  if(isTRUE(intext)){
    if(!drop_transliteration){
      inline_transliteration <- paste(transliteration, collapse = " ")
      sep1 <- " ("
      sep2 <- ")"
    } else {
      inline_transliteration <- ""
      sep1 <- ""
      sep2 <- ""
    }


    result <- paste0(inline_transliteration,
                     sep1,
                     paste(glosses, collapse = " "),
                     if(nchar(free_translation) > 0){
                       paste0(" '", free_translation, "'")} else {""},
                     if(nchar(comment) > 0){
                       paste0(" ", comment)} else {""},
                     sep2,
                     collapse = "")
  } else{

# long line splitting ------------------------------------------------------

    if(length(unique(splits_by_line)) > 1){
      multiline_result <- lapply(unique(splits_by_line), function(i){
        gloss_example(
          paste(transliteration[splits_by_line == i], collapse = " "),
          paste(glosses_by_word[splits_by_line == i], collapse = " "),
          free_translation = if(i == max(splits_by_line)){free_translation} else {""},
          orthography = if(length(orthography) > 0){
            paste(orthography[splits_by_line == i], collapse = " ")},
          comment = if(i == max(splits_by_line)){comment} else {""},
          italic_transliteration = FALSE,
          line_length = line_length,
          drop_transliteration = drop_transliteration,
          intext = FALSE)
      })
    } else {

# combine everything into table --------------------------------------------
      orth <- if(length(orthography) > 0){orthography} else{NULL}
      trans <- if(!drop_transliteration){transliteration} else{NULL}
      for_matrix <- c(orth, trans, glosses)
      nrow_matrix <- length_glosses + (length(orth) > 0) + (length(trans) > 0)

      result <- matrix(for_matrix, nrow = nrow_matrix, byrow = TRUE)
      result <- kableExtra::kbl(result, align = "l", centering = FALSE,
                                escape = FALSE, vline = "")
      result <- kableExtra::kable_minimal(result,
                                          position = "left",
                                          full_width = FALSE)

# add comment --------------------------------------------------------------
      if(nchar(comment) > 0){
        result <- kableExtra::footnote(kable_input = result,
                                       general = comment,
                                       general_title = "")
      }

# add free translation -----------------------------------------------------
      if(nchar(free_translation) > 0){
        result <- kableExtra::footnote(kable_input = result,
                                       general = paste0("'", free_translation, "'"),
                                       general_title = "")
      }

# remove lines from LaTeX --------------------------------------------------
      if(knitr::is_latex_output()){
        result <- gsub("\\\\toprule", "", result)
        result <- gsub("\\\\midrule", "", result)
        result <- gsub("\\\\bottomrule", "", result)
        result <- gsub("\\\\hline", "", result)
      }
    }
  }

# return output ------------------------------------------------------------
  if(length(unique(splits_by_line)) > 1){
    cat(unlist(multiline_result))
  } else{
    return(result)
  }
}
