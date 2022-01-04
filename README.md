<!-- README.md is generated from README.Rmd. Please edit that file -->



# lingglosses

[![CRAN version](http://www.r-pkg.org/badges/version/lingglosses)](https://cran.r-project.org/package=lingglosses)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/440443756.svg)](https://zenodo.org/badge/latestdoi/440443756)
[![R build status](https://github.com/agricolamz/lingglosses/workflows/R-CMD-check/badge.svg)](https://github.com/agricolamz/lingglosses/actions)

The main goal of the `lingglosses` R package is to create:

* linguistic glosses for `.html` output of `rmarkdown`;

```r
gloss_example(transliteration = "bur-e-ri c'in-ne-sːu",
              glosses = "fly-NPST-INF know-HAB-NEG", 
              free_translation = "I cannot fly.", 
              comment = "(lit. do not know how to)")
```



* semi-automatic compiled abbreviation list.

```r
make_gloss_list()
```

<span style="font-variant:small-caps;">hab</span> — habitual; <span style="font-variant:small-caps;">inf</span> — infinitive; <span style="font-variant:small-caps;">neg</span> — negation; <span style="font-variant:small-caps;">npst</span> — non-past

For more details see the [html-version of the tutorial](https://agricolamz.githtranliteration ub.io/lingglosses/).

You can also be interested in [scription format](https://github.com/digitallinguistics/scription) and [scription2dlx Java-script library](https://github.com/digitallinguistics/scription2dlx).

## Installation

You can install the development version of lingglosses from [GitHub](https://github.com/) with:


```r
# install.packages("remotes")
remotes::install_github("agricolamz/lingglosses")
```

## How to cite this package


```r
citation("lingglosses")
#> 
#> To cite lingglosses in publications use:
#> 
#>   Moroz, G. (2021) lingglosses: Linguistic glosses and semi-automatic
#>   list of glosses creation. (Version 0.0.2). Zenodo
#>   https://doi.org/10.5281/zenodo.5801712
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {lingglosses: Linguistic glosses and semi-automatic list of glosses creation},
#>     author = {George Moroz},
#>     year = {2021},
#>     doi = {10.5281/zenodo.5801712},
#>   }
```

