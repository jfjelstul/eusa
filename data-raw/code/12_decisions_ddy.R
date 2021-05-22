################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# source files
source("data-raw/code/utilities/create_template.R")
source("data-raw/code/utilities/base_data.R")

##################################################
# decisions_ddy
##################################################

# create a template
template_ddy <- create_template(
  departments$department,
  member_states$member_state,
  1988:2020,
  decision_types$decision_type,
  names = c("department", "member_state", "year", "decision_type")
)

# collapse
decisions_ddy <- decisions %>%
  dplyr::group_by(department, member_state, year, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge into template
decisions_ddy <- dplyr::left_join(template_ddy, decisions_ddy, by = c("department", "member_state", "year", "decision_type"))

# code zeros
decisions_ddy$count_decisions[is.na(decisions_ddy$count_decisions)] <- 0

# merge in member state data
decisions_ddy <- dplyr::left_join(decisions_ddy, member_states, by = "member_state")

# merge in DG data
decisions_ddy <- dplyr::left_join(decisions_ddy, departments, by = "department")

# merge in decision stage data
decisions_ddy <- dplyr::left_join(decisions_ddy, decision_types, by = "decision_type")

# arrange
decisions_ddy <- dplyr::arrange(decisions_ddy, year, department_id, member_state_id, decision_type_id)

# key ID
decisions_ddy$key_id <- 1:nrow(decisions_ddy)

# select variables
decisions_ddy <- dplyr::select(
  decisions_ddy,
  key_id, year,
  department_id, department, department_code,
  member_state_id, member_state, member_state_code,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_ddy, file = "data/decisions_ddy.RData")

##################################################
# cases_ddy_ct
##################################################

# create a template
template_ddy_ct <- create_template(
  departments$department,
  member_states$member_state,
  1988:2020,
  case_types$case_type,
  decision_types$decision_type,
  names = c("department", "member_state", "year", "case_type", "decision_type")
)

# collapse
decisions_ddy_ct <- decisions %>%
  dplyr::group_by(department, member_state, year, case_type, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge
decisions_ddy_ct <- dplyr::left_join(template_ddy_ct, decisions_ddy_ct, by = c("department", "member_state", "year", "case_type", "decision_type"))

# code zeros
decisions_ddy_ct$count_decisions[is.na(decisions_ddy_ct$count_decisions)] <- 0

# merge in member state data
decisions_ddy_ct <- dplyr::left_join(decisions_ddy_ct, member_states, by = "member_state")

# merge in DG data
decisions_ddy_ct <- dplyr::left_join(decisions_ddy_ct, departments, by = "department")

# merge in case types data
decisions_ddy_ct <- dplyr::left_join(decisions_ddy_ct, case_types, by = "case_type")

# merge in decision stages data
decisions_ddy_ct <- dplyr::left_join(decisions_ddy_ct, decision_types, by = "decision_type")

# arrange
decisions_ddy_ct <- dplyr::arrange(decisions_ddy_ct, year, department_id, member_state_id, case_type_id, decision_type_id)

# key ID
decisions_ddy_ct$key_id <- 1:nrow(decisions_ddy_ct)

# select variables
decisions_ddy_ct <- dplyr::select(
  decisions_ddy_ct,
  key_id, year,
  department_id, department, department_code,
  member_state_id, member_state, member_state_code,
  case_type_id, case_type,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_ddy_ct, file = "data/decisions_ddy_ct.RData")

################################################################################
# end R script
################################################################################
