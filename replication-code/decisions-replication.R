###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/cases.RData")

##################################################
# separate rows
##################################################

# one decision per row
decisions <- tidyr::separate_rows(cases, decisions, sep = "; ")

# rename variable
decisions <- dplyr::rename(decisions, decision = decisions)

##################################################
# organize
##################################################

# sort
decisions <- dplyr::arrange(decisions, notification_date, member_state, case_number)

# key ID
decisions$key_ID <- 1:nrow(decisions)

# decision ID
decisions <- decisions %>%
  dplyr::group_by(case_number) %>%
  dplyr::mutate(
    decision_ID = 1:dplyr::n()
  ) %>%
  dplyr::ungroup()

# select variables
decisions <- dplyr::select(
  decisions,
  key_ID, case_number, procedure_number,
  notification_date,
  member_state, directorate_general, directorate_general_code,
  decision_ID, decision
)

##################################################
# save
##################################################

# save
save(decisions, file = "data/decisions.RData")
write.csv(decisions, "data/decisions.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
