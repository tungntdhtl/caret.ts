ets_parameters <- function() {
  return(data.frame(parameter = c("model"),
                    class = c("character"),
                    label = c("Model"),
                    stringsAsFactors = FALSE))
}

ets_grid <- function(model = "ZZZ") {
  return(function(x, y, len = NULL, search = "grid") {
    return(data.frame(model = model,
                      stringsAsFactors = FALSE))
  })
}

ets_fit <- function(...) {
  return(function(x, y, wts, param, lev, last, weights, classProbs) {
    # cat("ARIMA\n")
    if (ncol(x) == 0) {
      m <- forecast::ets(y = y, model = param$model, ...)    
    } else {
      stop("Exogenous predictors are not supported for model 'ets'.")
    }
    
    return(m)
  })
}

#' @importFrom stats predict
ets_predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL) {
  if ("ts" %in% class(newdata)) {
    newdata <- zoo::coredata(newdata)
  }
  
  if (is.vector(newdata)) { 
    # modelFit <- forecast::ets(newdata, model = modelFit)
    pred <- forecast::forecast(modelFit, h = length(newdata)) # , xreg = matrix(newdata, ncol = 1)
  } else if (ncol(newdata) == 0) {
    pred <- forecast::forecast(modelFit, h = nrow(newdata))
  } else {
    stop("Exogenous predictors are not supported for model 'ets'.")
  }
  
  return(as.numeric(pred$mean))
}

ets_sort <- function(x) {
  return(x)
}

#' ETS model
#' 
#' Creates an exponential smoothing state space (ETS) model that is then fitted to the 
#' data as a univariate time series.
#' @param model Model type according to \code{\link[forecast]{ets}}. Default is 
#' \code{"ZZZ"} which performs auto-fitting.
#' @param ... Further arguments used when fitting ETS model.
#' @return Model definition that can then be insered into \code{\link[caret]{train}}.
#' @note ETS model does not support exogenous variables.
#' @examples 
#' library(caret)
#' 
#' library(forecast)
#' data(WWWusage) # from package "forecast"
#' 
#' data_train <- WWWusage[1:80]
#' data_test <- WWWusage[81:100]
#' 
#' lm <- train(data_train, method = "lm", trControl = trainDirectFit())
#' summary(lm)
#' RMSE(predict(lm, data_test), data_test)
#' 
#' ets <- train(data_train, method = ets_model(), trControl = trainDirectFit())
#' summary(ets)
#' RMSE(predict(ets, data_test), data_test)
#' @export
ets_model <- function(model = "ZZZ", ...) {
  return(list(label = "ETS",
              type = "Regression",
              library = "forecast",
              loop = NULL,
              prob = NULL, 
              parameters = ets_parameters(),
              grid = ets_grid(model),
              fit = ets_fit(...),
              predict = ets_predict,
              sort = ets_sort))
}


