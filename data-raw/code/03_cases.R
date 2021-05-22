################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

# load data
load("data-raw/working-files/cases_raw.RData")

# rename
cases <- cases_raw

##################################################
# member state
##################################################

# standardize name
cases$member_state[cases$member_state == "Czechia"] <- "Czech Republic"

# read in member state data
load("data-raw/member_states.RData")

# select variables
member_states <- dplyr::select(member_states, member_state_id, member_state, member_state_code)

# merge
cases <- dplyr::left_join(cases, member_states, by = "member_state")

##################################################
# case type
##################################################

# convert to lower case
cases$case_type[cases$case_type == "Ad Hoc Case"] <- "Ad hoc"
cases$case_type[cases$case_type == "Individual Application"] <- "Individual application"
cases$case_type[cases$case_type == "Not applicable"] <- NA

# schemes = aid awarded through an approved scheme that is not notifiable
# individual application = aid awarded through an approved scheme that is notifiable
# ad hoc = aid not awarded through a scheme

# case type ID
cases$case_type_id <- NA
cases$case_type_id[cases$case_type == "Scheme"] <- 1
cases$case_type_id[cases$case_type == "Individual application"] <- 2
cases$case_type_id[cases$case_type == "Ad hoc"] <- 3

##################################################
# procedure type
##################################################

# procedure type
cases$procedure_types <- cases$procedure_numbers
cases$procedure_types <- stringr::str_replace_all(cases$procedure_types, "[^A-Z, ]", "")

# procedure type dummies
cases$contradictory_aid <- as.numeric(stringr::str_detect(cases$procedure_types, "C(,|$)"))
cases$existing_aid <- as.numeric(stringr::str_detect(cases$procedure_types, "E(,|$)"))
cases$notified_aid <- as.numeric(stringr::str_detect(cases$procedure_types, "N(,|$)"))
cases$unnotified_aid <- as.numeric(stringr::str_detect(cases$procedure_types, "NN(,|$)"))
cases$general_block_exemption <- as.numeric(stringr::str_detect(cases$procedure_types, "X(,|$)"))
cases$specific_block_exemption <- as.numeric(stringr::str_detect(cases$procedure_types, "X[A-Z]?(,|$)"))
cases$monitoring <- as.numeric(stringr::str_detect(cases$procedure_types, "MC(,|$)"))

# table(cases$contradictory_aid)
# table(cases$existing_aid)
# table(cases$notified_aid)
# table(cases$unnotified_aid)
# table(cases$monitoring)
# table(cases$general_block_exemption)
# table(cases$specific_block_exemption)

# check
# cases$check <- cases$contradictory_aid + cases$existing_aid + cases$notified_aid + cases$unnotified_aid + cases$general_block_exemption + cases$specific_block_exemption + cases$monitoring
# table(cases$check)

# drop monitoring procedures
cases <- dplyr::filter(cases, monitoring == 0)

# function to clean aid instruments
clean_procedure_types <- function(x) {

  # split string
  x <- stringr::str_split(x, ",")

  # convert to a string vector
  x <- unlist(x)

  # clean white space
  x <- stringr::str_squish(x)

  # keep non-mising unique values
  x <- unique(x)
  x <- x[x != ""]

  # drop
  x[!(x %in% c("C", "E", "N", "NN", "X", "XA", "XE", "XF", "XP", "XR", "XS", "XT"))] <- ""

  # make corrections
  x[x == "C"] <- "Contradictory aid"
  x[x == "E"] <- "Existing aid"
  x[x == "N"] <- "Notified aid"
  x[x == "NN"] <- "Unnotified aid"
  x[x == "X"] <- "General block exemption"
  x[x %in% c("XA", "XE", "XF", "XP", "XR", "XS", "XT")] <- "Special block exemption"

  # drop empty strings
  x <- x[x != ""]

  # combine into one string
  x <- stringr::str_c(x, collapse = ", ")

  # return cleaned text
  return(x)
}

# clean text
for (i in 1:nrow(cases)) {
  cases$procedure_types[i] <- clean_procedure_types(cases$procedure_types[i])
}
cases$procedure_types[cases$procedure_types == ""] <- NA

# table(cases$procedure_types)

##################################################
# departments
##################################################

# department name
cases$department[cases$department == "Agriculture and Rural Development DG"] <- "Directorate-General for Agriculture and Rural Development"
cases$department[cases$department == "Competition DG"] <- "Directorate-General for Competition"
cases$department[cases$department == "Fisheries and Maritime Affairs DG"] <- "Directorate-General for Maritime Affairs and Fisheries"

# department code
cases$department_code <- ""
cases$department_code[cases$department == "Directorate-General for Agriculture and Rural Development"] <- "AGRI"
cases$department_code[cases$department == "Directorate-General for Competition"] <- "COMP"
cases$department_code[cases$department == "Directorate-General for Maritime Affairs and Fisheries"] <- "MARE"

# department ID
cases$department_id <- 0
cases$department_id[cases$department == "Directorate-General for Agriculture and Rural Development"] <- 127
cases$department_id[cases$department == "Directorate-General for Competition"] <- 89
cases$department_id[cases$department == "Directorate-General for Maritime Affairs and Fisheries"] <- 139

##################################################
# aid instrument
##################################################

# # convert to lower case
# cases$aid_instruments <- stringr::str_to_lower(cases$aid_instruments)
#
# # recode missing
# cases$aid_instruments[cases$aid_instruments == ""] <- NA
#
# # function to clean aid instruments
# clean_aid_instruments <- function(x) {
#
#   # split string
#   x <- stringr::str_split(x, ",")
#
#   # convert to a string vector
#   x <- unlist(x)
#
#   # clean white space
#   x <- stringr::str_squish(x)
#
#   # keep non-mising unique values
#   x <- unique(x)
#   x <- x[x != ""]
#
#   # make corrections
#   x[x == "direct grant/ interest rate subsidy"] <- "direct grant/interest rate subsidy"
#   x[x == "loan/ repayable advances"] <- "loan/repayable advances"
#   x[x == "guarantee (where appropriate with a reference to the commission decision (10))"] <- "guarantee"
#   x[x == "guarantee (where appropriate with a reference to the commission decision (9))"] <- "guarantee"
#   x[x == "through parafiscal charges or taxes affected to a beneficiary"] <- NA
#   x[x == "handling of cases"] <- NA
#   x[x == "article 107(3)(a)"] <- NA
#   x[x == "- horizontal"] <- NA
#   x[x == "other"] <- NA
#   x[x == "rescue and restructuring"] <- NA
#
#   # drop empty strings
#   x <- x[x != ""]
#
#   # order
#   x <- x[order(x)]
#
#   # combine into one string
#   x <- stringr::str_c(x, collapse = ", ")
#
#   # return cleaned text
#   return(x)
# }
#
# # clean text
# for(i in 1:nrow(cases)) {
#   if(!is.na(cases$aid_instruments[i])) {
#     cases$aid_instruments[i] <- clean_aid_instruments(cases$aid_instruments[i])
#   } else {
#     cases$aid_instruments[i] <- NA
#   }
# }
#
# # number of aid instruments
# cases$count_aid_instruments <- stringr::str_count(cases$aid_instruments, ",") + 1
# cases$count_aid_instruments[is.na(cases$aid_instruments)] <- 0

# x <- cases$aid_instruments
# x <- stringr::str_split(x, ",")
# x <- unlist(x)
# x <- stringr::str_squish(x)
# x <- x[x != ""]
# table(x)

##################################################
# decisions
##################################################

# convert to lower case
cases$decisions <- stringr::str_to_lower(cases$decisions)

# function to clean decision text
clean_decisions <- function(x) {

  # split string
  x <- stringr::str_split(x, ",")

  # convert to a string vector
  x <- unlist(x)

  # clean white space
  x <- stringr::str_squish(x)

  # keep non-mising unique values
  x <- unique(x)
  x <- x[x != ""]

  # after a preliminary examination (phase I)

  x[x == "article 4(2) - decision does not constitute aid"] <- "Article 4(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid"
  x[x == "decision does not constitute aid"] <- "Article 4(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid"
  x[x == "decision finding that the measures do not constitute aid"] <- "Article 4(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid"

  x[x == "article 4(3) - decision not to raise objections"] <- "Article 4(3) of Council Regulation (EU) 2015/1589: decision not to raise objections"
  x[x == "decision not to raise objections"] <- "Article 4(3) of Council Regulation (EU) 2015/1589: decision not to raise objections"

  x[x == "article 4(4) - decision to initiate the formal investigation procedure"] <- "Article 4(4) of Council Regulation (EU) 2015/1589: decision to initiate the formal investigation procedure"
  x[x == "decision to initiate the formal investigation procedure"] <- "Article 4(4) of Council Regulation (EU) 2015/1589: decision to initiate the formal investigation procedure"

  x[x == "article 4(4) - decision to extend proceedings"] <- "Article 4(4) of Council Regulation (EU) 2015/1589: decision to extend proceedings"
  x[x == "decision to extend proceedings"] <- "Article 4(4) of Council Regulation (EU) 2015/1589: decision to extend proceedings"

  # after a formal investigation procedure (phase II)

  x[x == "article 7(2) - decision does not constitute aid (after formal investigation procedure)"] <- "Article 9(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid (after formal investigation procedure)"
  x[x == "decision finding that the measures do not constitute aid (after formal investigation procedure)"] <- "Article 9(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid (after formal investigation procedure)"
  x[x == "decision does not constitute aid (after formal investigation procedure)"] <- "Article 9(2) of Council Regulation (EU) 2015/1589: decision does not constitute aid (after formal investigation procedure)"

  x[x == "article 7(3) - positive decision"] <- "Article 9(3) of Council Regulation (EU) 2015/1589: positive decision"
  x[x == "positive decision"] <- "Article 9(3) of Council Regulation (EU) 2015/1589: positive decision"

  x[x == "article 7(4) - conditional decision"] <- "Article 9(4) of Council Regulation (EU) 2015/1589: conditional decision"
  x[x == "conditional decision"] <- "Article 9(4) of Council Regulation (EU) 2015/1589: conditional decision"

  x[x == "article 7(5) and 14(1) - negative decision with recovery"] <- "Articles 9(5) and 16(1) of Council Regulation (EU) 2015/1589: negative decision with recovery"
  x[x == "negative decision with recovery"] <- "Articles 9(5) and 16(1) of Council Regulation (EU) 2015/1589: negative decision with recovery"

  x[x == "article 7(5) and 14(1) - negative decision without recovery"] <- "Articles 9(5) and 16(1) of Council Regulation (EU) 2015/1589: negative decision without recovery"
  x[x == "negative decision without recovery"] <- "Articles 9(5) and 16(1) of Council Regulation (EU) 2015/1589: negative decision without recovery"

  x[x == "article 7(5) - negative decision on notified aid not put into effect"] <- "Article 9(5) of Council Regulation (EU) 2015/1589: negative decision on notified aid"
  x[x == "negative decision on notified aid not put into effect"] <- "Article 9(5) of Council Regulation (EU) 2015/1589: negative decision on notified aid"
  x[x == "article 7(5) only - negative decision on notified aid not put into effect"] <- "Article 9(5) of Council Regulation (EU) 2015/1589: negative decision on notified aid"

  # other types of decisions

  x[x == "article 8(1) - withdrawal of notification (before formal investigation procedure)"] <- "Article 10(1) of Council Regulation (EU) 2015/1589: withdrawal of notification (before formal investigation procedure)"
  x[x == "withdrawal of notification (before formal investigation procedure)"] <- "Article 10(1) of Council Regulation (EU) 2015/1589: withdrawal of notification (before formal investigation procedure)"

  x[x == "article 8(2) - withdrawal of notification (after formal investigation procedure)"] <- "Article 10(2) of Council Regulation (EU) 2015/1589: withdrawal of notification (after formal investigation procedure)"
  x[x == "withdrawal of notification (after formal investigation procedure)"] <- "Article 10(2) of Council Regulation (EU) 2015/1589: withdrawal of notification (after formal investigation procedure)"

  x[x == "article 9 - revocation of a decision"] <- "Article 11 of Council Regulation (EU) 2015/1589: revocation of a decision"
  x[x == "revocation of a decision"] <- "Article 11 of Council Regulation (EU) 2015/1589: revocation of a decision"

  x[x == "article 10(3) - information injunction"] <- "Article 12(3) of Council Regulation (EU) 2015/1589: information injunction"
  x[x == "information injunction"] <- "Article 12(3) of Council Regulation (EU) 2015/1589: information injunction"

  x[x == "suspension injunction"] <- "Article 13(1) of Council Regulation (EU) 2015/1589: suspension injunction"

  x[x == "referral to court of justice (non-compliance with injunction)"] <- "Article 14 of Council Regulation (EU) 2015/1589: referral to the Court of Justice (non-compliance with an injunction)"

  x[x == "article 18 - proposal for appropriate measures"] <- "Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures"
  x[x == "proposal for appropriate measures"] <- "Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures"

  x[x == "ec treaty - referral to the court of justice (non-compliance with court judgment)"] <- "Article 260(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Court judgment)"
  x[x == "referral to the court of justice (non-compliance with court judgment) – ex article 228(2) ec treaty"] <- "Article 260(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Court judgment)"

  x[x == "referral to the court of justice (non-implementation of commission decision) (ex article 88(2) ec)"] <- "Article 108(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Commission decision)"

  x[x == "article 23 - referral to court of justice (non-compliance with decisions)"] <- "Article 108(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Commission decision)"
  x[x == "referral to court of justice (non-compliance with decisions)"] <- "Article 108(2) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Commission decision)"

  # other
  x[x == "corrigendum"] <- ""
  x[x == "other"] <- ""
  x[x == "expected"] <- ""
  x[x == "gber – approval of the evaluation plan"] <- ""

  # drop empty strings
  x <- x[x != ""]

  # combine into one string
  x <- stringr::str_c(x, collapse = "; ")

  # recode missing
  if (x == "") {
    x <- NA
  }

  # return cleaned text
  return(x)
}

# clean decision text
for (i in 1:nrow(cases)) {
  if (cases$decisions[i] != "") {
    cases$decisions[i] <- clean_decisions(cases$decisions[i])
  } else {
    cases$decisions[i] <- NA
  }
}

# recode missing
cases$decisions[is.na(cases$decisions)] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3)"
cases$decisions[cases$decisions == "Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures"] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3); Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures"
cases$decisions[cases$decisions == "Article 12(3) of Council Regulation (EU) 2015/1589: information injunction"] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3); Article 12(3) of Council Regulation (EU) 2015/1589: information injunction"
cases$decisions[cases$decisions == "Article 12(3) of Council Regulation (EU) 2015/1589: information injunction; Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures"] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3); Article 12(3) of Council Regulation (EU) 2015/1589: information injunction; Article 22 of Council Regulation (EU) 2015/1589: proposal for appropriate measures"

# number of decisions
cases$count_decisions <- stringr::str_count(cases$decisions, ";") + 1

# investigations
cases$formal_investigation <- as.numeric(stringr::str_detect(cases$decisions, "decision to initiate the formal investigation procedure"))
cases$exempt <- as.numeric(stringr::str_detect(cases$decisions, "exempt"))
cases$preliminary_investigation <- 1 - cases$exempt

# outcomes
cases$negative <- as.numeric(stringr::str_detect(cases$decisions, "negative decision"))
cases$positive <- as.numeric(stringr::str_detect(cases$decisions, "positive decision"))
cases$conditional <- as.numeric(stringr::str_detect(cases$decisions, "conditional decision"))
cases$withdrawal <- as.numeric(stringr::str_detect(cases$decisions, "withdrawal"))
cases$not_aid <- as.numeric(stringr::str_detect(cases$decisions, "does not constitute aid"))
cases$no_objection <- as.numeric(stringr::str_detect(cases$decisions, "decision not to raise objections"))

# other
cases$referral <- as.numeric(stringr::str_detect(cases$decisions, "referral"))
cases$recovery <- as.numeric(stringr::str_detect(cases$decisions, "negative decision with recovery"))

# preliminary investigation outcome
cases$outcome_phase_1 <- "Not applicable"
cases$outcome_phase_1[cases$not_aid == 1 & cases$formal_investigation == 0] <- "Does not constitute aid"
cases$outcome_phase_1[cases$no_objection == 1 & cases$formal_investigation == 0] <- "No objection"
cases$outcome_phase_1[cases$withdrawal == 1 & cases$formal_investigation == 0] <- "Notification withdrawn"
cases$outcome_phase_1[cases$formal_investigation == 1] <- "Formal investigation"

# table(cases$outcome_phase_1)

# formal investigation outcome
cases$outcome_phase_2 <- "Not applicable"
cases$outcome_phase_2[cases$formal_investigation == 1] <- "Missing record"
cases$outcome_phase_2[cases$conditional == 1 & cases$formal_investigation == 1] <- "Conditional decision"
cases$outcome_phase_2[cases$negative == 1 & cases$formal_investigation == 1] <- "Negative decision"
cases$outcome_phase_2[cases$positive == 1 & cases$formal_investigation == 1] <- "Positive decision"
cases$outcome_phase_2[cases$not_aid == 1 & cases$formal_investigation == 1] <- "Does not constitute aid"
cases$outcome_phase_2[cases$withdrawal == 1 & cases$formal_investigation == 1] <- "Notification withdrawn"

# table(cases$outcome_phase_2)

# overall outcome
cases$outcome <- "Missing"
cases$outcome[cases$formal_investigation == 1] <- "Missing record"
cases$outcome[cases$exempt == 1] <- "Exempt from notification"
cases$outcome[cases$no_objection == 1] <- "No objection"
cases$outcome[cases$not_aid == 1] <- "Does not constitute aid"
cases$outcome[cases$conditional == 1] <- "Conditional decision"
cases$outcome[cases$negative == 1] <- "Negative decision"
cases$outcome[cases$positive == 1] <- "Positive decision"
cases$outcome[cases$withdrawal == 1] <- "Notification withdrawn"

# table(cases$outcome)

# x <- cases$decisions
# x <- stringr::str_split(x, ";")
# x <- unlist(x)
# x <- stringr::str_squish(x)
# x <- x[x != ""]
# unique(x)

##################################################
# NACE codes
##################################################

# # recode missing
# cases$NACE_codes[cases$NACE_codes == ""] <- NA
#
# # function to clean aid instruments
# clean_NACE_codes <- function(x) {
#
#   # split string
#   x <- stringr::str_extract_all(x, "[A-Z]+(\\.[0-9]+)* -")
#
#   # convert to a string vector
#   x <- unlist(x)
#
#   # clean text
#   x <- stringr::str_replace(x, "-", "")
#
#   # clean white space
#   x <- stringr::str_squish(x)
#
#   # keep non-mising unique values
#   x <- unique(x)
#
#   # order
#   x <- x[order(x)]
#
#   # combine into one string
#   x <- stringr::str_c(x, collapse = ", ")
#
#   # return cleaned text
#   return(x)
# }
#
# # clean decision text
# for(i in 1:nrow(cases)) {
#   if(!is.na(cases$NACE_codes[i])) {
#     cases$NACE_codes[i] <- clean_NACE_codes(cases$NACE_codes[i])
#   } else {
#     cases$NACE_codes[i] <- NA
#   }
# }
#
# # number of decisions
# cases$count_NACE_codes <- stringr::str_count(cases$NACE_codes, ",") + 1
# cases$count_NACE_codes[is.na(cases$NACE_codes)] <- 0

# x <- cases$NACE_codes
# x <- stringr::str_split(x, ",")
# x <- unlist(x)
# x <- stringr::str_squish(x)
# x <- x[x != ""]
# table(x)

##################################################
# related cases
##################################################

# # recode missing values
# cases$related_cases[cases$related_cases == ""] <- NA
#
# # function to clean aid instruments
# clean_related_cases <- function(x) {
#
#   # split string
#   x <- stringr::str_split(x, ",")
#
#   # convert to a string vector
#   x <- unlist(x)
#
#   # clean white space
#   x <- stringr::str_squish(x)
#
#   # keep non-mising unique values
#   x <- unique(x)
#
#   # order
#   x <- x[order(x)]
#
#   # combine into one string
#   x <- stringr::str_c(x, collapse = ", ")
#
#   # return cleaned text
#   return(x)
# }
#
# # clean decision text
# for(i in 1:nrow(cases)) {
#   if(!is.na(cases$related_cases[i])) {
#     cases$related_cases[i] <- clean_related_cases(cases$related_cases[i])
#   } else {
#     cases$related_cases[i] <- NA
#   }
# }
#
# # number of related cases
# cases$count_related_cases <- stringr::str_count(cases$related_cases, ",") + 1
# cases$count_related_cases[is.na(cases$related_cases)] <- 0

##################################################
# official journal citations
##################################################

# # recode missing
# cases$OJ_citations[is.na(cases$OJ_citations)] <- NA
# cases$OJ_citations[cases$OJ_citations == ""] <- NA
#
# # function to clean aid instruments
# clean_OJ_citations <- function(x) {
#
#   # split string
#   x <- stringr::str_split(x, ",")
#
#   # convert to a string vector
#   x <- unlist(x)
#
#   # clean white space
#   x <- stringr::str_squish(x)
#
#   # keep non-mising unique values
#   x <- unique(x)
#
#   # keep correctly formatted values
#   x <- x[stringr::str_detect(x, "^JOCE C.[0-9]+.[0-9]{4}$")]
#
#   # order
#   x <- x[order(x)]
#
#   # combine into one string
#   x <- stringr::str_c(x, collapse = ", ")
#
#   # handle missing
#   if(x == "") {
#     x <- NA
#   }
#
#   # return cleaned text
#   return(x)
# }
#
# # clean decision text
# for(i in 1:nrow(cases)) {
#   if(!is.na(cases$OJ_citations[i])) {
#     cases$OJ_citations[i] <- clean_OJ_citations(cases$OJ_citations[i])
#   } else {
#     cases$OJ_citations[i] <- NA
#   }
# }
#
# # replace JOCE with OJ
# cases$OJ_citations <- stringr::str_replace_all(cases$OJ_citations, "JOCE", "OJ")
#
# # count citations
# cases$count_OJ_citations <- stringr::str_count(cases$OJ_citations, ",") + 1
# cases$count_OJ_citations[is.na(cases$OJ_citations)] <- 0

##################################################
# dates
##################################################

# start date
# cases$start_date <- lubridate::dmy(cases$start_date)
# cases$start_date <- lubridate::ymd(cases$start_date)

# end date
# cases$end_date <- lubridate::dmy(cases$end_date)
# cases$end_date <- lubridate::ymd(cases$end_date)

# notification date
cases$notification_date <- lubridate::dmy(cases$notification_date)
cases$notification_date <- lubridate::ymd(cases$notification_date)

# outcome date
cases$outcome_date <- lubridate::dmy(cases$outcome_date)
cases$outcome_date <- lubridate::ymd(cases$outcome_date)

# state date variables
# cases$start_year <- lubridate::year(cases$start_date)
# cases$start_month <- lubridate::month(cases$start_date)
# cases$start_day <- lubridate::day(cases$start_date)

# end date variables
# cases$end_year <- lubridate::year(cases$end_date)
# cases$end_month <- lubridate::month(cases$end_date)
# cases$end_day <- lubridate::day(cases$end_date)

# notification date variables
cases$notification_year <- lubridate::year(cases$notification_date)
cases$notification_month <- lubridate::month(cases$notification_date)
cases$notification_day <- lubridate::day(cases$notification_date)

# decision date variables
cases$outcome_year <- lubridate::year(cases$outcome_date)
cases$outcome_month <- lubridate::month(cases$outcome_date)
cases$outcome_day <- lubridate::day(cases$outcome_date)

##################################################
# case title
##################################################

# # clean text
# cases$case_title <- stringr::str_to_lower(cases$case_title)
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[[:punct:]]+", " ")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[€$£+]", " ")
# cases$case_title <- stringr::str_squish(cases$case_title)
#
# # convert to ASCII
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[áàăâåäãąā]", "a")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[æ]", "ae")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ćčç]", "c")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[đ]", "d")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[éèêěëėęē]", "e")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ģ]", "g")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[íìîïįī]", "i")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ķ]", "k")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ľļł]", "l")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ńňñņ]", "n")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[óòôöőõø]", "o")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[œ]", "oe")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ř]", "r")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[śšşș]", "s")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ß]", "ss")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ťţț]", "t")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[úùûůüűųū]", "u")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[ý]", "y")
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[źžż]", "z")
#
# # remove non-ASCII characters
# cases$case_title <- stringr::str_replace_all(cases$case_title, "[^a-z0-9 ]*", "")
#
# # fix white space
# cases$case_title <- stringr::str_squish(cases$case_title)
#
# # recode white space
# cases$case_title[cases$case_title == ""] <- NA

# x <- stringr::str_split(cases$case_title, "")
# x <- unlist(x)
# x <- unique(x)
# x <- x[order(x)]
# x

##################################################
# organize
##################################################

# sort
cases <- dplyr::arrange(cases, notification_date, member_state_id, case_number)

# key ID
cases$key_id <- 1:nrow(cases)

# select variables
cases <- dplyr::select(
  cases,
  key_id, case_number,
  procedure_numbers,
  member_state_id, member_state, member_state_code,
  department_id, department, department_code,
  case_type_id, case_type,
  procedure_types, contradictory_aid, existing_aid, notified_aid, unnotified_aid,
  general_block_exemption, specific_block_exemption,
  notification_date, notification_year, notification_month, notification_day,
  outcome_date, outcome_year, outcome_month, outcome_day,
  decisions, count_decisions,
  outcome, outcome_phase_1, outcome_phase_2,
  exempt, preliminary_investigation, formal_investigation,
  no_objection, not_aid, positive, negative, conditional, withdrawal,
  referral, recovery
  # start_date, end_date,
  # aid_instruments, count_aid_instruments,
  # NACE_codes, count_NACE_codes,
  # OJ_citations, count_OJ_citations,
  # related_cases, count_related_cases
)

##################################################
# save
##################################################

# save
save(cases, file = "data/cases.RData")

################################################################################
# end R script
################################################################################
