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
# cases_ddy
##################################################

# create a template
template_ddy <- create_template(
  departments$department,
  member_states$member_state,
  1988:2020,
  names = c("department", "member_state", "year")
)

# collapse
cases_ddy <- cases %>%
  dplyr::group_by(department, member_state, year) %>%
  dplyr::summarize(
    count_cases = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge
cases_ddy <- dplyr::left_join(template_ddy, cases_ddy, by = c("department", "member_state", "year"))

# code zeros
cases_ddy$count_cases[is.na(cases_ddy$count_cases)] <- 0

# merge in member state data
cases_ddy <- dplyr::left_join(cases_ddy, member_states, by = "member_state")

# merge in DG data
cases_ddy <- dplyr::left_join(cases_ddy, departments, by = "department")

# arrange
cases_ddy <- dplyr::arrange(cases_ddy, year, department_id, member_state_id)

# key ID
cases_ddy$key_id <- 1:nrow(cases_ddy)

# select variables
cases_ddy <- dplyr::select(
  cases_ddy,
  key_id, year,
  department_id, department, department_code,
  member_state_id, member_state, member_state_code,
  count_cases
)

# save
save(cases_ddy, file = "data/cases_ddy.RData")

##################################################
# cases_ddy_ct
##################################################

# create a template
template_ddy_ct <- create_template(
  departments$department,
  member_states$member_state,
  1988:2020,
  case_types$case_type,
  names = c("department", "member_state", "year", "case_type")
)

# collapse
cases_ddy_ct <- cases %>%
  dplyr::group_by(department, member_state, year, case_type) %>%
  dplyr::summarize(
    count_cases = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge
cases_ddy_ct <- dplyr::left_join(template_ddy_ct, cases_ddy_ct, by = c("department", "member_state", "year", "case_type"))

# code zeros
cases_ddy_ct$count_cases[is.na(cases_ddy_ct$count_cases)] <- 0

# merge in member state data
cases_ddy_ct <- dplyr::left_join(cases_ddy_ct, member_states, by = "member_state")

# merge in DG data
cases_ddy_ct <- dplyr::left_join(cases_ddy_ct, departments, by = "department")

# merge in case type data
cases_ddy_ct <- dplyr::left_join(cases_ddy_ct, case_types, by = "case_type")

# arrange
cases_ddy_ct <- dplyr::arrange(cases_ddy_ct, year, department_id, member_state_id, case_type_id)

# key ID
cases_ddy_ct$key_id <- 1:nrow(cases_ddy_ct)

# select variables
cases_ddy_ct <- dplyr::select(
  cases_ddy_ct,
  key_id, year,
  department_id, department, department_code,
  member_state_id, member_state, member_state_code,
  case_type_id, case_type,
  count_cases
)

# save
save(cases_ddy_ct, file = "data/cases_ddy_ct.RData")

################################################################################
# end R script
################################################################################
