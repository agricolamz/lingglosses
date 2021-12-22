#' Gloss an example
#'
#' Creates an interlinear glossed example for linguistics.
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @param transliteration blah
#' @param glosses blah
#' @param free_translation blah
#' @param orthography blah
#' @param comment blah
#' @param line_length blah
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
                          orthography = "",
                          comment = "",
                          line_length = 70){

  transliteration <- unlist(strsplit(transliteration, " "))
  glosses <- unlist(strsplit(glosses, " "))

  # check that glosses and transliteration have the same length
  if(length(transliteration) != length(glosses)){
    stop(paste0("There is a different number of words and glosses in the
                following example: ", paste0(transliteration, collapse = " ")))
  }

  # add glosses
  single_gl <- unlist(strsplit(glosses, "[-\\.=]"))
  glosses2add <- gsub("[_\\*]", "", single_gl[single_gl == toupper(single_gl)])
  assign(.get_variable_name(),
         append(eval(parse(text = .get_variable_name())), glosses2add),
         envir = .GlobalEnv)

  # compare language and gloss line by the length
  longest <- if(sum(nchar(transliteration)) > sum(nchar(glosses))){
    transliteration
  } else {
    glosses
  }

  # vector of splits of the glosses by line
  splits_by_line <- as.double(cut(cumsum(nchar(longest)),
                                  breaks = 0:1e5*line_length))

  if(length(unique(splits_by_line)) > 1){
    multi_result <- lapply(unique(splits_by_line), function(i){
      gloss_example(paste0(transliteration[splits_by_line == i]),
                    paste0(glosses[splits_by_line == i]),
                    free_translation = if(i == max(splits_by_line)){free_translation} else {""},
                    line_length = line_length)
    })
    cat(unlist(multi_result))
  } else {
    result <- matrix(c(paste0("*", transliteration, "*"), glosses),
                     nrow = 2, byrow = TRUE)
    result <- kableExtra::kable_minimal(kableExtra::kbl(result),
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
