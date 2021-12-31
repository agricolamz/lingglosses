test_that("small_caps test", {
  expect_snapshot(cat(lingglosses:::small_caps("sg")))
})
