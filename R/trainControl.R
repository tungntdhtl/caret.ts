#' Training with direct fit only
#' 
#' This function is an alternative training function with performs a direct fit only,
#' i.e. it avoids any kind of cross-validation or any form of repeated executions. It
#' is thus beneficial to use this training function when working with objects that
#' solely require a direct fit, such as a least squares, ARMA or ARIMA. It thereby
#' considerably reduces runtime compare to the default initialization of 
#' \code{\link[caret]{trainControl}}.
#' @param ... Optional parameters passed on to \code{\link[caret]{trainControl}}.
#' @return An object that controls the training inside \code{\link[caret]{train}}.
#' @examples 
#' library(forecast)
#' 
#' data(WWWusage) # from package "forecast"
#' df <- data.frame(y = as.numeric(WWWusage))
#' 
#' library(caret)
#' 
#' lm <- train(y ~ 1, data = df, method = "lm", trControl = trainDirectFit())
#' summary(lm)
#' 
#' arima <- train(y ~ 1, data = df, method = arima_model, trControl = trainDirectFit())
#' summary(arima)
#' @export
trainDirectFit <- function(...) {
  return(caret::trainControl(method = "none", repeats = 1, ...))
}

