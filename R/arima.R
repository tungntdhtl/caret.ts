arima_grid <- function(p = 5, d = 5, q = 5) {
  return(function(x, y, len = NULL, search = "grid") {
    out <- data.frame(p = p, d = d, q = q, intercept = TRUE)
    return(out)
  })
}

arima_fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  # cat("ARIMA\n")
  if (ncol(x) == 0) {
    m <- forecast::Arima(x = y)    
  } else {
    m <- forecast::Arima(x = y, xreg = x)
  }
  
  return(m)
}

auto_arima_fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  # cat("ARIMA\n")
  if (ncol(x) == 0) {
    m <- forecast::auto.arima(x = y)    
  } else {
    m <- forecast::auto.arima(x = y, xreg = x)
  }
  
  return(m)
}

#' @importFrom stats predict
arima_predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL) {
  pred <- predict(modelFit, n.ahead = 1, newxreg = newdata)
  
  return(as.numeric(pred$pred))
}

arima_sort <- function(x) {
  return(x)
}

#' ARIMA model
#' @examples 
#' @export
arima_model <- function(p, d, q) {
  return(list(label = "ARIMA",
                    type = "Regression",
                    library = "forecast",
                    loop = NULL,
                    prob = NULL, 
                    parameters = data.frame(parameter = c("p", "d", "q", "intercept"),
                                            class = c("integer", "integer", "integer", "logical"),
                                            label = c("Order AR", "Degree differencing", "Order MA", "Intercept")),
                    grid = arima_grid(p, d, q),
                    fit = arima_fit,
                    predict = arima_predict,
                    sort = arima_sort))
}

#' ARIMA model
#' 
#' Creates an AIRMA model that is then fitted to the data as a univariate time series.
#' If further variables are specified in the model, it also includess exogenous variables. 
#' The order (p, d, q) is fixed as specified. If one desires an auto-tuning of the best order, then
#' one needs to switch to \code{\link{auto_arima_model}}.
#' @param p Order of auto-regressive (AR) terms.
#' @param d Degree of differencing
#' @param q Order of moving-average (MA) terms.
#' @examples 
#' data(WWWusage) # from package "forecast"
#' df <- data.frame(y = as.numeric(WWWusage))
#' 
#' library(caret)
#' 
#' # without exogenous variables
#' 
#' lm <- train(y ~ 1, data = df, method = "lm", trControl = trainDirectFit())
#' summary(lm)
#' 
#' arima <- train(y ~ 1, data = df, method = arima_model(1, 1, 1), trControl = trainDirectFit())
#' summary(arima)
#' @export
arima_model <- function(p, d, q) {
  return(list(label = "ARIMA",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = data.frame(parameter = c("p", "d", "q", "intercept"),
                                      class = c("integer", "integer", "integer", "logical"),
                                      label = c("Order AR", "Degree differencing", "Order MA", "Intercept")),
              grid = arima_grid(p, d, q),
              fit = arima_fit,
              predict = arima_predict,
              sort = arima_sort))
}

#' Auto ARIMA model
#' @examples 
#' @export
auto_arima_model <- function(p, d, q) {
  return(list(label = "ARIMA",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = data.frame(parameter = c("p", "d", "q", "intercept"),
                                      class = c("integer", "integer", "integer", "logical"),
                                      label = c("Order AR", "Degree differencing", "Order MA", "Intercept")),
              grid = arima_grid(p, d, q),
              fit = auto_arima_fit,
              predict = arima_predict,
              sort = arima_sort))
}


