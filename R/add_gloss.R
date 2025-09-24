#' Gloss an example
#'
#' Adds glosses to the glosses list and adds small capitals to glosses. Escapes strings that begins and ends with curly brackets.
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @param glosses character vector with glosses in upper case.
#'
#' @return vector of small capitalized glosses (if string is in the upper case) and not glosses (if string is not in the upper case)
#'
#' @examples
#' add_gloss(c("ABS", "ERG"))
#'
#' @importFrom utils write.table
#'
#' @export

add_gloss <- function(glosses){

# remove empty values ------------------------------------------------------
  glosses <- glosses[glosses != ""]

# remove formatting --------------------------------------------------------
  glosses2add <- gsub("[_\\*]", "", glosses[glosses == toupper(glosses)])
  without_escape <- which(!(grepl("^\\{", glosses2add) &
                              grepl("\\}$", glosses2add)|
                              grepl("[-\\.=:\\)\\(!\\?<>\\~\\+\uFF3D\uFF3B]", glosses2add)))
  glosses2add <- glosses2add[without_escape]

# add glosses to the list --------------------------------------------------
  if(length(glosses2add) > 0){
    utils::write.table(x = glosses2add,
                       file = getOption("lingglosses.glosses_list"),
                       row.names = FALSE, col.names = FALSE, append = TRUE,
                       fileEncoding = "UTF-8")
  }
# add small caps -----------------------------------------------------------
  glosses <- ifelse(glosses == toupper(glosses) &
                      !(grepl("^\\{", glosses) &
                          grepl("\\}$", glosses) |
                          grepl("[-\\.=:\\)\\(!\\?<>\\~\\+\uFF3D\uFF3B]", glosses)),
                    small_caps(glosses),
                    glosses)
  glosses <- gsub("[\\}\\{]", "", glosses)
  return(glosses)
}
