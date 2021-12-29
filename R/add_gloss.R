#' Gloss an example
#'
#' Adds glosses to the glosses list and adds small capitals to glosses.
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @param gloss character vector with glosses in upper case.
#'
#' @examples
#' add_gloss(c("ABS", "ERG"))
#'
#' @export

add_gloss <- function(glosses){

# remove empty values ------------------------------------------------------
  glosses <- glosses[glosses != ""]

# remove formatting --------------------------------------------------------
  glosses2add <- gsub("[_\\*]", "", glosses[glosses == toupper(glosses)])

# add glosses to the list --------------------------------------------------
  write.table(x = glosses2add, file = getOption("lingglosses.glosses_list"),
              row.names = FALSE, col.names = FALSE, append = TRUE,
              fileEncoding = "UTF-8")

# add small caps -----------------------------------------------------------
  glosses <- ifelse(glosses == toupper(glosses),
                    lingglosses:::small_caps(glosses),
                    glosses)
  return(glosses)
}
