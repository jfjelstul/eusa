###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# source files
source("replication-code/utilities/create_template.R")
source("replication-code/utilities/base_data.R")

##################################################
# decisions_DDY
##################################################

# create a template
template_DDY <- create_template(
  directorates_general$directorate_general, 
  member_states$member_state, 
  1988:2020,
  decision_types$decision_type,
  names = c("directorate_general", "member_state", "year", "decision_type")
)

# collapse
decisions_DDY <- decisions %>%
  dplyr::group_by(directorate_general, member_state, year, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>% dplyr::ungroup()

# merge into template
decisions_DDY <- dplyr::left_join(template_DDY, decisions_DDY, by = c("directorate_general", "member_state", "year", "decision_type"))

# code zeros
decisions_DDY$count_decisions[is.na(decisions_DDY$count_decisions)] <- 0

# merge in member state data
decisions_DDY <- dplyr::left_join(decisions_DDY, member_states, by = "member_state")

# merge in DG data
decisions_DDY <- dplyr::left_join(decisions_DDY, directorates_general, by = "directorate_general")

# merge in decision stage data
decisions_DDY <- dplyr::left_join(decisions_DDY, decision_types, by = "decision_type")

# arrange
decisions_DDY <- dplyr::arrange(decisions_DDY, year, directorate_general_ID, member_state_ID, decision_type_ID)

# key ID
decisions_DDY$key_ID <- 1:nrow(decisions_DDY)

# select variables
decisions_DDY <- dplyr::select(
  decisions_DDY,
  key_ID, year, 
  directorate_general_ID, directorate_general, directorate_general_code,
  member_state_ID, member_state, member_state_code, 
  decision_type_ID, decision_type,
  count_decisions
)

# save
save(decisions_DDY, file = "data/decisions_DDY.RData")

##################################################
# cases_DDY_D
##################################################

# create a template
template_DDY_D <- create_template(
  directorates_general$directorate_general, 
  member_states$member_state, 
  1988:2020,
  case_types$case_type,
  decision_types$decision_type,
  names = c("directorate_general", "member_state", "year", "case_type", "decision_type")
)

# collapse
decisions_DDY_D <- decisions %>%
  dplyr::group_by(directorate_general, member_state, year, case_type, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>% dplyr::ungroup()

# merge
decisions_DDY_D <- dplyr::left_join(template_DDY_D, decisions_DDY_D, by = c("directorate_general", "member_state", "year", "case_type", "decision_type"))

# code zeros
decisions_DDY_D$count_decisions[is.na(decisions_DDY_D$count_decisions)] <- 0

# merge in member state data
decisions_DDY_D <- dplyr::left_join(decisions_DDY_D, member_states, by = "member_state")

# merge in DG data
decisions_DDY_D <- dplyr::left_join(decisions_DDY_D, directorates_general, by = "directorate_general")

# merge in case types data
decisions_DDY_D <- dplyr::left_join(decisions_DDY_D, case_types, by = "case_type")

# merge in decision stages data
decisions_DDY_D <- dplyr::left_join(decisions_DDY_D, decision_types, by = "decision_type")

# arrange
decisions_DDY_D <- dplyr::arrange(decisions_DDY_D, year, directorate_general_ID, member_state_ID, case_type_ID, decision_type_ID)

# key ID
decisions_DDY_D$key_ID <- 1:nrow(decisions_DDY_D)

# select variables
decisions_DDY_D <- dplyr::select(
  decisions_DDY_D,
  key_ID, year,
  directorate_general_ID, directorate_general, directorate_general_code,
  member_state_ID, member_state, member_state_code, 
  case_type_ID, case_type,
  decision_type_ID, decision_type,
  count_decisions
)

# save
save(decisions_DDY_D, file = "data/decisions_DDY_D.RData")

###########################################################################
# end R script
###########################################################################
