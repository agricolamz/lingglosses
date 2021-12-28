# lingglosses 0.0.2

- change `glosses` dataset to `glosses_df` (to avoid the same name with the `gloss_example()`'s argument)
- fix `(`, `)` and `:` bug in glossing line
- add non-breaking space to `make_gloss_list()` output
- add compatibility to the `latex` outputs
- fill non-specified by user glosses with values from `lingglosses::glosses`
- add color annotation for glosses without definition or duplicated glosses with the argument `annotate_definitionless`
- add possibility to add in-text examples with additional argument `intext` for the `gloss_example()` function
- update `lingglosses::glosses` file with glosses from Wikipedia
