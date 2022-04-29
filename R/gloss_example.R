#' Gloss an example
#'
#' Creates an interlinear glossed example for linguistics.
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @param transliteration character vector of the length one for the transliteration line.
#' @param glosses character vector of the length one for the glosses line.
#' @param free_translation character vector of the length one for the free translation line.
#' @param annotation character vector of the length one for the annotation line (above translation).
#' @param grammaticality character vector with the grammaticality value.
#' @param comment character vector of the length one for the comment line (under the free translation line).
#' @param line_length integer vector of the length one that denotes maximum number of characters per one line.
#' @param italic_transliteration logical variable that denotes, whether user wants to italicize your example.
#' @param drop_transliteration logical variable that denotes, whether user wants to have an example without transliteration.
#' @param intext logical variable that denotes, whether example should be considered as part of the text (\code{TRUE}) or as a standalone paragraph (\code{FALSE})
#' @param write_to_db logical variable that denotes, whether example should be added to the example database.
#' @return html/latex output(s) with glossed examples.
#'
#' @examples
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'               "fly-NPST-**INF** know-HAB-NEG",
#'               "I cannot fly. (Zilo Andi, East Caucasian)",
#'               grammaticality = "*",
#'               comment = "(lit. do not know how to)")
#'
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'               "fly-NPST-**INF** know-HAB-NEG",
#'               "I cannot fly.",
#'               intext = TRUE)
#'
#' @importFrom knitr is_latex_output
#' @importFrom kableExtra kable_minimal
#' @importFrom kableExtra kbl
#' @importFrom kableExtra footnote
#' @export

gloss_example <- function(transliteration,
                          glosses,
                          free_translation = "",
                          comment = "",
                          annotation = NULL,
                          grammaticality = NULL,
                          line_length = 70,
                          italic_transliteration = TRUE,
                          drop_transliteration = FALSE,
                          intext = FALSE,
                          write_to_db = TRUE){

# add 1 to the counter -----------------------------------------------------
  example_counter <- getOption("lingglosses.example_counter")
  options("lingglosses.example_counter" = as.double(example_counter)+1)

# fix for multiple glosses line --------------------------------------------
  length_glosses <- length(glosses)
  if(length_glosses > 1){
    glosses <- c(paste0(glosses[-length_glosses], " "), glosses[length_glosses])
  }

# check arguments ----------------------------------------------------------
  if(length(line_length) != 1 | typeof(line_length) != "double"){
    stop(paste0("line_length",
                " argument should be a character vector of length 1"))
  }

# fix the apostrophe problem
  if(!drop_transliteration){
    transliteration <- gsub(pattern = "[\u2019\u02BC]", replacement = "'", transliteration)}
  glosses <- gsub(pattern = "[\u2019\u02BC]", replacement = "'", glosses)
  if(!is.null(grammaticality)){
    grammaticality <- gsub(pattern = "\\*", replacement = "\uFF0A", grammaticality)
  }

# split arguments by spaces ------------------------------------------------
  if(drop_transliteration){
    transliteration <- glosses
  }

  transliteration <- unlist(strsplit(transliteration, " "))
  glosses_by_word <- unlist(strsplit(glosses, " "))

# prepare vector of splits of the glosses by line --------------------------
  longest <- if(sum(nchar(transliteration)) > sum(nchar(glosses))){
    transliteration
  } else {
    glosses_by_word
  }


# add example to the example list ------------------------------------------
  if(write_to_db){
    glossed_df <- lingglosses::convert_to_df(
      transliteration = paste0(transliteration, collapse = " "),
      glosses = glosses,
      free_translation = free_translation,
      comment = comment,
      annotation = annotation,
      drop_transliteration = drop_transliteration)
  }

# add glosses to the document gloss list -----------------------------------
  single_gl <- unlist(strsplit(glosses_by_word, "[-\\.=:\\)\\(!\\?]"))
  starts_with_punctuation <- single_gl[1] == ""
  single_gl <- lingglosses::add_gloss(single_gl)
  if(starts_with_punctuation){single_gl <- c("", single_gl)}

# get delimiters back ------------------------------------------------------
  delimiters <- unlist(strsplit(glosses,
"[^-:\\.= \\)\\(!\\?\u201E\u201C\u2019\u201D\u00BB\u00AB\u201F]"))
  delimiters <- c(delimiters[delimiters != ""], "")
  glosses <- paste0(single_gl, delimiters, collapse = "")
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
                     grammaticality,
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
          grammaticality = if(i == min(splits_by_line)){grammaticality} else {NULL},
          annotation = if(!is.null(annotation)){
            paste(annotation[splits_by_line == i], collapse = " ")} else {""},
          comment = if(i == max(splits_by_line)){comment} else {""},
          italic_transliteration = FALSE,
          line_length = line_length,
          drop_transliteration = drop_transliteration,
          intext = FALSE,
          write_to_db = FALSE)
      })
    } else {

# combine everything into table --------------------------------------------
      if(!is.null(annotation)){
        annotation <- unlist(strsplit(annotation, " "))
      }

      ann <- if(!is.null(annotation)){annotation} else{NULL}
      trans <- if(!drop_transliteration){transliteration} else{NULL}
      for_matrix <- c(ann, trans, glosses)
      nrow_matrix <- length_glosses + (length(ann) > 0) + (length(trans) > 0)

      result <- matrix(for_matrix, nrow = nrow_matrix, byrow = TRUE)

      if(!is.null(grammaticality)){
        if(nrow_matrix == 2){
          result <- cbind(matrix(c(grammaticality, "")), result)
        } else if(nrow_matrix == 3){
          result <- cbind(matrix(c("", grammaticality, "")), result)
        }
      }

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
