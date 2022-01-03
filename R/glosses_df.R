#' Catalog of glosses
#'
#' A dataset contains the list of glosses from the Leipzig Glossing Rules by
#' Comrie, Haspelmath, and Bickel and other glosses automatically gathered from
#' Glossa Journal articles.
#'
#' @format A data frame with 993 rows and 4 variables:
#' \describe{
#'   \item{gloss}{the gloss abbreviation}
#'   \item{definition}{the gloss definition}
#'   \item{source}{the gloss source. Three possible values: Leipzig Glossing Rules, \href{https://en.wikipedia.org/wiki/List_of_glossing_abbreviations}{Wikipedia} or lingglosses (this means parsed from Glossa).}
#'   \item{weight}{glossa weight used for the choice in case of multiple definitions per gloss.}
#' }
#'

"glosses_df"
