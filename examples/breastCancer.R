## k means clustering for breast cancer dataset##

# You can use the setwd() command to change your working directory. Examples below

# Currently using identification for an account on studio.azureml-int.net
# If you would like to see the web services published, please create an account there
# and substitute in your identification
wsID = "" # Insert workspace ID
wsAuth = "" # Insert workspace authorization token

dataset <- read.csv(file="breastCancer.csv")

# Create clustering function
getCluster <- function (age, mp, tSize, invNodes, nodeCaps, DegMalig, Breast, BreastQuad, Irradiat) {
  # Train model
  fit <- kmeans(rbind(dataset, data.frame("age"=age,"menopause"=mp, "tumor.size"=tSize, "inv.nodes"=invNodes,
                                          "node.caps"=nodeCaps, "deg.malig"=DegMalig, "breast"=Breast, "breast.quad"=BreastQuad,
                                          "irradiat"=Irradiat)),5)
  return(fit$cluster[[length(fit$cluster)]])
}

# Publish web service
onlineCluster <- publishWebService("getCluster", "kMeansCancer", list("age"="int","mp"="int", "tSize"="int", "invNodes"="int",
                                                                      "nodeCaps"="int", "DegMalig"="int", "Breast"="int", "BreastQuad"="int",
                                                                      "Irradiat"="int"), list("cluster"="int"), wsID, wsAuth)
# Consume web service
endpoints <- onlineCluster[[2]]
responseDF <- consumeDataLists(endpoints[[1]]$PrimaryKey, endpoints[[1]]$ApiLocation,
                               list("age", "mp", "tSize", "invNodes", "nodeCaps", "DegMalig", "Breast", "BreastQuad", "Irradiat"),
                               list(7, 2, 3, 4, 2, 3, 2, 1, 1))
