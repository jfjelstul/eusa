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
# cases_DDY
##################################################

# create a template
template_DDY <- create_template(
  directorates_general$directorate_general, 
  member_states$member_state, 
  1988:2020,
  names = c("directorate_general", "member_state", "year")
)

# collapse
cases_DDY <- cases %>%
  dplyr::group_by(directorate_general, member_state, year) %>%
  dplyr::summarize(
    count_cases = dplyr::n()
  ) %>% dplyr::ungroup()

# merge
cases_DDY <- dplyr::left_join(template_DDY, cases_DDY, by = c("directorate_general", "member_state", "year"))

# code zeros
cases_DDY$count_cases[is.na(cases_DDY$count_cases)] <- 0

# merge in member state data
cases_DDY <- dplyr::left_join(cases_DDY, member_states, by = "member_state")

# merge in DG data
cases_DDY <- dplyr::left_join(cases_DDY, directorates_general, by = "directorate_general")

# arrange
cases_DDY <- dplyr::arrange(cases_DDY, year, directorate_general_ID, member_state_ID)

# key ID
cases_DDY$key_ID <- 1:nrow(cases_DDY)

# select variables
cases_DDY <- dplyr::select(
  cases_DDY,
  key_ID, year, 
  directorate_general_ID, directorate_general, directorate_general_code,
  member_state_ID, member_state, member_state_code, 
  count_cases
)

# save
save(cases_DDY, file = "data/cases_DDY.RData")

##################################################
# cases_DDY_D
##################################################

# create a template
template_DDY_D <- create_template(
  directorates_general$directorate_general,
  member_states$member_state, 
  1988:2020,
  case_types$case_type,
  names = c("directorate_general", "member_state", "year", "case_type")
)

# collapse
cases_DDY_D <- cases %>%
  dplyr::group_by(directorate_general, member_state, year, case_type) %>%
  dplyr::summarize(
    count_cases = dplyr::n()
  ) %>% dplyr::ungroup()

# merge
cases_DDY_D <- dplyr::left_join(template_DDY_D, cases_DDY_D, by = c("directorate_general", "member_state", "year", "case_type"))

# code zeros
cases_DDY_D$count_cases[is.na(cases_DDY_D$count_cases)] <- 0

# merge in member state data
cases_DDY_D <- dplyr::left_join(cases_DDY_D, member_states, by = "member_state")

# merge in DG data
cases_DDY_D <- dplyr::left_join(cases_DDY_D, directorates_general, by = "directorate_general")

# merge in case type data
cases_DDY_D <- dplyr::left_join(cases_DDY_D, case_types, by = "case_type")

# arrange
cases_DDY_D <- dplyr::arrange(cases_DDY_D, year, directorate_general_ID, member_state_ID, case_type_ID)

# key ID
cases_DDY_D$key_ID <- 1:nrow(cases_DDY_D)

# select variables
cases_DDY_D <- dplyr::select(
  cases_DDY_D,
  key_ID, year,
  directorate_general_ID, directorate_general, directorate_general_code,
  member_state_ID, member_state, member_state_code, 
  case_type_ID, case_type,
  count_cases
)

# save
save(cases_DDY_D, file = "data/cases_DDY_D.RData")

###########################################################################
# end R script
###########################################################################
