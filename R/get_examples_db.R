#' Get database of interlinear examples
#'
#' Reads database of interlinear examples collected through the whole document.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @return a dataframe with all interlinear examples from rmarkdown document.
#' @importFrom utils read.table
#' @export

get_examples_db <- function(){
  gloss_file_name <- getOption("lingglosses.example_table")
  if(file.exists(gloss_file_name) && file.size(gloss_file_name) > 0){
    df <- utils::read.table(gloss_file_name, header = FALSE, encoding = "UTF-8")
    colnames(df) <- c("id",
                      "example_id",
                      "word_id",
                      "morpheme_id",
                      "transliteration",
                      "gloss",
                      "delimeter",
                      "emphasize_start",
                      "emphasize_end",
                      "transliteration_orig",
                      "glosses_orig",
                      "free_translation",
                      "comment")
    df$id <- seq_along(df$id)
  return(df)
    }
}
