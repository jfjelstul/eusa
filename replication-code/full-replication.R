###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# clean workspace
rm(list = ls())

##################################################
# run replication scripts
##################################################

# input: "data/decisions.RData"
# output: "data/cases.RData"

# cases (raw)
source("replication-code/1-cases-raw.R")
rm(list = ls())
# input: "data-raw/cases/"
# output: "data-raw/cases_raw.RData"

# awards (raw)
source("replication-code/2-awards-raw.R")
rm(list = ls())
# input: "data-raw/transparency/"
# output: "data-raw/awards_raw.RData"

# cases 
source("replication-code/3-cases.R")
rm(list = ls())
# input: "data-raw/cases_raw.RData"
# output: "data/cases.RData"

# decisions
source("replication-code/4-decisions.R")
rm(list = ls())
# input: "data/cases.RData"
# output: "data/decisions.RData"

# awards
source("replication-code/5-awards.R")
rm(list = ls())
# input: "data-raw/awards_raw.RData"
# output: "data/awards.RData"
# output: "data/NACE_codes.RData"

# awards CSTS data
source("replication-code/6-awards-CSTS-data.R")
rm(list = ls())
# input: "data/awards.RData"
# output: "data/awards_CSTS.RData"
# output: "data/awards_CSTS_B.RData"
# output: "data/awards_CSTS_I.RData"
# output: "data/awards_CSTS_S.RData"

# cases TS data
source("replication-code/7-cases-TS-data.R")
rm(list = ls())
# input: "data/cases.RData"
# output: "data/cases_TS.RData"
# output: "data/cases_TS_D.RData"

# decisions TS data
source("replication-code/8-decisions-TS-data.R")
rm(list = ls())
# input: "data/decisions.RData"
# output: "data/decisions_TS.RData"
# output: "data/decisions_TS_D.RData"

# cases CSTS data
source("replication-code/9-cases-CSTS-data.R")
rm(list = ls())
# input: "data/cases.RData"
# output: "data/cases_MS.RData"
# output: "data/cases_MS_D.RData"
# output: "data/cases_DG.RData"
# output: "data/cases_DG_D.RData"

# decisions CSTS data
source("replication-code/10-decisions-CSTS-data.R")
rm(list = ls())
# input: "data/decisions.RData"
# output: "data/decisions_MS.RData"
# output: "data/decisions_MS_D.RData"
# output: "data/decisions_DG.RData"
# output: "data/decisions_DG_D.RData"

# cases DDY data
source("replication-code/11-cases-DDY-data.R")
rm(list = ls())
# input: "data/cases.RData"
# output: "data/cases_DDY.RData"
# output: "data/cases_DDY_D.RData"

# decisions DDY data
source("replication-code/12-decisions-DDY-data.R")
rm(list = ls())
# input: "data/decisions.RData"
# output: "data/decisions_DDY.RData"
# output: "data/decisions_DDY_D.RData"

# network data
source("replication-code/13-network-data.R")
rm(list = ls())
# input: "data/cases_DDY.RData"
# input: "data/cases_DDY_D.RData"
# input: "data/decisions_DDY.RData"
# input: "data/decisions_DDY_D.RData"
# output: "data/cases_network.RData"
# output: "data/cases_network_D.RData"
# output: "data/decisions_network.RData"
# output: "data/decisions_network_D.RData"

##################################################
# load data
##################################################

# cases
load("data/cases.RData")
load("data/cases_TS.RData")
load("data/cases_TS_D.RData")
load("data/cases_CSTS_MS.RData")
load("data/cases_CSTS_MS_D.RData")
load("data/cases_CSTS_DG.RData")
load("data/cases_CSTS_DG_D.RData")
load("data/cases_DDY.RData")
load("data/cases_DDY_D.RData")
load("data/cases_network.RData")
load("data/cases_network_D.RData")

# decisions
load("data/decisions.RData")
load("data/decisions_TS.RData")
load("data/decisions_TS_D.RData")
load("data/decisions_CSTS_MS.RData")
load("data/decisions_CSTS_MS_D.RData")
load("data/decisions_CSTS_DG.RData")
load("data/decisions_CSTS_DG_D.RData")
load("data/decisions_DDY.RData")
load("data/decisions_DDY_D.RData")
load("data/decisions_network.RData")
load("data/decisions_network_D.RData")

# awards
load("data/awards.RData")
load("data/awards_CSTS.RData")
load("data/awards_CSTS_B.RData")
load("data/awards_CSTS_I.RData")
load("data/awards_CSTS_S.RData")

# NACE codes
load("data/NACE_codes.RData")

##################################################
# write data
##################################################

# cases
write.csv(cases, "build/EUSA-cases.csv", row.names = FALSE)
write.csv(cases_TS, "build/EUSA-cases-TS.csv", row.names = FALSE)
write.csv(cases_TS_D, "build/EUSA-cases-TS-D.csv", row.names = FALSE)
write.csv(cases_CSTS_MS, "build/EUSA-cases-CSTS-MS.csv", row.names = FALSE)
write.csv(cases_CSTS_MS_D, "build/EUSA-cases-CSTS-MS-D.csv", row.names = FALSE)
write.csv(cases_CSTS_DG, "build/EUSA-cases-CSTS-DG.csv", row.names = FALSE)
write.csv(cases_CSTS_DG_D, "build/EUSA-cases-CSTS-DG-D.csv", row.names = FALSE)
write.csv(cases_DDY, "build/EUSA-cases-DDY.csv", row.names = FALSE)
write.csv(cases_DDY_D, "build/EUSA-cases-DDY-D.csv", row.names = FALSE)
write.csv(cases_network, "build/EUSA-cases-network.csv", row.names = FALSE)
write.csv(cases_network_D, "build/EUSA-cases-network-D.csv", row.names = FALSE)

# decisions
write.csv(decisions, "build/EUSA-decisions.csv", row.names = FALSE)
write.csv(decisions_TS, "build/EUSA-decisions-TS.csv", row.names = FALSE)
write.csv(decisions_TS_D, "build/EUSA-decisions-TS-D.csv", row.names = FALSE)
write.csv(decisions_CSTS_MS, "build/EUSA-decisions-CSTS-MS.csv", row.names = FALSE)
write.csv(decisions_CSTS_MS_D, "build/EUSA-decisions-CSTS-MS-D.csv", row.names = FALSE)
write.csv(decisions_CSTS_DG, "build/EUSA-decisions-CSTS-DG.csv", row.names = FALSE)
write.csv(decisions_CSTS_DG_D, "build/EUSA-decisions-CSTS-DG-D.csv", row.names = FALSE)
write.csv(decisions_DDY, "build/EUSA-decisions-DDY.csv", row.names = FALSE)
write.csv(decisions_DDY_D, "build/EUSA-decisions-DDY-D.csv", row.names = FALSE)
write.csv(decisions_network, "build/EUSA-decisions-network.csv", row.names = FALSE)
write.csv(decisions_network_D, "build/EUSA-decisions-network-D.csv", row.names = FALSE)

# awards
write.csv(awards, "build/EUSA-awards.csv", row.names = FALSE)
write.csv(awards_CSTS, "build/EUSA-awards-CSTS.csv", row.names = FALSE)
write.csv(awards_CSTS_B, "build/EUSA-awards-CSTS-B.csv", row.names = FALSE)
write.csv(awards_CSTS_I, "build/EUSA-awards-CSTS-I.csv", row.names = FALSE)
write.csv(awards_CSTS_S, "build/EUSA-awards-CSTS-S.csv", row.names = FALSE)

# NACE codes
write.csv(NACE_codes, "build/EUSA-NACE-codes.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
