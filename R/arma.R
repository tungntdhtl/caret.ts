arma_parameters <- function() {
  return(data.frame(parameter = c("p", "q", "intercept"),
                    class = c("integer", "integer", "logical"),
                    label = c("Order AR", "Order MA", "Intercept"),
                    stringsAsFactors = FALSE))
}

arma_grid <- function(p = 5, q = 5, intercept = TRUE) {
  return(function(x, y, len = NULL, search = "grid") {
    out <- data.frame(p = p, q = q, intercept = intercept,
                      stringsAsFactors = FALSE)
    return(out)
  })
}

arma_fit <- function(...) {
  return(function(x, y, wts, param, lev, last, weights, classProbs) {
    if (ncol(x) == 0) {
      m <- forecast::Arima(y = y, order = c(param$p, 0, param$q), ...)    
    } else {
      m <- forecast::Arima(y = y, xreg = x, order = c(param$p, 0, param$q), ...)
    }
    
    return(m)
  })
}

auto_arma_fit <- function(...) {
  return(function(x, y, wts, param, lev, last, weights, classProbs) {
    if (ncol(x) == 0) {
      m <- forecast::auto.arima(y = y, max.p = param$p, max.d = 0, max.q = param$q, start.p = 0, start.q = 0, seasonal = FALSE, ...)    
    } else {
      m <- forecast::auto.arima(y = y, xreg = x, max.p = param$p, max.d = 0, max.q = param$q, start.p = 0, start.q = 0, seasonal = FALSE, ...)
    }
    
    return(m)
  })
}

#' ARMA model with fixed order
#' 
#' Creates an ARMA model that is then fitted to the data as a univariate time series.
#' If further variables are specified in the model, it also includess exogenous variables. 
#' The order (p,q) is fixed as specified. 
#' @param p Order of auto-regressive (AR) terms.
#' @param q Order of moving-average (MA) terms.
#' @param intercept Boolean value whether to include an intercept term (default: 
#' \code{TRUE}).
#' @param ... Further arguments used when fitting ARMA model.
#' @return Model definition that can then be insered into \code{\link[caret]{train}}.
#' @note If one desires an auto-tuning of the best order, then one needs to switch to 
#' \code{\link{auto_arma_model}}.
#' @details Variable importance metrics return the absolute value of the coefficients
#' for the exogenous variables (if any).
#' @examples 
#' library(caret)
#' 
#' # without exogenous variables
#' 
#' library(forecast)
#' data(WWWusage) # from package "forecast"
#' df <- data.frame(y = as.numeric(WWWusage))
#' 
#' lm <- train(y ~ 1, data = df, method = "lm", trControl = trainDirectFit())
#' summary(lm)
#' 
#' arma <- train(y ~ 1, data = df, method = arma_model(1, 1), trControl = trainDirectFit())
#' summary(arma)
#' 
#' predict(arma, df)
#' RMSE(predict(arma, df), df)
#' 
#' # with exogenous variables
#' 
#' library(vars)
#' data(Canada)
#' 
#' arma <- train(x = Canada[, -2], y = Canada[, 2], 
#'                method = arma_model(2, 0), trControl = trainDirectFit())
#' 
#' summary(arma)
#' arimaorder(arma$finalModel) # order of best model
#' 
#' predict(arma, Canada[, -2]) # in-sample predictions
#' RMSE(predict(arma, Canada[, -2]), Canada[, 2]) # in-sample RMSE
#' 
#' absCoef <- varImp(arma, scale = FALSE) # variable importance (= absolute value of coefficient)
#' absCoef
#' 
#' plot(absCoef)
#' @export
arma_model <- function(p, q, intercept = TRUE, ...) {
  return(list(label = "ARMA",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = arma_parameters(),
              grid = arma_grid(p, q, intercept),
              fit = arma_fit(...),
              predict = arima_predict,
              sort = arima_sort,
              varImp = arima_varimp))
}

#' ARMA model with tuned order
#' 
#' Creates an ARMA model that is then fitted to the data as a univariate time series.
#' If further variables are specified in the model, it also includess exogenous variables. 
#' The order (p, q) is tuned by choosing the one with best fit. 
#' @param p Maximum order of auto-regressive (AR) terms that is tested to find the best 
#' fit (default: 5).
#' @param q Maximum order of moving-average (MA) term that is tested to find the best 
#' fit (default: 5).
#' @param intercept Boolean value whether to include an intercept term (default: 
#' \code{TRUE}).
#' @return Model definition that can then be insered into \code{\link[caret]{train}}.
#' @param ... Further arguments used when fitting ARMA model.
#' @note If one desires an ARMA model of fixed, pre-defined order, then one needs to 
#' switch to \code{\link{auto_arma_model}}.
#' @details Variable importance metrics return the absolute value of the coefficients
#' for the exogenous variables (if any).
#' @examples 
#' library(caret)
#' 
#' # without exogenous variables
#' 
#' library(forecast)
#' data(WWWusage) # from package "forecast"
#' df <- data.frame(y = as.numeric(WWWusage))
#' 
#' lm <- train(y ~ 1, data = df, method = "lm", trControl = trainDirectFit())
#' summary(lm)
#' RMSE(predict(lm, df), df)
#' 
#' arma <- train(y ~ 1, data = df, method = auto_arma_model(), trControl = trainDirectFit())
#' summary(arma)
#' RMSE(predict(arma, df), df)
#' 
#' # with exogenous variables
#' 
#' library(vars)
#' data(Canada)
#' 
#' arma <- train(x = Canada[, -2], y = Canada[, 2], 
#'               method = auto_arma_model(), trControl = trainDirectFit())
#' 
#' summary(arma)
#' arimaorder(arma$finalModel) # order of best model
#' 
#' predict(arma, Canada[, -2]) # in-sample predictions
#' RMSE(predict(arma, Canada[, -2]), Canada[, 2]) # in-sample RMSE
#' 
#' absCoef <- varImp(arma, scale = FALSE) # variable importance (= absolute value of coefficient)
#' absCoef
#' 
#' plot(absCoef)
#' @export
auto_arma_model <- function(p = 5, q = 5, intercept = TRUE, ...) {
  return(list(label = "ARMA",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = arma_parameters(),
              grid = arma_grid(p, q, intercept),
              fit = auto_arma_fit(...),
              predict = arima_predict,
              sort = arima_sort,
              varImp = arima_varimp))
}


