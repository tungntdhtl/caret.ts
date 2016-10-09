arima_parameters <- data.frame(parameter = c("p", "d", "q", "intercept"),
                               class = c("integer", "integer", "integer", "logical"),
                               label = c("Order AR", "Degree differencing", "Order MA", "Intercept"))

arima_model <- list(label = "ARIMA",
                    type = "Regression",
                    library = "forecast",
                    loop = NULL,
                    prob = NULL, 
                    parameters = arima_parameters,
                    grid = arima_grid,
                    fit = arima_fit,
                    predict = arima_predict,
                    sort = arima_sort)

str(arima_model)
