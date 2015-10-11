test_ws_id <- "FILLMEIN"
test_auth_token <- "FILLMEIN"
# do some checks.
if(any(c(test_ws_id,test_auth_token) == "FILLMEIN")){
  stop("You need to fill in these values with your workspace id and authorization token.")
}else{
  save(test_ws_id, test_auth_token, file = "mlstudio_auth_info.RData")
}