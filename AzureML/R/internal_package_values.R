# API URLs ----------------------------------------------------------------

prodURL <- "https://management-tm.azureml.net"


# RCurl Options

azureMlRCurlOptions = list(
  # Accept SSL certificates issued by public Certificate Authorities
  cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")
)
