###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

##################################################
# function to parse HTML
##################################################

parse_HTML <- function(file) {
  html <- file %>% xml2::read_html()
  table <- html %>%
    rvest::html_nodes("table") %>%
    rvest::html_table(fill = TRUE)
  table <- as.data.frame(table[[1]], stringsAsFactors = TRUE)
  return(table)
}

##################################################
# read in data
##################################################

# get list of files
files <- stringr::str_c("data-raw/cases/", list.files("data-raw/cases/"))

# read in data
raw <- list()
for(i in 1:length(files)) {
  raw[[i]] <- parse_HTML(files[i])
}
rm(i, files)

# stack data frames
cases <- dplyr::bind_rows(raw)

# variable names
names(cases) <- c("case_number", "procedure_number", "case_title", "case_title_original",
                  "member_state", "regions", "NACE_codes", "aid_instruments", "case_type",
                  "start_date", "end_date", "notification_date",
                  "decisions", "objectives", "decision_date", "OJ_citations", "related_cases", "directorate_general",
                  "expenditures")

# select variables
cases <- dplyr::select(
  cases,
  case_number, procedure_number, case_title, member_state, NACE_codes,
  aid_instruments, case_type, start_date, end_date, notification_date, decision_date,
  decisions, OJ_citations, related_cases, directorate_general
)

##################################################
# case type
##################################################

# convert to lower case
cases$case_type <- stringr::str_to_lower(cases$case_type)

# table(cases$case_type, useNA = "always")

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

# clean decison text
for(i in 1:nrow(cases)) {
  if(cases$decisions[i] != "") {
    cases$decisions[i] <- clean_decisions(cases$decisions[i])
  } else {
    cases$decisions[i] <- NA
  }
}

# number of decisions
cases$count_decisions <- stringr::str_count(cases$decisions, ";") + 1
cases$count_decisions[is.na(cases$decisions)] <- 0

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
# case title
##################################################

# clean text
cases$case_title <- stringr::str_to_lower(cases$case_title)
cases$case_title <- stringr::str_replace_all(cases$case_title, "[[:punct:]]+", " ")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[€$£+]", " ")
cases$case_title <- stringr::str_squish(cases$case_title)

# convert to ASCII
cases$case_title <- stringr::str_replace_all(cases$case_title, "[áàăâåäãąā]", "a")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[æ]", "ae")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ćčç]", "c")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[đ]", "d")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[éèêěëėęē]", "e")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ģ]", "g")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[íìîïįī]", "i")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ķ]", "k")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ľļł]", "l")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ńňñņ]", "n")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[óòôöőõø]", "o")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[œ]", "oe")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ř]", "r")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[śšşș]", "s")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ß]", "ss")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ťţț]", "t")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[úùûůüűųū]", "u")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[ý]", "y")
cases$case_title <- stringr::str_replace_all(cases$case_title, "[źžż]", "z")

# remove non-ASCII characters
cases$case_title <- stringr::str_replace_all(cases$case_title, "[^a-z0-9 ]*", "")

# fix white space
cases$case_title <- stringr::str_squish(cases$case_title)

# recode white space
cases$case_title[cases$case_title == ""] <- NA

# x <- stringr::str_split(cases$case_title, "")
# x <- unlist(x)
# x <- unique(x)
# x <- x[order(x)]
# x

##################################################
# organize
##################################################

# key ID
cases$key_ID <- 1:nrow(cases)

# select variables
cases <- dplyr::select(
  cases,
  key_ID, case_number, procedure_number,
  member_state, directorate_general, directorate_general_code,
  case_type, case_title,
  start_date, end_date, notification_date, decision_date,
  decisions, count_decisions,
  aid_instruments, count_aid_instruments,
  NACE_codes, count_NACE_codes,
  OJ_citations, count_OJ_citations,
  related_cases, count_related_cases
)

###########################################################################
# decisions
###########################################################################

# one decision per row
decisions <- tidyr::separate_rows(cases, decisions, sep = "; ")

# rename variable
decisions <- dplyr::rename(decisions, decision = decisions)

# drop cases with no decisions
decisions <- dplyr::filter(decisions, decision != "none")

# key ID
decisions$key_ID <- 1:nrow(decisions)

# select variables
decisions <- dplyr::select(
  decisions,
  key_ID, case_number, procedure_number,
  member_state, directorate_general, directorate_general_code,
  decision
  # case_type, case_title,
  # start_date, end_date, notification_date, decision_date,
  # aid_instruments, count_aid_instruments,
  # NACE_codes, count_NACE_codes,
  # OJ_citations, count_OJ_citations,
  # related_cases, count_related_cases
)

###########################################################################
# end R script
###########################################################################
