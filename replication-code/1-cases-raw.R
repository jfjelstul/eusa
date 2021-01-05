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
cases_raw <- dplyr::bind_rows(raw)

# convert to tibble
cases_raw <- dplyr::as_tibble(cases_raw)

# variable names
names(cases_raw) <- c("case_number", "procedure_numbers", "case_title", "case_title_original",
                      "member_state", "regions", "NACE_codes", "aid_instruments", "case_type",
                      "start_date", "end_date", "notification_date",
                      "decisions", "objectives", "outcome_date", "citations", "related_cases", "directorate_general",
                      "expenditures")

##################################################
# save
##################################################

# save
save(cases_raw, file = "data-raw/cases_raw.RData")

###########################################################################
# end R script
###########################################################################
