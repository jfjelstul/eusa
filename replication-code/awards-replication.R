###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# load data
load("data-raw/awards_raw.RData")

# select variables
awards <- dplyr::select(awards_raw, case_number, reference_number, date, publication_date, member_state, authority, beneficiary_name, beneficiary_type, NACE_description, region, aid_instrument, objectives, raw_amount, currency)

##################################################
# clean NACE description
##################################################

# convert to lower case
awards$NACE_description <- stringr::str_to_lower(awards$NACE_description)

##################################################
# clean beneficiary type
##################################################

# convert to lower case
awards$beneficiary_type <- stringr::str_to_lower(awards$beneficiary_type)

##################################################
# clean member state
##################################################

# fix Czech Republic
awards$member_state[awards$member_state == "Czechia"] <- "Czech Republic"

##################################################
# award amount
##################################################

# clean amount
awards$raw_amount <- stringr::str_replace(awards$raw_amount, "<|>", "")
awards$raw_amount <- stringr::str_replace_all(awards$raw_amount, ",", "")
awards$raw_amount <- stringr::str_squish(awards$raw_amount)
awards$raw_amount[awards$raw_amount == "1000001 - 2000000"] <- "1000000 - 2000000"
awards$raw_amount[awards$raw_amount == "2000001 - 5000000"] <- "2000000 - 5000000"
awards$raw_amount[awards$raw_amount == "500001 - 1000000"] <- "500000 - 1000000"

# is amount is in euros?
awards$euros <- as.numeric(awards$currency == "EUR")

# is the amount an estimate?
awards$range <- as.numeric(stringr::str_detect(awards$raw_amount, "-"))

# minimum value of range
awards$range_min <- stringr::str_extract(awards$raw_amount, "^[0-9]+")
awards$range_min[awards$range == 0] <- NA

# maximum value of range
awards$range_max <- stringr::str_extract(awards$raw_amount, "[0-9]+$")
awards$range_max[awards$range == 0] <- NA

# recode estimates
awards$raw_amount[awards$raw_amount == "1000000 - 2000000"] <- (1000000 + 2000000) / 2
awards$raw_amount[awards$raw_amount == "10000000 - 30000000"] <- (10000000 + 30000000) / 2
awards$raw_amount[awards$raw_amount == "2000000 - 5000000"] <- (2000000 + 5000000) / 2
awards$raw_amount[awards$raw_amount == "30000 - 200000"] <- (30000 + 200000) / 2
awards$raw_amount[awards$raw_amount == "500000 - 1000000"] <- (500000 + 1000000) / 2
awards$raw_amount[awards$raw_amount == "5000000 - 10000000"] <- (5000000 + 10000000) / 2
awards$raw_amount[awards$raw_amount == "60000 - 500000"] <- (60000 + 500000) / 2
awards$raw_amount <- as.numeric(awards$raw_amount)
awards$raw_amount <- round(awards$raw_amount)

##################################################
# aid instrument
##################################################

# clean aid instrument
awards$aid_instrument <- stringr::str_to_lower(awards$aid_instrument)
awards$aid_instrument[stringr::str_detect(awards$aid_instrument, "other|stateaidfinancingtype")] <- "other"
awards$aid_instrument[stringr::str_detect(awards$aid_instrument, "guarantee")] <- "guarantee"
awards$aid_instrument[awards$aid_instrument == "direct grant/ interest rate subsidy"] <- "direct grant/interest rate subsidy"
awards$aid_instrument[awards$aid_instrument == "loan/ repayable advances"] <- "loan/repayable advances"

##################################################
# format dates
##################################################

# convert to date
awards$date <- lubridate::dmy(awards$date)

# change format
awards$date <- lubridate::ymd(awards$date)

# convert to date
awards$publication_date <- lubridate::dmy(awards$publication_date)

# change format
awards$publication_date <- lubridate::ymd(awards$publication_date)

##################################################
# prepare exchange rate data
##################################################

# exchange rate files
files <- stringr::str_c("data-raw/exchange-rates/", list.files("data-raw/exchange-rates/"))

# read in exchange rate data
raw <- list()
for(i in 1:length(files)) {
  raw[[i]] <- read.csv(files[i], stringsAsFactors = FALSE)
  raw[[i]]$file <- files[i]
}
rm(i, files)

# stack data frames
rates <- dplyr::bind_rows(raw)
rm(raw)

# currency
rates$symbol <- stringr::str_extract(rates$file, "[A-Z]{6}")

# invert rate
rates$value <- 1 / suppressWarnings(as.numeric(rates$Close))
rates$symbol <- stringr::str_replace(rates$symbol, "([A-Z]{3})([A-Z]{3})", "\\2\\1")

# rename variable
rates <- dplyr::rename(rates, date = Date)

# select variables
rates <- dplyr::select(rates, symbol, date, value)

# member state
rates$member_state <- NA
rates$member_state[rates$symbol == "BGNEUR"] <- "Bulgaria"
rates$member_state[rates$symbol == "HRKEUR"] <- "Croatia"
rates$member_state[rates$symbol == "CZKEUR"] <- "Czech Republic"
rates$member_state[rates$symbol == "DKKEUR"] <- "Denmark"
rates$member_state[rates$symbol == "HUFEUR"] <- "Hungary"
rates$member_state[rates$symbol == "SEKEUR"] <- "Sweden"
rates$member_state[rates$symbol == "GBPEUR"] <- "United Kingdom"

# format date
rates$date <- lubridate::ymd(rates$date)

# drop missing values
rates <- na.omit(rates)

##################################################
# convert currencies
##################################################

# mark awards in Lithuanian litas as missing
awards$raw_amount[awards$currency == "LTL"] <- NA

# convert currencies
awards$exchange_rate <- 1
for(i in 1:nrow(awards)) {
  if(awards$currency[i] == "EUR") {
    next
  } else {
    member_state <- awards$member_state[i]
    date <- awards$date[i]
    x <- abs(as.numeric(rates$date - date))
    index <- which(x == min(x))
    index <- index[rates$member_state[index] == member_state]
    index <- index[1]
    awards$exchange_rate[i] <- rates$value[index]
  }
}
rm(i, x, date, member_state, index)

# calculate amount
awards$adjusted_amount <- awards$raw_amount * awards$exchange_rate
awards$adjusted_amount <- round(awards$adjusted_amount / 1000) * 1000

# cut-off
awards$voluntary <- as.numeric(awards$adjusted_amount < 500000)

##################################################
# NACE codes
##################################################

# read in data
nace <- readLines("data-raw/NACE-codes/NACE-codes.txt")

# make a tibble
nace <- dplyr::tibble(text = nace[-1])

# code
nace$NACE_code <- stringr::str_extract(nace$text, "^[A-Z0-9.]+")

# sector
nace$NACE_sector <- stringr::str_extract(nace$text, "^[A-Z]")

# description
nace$NACE_description <- stringr::str_extract(nace$text, "-.*")
nace$NACE_description <- stringr::str_replace(nace$NACE_description, "- ", "")
nace$NACE_description <- stringr::str_squish(nace$NACE_description)

# drop duplicates
nace$drop <- stringr::str_detect(nace$NACE_code, "\\.0$")
nace <- dplyr::filter(nace, drop == FALSE)
nace$drop <- NULL
nace$duplicated <- duplicated(nace$NACE_description)
nace <- dplyr::filter(nace, duplicated == FALSE)
nace$duplicated <- NULL

# convert to lower case
nace$NACE_description <- stringr::str_to_lower(nace$NACE_description)

# fix inconsistenciess
awards$NACE_description[awards$NACE_description == "activities of sports clubs"] <- "activities of sport clubs"
awards$NACE_description[awards$NACE_description == "manufacture of buildersâ€™ ware of plastic"] <- "manufacture of builders' ware of plastic"
awards$NACE_description[awards$NACE_description == "manufacture of plastic products"] <- "manufacture of rubber and plastic products"
awards$NACE_description[awards$NACE_description == "other service activities"] <- "other services activities"
awards$NACE_description[awards$NACE_description == "rental and leasing of agricultural machinery and equipment"] <- "renting and leasing of agricultural machinery and equipment"
awards$NACE_description[awards$NACE_description == "rental and leasing of cars and light motor vehicles"] <- "renting and leasing of cars and light motor vehicles"
awards$NACE_description[awards$NACE_description == "rental and leasing of construction and civil engineering machinery and equipment"] <- "renting and leasing of construction and civil engineering machinery and equipment"
awards$NACE_description[awards$NACE_description == "rental and leasing of motor vehicles"] <- "renting and leasing of motor vehicles"
awards$NACE_description[awards$NACE_description == "rental and leasing of office machinery and equipment (including computers)"] <- "renting and leasing of office machinery and equipment (including computers)"
awards$NACE_description[awards$NACE_description == "rental and leasing of other machinery, equipment and tangible goods"] <- "renting and leasing of other machinery, equipment and tangible goods"
awards$NACE_description[awards$NACE_description == "rental and leasing of other machinery, equipment and tangible goods n.e.c."] <- "renting and leasing of other machinery, equipment and tangible goods n.e.c."
awards$NACE_description[awards$NACE_description == "rental and leasing of other personal and household goods"] <- "renting and leasing of other personal and household goods"
awards$NACE_description[awards$NACE_description == "rental and leasing of personal and household goods"] <- "renting and leasing of personal and household goods"
awards$NACE_description[awards$NACE_description == "rental and leasing of recreational and sports goods"] <- "renting and leasing of recreational and sports goods"
awards$NACE_description[awards$NACE_description == "rental and leasing of trucks"] <- "renting and leasing of trucks"
awards$NACE_description[awards$NACE_description == "rental and operating of own or leased real estate"] <- "renting and operating of own or leased real estate"
awards$NACE_description[awards$NACE_description == "transportation and storage"] <- "transporting and storage"
awards$NACE_description[awards$NACE_description == "water supply; sewerage, waste management and remediation activities"] <- "water supply; sewerage; waste managment and remediation activities"

# drop variable
nace <- dplyr::select(nace, -text)

# merge
awards <- dplyr::left_join(awards, nace, by = "NACE_description")

# key ID
nace$key_ID <- 1:nrow(nace)

# organize variables
nace <- dplyr::select(nace, key_ID, NACE_sector, NACE_code, NACE_description)

# save NACE data
save(nace, file = "data/nace.RData")
write.csv(nace, "data/nace.csv", row.names = FALSE)

##################################################
# organize
##################################################

# arrange
awards <- dplyr::arrange(awards, date, case_number, member_state)

# key ID
awards$key_ID <- 1:nrow(awards)

# organize variables
awards <- dplyr::select(
  awards,
  key_ID, case_number, reference_number,
  date, publication_date,
  member_state, authority, region,
  beneficiary_name, beneficiary_type,
  NACE_sector, NACE_code, NACE_description,
  aid_instrument,
  raw_amount, currency, range, range_min, range_max, exchange_rate,
  adjusted_amount, voluntary
)

# save
save(awards, file = "data/awards.RData")
write.csv(awards, "data/awards.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
