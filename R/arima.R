arima_parameters <- function() {
  return(data.frame(parameter = c("p", "d", "q", "intercept"),
                    class = c("integer", "integer", "integer", "logical"),
                    label = c("Order AR", "Degree differencing", "Order MA", "Intercept"),
                    stringsAsFactors = FALSE))
}

arima_grid <- function(p = 5, d = 5, q = 5, intercept = TRUE) {
  return(function(x, y, len = NULL, search = "grid") {
    out <- data.frame(p = p, d = d, q = q, intercept = intercept,
                      stringsAsFactors = FALSE)
    return(out)
  })
}

arima_fit <- function(...) {
  return(function(x, y, wts, param, lev, last, weights, classProbs) {
    if (is.null(y)) {
      y <- x
    }
    
    if (ncol(x) == 0) {
      m <- forecast::Arima(y = y, order = c(param$p, param$d, param$q), ...)    
    } else {
      m <- forecast::Arima(y = y, xreg = x, order = c(param$p, param$d, param$q), ...)
    }
  
    return(m)
  })
}

auto_arima_fit <- function(...) {
  return(function(x, y, wts, param, lev, last, weights, classProbs) {
    # cat("ARIMA\n")
    if (ncol(x) == 0) {
      m <- forecast::auto.arima(y = y, max.p = param$p, max.d = param$d, max.q = param$q, start.p = 0, start.q = 0, seasonal = FALSE, ...)    
    } else {
      m <- forecast::auto.arima(y = y, xreg = x, max.p = param$p, max.d = param$d, max.q = param$q, start.p = 0, start.q = 0, seasonal = FALSE, ...)
    }
  
    return(m)
  })
}

#' @importFrom stats predict
arima_predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL) {
  if ("ts" %in% class(newdata)) {
    newdata <- zoo::coredata(newdata)
  }
  
  if (is.vector(newdata)) { 
    modelFit <- forecast::Arima(newdata, model = modelFit)
    pred <- forecast::forecast(modelFit, h = length(newdata)) # , xreg = matrix(newdata, ncol = 1)
  } else if (ncol(newdata) == 0) {
    pred <- forecast::forecast(modelFit, h = nrow(newdata))
  } else {
    pred <- forecast::forecast(modelFit, xreg = newdata)
  }
  
  return(as.numeric(pred$mean))
}

arima_sort <- function(x) {
  return(x)
}

arima_varimp <- function(object, ...) {
  values <- abs(object$coef[object$xNames])

  out <- data.frame(values)
  colnames(out) <- "Overall"
  
  if (!is.null(names(values))) {
    rownames(out) <- names(values)
  }
  
  return(out) 
}

#' ARIMA model with fixed order
#' 
#' Creates an ARIMA model that is then fitted to the data as a univariate time series.
#' If further variables are specified in the model, it also includess exogenous variables. 
#' The order (p, d, q) is fixed as specified. 
#' @param p Order of auto-regressive (AR) terms.
#' @param d Degree of differencing.
#' @param q Order of moving-average (MA) terms.
#' @param intercept Boolean value whether to include an intercept term (default: 
#' \code{TRUE}).
#' @param ... Further arguments used when fitting ARIMA model.
#' @return Model definition that can then be insered into \code{\link[caret]{train}}.
#' @note If one desires an auto-tuning of the best order, then one needs to switch to 
#' \code{\link{auto_arima_model}}.
#' @details Variable importance metrics return the absolute value of the coefficients
#' for the exogenous variables (if any).
#' @examples 
#' library(caret)
#' 
#' # without exogenous variables
#' 
#' library(forecast)
#' data(WWWusage) # from package "forecast"
#' 
#' lm <- train(WWWusage, method = "lm", trControl = trainDirectFit())
#' summary(lm)
#' 
#' arima <- train(WWWusage, method = arima_model(1, 1, 1), trControl = trainDirectFit())
#' summary(arima)
#' 
#' # with exogenous variables
#' 
#' library(vars)
#' data(Canada)
#' 
#' arima <- train(x = Canada[, -2], y = Canada[, 2], 
#'                method = arima_model(2, 0, 0), trControl = trainDirectFit())
#' 
#' summary(arima)
#' arimaorder(arima$finalModel) # order of best model
#' 
#' predict(arima, Canada[, -2]) # in-sample predictions
#' RMSE(predict(arima, Canada[, -2]), Canada[, 2]) # in-sample RMSE
#' 
#' absCoef <- varImp(arima, scale = FALSE) # variable importance (= absolute value of coefficient)
#' absCoef
#' 
#' plot(absCoef)
#' @export
arima_model <- function(p, d, q, intercept = TRUE, ...) {
  return(list(label = "ARIMA",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = arima_parameters(),
              grid = arima_grid(p, d, q, intercept),
              fit = arima_fit(...),
              predict = arima_predict,
              sort = arima_sort,
              varImp = arima_varimp))
}

#' ARIMA model with tuned order
#' 
#' Creates an ARIMA model that is then fitted to the data as a univariate time series.
#' If further variables are specified in the model, it also includess exogenous variables. 
#' The order (p, d, q) is tuned by choosing the one with best fit. 
#' @param p Maximum order of auto-regressive (AR) terms that is tested to find the best 
#' fit (default: 5).
#' @param d Maximum degree of differencing that is tested to find the best fit (default: 
#' 2).
#' @param q Maximum order of moving-average (MA) term that is tested to find the best 
#' fit (default: 5).
#' @param intercept Boolean value whether to include an intercept term (default: 
#' \code{TRUE}).
#' @return Model definition that can then be insered into \code{\link[caret]{train}}.
#' @param ... Further arguments used when fitting ARIMA model.
#' @note If one desires an ARIMA model of fixed, pre-defined order, then one needs to 
#' switch to \code{\link{auto_arima_model}}.
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
#' arima <- train(y ~ 1, data = df, method = auto_arima_model(), trControl = trainDirectFit())
#' summary(arima)
#' RMSE(predict(arima, df), df)
#' 
#' # with exogenous variables
#' 
#' library(vars)
#' data(Canada)
#' 
#' arima <- train(x = Canada[, -2], y = Canada[, 2], 
#'                method = auto_arima_model(), trControl = trainDirectFit())
#' 
#' summary(arima)
#' arimaorder(arima$finalModel) # order of best model
#' 
#' predict(arima, Canada[, -2]) # in-sample predictions
#' RMSE(predict(arima, Canada[, -2]), Canada[, 2]) # in-sample RMSE
#' 
#' absCoef <- varImp(arima, scale = FALSE) # variable importance (= absolute value of coefficient)
#' absCoef
#' 
#' plot(absCoef)
#' @export
auto_arima_model <- function(p = 5, d = 2, q = 5, intercept = TRUE, ...) {
  return(list(label = "ARIMA",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = arima_parameters(),
              grid = arima_grid(p, d, q, intercept),
              fit = auto_arima_fit(...),
              predict = arima_predict,
              sort = arima_sort,
              varImp = arima_varimp))
}


