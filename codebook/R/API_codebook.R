###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# read in codebook data
API_codebook <- read.csv("codebook/build/EUSA-API-codebook.csv")

# select variables
API_codebook <- dplyr::select(API_codebook, API_route, API_parameter)

# drop download parameters
API_codebook <- dplyr::filter(API_codebook, API_parameter != "download")

# save
save(API_codebook, file = "R/sysdata.rda")

###########################################################################
# end R script
###########################################################################
