test_workspace_id <- NA
test_primary_auth_token <- NA
test_secondary_auth_token <- NA
 
value_names <- grep("^test_", ls(), value = TRUE)

values_are_filled <-vapply(value_names,
       function(x) !is.na(get(x)),
       FUN.VALUE = logical(1))

stopifnot(values_are_filled)

save(list = value_names, 
     file = "mlstudio_auth_info.RData")
