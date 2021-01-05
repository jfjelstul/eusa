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
decisions <- dplyr::rename(decisions, decision_type = decisions)

##################################################
# phase
##################################################

decisions$phase <- "Other"
decisions$phase[stringr::str_detect(decisions$decision_type, "Article 4")] <- "Phase 1"
decisions$phase[stringr::str_detect(decisions$decision_type, "Articles? 9")] <- "Phase 2"
decisions$phase[stringr::str_detect(decisions$decision_type, "exempt")] <- "Exempt"

##################################################
# decision type
##################################################

# decision types
decision_types <- dplyr::tibble(
  decision_type_ID = 1:20,
  decision_type = c(
    "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3)",
    "Article 4(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid",
    "Article 4(3) of Council Regulation (EU) 2015/1589: decision not to raise objections",
    "Article 4(4) of Council Regulation (EU) 2015/1589: decision to initiate the formal investigation procedure",
    "Article 4(4) of Council Regulation (EU) 2015/1589: decision to extend proceedings",
    "Article 9(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid (after formal investigation procedure)",
    "Article 9(3) of Council Regulation (EU) 2015/1589: positive decision",
    "Article 9(4) of Council Regulation (EU) 2015/1589: conditional decision",
    "Article 9(5) of Council Regulation (EU) 2015/1589: negative decision on notified aid",
    "Articles 9(5) and 16(1) of Council Regulation (EU) 2015/1589: negative decision without recovery",
    "Articles 9(5) and 16(1) of Council Regulation (EU) 2015/1589: negative decision with recovery",
    "Article 10(1) of Council Regulation (EU) 2015/1589: withdrawal of notification (before formal investigation procedure)",
    "Article 10(2) of Council Regulation (EU) 2015/1589: withdrawal of notification (after formal investigation procedure)",
    "Article 11 of Council Regulation (EU) 2015/1589: revocation of a decision",
    "Article 12(3) of Council Regulation (EU) 2015/1589: information injunction",
    "Article 13(1) of Council Regulation (EU) 2015/1589: suspension injunction",
    "Article 14 of Council Regulation (EU) 2015/1589: referral to the Court of Justice (non-compliance with an injunction)",
    "Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures",
    "Article 108(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Commission decision)",
    "Article 260(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Court judgment)"
  )
)

# merge
decisions <- dplyr::left_join(decisions, decision_types, by = "decision_type")

##################################################
# organize
##################################################

# sort
decisions <- dplyr::arrange(decisions, notification_date, member_state_ID, case_number)

# key ID
decisions$key_ID <- 1:nrow(decisions)

# decision ID
decisions <- decisions %>%
  dplyr::group_by(case_number) %>%
  dplyr::mutate(
    decision_number = 1:dplyr::n()
  ) %>%
  dplyr::ungroup()

# select variables
decisions <- dplyr::select(
  decisions,
  key_ID, case_number, procedure_numbers,
  member_state_ID, member_state, member_state_code,
  directorate_general_ID, directorate_general, directorate_general_code,
  case_type_ID, case_type, 
  procedure_types, contradictory_aid, existing_aid, notified_aid, unnotified_aid, 
  general_block_exemption, specific_block_exemption,
  notification_date, notification_year, notification_month, notification_day,
  outcome_date, outcome_year, outcome_month, outcome_day,
  decision_number, decision_type_ID, decision_type, phase
)

##################################################
# save
##################################################

# save
save(decisions, file = "data/decisions.RData")

###########################################################################
# end R script
###########################################################################
