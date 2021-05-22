################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

# load data
load("data-raw/working-files/awards_raw.RData")

# select variables
awards <- dplyr::select(
  awards_raw,
  case_number, reference_number, national_id,
  notification_date, publication_date,
  member_state, authority_name, beneficiary_name, beneficiary_type,
  nace_description, region, aid_instrument, objectives, raw_amount, currency
)

##################################################
# clean beneficiary type
##################################################

# convert to lower case
awards$beneficiary_type <- stringr::str_to_lower(awards$beneficiary_type)
awards$beneficiary_type[awards$beneficiary_type == "small and medium-sized entreprises"] <- "Small or medium-sized enterprise (SME)"
awards$beneficiary_type[awards$beneficiary_type == "only large enterprises"] <- "Large enterprise"

# beneficiary type ID
awards$beneficiary_type_id <- 0
awards$beneficiary_type_id[awards$beneficiary_type == "Small or medium-sized enterprise (SME)"] <- 1
awards$beneficiary_type_id[awards$beneficiary_type == "Large enterprise"] <- 2

##################################################
# clean member state
##################################################

# fix Czech Republic
awards$member_state[awards$member_state == "Czechia"] <- "Czech Republic"

# read in member state data
load("data-raw/member_states.RData")

# select variables
member_states <- dplyr::select(member_states, member_state_id, member_state, member_state_code)

# merge
awards <- dplyr::left_join(awards, member_states, by = "member_state")

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
awards$aid_instrument[awards$aid_instrument == "direct grant/interest rate subsidy"] <- "interest rate subsidy"
awards$aid_instrument[awards$aid_instrument == "loan/repayable advances"] <- "loan"
awards$aid_instrument[awards$aid_instrument == "repayable advances"] <- "loan"
awards$aid_instrument[awards$aid_instrument == "interest subsidy"] <- "interest rate subsidy"

# aid instrument ID
awards$aid_instrument_id <- 0
awards$aid_instrument_id[awards$aid_instrument == "direct grant"] <- 1
awards$aid_instrument_id[awards$aid_instrument == "guarantee"] <- 2
awards$aid_instrument_id[awards$aid_instrument == "interest rate subsidy"] <- 3
awards$aid_instrument_id[awards$aid_instrument == "loan"] <- 4
awards$aid_instrument_id[awards$aid_instrument == "provision of risk capital"] <- 5
awards$aid_instrument_id[awards$aid_instrument == "provision of risk finance"] <- 6
awards$aid_instrument_id[awards$aid_instrument == "reduction of social security contributions"] <- 7
awards$aid_instrument_id[awards$aid_instrument == "reimbursable grant"] <- 8
awards$aid_instrument_id[awards$aid_instrument == "soft loan"] <- 9
awards$aid_instrument_id[awards$aid_instrument == "subsidised services"] <- 10
awards$aid_instrument_id[awards$aid_instrument == "tax advantage or tax exemption"] <- 11
awards$aid_instrument_id[awards$aid_instrument == "tax allowance"] <- 12
awards$aid_instrument_id[awards$aid_instrument == "tax base reduction"] <- 13
awards$aid_instrument_id[awards$aid_instrument == "tax rate reduction"] <- 14
awards$aid_instrument_id[awards$aid_instrument == "other"] <- 15

##################################################
# format dates
##################################################

# convert to date
awards$notification_date <- lubridate::dmy(awards$notification_date)

# change format
awards$notification_date <- lubridate::ymd(awards$notification_date)

# convert to date
awards$publication_date <- lubridate::dmy(awards$publication_date)

# change format
awards$publication_date <- lubridate::ymd(awards$publication_date)

# notification date variables
awards$notification_year <- lubridate::year(awards$notification_date)
awards$notification_month <- lubridate::month(awards$notification_date)
awards$notification_day <- lubridate::day(awards$notification_date)

# publication year
awards$publication_year <- lubridate::year(awards$publication_date)
awards$publication_month <- lubridate::month(awards$publication_date)
awards$publication_day <- lubridate::day(awards$publication_date)

##################################################
# prepare exchange rate data
##################################################

# exchange rate files
files <- stringr::str_c("data-raw/exchange-rates/", list.files("data-raw/exchange-rates/"))

# read in exchange rate data
raw <- list()
for (i in 1:length(files)) {
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
for (i in 1:nrow(awards)) {
  if (awards$currency[i] == "EUR") {
    next
  } else {
    member_state <- awards$member_state[i]
    date <- awards$notification_date[i]
    x <- abs(as.numeric(rates$date - date))
    index <- which(x == min(x))
    index <- index[rates$member_state[index] == member_state]
    index <- index[1]
    awards$exchange_rate[i] <- rates$value[index]
  }
}
rm(i, x, date, member_state, index)

# calculate amount
awards$amount_euros <- awards$raw_amount * awards$exchange_rate
awards$amount_euros <- round(awards$amount_euros / 1000) * 1000

# cut-off
awards$voluntary <- as.numeric(awards$amount_euros < 500000)

##################################################
# currency
##################################################

# recode
awards$currency[awards$currency == "EUR"] <- "euro"
awards$currency[awards$currency == "HUF"] <- "forint"
awards$currency[awards$currency == "CZK"] <- "koruna"
awards$currency[awards$currency == "SEK"] <- "krona"
awards$currency[awards$currency == "DKK"] <- "krone"
awards$currency[awards$currency == "HRK"] <- "kuna"
awards$currency[awards$currency == "BGN"] <- "lev"
awards$currency[awards$currency == "GBP"] <- "pound"
awards$currency[awards$currency == "LTL"] <- "euro"

##################################################
# NACE codes
##################################################

# convert to lower case
awards$nace_description <- stringr::str_to_lower(awards$nace_description)

# read in data
nace_codes <- readLines("data-raw/NACE-codes/nace_codes.txt")

# make a tibble
nace_codes <- dplyr::tibble(text = nace_codes[-1])

# code
nace_codes$nace_code <- stringr::str_extract(nace_codes$text, "^[A-Z0-9.]+")

# sector
nace_codes$nace_sector_code <- stringr::str_extract(nace_codes$text, "^[A-Z]")

# description
nace_codes$nace_description <- stringr::str_extract(nace_codes$text, "-.*")
nace_codes$nace_description <- stringr::str_replace(nace_codes$nace_description, "- ", "")
nace_codes$nace_description <- stringr::str_squish(nace_codes$nace_description)

# drop duplicates
nace_codes$drop <- stringr::str_detect(nace_codes$nace_code, "\\.0$")
nace_codes <- dplyr::filter(nace_codes, drop == FALSE)
nace_codes$drop <- NULL
nace_codes$duplicated <- duplicated(nace_codes$nace_description)
nace_codes <- dplyr::filter(nace_codes, duplicated == FALSE)
nace_codes$duplicated <- NULL

# convert to lower case
nace_codes$nace_description <- stringr::str_to_lower(nace_codes$nace_description)

# fix inconsistenciess
awards$nace_description[awards$nace_description == "activities of sports clubs"] <- "activities of sport clubs"
awards$nace_description[awards$nace_description == "manufacture of buildersâ€™ ware of plastic"] <- "manufacture of builders' ware of plastic"
awards$nace_description[awards$nace_description == "manufacture of plastic products"] <- "manufacture of rubber and plastic products"
awards$nace_description[awards$nace_description == "other service activities"] <- "other services activities"
awards$nace_description[awards$nace_description == "rental and leasing of agricultural machinery and equipment"] <- "renting and leasing of agricultural machinery and equipment"
awards$nace_description[awards$nace_description == "rental and leasing of cars and light motor vehicles"] <- "renting and leasing of cars and light motor vehicles"
awards$nace_description[awards$nace_description == "rental and leasing of construction and civil engineering machinery and equipment"] <- "renting and leasing of construction and civil engineering machinery and equipment"
awards$nace_description[awards$nace_description == "rental and leasing of motor vehicles"] <- "renting and leasing of motor vehicles"
awards$nace_description[awards$nace_description == "rental and leasing of office machinery and equipment (including computers)"] <- "renting and leasing of office machinery and equipment (including computers)"
awards$nace_description[awards$nace_description == "rental and leasing of other machinery, equipment and tangible goods"] <- "renting and leasing of other machinery, equipment and tangible goods"
awards$nace_description[awards$nace_description == "rental and leasing of other machinery, equipment and tangible goods n.e.c."] <- "renting and leasing of other machinery, equipment and tangible goods n.e.c."
awards$nace_description[awards$nace_description == "rental and leasing of other personal and household goods"] <- "renting and leasing of other personal and household goods"
awards$nace_description[awards$nace_description == "rental and leasing of personal and household goods"] <- "renting and leasing of personal and household goods"
awards$nace_description[awards$nace_description == "rental and leasing of recreational and sports goods"] <- "renting and leasing of recreational and sports goods"
awards$nace_description[awards$nace_description == "rental and leasing of trucks"] <- "renting and leasing of trucks"
awards$nace_description[awards$nace_description == "rental and operating of own or leased real estate"] <- "renting and operating of own or leased real estate"
awards$nace_description[awards$nace_description == "transportation and storage"] <- "transporting and storage"
awards$nace_description[awards$nace_description == "water supply; sewerage, waste management and remediation activities"] <- "water supply; sewerage; waste managment and remediation activities"

# drop variable
nace_codes <- dplyr::select(nace_codes, -text)

# NACE sectors
sectors <- dplyr::filter(nace_codes, nace_code == nace_sector_code)
sectors <- dplyr::select(sectors, nace_code, nace_description)
sectors <- dplyr::rename(sectors, nace_sector = nace_description)

# merge in
nace_codes <- dplyr::left_join(nace_codes, sectors, by = c("nace_sector_code" = "nace_code"))

# NACE sector ID
nace_codes$nace_sector_id <- as.numeric(as.factor(nace_codes$nace_sector_code))

# merge
awards <- dplyr::left_join(awards, nace_codes, by = "nace_description")

# key ID
nace_codes$key_id <- 1:nrow(nace_codes)

# organize variables
nace_codes <- dplyr::select(
  nace_codes,
  key_id, nace_sector_id, nace_sector_code, nace_sector, nace_code, nace_description
)

# save NACE data
save(nace_codes, file = "data/nace_codes.RData")

##################################################
# organize
##################################################

# arrange
awards <- dplyr::arrange(awards, notification_date, case_number, member_state_id)

# key ID
awards$key_id <- 1:nrow(awards)

# organize variables
awards <- dplyr::select(
  awards,
  key_id, case_number, reference_number,
  notification_date, notification_year, notification_month, notification_day,
  publication_date, publication_year, publication_month, publication_day,
  member_state_id, member_state, member_state_code,
  authority_name, region,
  beneficiary_name, beneficiary_type_id, beneficiary_type,
  nace_sector_id, nace_sector_code, nace_sector, nace_code, nace_description,
  aid_instrument_id, aid_instrument,
  raw_amount, currency, range, range_min, range_max, exchange_rate,
  amount_euros, voluntary
)

# conver to a tibble
awards <- dplyr::as_tibble(awards)

# save
save(awards, file = "data/awards.RData")

################################################################################
# end R script
################################################################################
