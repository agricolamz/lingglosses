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
#' @param transliteration_italic logical that denotes, whether you want to italicize your example.
#'
#' @examples
#' \dontrun{
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'                "fly-NPST-**INF** know-HAB-NEG",
#'                "I cannot fly. (Zilo Andi, East Caucasian)",
#'                comment = "(lit. do not know how to)")
#' }
#'
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
                          transliteration_italic = TRUE){

# check arguments ----------------------------------------------------------
  lapply(names(formals(gloss_example)),
         function(argument){
             if(length(eval(parse(text = argument))) != 1 |
                typeof(eval(parse(text = argument))) != "character"){
               stop(paste0(argument,
                           " argument should be a character vector of length 1"))
             }
           })

  if(length(line_length) != 1 |
     typeof(line_length) != "double"){
    stop(paste0("line_length",
                " argument should be a character vector of length 1"))
  }

# split arguments by spaces ------------------------------------------------
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
  if(length(transliteration) != length(glosses_by_word)){
    stop(paste0("There is a different number of words and glosses in the
                following example: ", paste0(transliteration, collapse = " ")))
  }

  if(length(orthography) > 0 & length(transliteration) != length(orthography)){
    stop(paste0("There is a different number of words in orthography and
                transliteration in the following example: ",
                paste0(transliteration, collapse = " ")))
  }

# add glosses --------------------------------------------------------------
  single_gl <- unlist(strsplit(glosses_by_word, "[-\\.=:\\)\\(]"))
  single_gl <- single_gl[single_gl != ""]
  glosses2add <- gsub("[_\\*]", "", single_gl[single_gl == toupper(single_gl)])
  write.table(x = glosses2add, file = getOption("lingglosses.glosses_list"),
              row.names = FALSE, col.names = FALSE, append = TRUE)

# add small-caps -----------------------------------------------------------
  single_gl <- ifelse(single_gl == toupper(single_gl),
                      lingglosses::small_caps(single_gl),
                      single_gl)
  delimeters <- unlist(strsplit(glosses, "[^-:\\.= \\)\\(]"))
  delimeters <- c(delimeters[delimeters != ""], "")
  glosses <- paste0(single_gl, delimeters, collapse = "")
  glosses <- gsub("<span style=", "<span_style=", glosses)
  glosses <- unlist(strsplit(glosses, " "))
  glosses <- gsub("<span_style=", "<span style=", glosses)

# long line splitting ------------------------------------------------------
  splits_by_line <- as.double(cut(cumsum(nchar(longest)),
                                  breaks = 0:1e5*line_length))

  if(length(unique(splits_by_line)) > 1){
    multi_result <- lapply(unique(splits_by_line), function(i){
      gloss_example(
        paste(transliteration[splits_by_line == i], collapse = " "),
        paste(glosses_by_word[splits_by_line == i], collapse = " "),
    free_translation = if(i == max(splits_by_line)){free_translation} else {""},
        orthography = if(length(orthography) > 0){
            paste(orthography[splits_by_line == i], collapse = " ")},
        comment = if(i == max(splits_by_line)){comment} else {""},
        line_length = line_length)
    })
    cat(unlist(multi_result))
  } else {

# italic of the language line ----------------------------------------------
    if(isTRUE(transliteration_italic)){
      if(knitr::is_latex_output()){
        transliteration <- paste0("\\textit{", transliteration, "}")
      } else {
        transliteration <- paste0("*", transliteration, "*")
      }
    }

# combine everything into table --------------------------------------------
    if(length(orthography) > 0){
      for_matrix <- c(orthography, transliteration, glosses)
      nrow_matrix <- 3
    } else {
      for_matrix <- c(transliteration, glosses)
      nrow_matrix <- 2
    }
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

    return(result)
  }
}
