#' Converts example to a data.frame
#'
#' Converts example to a data.frame and adds it to the database of Interlinear-Glossed examples.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param transliteration character vector of the length one for the transliteration line.
#' @param glosses character vector of the length one for the glosses line.
#' @param free_translation character vector of the length one for the free translation line.
#' @param annotation character vector of the length one for the annotation line (above translation).
#' @param comment character vector of the length one for the comment line (under the free translation line).
#' @param drop_transliteration logical variable that denotes, whether user wants to have an example without transliteration.
#' @param write_to_db logical variable that denotes, whether example should be added to the example database.
#' @param counter double, value that denotes example id. By default gathered automatically through hidden variables in the Rmd document.

#' @return dataframe with
#'
#' @export

convert_to_df <- function(transliteration,
                          glosses,
                          free_translation = "",
                          comment = "",
                          annotation = NULL,
                          drop_transliteration = FALSE,
                          write_to_db = TRUE,
                          counter = getOption("lingglosses.example_counter")){

  glosses <- glosses[1] # fake fix for sign languages

  if(drop_transliteration){
    transliteration <- glosses
  }

  transliteration <- gsub("\\s{1,}", " ", transliteration)
  glosses <- gsub("\\s{1,}", " ", glosses)

# add PUNCT to translation -------------------------------------------------
  transliteration_by_word <- unlist(strsplit(transliteration, " "))

  transliteration_by_word <- unlist(lapply(seq_along(transliteration_by_word),
function(i) {
  if(!grepl("^\"!\\[\\]\\(.*?\\)", transliteration_by_word[i])){
    gsub("[\"!\\?\u201E\u201C\u2019\u201D\u00BB\u00AB\u201F\\+]", " PUNCT ",
         transliteration_by_word[i])
    } else {transliteration_by_word[i]}}))

  transliteration_by_word <- gsub("\\s{1,}", " ", transliteration_by_word)
  transliteration_by_word <- gsub("^ ", "", transliteration_by_word)
  transliteration_by_word <- gsub(" $", "", transliteration_by_word)
  transliteration_by_word <- unlist(strsplit(transliteration_by_word, " "))

# add PUNCT to glosses -----------------------------------------------------
  glosses_by_word <- transliteration_by_word
  glosses_by_word[which(glosses_by_word != "PUNCT")] <-
                                                  unlist(strsplit(glosses, " "))

# split translation into gloss chunks --------------------------------------
  names(transliteration_by_word) <- paste0(seq_along(transliteration_by_word),
                                           "w_")
  names(glosses_by_word) <- paste0(seq_along(transliteration_by_word),
                                           "w_")

  single_tr <- gsub("[-=\\~\\+]$", "", transliteration_by_word)
  single_tr <- gsub("^[-=\\~\\+]", "", single_tr)
  single_tr <- unlist(strsplit(single_tr, "[-=\\~]"))

  single_gl <- gsub("[-=\\~\\+]$", "", glosses_by_word)
  single_gl <- gsub("^[-=\\~\\+]", "", single_gl)
  single_gl <- unlist(strsplit(single_gl, "[-=\\~\\+]"))

  single_tr <- single_tr[single_tr != ""]
  single_gl <- single_gl[single_gl != ""]

  delimiters <- unlist(strsplit(paste0(glosses_by_word, " "), "[^-= \\~\\+]"))
  delimiters <- delimiters[-c(which(delimiters == ""))]

  morpheme_id <- gsub("\\d{1,}w_", "", names(single_tr))
  morpheme_id[which(morpheme_id == "")] <- "1"

  results <- data.frame(example_id = counter,
                        word_id = gsub("w_.*", "", names(single_tr)),
                        morpheme_id = morpheme_id,
                        transliteration =   if(drop_transliteration){
                          ""
                          } else {unname(single_tr)},
                        gloss = unname(single_gl),
                        delimiter = delimiters,
                        transliteration_orig = if(drop_transliteration){
                          ""
                        } else {transliteration},
                        glosses_orig = glosses,
                        free_translation = free_translation,
                        comment = comment)

  if(!is.null(annotation)){
    annotation <- unlist(strsplit(annotation, " "))
    if(!is.null(annotation) > 0 &
       length(transliteration_by_word) != length(annotation)){
      stop(paste0("There is a different number of words in annotation and ",
                  "transliteration in the following example: ",
                  paste0(transliteration_by_word, collapse = " ")))
    }
  } else {
    annotation <- ""
    }

  results <- merge(results,
                   data.frame(word_id = unique(results$word_id),
                              annotation = ifelse(is.null(annotation),
                                                  "",
                                                  annotation)),
                   by = "word_id")

  results <- results[, c("example_id",
                         "word_id",
                         "morpheme_id",
                         "transliteration",
                         "gloss",
                         "delimiter",
                         "transliteration_orig",
                         "glosses_orig",
                         "free_translation",
                         "comment")]

  results$example_id <- as.double(results$example_id)
  results$word_id <- as.double(results$word_id)
  results$morpheme_id <- as.double(results$morpheme_id)
  results <- results[order(results$word_id, results$morpheme_id),]
  row.names(results) <- seq_along(results$example_id)

  if(write_to_db){
    utils::write.table(x = results,
                       file = getOption("lingglosses.example_table"),
                       row.names = TRUE, col.names = FALSE, append = TRUE,
                       fileEncoding = "UTF-8")
  }
  return(results)
}
