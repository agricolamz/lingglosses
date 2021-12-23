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
#'
#' @examples
#' \dontrun{
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'                "fly-NPST-**INF** know-HAB-NEG",
#'                "I cannot fly. (Zilo Andi, East Caucasian)",
#'                comment = "(lit. do not know how to)")
#' }
#'
#' @return no output
#' @importFrom rmarkdown metadata
#' @importFrom kableExtra kable_minimal
#' @importFrom kableExtra kbl
#' @importFrom kableExtra footnote
#' @export

gloss_example <- function(transliteration,
                          glosses,
                          free_translation = "",
                          comment = "",
                          orthography = "",
                          line_length = 70){

# prepare vector of splits of the glosses by line --------------------------
  longest <- if(sum(nchar(transliteration)) > sum(nchar(glosses))){
    transliteration
  } else {
    glosses
  }

  splits_by_line <- as.double(cut(cumsum(nchar(longest)),
                                  breaks = 0:1e5*line_length))

  transliteration <- unlist(strsplit(transliteration, " "))
  glosses_by_word <- unlist(strsplit(glosses, " "))

  if(length(orthography) > 0){
    orthography <- unlist(strsplit(orthography, " "))
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
  single_gl <- unlist(strsplit(glosses, "[-\\.= ]"))
  glosses2add <- gsub("[_\\*]", "", single_gl[single_gl == toupper(single_gl)])
  assign(.get_variable_name(),
         append(eval(parse(text = .get_variable_name())), glosses2add),
         envir = .GlobalEnv)

# add small-caps -----------------------------------------------------------
  single_gl <- ifelse(single_gl == toupper(single_gl),
                      paste0('<span style="font-variant:small-caps;">',
                             tolower(single_gl),
                             '</span>'),
                      single_gl)
  delimeters <- unlist(strsplit(glosses, "[^-\\.= ]"))
  delimeters <- c(delimeters[delimeters != ""], "")
  glosses <- paste0(single_gl, delimeters, collapse = "")
  glosses <- gsub("<span style=", "<span_style=", glosses)
  glosses <- unlist(strsplit(glosses, " "))
  glosses <- gsub("<span_style=", "<span style=", glosses)

# long line splitting ------------------------------------------------------
  if(length(unique(splits_by_line)) > 1){
    multi_result <- lapply(unique(splits_by_line), function(i){
      gloss_example(paste0(transliteration[splits_by_line == i]),
                    paste0(glosses[splits_by_line == i]),
                    free_translation = if(i == max(splits_by_line)){free_translation} else {""},
                    orthography = paste0(orthography[splits_by_line == i]),
                    line_length = line_length)
    })
    cat(unlist(multi_result))
  } else {
    if(length(orthography) > 0){
      for_matrix <- c(orthography, paste0("*", transliteration, "*"), glosses)
      nrow_matrix <- 3
    } else {
      for_matrix <- c(paste0("*", transliteration, "*"), glosses)
      nrow_matrix <- 2
    }
    result <- matrix(for_matrix, nrow = nrow_matrix, byrow = TRUE)
    result <- kableExtra::kable_minimal(kableExtra::kbl(result,
                                                        align = "l",
                                                        centering = FALSE,
                                                        escape = FALSE),
                                        position = "left",
                                        full_width = FALSE)
    if(nchar(comment) > 0){
      result <- kableExtra::footnote(kable_input = result,
                                     general = comment,
                                     general_title = "")
    }
    if(nchar(free_translation) > 0){
      result <- kableExtra::footnote(kable_input = result,
                                     general = paste0("'", free_translation, "'"),
                                     general_title = "")
      }
    return(result)
  }
}
