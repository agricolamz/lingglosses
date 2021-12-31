test_that("color_annotate test", {
  expect_snapshot(cat(lingglosses:::color_annotate("sg")))
})
