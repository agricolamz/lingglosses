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
#' gloss_example("bur-e-**ri** c'in-ne-s:u",
#'                "fly-NPST-**INF** know-HAB-NEG",
#'                "I cannot fly. (Zilo Andi, East Caucasian)",
#'                comment = "(lit. do not know how to)")
#'
#' @return no output
#' @importFrom rmarkdown metadata
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
  glosses <- unlist(strsplit(glosses, "[-\\.=]"))
  glosses2add <- gsub("[_\\*]", "", glosses[glosses == toupper(glosses)])
  assign(.get_variable_name(),
         append(eval(parse(text = .get_variable_name())), glosses2add),
         envir = .GlobalEnv)
}
