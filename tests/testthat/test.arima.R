library(caret.ts)
context("ARIMA models")

library(caret)
library(forecast)

test_that("ARIMA models is created correctly", {
  m <- arima_model(1, 2, 3)
  expect_match(m$label, "ARIMA")
  expect_equal(dim(m$parameters), c(4, 3))
  expect_equal(colnames(m$parameters), c("parameter", "class", "label"))
  expect_equal(m$parameters$parameter, c("p", "d", "q", "intercept"))
  expect_equal(m$parameters$class, c("integer", "integer", "integer", "logical"))
  
  m <- auto_arima_model(1, 2, 3)
  expect_match(m$label, "ARIMA")
  expect_equal(dim(m$parameters), c(4, 3))
  expect_equal(colnames(m$parameters), c("parameter", "class", "label"))
  expect_equal(m$parameters$parameter, c("p", "d", "q", "intercept"))
  expect_equal(m$parameters$class, c("integer", "integer", "integer", "logical"))  
  
  data(WWWusage) # from package "forecast"
  df <- data.frame(y = as.numeric(WWWusage))
  
  arima <- train(y ~ 1, data = df, method = arima_model(1, 1, 1), trControl = trainDirectFit())
  expect_equal(arimaorder(arima$finalModel), c(1, 1, 1))
  
  arima <- train(y ~ 1, data = df, method = auto_arima_model(3, 2, 3), trControl = trainDirectFit())
  expect_equal(arimaorder(arima$finalModel), c(1, 1, 1))
})