# arima_grid <- function(x, y, len = NULL, search = "grid") {
#   if (search == "grid") {
#     out <- expand.grid(p = 0:5, 
#                        d = 0:5, 
#                        q = 0:5, 
#                        intercept = TRUE)
#   } else {
#     out <- data.frame(p = sample(0:5, 1),
#                       d = sample(0:5, 1),
#                       q = sample(0:5, 1),
#                       intercept = TRUE)
#   }
#   
#   return(out)
# }
arima_grid <- function(x, y, len = NULL, search = "grid") {
  out <- data.frame(p = 5, d = 5, q = 5, intercept = TRUE)
  return(out)
}

arima_fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  cat("ARIMA\n")
  if (ncol(x) == 0) {
    m <- auto.arima(x = y)    
  } else {
    m <- auto.arima(x = y, 
               xreg = x)
  }

  return(m)
}

arima_predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL) {
  pred <- predict(modelFit, n.ahead = 1, newxreg = newdata)
  
  return(as.numeric(pred$pred))
}

arima_sort <- function(x) {
  return(x)
}


