# `checkdown`

G. Moroz

## Installation

Get the development version from GitHub:

```{r, eval=FALSE}
install.packages("remotes")
remotes::install_github("agricolamz/lingglosses")
```

## 1. Demo (it is better to look in the [html-version](https://agricolamz.github.io/lingglosses/))

The main goal of the `lingglosses` package is to provide an option for creating:

* linguistic glosses for `.html` output of `rmarkdown`;
```
gloss_example("bur-e-**ri** c'in-ne-s:u",
              "fly-NPST-**INF** know-HAB-_NEG_",
              "I cannot fly.",
              "(lit. do not know how to)")
```

* semi-automatic compiled abbreviation list.
```
make_gloss_list()
```

That will produce the following:

```
HAB — habitual; INF — infinitive; NEG — negation; NPST — non-past
```
