# lingglosses 0.0.4

- fix glosses with markdown annotation; #13 

# lingglosses 0.0.3

- rename `orthography` to `annotation` in the `gloss_example()` function.
- add functions for creating an example database: `convert_to_df()` and `get_example_db()`.
- deal with apostroph strange behaviour. #12
- add argument grammaticality to `gloss_example()`. #11
- rename `definition` to `definition_en` in the `glosses_df` dataset.
- fix the punctuation problem. #14

# lingglosses 0.0.2

- change `glosses` dataset to `glosses_df` (to avoid the same name with the argument of `gloss_example()`)
- fix `(`, `)` and `:` bug in glossing line
- add non-breaking space to `make_gloss_list()` output
- add compatibility to the `latex` outputs
- fill glosses not specified by the user with values from `lingglosses::glosses_df`
- add color annotation for glosses without definition or duplicated glosses with the argument `annotate_definitionless`
- add possibility to add in-text examples with additional argument `intext` for the `gloss_example()` function
- add possibility to add stand-alone examples with the `add_gloss()` function
- update `lingglosses::glosses_df` file with glosses from Wikipedia
- make the package work with `bookdown`
- add `lingglosses` rmarkdown template
- add possibility to remove glosses in the `make_gloss_list()` output with the `remove_glosses` argument
- add possibility to escape glossing with curly brackets, e.g. `{I}`
- provide the ability to have multiline lines of glosses in an example for Sign Languages
- provide the ability to have an example without transliteration
