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
                  "member_state", "regions", "NACE_code", "aid_instrument", "case_type",
                  "start_date", "end_date", "notification_date",
                  "decisions", "objectives", "decision_date", "OJ_info", "related_cases", "DG_responsible",
                  "expenditures")

# select variables
cases <- dplyr::select(
  cases,
  case_number, procedure_number, case_title, member_state, NACE_code,
  aid_instrument, case_type, start_date, end_date, notification_date, decision_date,
  decisions, objectives, related_cases, DG_responsible
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
cases$aid_instrument <- stringr::str_to_lower(cases$aid_instrument)

# recode missing
cases$aid_instrument[cases$aid_instrument == ""] <- NA

# table(cases$aid_instrument, useNA = "always")

##################################################
# decisions
##################################################

# convert to lower case
cases$decisions <- stringr::str_to_lower(cases$decisions)

x <- unique(cases$decisions)
x <- stringr::str_split(x, ",")
x <- unlist(x)
x <- stringr::str_squish(x)
x <- x[x != ""]
x <- unique(x)

##################################################
# clean dates
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


###########################################################################
# end R script
###########################################################################
