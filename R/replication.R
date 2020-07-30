###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# turn off scientific notation
options(scipen = 999)

##################################################
# read in data
##################################################

# get list of files
files <- stringr::str_c("data-raw/transparency/", list.files("data-raw/transparency/"))

# read in data
raw <- list()
for(i in 1:length(files)) {
  temp <- read.csv(files[i], stringsAsFactors = FALSE)
  temp[, 18] <- as.character(temp[, 18])
  temp[, 17] <- as.character(temp[, 17])
  temp[, 7] <- as.character(temp[, 7])
  raw[[i]] <- temp
}
rm(i, temp, files)

# stack data frames
aid <- dplyr::bind_rows(raw)
rm(raw)

# fix variables names
names(aid) <- c(
  "member_state", "other_beneficiary", "title", "title_english",
  "case_number", "reference_number", "national_id",
  "beneficiary_name", "beneficiary_name_english", "beneficiary_type",
  "region", "NACE_description", "aid_instrument", "aid_instrument_english",
  "objectives", "objectives_english", "nominal", "raw_amount",
  "currency", "date", "authority", "authority_english", "publication_date"
)

# select variables
aid <- dplyr::select(aid, case_number, reference_number, date, publication_date, member_state, authority, beneficiary_name, beneficiary_type, NACE_description, region, aid_instrument, objectives, raw_amount, currency)

##################################################
# clean NACE description
##################################################

# convert to lower case
aid$NACE_description <- stringr::str_to_lower(aid$NACE_description)

##################################################
# clean beneficiary type
##################################################

# convert to lower case
aid$beneficiary_type <- stringr::str_to_lower(aid$beneficiary_type)

##################################################
# clean member state
##################################################

# fix Czech Republic
aid$member_state[aid$member_state == "Czechia"] <- "Czech Republic"

##################################################
# award amount
##################################################

# clean amount
aid$raw_amount <- stringr::str_replace(aid$raw_amount, "<|>", "")
aid$raw_amount <- stringr::str_replace_all(aid$raw_amount, ",", "")
aid$raw_amount <- stringr::str_squish(aid$raw_amount)
aid$raw_amount[aid$raw_amount == "1000001 - 2000000"] <- "1000000 - 2000000"
aid$raw_amount[aid$raw_amount == "2000001 - 5000000"] <- "2000000 - 5000000"
aid$raw_amount[aid$raw_amount == "500001 - 1000000"] <- "500000 - 1000000"

# is amount is in euros?
aid$euros <- as.numeric(aid$currency == "EUR")

# is the amount an estimate?
aid$range <- as.numeric(stringr::str_detect(aid$raw_amount, "-"))

# minimum value of range
aid$range_min <- stringr::str_extract(aid$raw_amount, "^[0-9]+")
aid$range_min[aid$range == 0] <- NA

# maximum value of range
aid$range_max <- stringr::str_extract(aid$raw_amount, "[0-9]+$")
aid$range_max[aid$range == 0] <- NA

# recode estimates
aid$raw_amount[aid$raw_amount == "1000000 - 2000000"] <- (1000000 + 2000000) / 2
aid$raw_amount[aid$raw_amount == "10000000 - 30000000"] <- (10000000 + 30000000) / 2
aid$raw_amount[aid$raw_amount == "2000000 - 5000000"] <- (2000000 + 5000000) / 2
aid$raw_amount[aid$raw_amount == "30000 - 200000"] <- (30000 + 200000) / 2
aid$raw_amount[aid$raw_amount == "500000 - 1000000"] <- (500000 + 1000000) / 2
aid$raw_amount[aid$raw_amount == "5000000 - 10000000"] <- (5000000 + 10000000) / 2
aid$raw_amount[aid$raw_amount == "60000 - 500000"] <- (60000 + 500000) / 2
aid$raw_amount <- as.numeric(aid$raw_amount)
aid$raw_amount <- round(aid$raw_amount)

##################################################
# aid instrument
##################################################

# clean aid instrument
aid$aid_instrument <- stringr::str_to_lower(aid$aid_instrument)
aid$aid_instrument[stringr::str_detect(aid$aid_instrument, "other|stateaidfinancingtype")] <- "other"
aid$aid_instrument[stringr::str_detect(aid$aid_instrument, "guarantee")] <- "guarantee"
aid$aid_instrument[aid$aid_instrument == "direct grant/ interest rate subsidy"] <- "direct grant/interest rate subsidy"
aid$aid_instrument[aid$aid_instrument == "loan/ repayable advances"] <- "loan/repayable advances"

##################################################
# firm size
##################################################

# firm size
# aid$small_firms <- as.numeric(stringr::str_detect(aid$beneficiary_type, "Small and medium-sized entreprises"))
# aid$large_firms <- 1 - aid$small_firms

##################################################
# format dates
##################################################

# convert to date
aid$date <- lubridate::dmy(aid$date)

# change format
aid$date <- lubridate::ymd(aid$date)

# convert to date
aid$publication_date <- lubridate::dmy(aid$publication_date)

# change format
aid$publication_date <- lubridate::ymd(aid$publication_date)

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
aid$raw_amount[aid$currency == "LTL"] <- NA

# convert currencies
aid$exchange_rate <- 1
for(i in 1:nrow(aid)) {
  if(aid$currency[i] == "EUR") {
    next
  } else {
    member_state <- aid$member_state[i]
    date <- aid$date[i]
    x <- abs(as.numeric(rates$date - date))
    index <- which(x == min(x))
    index <- index[rates$member_state[index] == member_state]
    index <- index[1]
    aid$exchange_rate[i] <- rates$value[index]
  }
}
rm(i, x, date, member_state, index)

# calculate amount
aid$adjusted_amount <- aid$raw_amount * aid$exchange_rate
aid$adjusted_amount <- round(aid$adjusted_amount / 1000) * 1000

# cut-off
aid$voluntary <- as.numeric(aid$adjusted_amount < 500000)

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
aid$NACE_description[aid$NACE_description == "activities of sports clubs"] <- "activities of sport clubs"
aid$NACE_description[aid$NACE_description == "manufacture of buildersâ€™ ware of plastic"] <- "manufacture of builders' ware of plastic"
aid$NACE_description[aid$NACE_description == "manufacture of plastic products"] <- "manufacture of rubber and plastic products"
aid$NACE_description[aid$NACE_description == "other service activities"] <- "other services activities"
aid$NACE_description[aid$NACE_description == "rental and leasing of agricultural machinery and equipment"] <- "renting and leasing of agricultural machinery and equipment"
aid$NACE_description[aid$NACE_description == "rental and leasing of cars and light motor vehicles"] <- "renting and leasing of cars and light motor vehicles"
aid$NACE_description[aid$NACE_description == "rental and leasing of construction and civil engineering machinery and equipment"] <- "renting and leasing of construction and civil engineering machinery and equipment"
aid$NACE_description[aid$NACE_description == "rental and leasing of motor vehicles"] <- "renting and leasing of motor vehicles"
aid$NACE_description[aid$NACE_description == "rental and leasing of office machinery and equipment (including computers)"] <- "renting and leasing of office machinery and equipment (including computers)"
aid$NACE_description[aid$NACE_description == "rental and leasing of other machinery, equipment and tangible goods"] <- "renting and leasing of other machinery, equipment and tangible goods"
aid$NACE_description[aid$NACE_description == "rental and leasing of other machinery, equipment and tangible goods n.e.c."] <- "renting and leasing of other machinery, equipment and tangible goods n.e.c."
aid$NACE_description[aid$NACE_description == "rental and leasing of other personal and household goods"] <- "renting and leasing of other personal and household goods"
aid$NACE_description[aid$NACE_description == "rental and leasing of personal and household goods"] <- "renting and leasing of personal and household goods"
aid$NACE_description[aid$NACE_description == "rental and leasing of recreational and sports goods"] <- "renting and leasing of recreational and sports goods"
aid$NACE_description[aid$NACE_description == "rental and leasing of trucks"] <- "renting and leasing of trucks"
aid$NACE_description[aid$NACE_description == "rental and operating of own or leased real estate"] <- "renting and operating of own or leased real estate"
aid$NACE_description[aid$NACE_description == "transportation and storage"] <- "transporting and storage"
aid$NACE_description[aid$NACE_description == "water supply; sewerage, waste management and remediation activities"] <- "water supply; sewerage; waste managment and remediation activities"

# drop variable
nace <- dplyr::select(nace, -text)

# merge
aid <- dplyr::left_join(aid, nace, by = "NACE_description")

#################################################
# organize
#################################################

# arrange
aid <- dplyr::arrange(aid, date, case_number, member_state)

# organize variables
aid <- dplyr::select(
  aid,
  case_number, reference_number,
  date, publication_date,
  member_state, authority, region,
  beneficiary_name, beneficiary_type,
  NACE_sector, NACE_code, NACE_description,
  aid_instrument,
  raw_amount, currency, range, range_min, range_max, exchange_rate,
  adjusted_amount, voluntary
)

# save
save(aid, file = "data/aid.RData")
write.csv(aid, "data/aid.csv", row.names = FALSE)
save(nace, file = "data/nace.RData")
write.csv(aid, "data/nace.csv", row.names = FALSE)

###########################################################################
# end R script
###########################################################################
