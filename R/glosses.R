#' Catalog of glosses
#'
#' A dataset contains the list of glosses from the Leipzig Glossing Rules by
#' Comrie, Haspelmath, and Bickel and other glosses automatically gathered from
#' Glossa Journal articles.
#'
#' @format A data frame with 479 rows and 4 variables:
#' \describe{
#'   \item{gloss}{the gloss abbreviation}
#'   \item{definition}{the gloss definition}
#'   \item{source}{the gloss source. Two possible values: Leipzig Glossing Rules or lingglosses (this means parsed from Glossa).}
#'   \item{weight}{glossa weight used for the choice in case of multiple definitions per gloss.}
#' }
#'

"glosses"
