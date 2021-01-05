###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# read in data
member_states <- read.csv("data-raw/member-states.csv", stringsAsFactors = FALSE)

# member state data
member_states <- dplyr::select(member_states, member_state_ID, member_state, member_state_code)

# directorate general data
directorates_general <- dplyr::tibble(
  directorate_general_ID = c(1, 2, 3),
  directorate_general = c("Competition", "Agriculture and Rural Development", "Maritime Affairs and Fisheries"),
  directorate_general_code = c("COMP", "AGRI", "MARE")
)

# case types
case_types <- dplyr::tibble(
 case_type_ID = c(1, 2, 3),
 case_type = c("Scheme", "Individual application", "Ad hoc")
)

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

# read in data
load("data/cases.RData")
load("data/decisions.RData")

# rename variables
cases <- dplyr::rename(cases, year = notification_year)
decisions <- dplyr::rename(decisions, year = notification_year)

# filter
cases <- dplyr::filter(cases, !is.na(year))
decisions <- dplyr::filter(decisions, !is.na(year))
cases <- dplyr::filter(cases, !is.na(case_type))
decisions <- dplyr::filter(decisions, !is.na(case_type))

###########################################################################
# end R script
###########################################################################
