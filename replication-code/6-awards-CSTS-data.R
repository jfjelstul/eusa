###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/awards.RData")

# read in member state data
member_states <- read.csv("data-raw/member-states.csv", stringsAsFactors = FALSE)
member_states <- dplyr::select(member_states, member_state_ID, member_state, member_state_code)

# aid instrument data
aid_instruments <- dplyr::select(awards, aid_instrument_ID, aid_instrument)
aid_instruments <- dplyr::filter(aid_instruments, !duplicated(aid_instruments$aid_instrument))
aid_instruments <- dplyr::arrange(aid_instruments, aid_instrument_ID)

# beneficiary type data
beneficiary_types <- dplyr::tibble(
  beneficiary_type_ID = c(1, 2),
  beneficiary_type = c("Small or medium-sized enterprise (SME)", "Large enterprise")
)

# NACE sector data
NACE_sectors <- dplyr::select(awards, NACE_sector_ID, NACE_sector_code, NACE_sector)
NACE_sectors <- dplyr::filter(NACE_sectors, !duplicated(NACE_sectors$NACE_sector_ID))
NACE_sectors <- dplyr::arrange(NACE_sectors, NACE_sector_ID)

##################################################
# awards_TS
##################################################

# create a template
template_CSTS <- expand.grid(
  member_states$member_state,
  2016:2020
)
names(template_CSTS) <- c("member_state", "year")
template_CSTS <- dplyr::as_tibble(template_CSTS)

# collapse
awards_CSTS <- awards %>%
  dplyr::group_by(notification_year, member_state) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>% dplyr::ungroup()

# rename variable
awards_CSTS <- dplyr::rename(awards_CSTS, year = notification_year)

# merge in template
awards_CSTS <- dplyr::left_join(template_CSTS, awards_CSTS, by = c("year", "member_state"))

# code zeros
awards_CSTS$count_awards[is.na(awards_CSTS$count_awards)] <- 0
awards_CSTS$total_amount_euros[is.na(awards_CSTS$total_amount_euros)] <- 0

# merge in member state data
awards_CSTS <- dplyr::left_join(awards_CSTS, member_states, by = "member_state")

# arrange
awards_CSTS <- dplyr::arrange(awards_CSTS, year, member_state_ID)

# key ID
awards_CSTS$key_ID <- 1:nrow(awards_CSTS)

# select variables
awards_CSTS <- dplyr::select(
  awards_CSTS,
  key_ID, year, 
  member_state_ID, member_state, member_state_code, 
  count_awards, total_amount_euros
)

# save
save(awards_CSTS, file = "data/awards_CSTS.RData")

##################################################
# awards_TS_B (beneficiary type)
##################################################

# create a template
template_CSTS_B <- expand.grid(
  member_states$member_state,
  2016:2020,
  beneficiary_types$beneficiary_type
)
names(template_CSTS_B) <- c("member_state", "year", "beneficiary_type")
template_CSTS_B <- dplyr::as_tibble(template_CSTS_B)

# collapse
awards_CSTS_B <- awards %>%
  dplyr::group_by(notification_year, member_state, beneficiary_type) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>% dplyr::ungroup()

# rename variable
awards_CSTS_B <- dplyr::rename(awards_CSTS_B, year = notification_year)

# merge in template
awards_CSTS_B <- dplyr::left_join(template_CSTS_B, awards_CSTS_B, by = c("year", "member_state", "beneficiary_type"))

# code zeros
awards_CSTS_B$count_awards[is.na(awards_CSTS_B$count_awards)] <- 0
awards_CSTS_B$total_amount_euros[is.na(awards_CSTS_B$total_amount_euros)] <- 0

# merge in member state data
awards_CSTS_B <- dplyr::left_join(awards_CSTS_B, member_states, by = "member_state")

# merge in beneficiary type data
awards_CSTS_B <- dplyr::left_join(awards_CSTS_B, beneficiary_types, by = "beneficiary_type")

# arrange
awards_CSTS_B <- dplyr::arrange(awards_CSTS_B, year, member_state_ID, beneficiary_type_ID)

# key ID
awards_CSTS_B$key_ID <- 1:nrow(awards_CSTS_B)

# select variables
awards_CSTS_B <- dplyr::select(
  awards_CSTS_B,
  key_ID, year, 
  member_state_ID, member_state, member_state_code, 
  beneficiary_type_ID, beneficiary_type,
  count_awards, total_amount_euros
)

# save
save(awards_CSTS_B, file = "data/awards_CSTS_B.RData")

##################################################
# awards_TS_I (aid instrument)
##################################################

# create a template
template_CSTS_I <- expand.grid(
  member_states$member_state,
  2016:2020,
  aid_instruments$aid_instrument
)
names(template_CSTS_I) <- c("member_state", "year", "aid_instrument")
template_CSTS_I <- dplyr::as_tibble(template_CSTS_I)

# collapse
awards_CSTS_I <- awards %>%
  dplyr::group_by(notification_year, member_state, aid_instrument) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>% dplyr::ungroup()

# rename variable
awards_CSTS_I <- dplyr::rename(awards_CSTS_I, year = notification_year)

# merge in template
awards_CSTS_I <- dplyr::left_join(template_CSTS_I, awards_CSTS_I, by = c("year", "member_state", "aid_instrument"))

# code zeros
awards_CSTS_I$count_awards[is.na(awards_CSTS_I$count_awards)] <- 0
awards_CSTS_I$total_amount_euros[is.na(awards_CSTS_I$total_amount_euros)] <- 0

# merge in member state data
awards_CSTS_I <- dplyr::left_join(awards_CSTS_I, member_states, by = "member_state")

# merge in aid instrument data
awards_CSTS_I <- dplyr::left_join(awards_CSTS_I, aid_instruments, by = "aid_instrument")

# arrange
awards_CSTS_I <- dplyr::arrange(awards_CSTS_I, year, member_state_ID, aid_instrument_ID)

# key ID
awards_CSTS_I$key_ID <- 1:nrow(awards_CSTS_I)

# select variables
awards_CSTS_I <- dplyr::select(
  awards_CSTS_I,
  key_ID, year, 
  member_state_ID, member_state, member_state_code, 
  aid_instrument_ID, aid_instrument,
  count_awards, total_amount_euros
)

# save
save(awards_CSTS_I, file = "data/awards_CSTS_I.RData")

##################################################
# awards_TS_S (NACE sector)
##################################################

# create a template
template_CSTS_S <- expand.grid(
  member_states$member_state,
  2016:2020,
  NACE_sectors$NACE_sector
)
names(template_CSTS_S) <- c("member_state", "year", "NACE_sector")
template_CSTS_S <- dplyr::as_tibble(template_CSTS_S)

# collapse
awards_CSTS_S <- awards %>%
  dplyr::group_by(notification_year, member_state, NACE_sector) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>% dplyr::ungroup()

# rename variable
awards_CSTS_S <- dplyr::rename(awards_CSTS_S, year = notification_year)

# merge in template
awards_CSTS_S <- dplyr::left_join(template_CSTS_S, awards_CSTS_S, by = c("year", "member_state", "NACE_sector"))

# code zeros
awards_CSTS_S$count_awards[is.na(awards_CSTS_S$count_awards)] <- 0
awards_CSTS_S$total_amount_euros[is.na(awards_CSTS_S$total_amount_euros)] <- 0

# merge in member state data
awards_CSTS_S <- dplyr::left_join(awards_CSTS_S, member_states, by = "member_state")

# merge in sector data
awards_CSTS_S <- dplyr::left_join(awards_CSTS_S, NACE_sectors, by = "NACE_sector")

# arrange
awards_CSTS_S <- dplyr::arrange(awards_CSTS_S, year, member_state_ID, NACE_sector_ID)

# key ID
awards_CSTS_S$key_ID <- 1:nrow(awards_CSTS_S)

# select variables
awards_CSTS_S <- dplyr::select(
  awards_CSTS_S,
  key_ID, year, 
  member_state_ID, member_state, member_state_code, 
  NACE_sector_ID, NACE_sector, NACE_sector_code,
  count_awards, total_amount_euros
)

# save
save(awards_CSTS_S, file = "data/awards_CSTS_S.RData")

###########################################################################
# end R script
###########################################################################
