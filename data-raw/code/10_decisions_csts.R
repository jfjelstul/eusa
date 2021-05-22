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
# decisions_csts_ms
##################################################

# create a template
template_csts_ms <- create_template(
  member_states$member_state,
  1988:2020,
  decision_types$decision_type,
  names = c("member_state", "year", "decision_type")
)

# collapse
decisions_csts_ms <- decisions %>%
  dplyr::group_by(member_state, year, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge into template
decisions_csts_ms <- dplyr::left_join(template_csts_ms, decisions_csts_ms, by = c("member_state", "year", "decision_type"))

# code zeros
decisions_csts_ms$count_decisions[is.na(decisions_csts_ms$count_decisions)] <- 0

# merge in member state data
decisions_csts_ms <- dplyr::left_join(decisions_csts_ms, member_states, by = "member_state")

# merge in decision stage data
decisions_csts_ms <- dplyr::left_join(decisions_csts_ms, decision_types, by = "decision_type")

# arrange
decisions_csts_ms <- dplyr::arrange(decisions_csts_ms, year, member_state_id, decision_type_id)

# key ID
decisions_csts_ms$key_id <- 1:nrow(decisions_csts_ms)

# select decisions_csts_ms_tidy
decisions_csts_ms <- dplyr::select(
  decisions_csts_ms,
  key_id, year,
  member_state_id, member_state, member_state_code,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_csts_ms, file = "data/decisions_csts_ms.RData")

##################################################
# decisions_csts_ms_ct
##################################################

# create a template
template_csts_ms_ct <- create_template(
  member_states$member_state,
  1988:2020,
  case_types$case_type,
  decision_types$decision_type,
  names = c("member_state", "year", "case_type", "decision_type")
)

# collapse
decisions_csts_ms_ct <- decisions %>%
  dplyr::group_by(member_state, year, case_type, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge into template
decisions_csts_ms_ct <- dplyr::left_join(template_csts_ms_ct, decisions_csts_ms_ct, by = c("member_state", "year", "case_type", "decision_type"))

# code zeros
decisions_csts_ms_ct$count_decisions[is.na(decisions_csts_ms_ct$count_decisions)] <- 0

# merge in member state data
decisions_csts_ms_ct <- dplyr::left_join(decisions_csts_ms_ct, member_states, by = "member_state")

# merge in case type data
decisions_csts_ms_ct <- dplyr::left_join(decisions_csts_ms_ct, case_types, by = "case_type")

# merge in decision stage data
decisions_csts_ms_ct <- dplyr::left_join(decisions_csts_ms_ct, decision_types, by = "decision_type")

# arrange
decisions_csts_ms_ct <- dplyr::arrange(decisions_csts_ms_ct, year, member_state_id, case_type_id, decision_type_id)

# key ID
decisions_csts_ms_ct$key_id <- 1:nrow(decisions_csts_ms_ct)

# select variables
decisions_csts_ms_ct <- dplyr::select(
  decisions_csts_ms_ct,
  key_id, year,
  member_state_id, member_state, member_state_code,
  case_type_id, case_type,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_csts_ms_ct, file = "data/decisions_csts_ms_ct.RData")

##################################################
# decisions_csts_dp
##################################################

# create a template
template_csts_dp <- create_template(
  departments$department,
  1988:2020,
  decision_types$decision_type,
  names = c("department", "year", "decision_type")
)

# collapse
decisions_csts_dp <- decisions %>%
  dplyr::group_by(department, year, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge into template
decisions_csts_dp <- dplyr::left_join(template_csts_dp, decisions_csts_dp, by = c("department", "year", "decision_type"))

# code zeros
decisions_csts_dp$count_decisions[is.na(decisions_csts_dp$count_decisions)] <- 0

# merge in DG data
decisions_csts_dp <- dplyr::left_join(decisions_csts_dp, departments, by = "department")

# merge in decision stage data
decisions_csts_dp <- dplyr::left_join(decisions_csts_dp, decision_types, by = "decision_type")

# arrange
decisions_csts_dp <- dplyr::arrange(decisions_csts_dp, year, department_id, decision_type_id)

# key ID
decisions_csts_dp$key_id <- 1:nrow(decisions_csts_dp)

# select variables
decisions_csts_dp <- dplyr::select(
  decisions_csts_dp,
  key_id, year,
  department_id, department, department_code,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_csts_dp, file = "data/decisions_csts_dp.RData")

##################################################
# decisions_csts_dp_ct
##################################################

# create a template
template_csts_dp_ct <- create_template(
  departments$department,
  1988:2020,
  case_types$case_type,
  decision_types$decision_type,
  names = c("department", "year", "case_type", "decision_type")
)

# collapse
decisions_csts_dp_ct <- decisions %>%
  dplyr::group_by(department, year, case_type, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge into template
decisions_csts_dp_ct <- dplyr::left_join(template_csts_dp_ct, decisions_csts_dp_ct, by = c("department", "year", "case_type", "decision_type"))

# code zeros
decisions_csts_dp_ct$count_decisions[is.na(decisions_csts_dp_ct$count_decisions)] <- 0

# merge in DG data
decisions_csts_dp_ct <- dplyr::left_join(decisions_csts_dp_ct, departments, by = "department")

# merge in case type data
decisions_csts_dp_ct <- dplyr::left_join(decisions_csts_dp_ct, case_types, by = "case_type")

# merge in decision stage data
decisions_csts_dp_ct <- dplyr::left_join(decisions_csts_dp_ct, decision_types, by = "decision_type")

# arrange
decisions_csts_dp_ct <- dplyr::arrange(decisions_csts_dp_ct, year, department_id, case_type_id, decision_type_id)

# key ID
decisions_csts_dp_ct$key_id <- 1:nrow(decisions_csts_dp_ct)

# select variables
decisions_csts_dp_ct <- dplyr::select(
  decisions_csts_dp_ct,
  key_id, year,
  department_id, department, department_code,
  case_type_id, case_type,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_csts_dp_ct, file = "data/decisions_csts_dp_ct.RData")

################################################################################
# end R script
################################################################################
