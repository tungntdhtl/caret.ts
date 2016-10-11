#' Train function to support time series objects
#' 
#' Extends the \code{\link[caret]{train}} function from the "caret" package to support
#' time series objects. 
#' @param x Object of class \code{\link[stats]{ts}}.
#' @param ... Further arguments passed on to \code{\link[caret]{train}} for training.
#' @return Trained model.
#' @examples 
#' library(forecast)
#' library(caret)
#' 
#' class(WWWusage)
#' str(WWWusage)

#' arima <- train(WWWusage, method = auto_arima_model(), trControl = trainDirectFit())
#' summary(arima)
#' arimaorder(arima$finalModel) # order of best model
#' RMSE(predict(arima, df), df) # in-sample RMSE
#' @export
train.ts <- function(x, ...) {
  df <- data.frame(y = as.numeric(x))
  return(train(y ~ 1, df, ...))
}