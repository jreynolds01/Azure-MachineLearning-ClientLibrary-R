# API URLs ----------------------------------------------------------------

prodURL <- "https://management-tm.azureml.net"


# RCurl Options

azureMlRCurlOptions <- list(
  # Accept SSL certificates issued by public Certificate Authorities
  cainfo = switch(R.version$os,
                  darwin13.4.0 = NULL,
                  system.file("CurlSSL", "cacert.pem", package = "RCurl")
  )
)


##################################
## for publishing

# String constants --------------------------------------------------------

publishURL <- "https://management.azureml.net/workspaces/%s/webservices/%s"
wrapper <- "inputDF <- maml.mapInputPort(1)\r\noutputDF <- matrix(ncol = %s, nrow = nrow(inputDF))\r\ncolnames(outputDF) <- list(%s)\r\noutputDF <- data.frame(outputDF)\r\nfor (file in list.files(\"src\")) {\r\n  if (file == \"%s\") {\r\n    load(\"src/%s\")\r\n    for (item in names(dependencies)) {\r\n      assign(item, dependencies[[item]])\r\n    }\r\n  }\r\n  else {\r\n    if (!(file %%in%% installed.packages()[,\"Package\"])) {\r\n      install.packages(paste(\"src\", file, sep=\"/\"), lib=\".\", repos=NULL, verbose=TRUE)\r\n    }\r\n    library(strsplit(file, \"\\\\.\")[[1]][[1]], character.only=TRUE)\r\n  }\r\n}\r\naction <- %s\r\nfor (i in 1:nrow(inputDF)) {\r\n  outputDF[i,] <- do.call(\"action\", as.list(inputDF[i,]))\r\n}\r\nmaml.mapOutputPort(\"outputDF\")"
