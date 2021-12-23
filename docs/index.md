---
title: "Introduction to `lingglosses`"
author: "G. Moroz, [NRU HSE Linguistic Convergence Laboratory](https://ilcl.hse.ru/en/)"
date: "23-12-2021"
output: 
  html_document:
    toc: true
    toc_position: right
    toc_depth: 2
    toc_float: yes
    number_sections: true
    df_print: paged
    keep_md: true
bibliography: bibliography.bib
---


# Introduction

Abbreviation list is obligatory part of linguistic articles that nobody reads. This lists contains definitions of abbreviations used in the article (e. g. corpora names or sign language names), but also a list of linguistic glosses --- abbreviations used in linguistic interlinear examples. There is a standardized list of glossing rules [@comrie08] which ends with a list of 84 standard abbreviations. Much bigger list is present on the [Wikipedia page](https://en.wikipedia.org/wiki/List_of_glossing_abbreviations). However researchers can deviate from this list and provide their own abbreviations.

The worst abbreviation list that I have found in a published article make it clear that there is a room for improvement:

```
NOM = nominative, GEN = nominative, DAT = nominative, ACC = accusative, VOC = accusative, LOC = accusative, INS = accusative, PL = plural, SG = singular
```

Except obvious mistakes in this list there are some more problems that I wanted to emphasize:

* lack of the alphabetic order;
* there is also some abbreviation (SBJV, IMP) in the article that are absent in the abbreviation list.

The main goal of the `lingglosses` package is to provide an option for creating:

* linguistic glosses for `.html` output of `rmarkdown` [@xie18][^latex];
* semi-automatic compiled abbreviation list.

[^latex]: If you want to render `.pdf` version you can either use latex and multiple linguistic packages developed for it (see e. g. `gb4e`, `langsci`, `expex`, `philex`), either you can render `.html` first and convert it to `.pdf` afterwards.

In order to use the package you need to load it with the `library()` call:


```r
library(lingglosses)
```

# Create glossed examples with `gloss_example()`

The main function of the `lingglosses` package is `gloss_example()`. This package has the following arguments:

* `transliteration`;
* `glosses`;
* `free_translation`;
* `comment`;
* `orthography`;
* `line_length`.

Except the last one all arguments are self-exploratory. 


```r
gloss_example(transliteration = "bur-e-**ri** c'in-ne-s:u",
              glosses = "fly-NPST-**INF** know-HAB-*NEG*",
              free_translation = "I cannot fly. (Zilo Andi, East Caucasian)",
              comment = "(lit. do not know how to)")
```

<table class=" lightable-minimal" style='font-family: "Trebuchet MS", verdana, sans-serif; width: auto !important; border-bottom: 0;border-bottom: 0;'>
<tbody>
  <tr>
   <td style="text-align:left;"> *bur-e-**ri*** </td>
   <td style="text-align:left;"> *c'in-ne-s:u* </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fly-<span style="font-variant:small-caps;">npst</span>-<span style="font-variant:small-caps;">**inf**</span> </td>
   <td style="text-align:left;"> know-<span style="font-variant:small-caps;">hab</span>-<span style="font-variant:small-caps;">*neg*</span> </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> (lit. do not know how to)</td></tr></tfoot>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> 'I cannot fly. (Zilo Andi, East Caucasian)'</td></tr></tfoot>
</table>

In this first example you can see that:

* the transliteration line is italic by default;
* users can use standrad markdown syntax (e. g. `**a**` for **bold** and `*a*` for *italic*);
* the free translation line is framed with quotation marks.

Since function arguments' names are optional in R, users can omit writing them as far as they follow the order of the arguments (you can always find the correct order in `?gloss_example`):


```r
gloss_example("bur-e-**ri** c'in-ne-s:u",
              "fly-NPST-**INF** know-HAB-_NEG_",
              "I cannot fly. (Zilo Andi, East Caucasian)",
              "(lit. do not know how to)")
```

<table class=" lightable-minimal" style='font-family: "Trebuchet MS", verdana, sans-serif; width: auto !important; border-bottom: 0;border-bottom: 0;'>
<tbody>
  <tr>
   <td style="text-align:left;"> *bur-e-**ri*** </td>
   <td style="text-align:left;"> *c'in-ne-s:u* </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fly-<span style="font-variant:small-caps;">npst</span>-<span style="font-variant:small-caps;">**inf**</span> </td>
   <td style="text-align:left;"> know-<span style="font-variant:small-caps;">hab</span>-<span style="font-variant:small-caps;">_neg_</span> </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> (lit. do not know how to)</td></tr></tfoot>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> 'I cannot fly. (Zilo Andi, East Caucasian)'</td></tr></tfoot>
</table>

It is possible to number and call your examples using strandard `rmarkdown` tool for generating lists `(@)`:

```
(@) my first example
(@) my second example
(@) my third example
```

renders

(@) my first example
(@) my second example
(@) my third example

In order to reference examples in the text you need to give them some names:

```
(@my_ex) example for the referencing
```
(@my_ex) example for the referencing

With names settled you can reference example (@my_ex) in the text using the following code `(@my_ex)`.

So this kind of example referncing can be used with `lingglosses` examples like in (@lingglosses1) and (@lingglosses2). The only important details are:

* change your code chunk argument to `echo = FALSE` (or specify it for all code chunks with the following comand in the begining of the document `knitr::opts_chunk$set(echo = FALSE")`);
* do not put an empty line between reference line (with `(@...)`) and the code chunk with `linggloses` code.

(@lingglosses1)
<table class=" lightable-minimal" style='font-family: "Trebuchet MS", verdana, sans-serif; width: auto !important; border-bottom: 0;border-bottom: 0;'>
<tbody>
  <tr>
   <td style="text-align:left;"> *bur-e-**ri*** </td>
   <td style="text-align:left;"> *c'in-ne-s:u* </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fly-<span style="font-variant:small-caps;">npst</span>-<span style="font-variant:small-caps;">**inf**</span> </td>
   <td style="text-align:left;"> know-<span style="font-variant:small-caps;">hab</span>-<span style="font-variant:small-caps;">_neg_</span> </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> (lit. do not know how to)</td></tr></tfoot>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> 'I cannot fly. (Zilo Andi, East Caucasian)'</td></tr></tfoot>
</table>

(@lingglosses2) Zilo Andi, East Caucasian
<table class=" lightable-minimal" style='font-family: "Trebuchet MS", verdana, sans-serif; width: auto !important; border-bottom: 0;border-bottom: 0;'>
<tbody>
  <tr>
   <td style="text-align:left;"> *bur-e-**ri*** </td>
   <td style="text-align:left;"> *c'in-ne-s:u* </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fly-<span style="font-variant:small-caps;">npst</span>-<span style="font-variant:small-caps;">**inf**</span> </td>
   <td style="text-align:left;"> know-<span style="font-variant:small-caps;">hab</span>-<span style="font-variant:small-caps;">_neg_</span> </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> (lit. do not know how to)</td></tr></tfoot>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> 'I cannot fly.'</td></tr></tfoot>
</table>


# Create semi-automatic compiled abbreviation list


```r
make_gloss_list()
```

<span style="font-variant:small-caps;">hab</span> — habitual; <span style="font-variant:small-caps;">inf</span> — infinitive; <span style="font-variant:small-caps;">neg</span> — negation; <span style="font-variant:small-caps;">npst</span> — non-past


```r
my_abbreviations <- data.frame(gloss = c("NPST", "HAB", "INF", "NEG"),
                               definition = c("non-past tense", "habitual aspect", "infinitive", "negation marker"))
make_gloss_list(my_abbreviations)
```

<span style="font-variant:small-caps;">hab</span> — habitual aspect; <span style="font-variant:small-caps;">inf</span> — infinitive; <span style="font-variant:small-caps;">neg</span> — negation marker; <span style="font-variant:small-caps;">npst</span> — non-past tense

# References
