context("Publish API")



test_that("packDependencies handles recursive packaging", {

  assign("add", function(x, y) x + y,
         envir = .GlobalEnv
  )

  results <- packDependencies("add")
  expect_equal(nchar(results[[1]]), 32)
  expect_equal(results[[2]], "")
})



test_that("publishPreprocess", {
  expect_equivalent(
    publishPreprocess(list(x="int", y="string", z="float")),
    list(x=list("type"="integer", "format"="int32"),
         y=list("type"="string", "format"="string"),
         z=list("type"="number", "format"="float")))
  expect_error(publishPreprocess(list("x"="dataframe")))
})



#  # Train the model
#  model <- naiveBayes(as.factor(Species) ~., dataset)
#})


test_that("publishWebService handles bad input schemas correctly", {
  auth_file <- "mlstudio_auth_info.RData"
  ## check for RData file:
  if(!file.exists(auth_file)){
    skip("skipping - no authorization info available.")
  }  
  load(auth_file)
  
  add <- function (x, y) {
    print("This will add x and y")
    return(x + y)
  }
  

  expect_error(publishWebService(functionName = "add", 
                                 serviceName  = "addTest", 
                                 inputSchema  = list(),
                                 outputSchema = list(), 
                                 wkID         = test_workspace_id,
                                 authToken    = test_primary_auth_token), 
               "Input schema does not contain the proper input. You provided 0 inputs and 2 were expected")
  expect_error(publishWebService(functionName = "add", 
                                 serviceName  = "addTest", 
                                 inputSchema  = list("x"="foo", "y"="bar"), 
                                 outputSchema = list("z"="int"), 
                                 wkID         = test_workspace_id,
                                 authToken    = test_primary_auth_token), 
               "data type \"foo\" not supported")
})


test_that("publishWebService handles various errors correctly", {
  auth_file <- "mlstudio_auth_info.RData"
  ## check for RData file:
  if(!file.exists(auth_file)){
    skip("skipping - no authorization info available.")
  }  
  load(auth_file)
  
  add <- function (x, y) {
    print("This will add x and y")
    return(x + y)
  }

  expect_error(publishWebService(
    functionName = "add", 
    serviceName  = "addtest", 
    inputSchema  = list("x"="float", "y"="float"), 
    outputSchema = list("z"="float"), 
    wkID         = "foo", 
    authToken    = "bar"), 
    "Error : Bad Request\r\n\n"
  )
})


test_that("publishWebService returns a working web service", {
  skip_on_cran()
  auth_file <- "mlstudio_auth_info.RData"
  ## check for RData file:
  if(!file.exists(auth_file)){
    skip("skipping publish 2 - no authorization info available.")
  }
  
  load(auth_file)
  
  ## generate the  model: just use iris, because it's in base
  #assign(x = "model",
  #       value = lm(Petal.Length ~ Sepal.Length + Petal.Width, data = iris, subset = Species != "setosa"),
  #       envir = .GlobalEnv)
  # model <- lm(Petal.Length ~ Sepal.Length + Petal.Width, data = iris, subset = Species != "setosa")

  ## create scoring function:
  
  assign(x = "add",
         value = function (x, y) {x + y},
         envir = .GlobalEnv
  )
  
  #MSFTpredict_test <- function(x, y) {
  ##  return(predict(object  = model, 
  #                 newdata = data.frame(Sepal.Length = sepalLength, Petal.Width = petalWidth))
  #         )
  #}
  ## publishWebService doesn't like testthat envs
  # assign(x = "MSFTpredict_test",
  #       value = MSFTpredict_test,
  #       envir = .GlobalEnv)
  
 ## generate the web service
 msftWebService <- publishWebService(functionName = "add", 
                                     serviceName  = "addtest", 
                                     inputSchema  = list(x = "float", x = "float"), 
                                     outputSchema = list(z = "float"), 
                                     wkID         = test_workspace_id,
                                     authToken    = test_primary_auth_token)
 ## get the endpoint:
 msftEndpoints <- msftWebService[[2]]
 ## test consumption:
 new_scores.df <- data.frame(
   close = c(25, 30),
   volume = c(300,100)
  )
 response <- consumeDataframe(apiKey     = msftEndpoints[[1]]["PrimaryKey"], 
                              requestUrl = msftEndpoints[[1]]$ApiLocation, 
                              scoreDataFrame = new_scores.df
                              )

 expect_equal(as.numeric(response[1,1]), 1)
 expect_equal(as.numeric(response[2,1]), 1)
 
 ## would be nice if I could delete a webService...
})



