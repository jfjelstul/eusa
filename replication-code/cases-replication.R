###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# load data
load("data-raw/cases_raw.RData")

# rename
cases <- cases_raw

##################################################
# member state
##################################################

# standardize name
cases$member_state[cases$member_state == "Czechia"] <- "Czech Republic"

##################################################
# case type
##################################################

# convert to lower case
cases$case_type <- stringr::str_to_lower(cases$case_type)

##################################################
# DG variables
##################################################

# standardize DG names
cases$directorate_general[cases$directorate_general == "Agriculture and Rural Development DG"] <- "Agriculture and Rural Development"
cases$directorate_general[cases$directorate_general == "Competition DG"] <- "Competition"
cases$directorate_general[cases$directorate_general == "Fisheries and Maritime Affairs DG"] <- "Maritime Affairs and Fisheries"

# DG code
cases$directorate_general_code <- ""
cases$directorate_general_code[cases$directorate_general == "Agriculture and Rural Development"] <- "AGRI"
cases$directorate_general_code[cases$directorate_general == "Competition"] <- "COMP"
cases$directorate_general_code[cases$directorate_general == "Maritime Affairs and Fisheries"] <- "MARE"

##################################################
# aid instrument
##################################################

# convert to lower case
cases$aid_instruments <- stringr::str_to_lower(cases$aid_instruments)

# recode missing
cases$aid_instruments[cases$aid_instruments == ""] <- NA

# function to clean aid instruments
clean_aid_instruments <- function(x) {

  # split string
  x <- stringr::str_split(x, ",")

  # convert to a string vector
  x <- unlist(x)

  # clean white space
  x <- stringr::str_squish(x)

  # keep non-mising unique values
  x <- unique(x)
  x <- x[x != ""]

  # make corrections
  x[x == "direct grant/ interest rate subsidy"] <- "direct grant/interest rate subsidy"
  x[x == "loan/ repayable advances"] <- "loan/repayable advances"
  x[x == "guarantee (where appropriate with a reference to the commission decision (10))"] <- "guarantee"
  x[x == "guarantee (where appropriate with a reference to the commission decision (9))"] <- "guarantee"
  x[x == "through parafiscal charges or taxes affected to a beneficiary"] <- NA
  x[x == "handling of cases"] <- NA
  x[x == "article 107(3)(a)"] <- NA
  x[x == "- horizontal"] <- NA
  x[x == "other"] <- NA
  x[x == "rescue and restructuring"] <- NA

  # drop empty strings
  x <- x[x != ""]

  # order
  x <- x[order(x)]

  # combine into one string
  x <- stringr::str_c(x, collapse = ", ")

  # return cleaned text
  return(x)
}

# clean decision text
for(i in 1:nrow(cases)) {
  if(!is.na(cases$aid_instruments[i])) {
    cases$aid_instruments[i] <- clean_aid_instruments(cases$aid_instruments[i])
  } else {
    cases$aid_instruments[i] <- NA
  }
}

# number of decisions
cases$count_aid_instruments <- stringr::str_count(cases$aid_instruments, ",") + 1
cases$count_aid_instruments[is.na(cases$aid_instruments)] <- 0

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

  x[x == "article 4(2) - decision does not constitute aid"] <- "Article 4(2) of Council Regulation (EC) No 659/1999: decision does not constitute aid"
  x[x == "decision does not constitute aid"] <- "Article 4(2) of Council Regulation (EC) No 659/1999: decision does not constitute aid"
  x[x == "decision finding that the measures do not constitute aid"] <- "Article 4(2) of Council Regulation (EC) No 659/1999: decision does not constitute aid"

  x[x == "article 4(3) - decision not to raise objections"] <- "Article 4(3) of Council Regulation (EC) No 659/1999: decision not to raise objections"
  x[x == "decision not to raise objections"] <- "Article 4(3) of Council Regulation (EC) No 659/1999: decision not to raise objections"

  x[x == "article 4(4) - decision to initiate the formal investigation procedure"] <- "Article 4(4) of Council Regulation (EC) No 659/1999: decision to initiate the formal investigation procedure"
  x[x == "decision to initiate the formal investigation procedure"] <- "Article 4(4) of Council Regulation (EC) No 659/1999: decision to initiate the formal investigation procedure"

  x[x == "article 4(4) - decision to extend proceedings"] <- "Article 4(4) of Council Regulation (EC) No 659/1999: decision to extend proceedings"
  x[x == "decision to extend proceedings"] <- "Article 4(4) of Council Regulation (EC) No 659/1999: decision to extend proceedings"

  # after a formal investigation procedure (phase II)

  x[x == "article 7(2) - decision does not constitute aid (after formal investigation procedure)"] <- "Article 7(2) of Council Regulation (EC) No 659/1999: decision does not constitute aid (after formal investigation procedure)"
  x[x == "decision finding that the measures do not constitute aid (after formal investigation procedure)"] <- "Article 7(2) of Council Regulation (EC) No 659/1999: decision does not constitute aid (after formal investigation procedure)"
  x[x == "decision does not constitute aid (after formal investigation procedure)"] <- "Article 7(2) of Council Regulation (EC) No 659/1999: decision does not constitute aid (after formal investigation procedure)"

  x[x == "article 7(3) - positive decision"] <- "Article 7(3) of Council Regulation (EC) No 659/1999: positive decision"
  x[x == "positive decision"] <- "Article 7(3) of Council Regulation (EC) No 659/1999: positive decision"

  x[x == "article 7(4) - conditional decision"] <- "Article 7(4) of Council Regulation (EC) No 659/1999: conditional decision"
  x[x == "conditional decision"] <- "Article 7(4) of Council Regulation (EC) No 659/1999: conditional decision"

  x[x == "article 7(5) and 14(1) - negative decision with recovery"] <- "Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999: negative decision with recovery"
  x[x == "negative decision with recovery"] <- "Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999: negative decision with recovery"

  x[x == "article 7(5) and 14(1) - negative decision without recovery"] <- "Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999: negative decision without recovery"
  x[x == "negative decision without recovery"] <- "Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999: negative decision without recovery"

  x[x == "article 7(5) - negative decision on notified aid not put into effect"] <- "Article 7(5) of Council Regulation (EC) No 659/1999: negative decision on notified aid"
  x[x == "negative decision on notified aid not put into effect"] <- "Article 7(5) of Council Regulation (EC) No 659/1999: negative decision on notified aid"
  x[x == "article 7(5) only - negative decision on notified aid not put into effect"] <- "Article 7(5) of Council Regulation (EC) No 659/1999: negative decision on notified aid"

  # other types of decisions

  x[x == "article 8(1) - withdrawal of notification (before formal investigation procedure)"] <- "Article 8(1) of Council Regulation (EC) No 659/1999: withdrawal of notification (before formal investigation procedure)"
  x[x == "withdrawal of notification (before formal investigation procedure)"] <- "Article 8(1) of Council Regulation (EC) No 659/1999: withdrawal of notification (before formal investigation procedure)"

  x[x == "article 8(2) - withdrawal of notification (after formal investigation procedure)"] <- "Article 8(2) of Council Regulation (EC) No 659/1999: withdrawal of notification (after formal investigation procedure)"
  x[x == "withdrawal of notification (after formal investigation procedure)"] <- "Article 8(2) of Council Regulation (EC) No 659/1999: withdrawal of notification (after formal investigation procedure)"

  x[x == "article 9 - revocation of a decision"] <- "Article 9 of Council Regulation (EC) No 659/1999: revocation of a decision"
  x[x == "revocation of a decision"] <- "Article 9 of Council Regulation (EC) No 659/1999: revocation of a decision"

  x[x == "article 10(3) - information injunction"] <- "Article 10(3) of Council Regulation (EC) No 659/1999: information injunction"
  x[x == "information injunction"] <- "Article 10(3) of Council Regulation (EC) No 659/1999: information injunction"

  x[x == "suspension injunction"] <- "Article 11(1) of Council Regulation (EC) No 659/1999: suspension injunction"

  x[x == "referral to court of justice (non-compliance with injunction)"] <- "Article 12 of Council Regulation (EC) No 659/1999: referral to the Court of Justice (non-compliance with an injunction)"

  x[x == "article 18 - proposal for appropriate measures"] <- "Article 18 of Council Regulation (EC) No 659/1999: proposal for appropriate measures"
  x[x == "proposal for appropriate measures"] <- "Article 18 of Council Regulation (EC) No 659/1999: proposal for appropriate measures"

  x[x == "ec treaty - referral to the court of justice (non-compliance with court judgment)"] <- "Article 260(2) (ex Article 228(2)) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Court judgment)"
  x[x == "referral to the court of justice (non-compliance with court judgment) – ex article 228(2) ec treaty"] <- "Article 260(2) (ex Article 228(2)) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-compliance with a Court judgment)"

  x[x == "referral to the court of justice (non-implementation of commission decision) (ex article 88(2) ec)"] <- "Article 108(2) (ex Article 88(2)) of the Treaty on the Functioning of the European Union (TFEU): referral to the Court of Justice (non-implementation of Commission decision)"

  x[x == "article 23 - referral to court of justice (non-compliance with decisions)"] <- "Article 23(1) of Council Regulation (EC) No 659/1999: referral to the Court of Justice (non-compliance with a decision)"
  x[x == "referral to court of justice (non-compliance with decisions)"] <- "Article 23(1) of Council Regulation (EC) No 659/1999: referral to the Court of Justice (non-compliance with a decision)"

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
  if(x == "") {
    x <- NA
  }

  # return cleaned text
  return(x)
}

# clean decision text
for(i in 1:nrow(cases)) {
  if(cases$decisions[i] != "") {
    cases$decisions[i] <- clean_decisions(cases$decisions[i])
  } else {
    cases$decisions[i] <- NA
  }
}

# recode missing
cases$decisions[is.na(cases$decisions)] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3)"
cases$decisions[cases$decisions == "Article 18 of Council Regulation (EC) No 659/1999: proposal for appropriate measures"] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3); Article 18 of Council Regulation (EC) No 659/1999: proposal for appropriate measures"
cases$decisions[cases$decisions == "Article 10(3) of Council Regulation (EC) No 659/1999: information injunction"] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3); Article 10(3) of Council Regulation (EC) No 659/1999: information injunction"
cases$decisions[cases$decisions == "Article 10(3) of Council Regulation (EC) No 659/1999: information injunction; Article 18 of Council Regulation (EC) No 659/1999: proposal for appropriate measures"] <- "Article 108(4) of the Treaty on the Functioning of the European Union (TFEU): exempt from notification under Article 108(3); Article 10(3) of Council Regulation (EC) No 659/1999: information injunction; Article 18 of Council Regulation (EC) No 659/1999: proposal for appropriate measures"

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
cases$outcome_preliminary <- "exempt from notification"
cases$outcome_preliminary[cases$not_aid == 1 & cases$formal_investigation == 0] <- "does not constitute aid"
cases$outcome_preliminary[cases$no_objection == 1 & cases$formal_investigation == 0] <- "no objection"
cases$outcome_preliminary[cases$formal_investigation == 1] <- "formal investigation"

# table(cases$outcome_preliminary)

# formal investigation outcome
cases$outcome_formal <- "not applicable"
cases$outcome_formal[cases$formal_investigation == 1] <- "missing record"
cases$outcome_formal[cases$conditional == 1 & cases$formal_investigation == 1] <- "conditional decision"
cases$outcome_formal[cases$negative == 1 & cases$formal_investigation == 1] <- "negative decision"
cases$outcome_formal[cases$positive == 1 & cases$formal_investigation == 1] <- "positive decision"
cases$outcome_formal[cases$not_aid == 1 & cases$formal_investigation == 1] <- "does not constitute aid"
cases$outcome_formal[cases$withdrawal == 1 & cases$formal_investigation == 1] <- "notification withdrawn"

# table(cases$outcome_formal)

# overall outcome
cases$outcome <- "missing"
cases$outcome[cases$formal_investigation == 1] <- "missing record (formal investigation)"
cases$outcome[cases$exempt == 1] <- "exempt from notification"
cases$outcome[cases$no_objection == 1] <- "no objection"
cases$outcome[cases$not_aid == 1] <- "does not constitute aid"
cases$outcome[cases$conditional == 1] <- "conditional decision"
cases$outcome[cases$negative == 1] <- "negative decision"
cases$outcome[cases$positive == 1] <- "positive decision"
cases$outcome[cases$withdrawal == 1] <- "notification withdrawn"

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

# recode missing
cases$NACE_codes[cases$NACE_codes == ""] <- NA

# function to clean aid instruments
clean_NACE_codes <- function(x) {

  # split string
  x <- stringr::str_extract_all(x, "[A-Z]+(\\.[0-9]+)* -")

  # convert to a string vector
  x <- unlist(x)

  # clean text
  x <- stringr::str_replace(x, "-", "")

  # clean white space
  x <- stringr::str_squish(x)

  # keep non-mising unique values
  x <- unique(x)

  # order
  x <- x[order(x)]

  # combine into one string
  x <- stringr::str_c(x, collapse = ", ")

  # return cleaned text
  return(x)
}

# clean decision text
for(i in 1:nrow(cases)) {
  if(!is.na(cases$NACE_codes[i])) {
    cases$NACE_codes[i] <- clean_NACE_codes(cases$NACE_codes[i])
  } else {
    cases$NACE_codes[i] <- NA
  }
}

# number of decisions
cases$count_NACE_codes <- stringr::str_count(cases$NACE_codes, ",") + 1
cases$count_NACE_codes[is.na(cases$NACE_codes)] <- 0

# x <- cases$NACE_codes
# x <- stringr::str_split(x, ",")
# x <- unlist(x)
# x <- stringr::str_squish(x)
# x <- x[x != ""]
# table(x)

##################################################
# related cases
##################################################

# recode missing values
cases$related_cases[cases$related_cases == ""] <- NA

# function to clean aid instruments
clean_related_cases <- function(x) {

  # split string
  x <- stringr::str_split(x, ",")

  # convert to a string vector
  x <- unlist(x)

  # clean white space
  x <- stringr::str_squish(x)

  # keep non-mising unique values
  x <- unique(x)

  # order
  x <- x[order(x)]

  # combine into one string
  x <- stringr::str_c(x, collapse = ", ")

  # return cleaned text
  return(x)
}

# clean decision text
for(i in 1:nrow(cases)) {
  if(!is.na(cases$related_cases[i])) {
    cases$related_cases[i] <- clean_related_cases(cases$related_cases[i])
  } else {
    cases$related_cases[i] <- NA
  }
}

# number of related cases
cases$count_related_cases <- stringr::str_count(cases$related_cases, ",") + 1
cases$count_related_cases[is.na(cases$related_cases)] <- 0

##################################################
# official journal citations
##################################################

# recode missing
cases$OJ_citations[is.na(cases$OJ_citations)] <- NA
cases$OJ_citations[cases$OJ_citations == ""] <- NA

# function to clean aid instruments
clean_OJ_citations <- function(x) {

  # split string
  x <- stringr::str_split(x, ",")

  # convert to a string vector
  x <- unlist(x)

  # clean white space
  x <- stringr::str_squish(x)

  # keep non-mising unique values
  x <- unique(x)

  # keep correctly formatted values
  x <- x[stringr::str_detect(x, "^JOCE C.[0-9]+.[0-9]{4}$")]

  # order
  x <- x[order(x)]

  # combine into one string
  x <- stringr::str_c(x, collapse = ", ")

  # handle missing
  if(x == "") {
    x <- NA
  }

  # return cleaned text
  return(x)
}

# clean decision text
for(i in 1:nrow(cases)) {
  if(!is.na(cases$OJ_citations[i])) {
    cases$OJ_citations[i] <- clean_OJ_citations(cases$OJ_citations[i])
  } else {
    cases$OJ_citations[i] <- NA
  }
}

# replace JOCE with OJ
cases$OJ_citations <- stringr::str_replace_all(cases$OJ_citations, "JOCE", "OJ")

# count citations
cases$count_OJ_citations <- stringr::str_count(cases$OJ_citations, ",") + 1
cases$count_OJ_citations[is.na(cases$OJ_citations)] <- 0

##################################################
# dates
##################################################

# start date
cases$start_date <- lubridate::dmy(cases$start_date)
cases$start_date <- lubridate::ymd(cases$start_date)

# end date
cases$end_date <- lubridate::dmy(cases$end_date)
cases$end_date <- lubridate::ymd(cases$end_date)

# notification date
cases$notification_date <- lubridate::dmy(cases$notification_date)
cases$notification_date <- lubridate::ymd(cases$notification_date)

# decision date
cases$decision_date <- lubridate::dmy(cases$decision_date)
cases$decision_date <- lubridate::ymd(cases$decision_date)
cases$decision_date[cases$count_decisions == 0] <- NA

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
cases <- dplyr::arrange(cases, notification_date, member_state, case_number)

# key ID
cases$key_ID <- 1:nrow(cases)

# select variables
cases <- dplyr::select(
  cases,
  key_ID, case_number, procedure_number,
  member_state, directorate_general, directorate_general_code,
  case_type,
  notification_date, decision_date,
  decisions, count_decisions,
  outcome, outcome_preliminary, outcome_formal,
  exempt, preliminary_investigation, formal_investigation,
  no_objection, not_aid, positive, negative, conditional, withdrawal,
  referral, recovery,
  start_date, end_date,
  aid_instruments, count_aid_instruments,
  NACE_codes, count_NACE_codes,
  OJ_citations, count_OJ_citations
)

##################################################
# save
##################################################

# save
save(cases, file = "data/cases.RData")
write.csv(cases, "data/cases.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
