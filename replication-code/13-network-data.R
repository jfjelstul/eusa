###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

##################################################
# read in data
##################################################

load("data/cases_DDY.RData")
load("data/cases_DDY_D.RData")
load("data/decisions_DDY.RData")
load("data/decisions_DDY_D.RData")

##################################################
# filter data
##################################################

cases_network <- dplyr::filter(cases_DDY, count_cases > 0)
cases_network_D <- dplyr::filter(cases_DDY_D, count_cases > 0)
decisions_network <- dplyr::filter(decisions_DDY, count_decisions > 0)
decisions_network_D <- dplyr::filter(decisions_DDY_D, count_decisions > 0)

##################################################
# save
##################################################

save(cases_network, file = "data/cases_network.RData")
save(cases_network_D, file = "data/cases_network_D.RData")
save(decisions_network, file = "data/decisions_network.RData")
save(decisions_network_D, file = "data/decisions_network_D.RData")

###########################################################################
# end R script
###########################################################################
