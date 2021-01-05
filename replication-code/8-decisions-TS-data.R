###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# source files
source("replication-code/utilities/base_data.R")

##################################################
# cases_TS
##################################################

# create a template
template_TS <- expand.grid(
  1988:2020,
  decision_types$decision_type,
  stringsAsFactors = FALSE
)
names(template_TS) <- c("year", "decision_type")

# collapse
decisions_TS <- decisions %>%
  dplyr::group_by(year, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>% dplyr::ungroup()

# merge in template
decisions_TS <- dplyr::left_join(template_TS, decisions_TS, by = c("year", "decision_type"))

# code zeros
decisions_TS$count_decisions[is.na(decisions_TS$count_decisions)] <- 0

# merge in decision stage data
decisions_TS <- dplyr::left_join(decisions_TS, decision_types, by = "decision_type")

# arrange
decisions_TS <- dplyr::arrange(decisions_TS, year, decision_type_ID)

# key ID
decisions_TS$key_ID <- 1:nrow(decisions_TS)

# select variables
decisions_TS <- dplyr::select(
  decisions_TS,
  key_ID, year, 
  decision_type_ID, decision_type,
  count_decisions
)

# save
save(decisions_TS, file = "data/decisions_TS.RData")

##################################################
# cases_TS_D
##################################################

# create a template
template_TS_D <- expand.grid(
  1988:2020,
  case_types$case_type,
  decision_types$decision_type,
  stringsAsFactors = FALSE
)
names(template_TS_D) <- c("year", "case_type", "decision_type")

# collapse
decisions_TS_D <- decisions %>%
  dplyr::group_by(year, case_type, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>% dplyr::ungroup()

# merge in template
decisions_TS_D <- dplyr::left_join(template_TS_D, decisions_TS_D, by = c("year", "case_type", "decision_type"))

# code zeros
decisions_TS_D$count_decisions[is.na(decisions_TS_D$count_decisions)] <- 0

# merge in case type data
decisions_TS_D <- dplyr::left_join(decisions_TS_D, case_types, by = "case_type")

# merge in decision stage data
decisions_TS_D <- dplyr::left_join(decisions_TS_D, decision_types, by = "decision_type")

# arrange
decisions_TS_D <- dplyr::arrange(decisions_TS_D, year, case_type_ID, decision_type_ID)

# key ID
decisions_TS_D$key_ID <- 1:nrow(decisions_TS_D)

# select variables
decisions_TS_D <- dplyr::select(
  decisions_TS_D,
  key_ID, year, 
  case_type_ID, case_type,
  decision_type_ID, decision_type,
  count_decisions
)

# save
save(decisions_TS_D, file = "data/decisions_TS_D.RData")

###########################################################################
# end R script
###########################################################################
