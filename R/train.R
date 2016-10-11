#' Train function to support time series objects
#' 
#' Extends the \code{\link[caret]{train}} function from the "caret" package to support
#' time series objects. 
#' @param x Object of class \code{\link[stats]{ts}}.
#' @param ... Further arguments passed on to \code{\link[caret]{train}} for training.
#' @return Trained model.
#' @examples 
#' library(caret)
#' 
#' library(forecast)
#' data(WWWusage)
#' 
#' class(WWWusage)
#' str(WWWusage)
#'
#' arima <- train(WWWusage, method = auto_arima_model(), trControl = trainDirectFit())
#' summary(arima)
#' arimaorder(arima$finalModel) # order of best model
#' RMSE(predict(arima, WWWusage), WWWusage) # in-sample RMSE
#' 
#' library(vars)
#' data(Canada)
#' 
#' class(Canada)
#' str(Canada)
#' 
#' arima <- train(x = Canada[, -2], y = Canada[, 2], 
#'                method = auto_arima_model(), trControl = trainDirectFit())
#' summary(arima)
#' arimaorder(arima$finalModel) # order of best model
#' RMSE(predict(arima, Canada[, -2]), Canada[, 2]) # in-sample RMSE
#' 
#' arima <- train(form = prod ~ ., data = Canada, 
#'                method = auto_arima_model(), trControl = trainDirectFit())
#' summary(arima)
#' arimaorder(arima$finalModel) # order of best model
#' RMSE(predict(arima, Canada), Canada[, "prod"]) # in-sample RMSE
#' @importFrom caret train
#' @export
train.ts <- function(x, ...) {
  x <- zoo::coredata(x)
  
  if ("y" %in% names(list(...)) && class(list(...)[["y"]]) == "ts") {
    inputArgs <- list(...)
    inputArgs[["y"]] <- zoo::coredata(inputArgs[["y"]])
    
    return(do.call(caret::train, c(list(x = x), inputArgs)))
  } else { 
    df <- data.frame(dependent = x)
    return(caret::train(y = x, x = matrix(NA, nrow = length(x), ncol = 0), ...))
  }
}