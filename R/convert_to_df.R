#' Converts example to the data.frame and adds it to the database
#'
#' Converts example to the data.frame and adds it to the database
#'
#' @author George Moroz <agricolamz@gmail.com>
#'
#' @return dataframe with
#'
#' @export

convert_to_df <- function(transliteration,
                          glosses,
                          free_translation = "",
                          comment = "",
                          annotation = "",
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
  transliteration_by_word <- gsub("[!\\?”“]", " PUNCT ", transliteration_by_word)
  transliteration_by_word <- gsub("\\s{1,}", " ", transliteration_by_word)
  transliteration_by_word <- gsub("^ ", "", transliteration_by_word)
  transliteration_by_word <- gsub(" $", "", transliteration_by_word)
  transliteration_by_word <- unlist(strsplit(transliteration_by_word, " "))

# add PUNCT to glosses -----------------------------------------------------
  glosses_by_word <- unlist(strsplit(glosses, " "))

  punct <- which(transliteration_by_word == "PUNCT")
  punct <- punct - seq_along(punct)
  glosses_by_word[punct] <- paste0(glosses_by_word[punct], " PUNCT")

  dup <- punct[duplicated(punct)]
  glosses_by_word[dup] <- paste0(glosses_by_word[dup], " PUNCT")
  glosses_by_word <- unlist(strsplit(glosses_by_word, " "))

# split translation into gloss chunks --------------------------------------
  names(transliteration_by_word) <- paste0(seq_along(transliteration_by_word),
                                           "w_")
  names(glosses_by_word) <- paste0(seq_along(transliteration_by_word),
                                           "w_")
  single_tr <- unlist(strsplit(transliteration_by_word, "[-=]"))
  single_gl <- unlist(strsplit(glosses_by_word, "[-=]"))

  delimeters <- unlist(strsplit(paste0(glosses_by_word, " "), "[^-= ]"))
  delimeters <- delimeters[-c(which(delimeters == ""))]

  morpheme_id <- gsub("\\d{1,}w_", "", names(single_tr))
  morpheme_id[which(morpheme_id == "")] <- "1"

  emph_gl <- grepl("^\\*\\*.*\\*\\*$", single_gl)
  emph_tr <- grepl("^\\*\\*.*\\*\\*$", single_tr)

  emphasize <- lapply(seq_along(emph_gl), function(i){
    if(emph_gl[i] & emph_tr[i]){
      "both"
    } else if(emph_gl[i]){
      "glosses"
    } else if(emph_tr[i]){
      "transliteration"
    } else {
      ""
    }
  })

  if(drop_transliteration){
    emphasize <- gsub("both", "glosses", emphasize)
  }

  results <- data.frame(sentance_id = counter,
                        word_id = gsub("w_.*", "", names(single_tr)),
                        morpheme_id = morpheme_id,
                        transliteration =   if(drop_transliteration){
                          ""
                          } else {unname(single_tr)},
                        gloss = unname(single_gl),
                        delimeter = delimeters,
                        emphasize = unlist(emphasize),
                        transliteration_orig = if(drop_transliteration){
                          ""
                        } else {transliteration},
                        glosses_orig = glosses,
                        free_translation = free_translation,
                        comment = comment)

  annotation <- if(length(annotation) > 0){
    unlist(strsplit(annotation, " "))
  } else {""}

  if(length(annotation) > 0 & length(transliteration) != length(annotation)){
    stop(paste0("There is a different number of words in annotation and
                transliteration in the following example: ",
                paste0(transliteration, collapse = " ")))
  }

  results <- merge(results,
                   data.frame(word_id = unique(results$word_id),
                              annotation = annotation),
                   by = "word_id")

  results <- results[, c("sentance_id",
                         "word_id",
                         "morpheme_id",
                         "transliteration",
                         "gloss",
                         "delimeter",
                         "emphasize",
                         "transliteration_orig",
                         "glosses_orig",
                         "free_translation",
                         "comment")]
  if(write_to_db){
    write.table(x = results, file = getOption("lingglosses.example_table"),
                row.names = FALSE, col.names = FALSE, append = TRUE,
                fileEncoding = "UTF-8")
  }
  return(results)
}
