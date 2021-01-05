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
template_TS <- dplyr::tibble(year = 1988:2020)

# collapse
cases_TS <- cases %>%
  dplyr::group_by(year) %>%
  dplyr::summarize(
    count_cases = dplyr::n()
  ) %>% dplyr::ungroup()

# merge in template
cases_TS <- dplyr::left_join(template_TS, cases_TS, by = "year")

# code zeros
cases_TS$count_cases[is.na(cases_TS$count_cases)] <- 0

# key ID
cases_TS$key_ID <- 1:nrow(cases_TS)

# select variables
cases_TS <- dplyr::select(
  cases_TS,
  key_ID, year, count_cases
)

# save
save(cases_TS, file = "data/cases_TS.RData")

##################################################
# cases_TS_D
##################################################

# create a template
template_TS_D <- expand.grid(year = 1988:2020, case_type = case_types$case_type)
names(template_TS_D) <- c("year", "case_type")
template_TS_D <- dplyr::as_tibble(template_TS_D)

# collapse
cases_TS_D <- cases %>%
  dplyr::group_by(year, case_type) %>%
  dplyr::summarize(
    count_cases = dplyr::n()
  ) %>% dplyr::ungroup()

# merge into template
cases_TS_D <- dplyr::left_join(template_TS_D, cases_TS_D, by = c("year", "case_type"))

# code zeros
cases_TS_D$count_cases[is.na(cases_TS_D$count_cases)] <- 0

# merge in case type data
cases_TS_D <- dplyr::left_join(cases_TS_D, case_types, by = "case_type")

# arrange
cases_TS_D <- dplyr::arrange(cases_TS_D, year, case_type_ID)

# key ID
cases_TS_D$key_ID <- 1:nrow(cases_TS_D)

# select variables
cases_TS_D <- dplyr::select(
  cases_TS_D,
  key_ID, year, 
  case_type_ID, case_type, 
  count_cases
)

# save
save(cases_TS_D, file = "data/cases_TS_D.RData")

###########################################################################
# end R script
###########################################################################
