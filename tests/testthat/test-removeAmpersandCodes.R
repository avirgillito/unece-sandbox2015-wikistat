source("../../scripts/r/whs_aux.R")

context("Remove ampersand codes correct")

test_that("removeAmpersandCodes converts correctly", {
        expect_equal(removeAmpersandCodes("My this &amp; last year&#39;s resolutions"), "My this & last year's resolutions")
})