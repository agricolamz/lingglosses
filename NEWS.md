# lingglosses 0.0.10

- fix delimiter problems; probably also closes #25

# lingglosses 0.0.9

- add `docx` compatibility

# lingglosses 0.0.8

- add 2PL gloss (thx to @IrinaPolitova)

# lingglosses 0.0.7

- fix by @yihui

# lingglosses 0.0.6

- small fix for CRAN


# lingglosses 0.0.5

- add possibility to have a sole transliteration line; thx to @sverhees #19
- fix plus sign bug (thx to Nastya Panova);
- fix tab bug (thx to Tatiana Philippova and Polina Nasledskova);
- fix multiline `gloss_example()`;
- add `lingglosses.italic_transliteration` option;

# lingglosses 0.0.4

- fix glosses with markdown annotation; #13 
- add possibility to work with infixes and reduplication; #15
- fix glosses from non-standard `definition_source`; #17
- add trick with square brackets; #18, #10
- fix multiline `gloss_example()`; #16
- extended work with punctuation in `gloss_example()`; #9
- add `audio_path` and `audio_label` arguments to `gloss_example()`; #3

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
