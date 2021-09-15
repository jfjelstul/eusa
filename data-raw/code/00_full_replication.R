################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

# clean workspace
rm(list = ls())

##################################################
# run replication scripts
##################################################

# cases (raw)
source("data-raw/code/01_cases_raw.R")
rm(list = ls())
# input: data-raw/cases/
# output: data-raw/cases_raw.RData

# awards (raw)
source("data-raw/code/02_awards_raw.R")
rm(list = ls())
# input: data-raw/transparency/
# output: data-raw/awards_raw.RData

# cases
source("data-raw/code/03_cases.R")
rm(list = ls())
# input: data-raw/cases_raw.RData
# output: data/cases.RData

# decisions
source("data-raw/code/04_decisions.R")
rm(list = ls())
# input: data/cases.RData
# output: data/decisions.RData

# awards
source("data-raw/code/05_awards.R")
rm(list = ls())
# input: data-raw/awards_raw.RData
# output: data/awards.RData
# output: data/nace_codes.RData

# awards CSTS data
source("data-raw/code/06_awards_csts.R")
rm(list = ls())
# input: data/awards.RData
# output: data/awards_csts.RData
# output: data/awards_csts_bt.RData
# output: data/awards_csts_ai.RData
# output: data/awards_csts_ns.RData

# cases TS data
source("data-raw/code/07_cases_ts.R")
rm(list = ls())
# input: data/cases.RData
# output: data/cases_ts.RData
# output: data/cases_ts_ct.RData

# decisions TS data
source("data-raw/code/08_decisions_ts.R")
rm(list = ls())
# input: data/decisions.RData
# output: data/decisions_ts.RData
# output: data/decisions_ts_ct.RData

# cases CSTS data
source("data-raw/code/09_cases_csts.R")
rm(list = ls())
# input: data/cases.RData
# output: data/cases_ms.RData
# output: data/cases_ms_ct.RData
# output: data/cases_dp.RData
# output: data/cases_dp_ct.RData

# decisions CSTS data
source("data-raw/code/10_decisions_csts.R")
rm(list = ls())
# input: data/decisions.RData
# output: data/decisions_ms.RData
# output: data/decisions_ms_ct.RData
# output: data/decisions_dp.RData
# output: data/decisions_dp_ct.RData

# cases DDY data
source("data-raw/code/11_cases_ddy.R")
rm(list = ls())
# input: data/cases.RData
# output: data/cases_ddy.RData
# output: data/cases_ddy_ct.RData

# decisions DDY data
source("data-raw/code/12_decisions_ddy.R")
rm(list = ls())
# input: data/decisions.RData
# output: data/decisions_ddy.RData
# output: data/decisions_ddy_ct.RData

# network data
source("data-raw/code/13_cases_net.R")
rm(list = ls())
# input: data/cases_ddy.RData
# input: data/cases_ddy_ct.RData
# output: data/cases_net.RData
# output: data/cases_net_ct.RData

# network data
source("data-raw/code/14_decisions_net.R")
rm(list = ls())
# input: data/decisions_ddy.RData
# input: data/decisions_ddy_ct.RData
# output: data/decisions_net.RData
# output: data/decisions_net_ct.RData

##################################################
# variables
##################################################

# read in data
variables <- read.csv("data-raw/documentation/eusa_variables.csv", stringsAsFactors = FALSE)

# convert to a tibble
variables <- dplyr::as_tibble(variables)

# save
save(variables, file = "data/variables.RData")

##################################################
# datasets
##################################################

# read in data
datasets <- read.csv("data-raw/documentation/eusa_datasets.csv", stringsAsFactors = FALSE)

# convert to a tibble
datasets <- dplyr::as_tibble(datasets)

# save
save(datasets, file = "data/datasets.RData")

##################################################
# documentation
##################################################

# documentation
load("data/variables.RData")
load("data/datasets.RData")

# document data
codebookr::document_data(
  file_path = "R/",
  variables_input = variables,
  datasets_input = datasets,
  include_variable_type = TRUE,
  author = "Joshua C. Fjelstul, Ph.D.",
  package = "eusa"
)

##################################################
# codebook
##################################################

# create a codebook
codebookr::create_codebook(
  file_path = "codebook/eusa_codebook.tex",
  datasets_input = datasets,
  variables_input = variables,
  title_text = "The European Union State Aid \\\\ (EUSA) Database",
  version_text = "1.0",
  footer_text = "The EUSA Database Codebook \\hspace{5pt} | \\hspace{5pt} Joshua C. Fjelstul, Ph.D.",
  author_names = "Joshua C. Fjelstul, Ph.D.",
  theme_color = "#4B94E6",
  heading_font_size = 30,
  subheading_font_size = 10,
  title_font_size = 16,
  table_of_contents = TRUE,
  include_variable_type = TRUE
)

##################################################
# load data
##################################################

# cases
load("data/cases.RData")
load("data/cases_ts.RData")
load("data/cases_ts_ct.RData")
load("data/cases_csts_ms.RData")
load("data/cases_csts_ms_ct.RData")
load("data/cases_csts_dp.RData")
load("data/cases_csts_dp_ct.RData")
load("data/cases_ddy.RData")
load("data/cases_ddy_ct.RData")
load("data/cases_net.RData")
load("data/cases_net_ct.RData")

# decisions
load("data/decisions.RData")
load("data/decisions_ts.RData")
load("data/decisions_ts_ct.RData")
load("data/decisions_csts_ms.RData")
load("data/decisions_csts_ms_ct.RData")
load("data/decisions_csts_dp.RData")
load("data/decisions_csts_dp_ct.RData")
load("data/decisions_ddy.RData")
load("data/decisions_ddy_ct.RData")
load("data/decisions_net.RData")
load("data/decisions_net_ct.RData")

# awards
load("data/awards.RData")
load("data/awards_csts.RData")
load("data/awards_csts_bt.RData")
load("data/awards_csts_ai.RData")
load("data/awards_csts_ns.RData")

# documentation
load("data/variables.RData")
load("data/datasets.RData")

##################################################
# check class
##################################################

# cases
class(cases)
class(cases_ts)
class(cases_ts_ct)
class(cases_csts_ms)
class(cases_csts_ms_ct)
class(cases_csts_dp)
class(cases_csts_dp_ct)
class(cases_ddy)
class(cases_ddy_ct)
class(cases_net)
class(cases_net_ct)

# decisions
class(decisions)
class(decisions_ts)
class(decisions_ts_ct)
class(decisions_csts_ms)
class(decisions_csts_ms_ct)
class(decisions_csts_dp)
class(decisions_csts_dp_ct)
class(decisions_ddy)
class(decisions_ddy_ct)
class(decisions_net)
class(decisions_net_ct)

# awards
class(awards)
class(awards_csts)
class(awards_csts_bt)
class(awards_csts_ai)
class(awards_csts_ns)

# documentation
class(variables)
class(datasets)

##################################################
# check missing
##################################################

# cases
table(is.na(cases))
table(is.na(cases_ts))
table(is.na(cases_ts_ct))
table(is.na(cases_csts_ms))
table(is.na(cases_csts_ms_ct))
table(is.na(cases_csts_dp))
table(is.na(cases_csts_dp_ct))
table(is.na(cases_ddy))
table(is.na(cases_ddy_ct))
table(is.na(cases_net))
table(is.na(cases_net_ct))

# decisions
table(is.na(decisions))
table(is.na(decisions_ts))
table(is.na(decisions_ts_ct))
table(is.na(decisions_csts_ms))
table(is.na(decisions_csts_ms_ct))
table(is.na(decisions_csts_dp))
table(is.na(decisions_csts_dp_ct))
table(is.na(decisions_ddy))
table(is.na(decisions_ddy_ct))
table(is.na(decisions_net))
table(is.na(decisions_net_ct))

# awards
table(is.na(awards))
table(is.na(awards_csts))
table(is.na(awards_csts_bt))
table(is.na(awards_csts_ai))
table(is.na(awards_csts_ns))

##################################################
# build
##################################################

# cases
write.csv(cases, "build/eusa_cases.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_ts, "build/eusa_cases_ts.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_ts_ct, "build/eusa_cases_ts_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_csts_ms, "build/eusa_cases_csts_ms.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_csts_ms_ct, "build/eusa_cases_csts_ms_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_csts_dp, "build/eusa_cases_csts_dp.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_csts_dp_ct, "build/eusa_cases_csts_dp_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_ddy, "build/eusa_cases_ddy.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_ddy_ct, "build/eusa_cases_ddy_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_net, "build/eusa_cases_net.csv", row.names = FALSE, quote = TRUE)
write.csv(cases_net_ct, "build/eusa_cases_net_ct.csv", row.names = FALSE, quote = TRUE)

# decisions
write.csv(decisions, "build/eusa_decisions.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_ts, "build/eusa_decisions_ts.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_ts_ct, "build/eusa_decisions_ts_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_csts_ms, "build/eusa_decisions_csts_ms.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_csts_ms_ct, "build/eusa_decisions_csts_ms_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_csts_dp, "build/eusa_decisions_csts_dp.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_csts_dp_ct, "build/eusa_decisions_csts_dp_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_ddy, "build/eusa_decisions_ddy.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_ddy_ct, "build/eusa_decisions_ddy_ct.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_net, "build/eusa_decisions_net.csv", row.names = FALSE, quote = TRUE)
write.csv(decisions_net_ct, "build/eusa_decisions_net_ct.csv", row.names = FALSE, quote = TRUE)

# awards
write.csv(awards, "build/eusa_awards.csv", row.names = FALSE, quote = TRUE)
write.csv(awards_csts, "build/eusa_awards_csts.csv", row.names = FALSE, quote = TRUE)
write.csv(awards_csts_bt, "build/eusa_awards_csts_bt.csv", row.names = FALSE, quote = TRUE)
write.csv(awards_csts_ai, "build/eusa_awards_csts_ai.csv", row.names = FALSE, quote = TRUE)
write.csv(awards_csts_ns, "build/eusa_awards_csts_ns.csv", row.names = FALSE, quote = TRUE)

# documentation
write.csv(variables, "build/eusa_variables.csv", row.names = FALSE, quote = TRUE)
write.csv(datasets, "build/eusa_datasets.csv", row.names = FALSE, quote = TRUE)

################################################################################
# end R script
################################################################################
