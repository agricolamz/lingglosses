test_that("add_gloss(), gloss_example(), make_gloss_list() test", {
  tmp <- tempdir()
  files <- list.files(
    system.file("rmarkdown/templates/lingglosses-document/skeleton/",
                package = "lingglosses", mustWork = TRUE), full.names = TRUE)
  file.copy(files, tmp)
  rmarkdown::render(paste0(tmp, "/skeleton.Rmd"), quiet = TRUE)
  expect_true(file.exists(paste0(tmp, "/skeleton.html")))
})
