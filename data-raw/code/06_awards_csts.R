################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# load data
load("data/awards.RData")

# read in member state data
load("data-raw/member_states.RData")
member_states <- dplyr::select(member_states, member_state_id, member_state, member_state_code)

# aid instrument data
aid_instruments <- dplyr::select(awards, aid_instrument_id, aid_instrument)
aid_instruments <- dplyr::filter(aid_instruments, !duplicated(aid_instruments$aid_instrument))
aid_instruments <- dplyr::arrange(aid_instruments, aid_instrument_id)

# beneficiary type data
beneficiary_types <- dplyr::tibble(
  beneficiary_type_id = c(1, 2),
  beneficiary_type = c("Small or medium-sized enterprise (SME)", "Large enterprise")
)

# NACE sector data
nace_sectors <- dplyr::select(awards, nace_sector_id, nace_sector_code, nace_sector)
nace_sectors <- dplyr::filter(nace_sectors, !duplicated(nace_sectors$nace_sector_id))
nace_sectors <- dplyr::arrange(nace_sectors, nace_sector_id)

##################################################
# awards_csts
##################################################

# create a template
template_csts <- expand.grid(
  member_states$member_state,
  2016:2020
)
names(template_csts) <- c("member_state", "year")
template_csts <- dplyr::as_tibble(template_csts)

# collapse
awards_csts <- awards %>%
  dplyr::group_by(notification_year, member_state) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>%
  dplyr::ungroup()

# rename variable
awards_csts <- dplyr::rename(awards_csts, year = notification_year)

# merge in template
awards_csts <- dplyr::left_join(template_csts, awards_csts, by = c("year", "member_state"))

# code zeros
awards_csts$count_awards[is.na(awards_csts$count_awards)] <- 0
awards_csts$total_amount_euros[is.na(awards_csts$total_amount_euros)] <- 0

# merge in member state data
awards_csts <- dplyr::left_join(awards_csts, member_states, by = "member_state")

# arrange
awards_csts <- dplyr::arrange(awards_csts, year, member_state_id)

# key ID
awards_csts$key_id <- 1:nrow(awards_csts)

# select variables
awards_csts <- dplyr::select(
  awards_csts,
  key_id, year,
  member_state_id, member_state, member_state_code,
  count_awards, total_amount_euros
)

# save
save(awards_csts, file = "data/awards_csts.RData")

##################################################
# awards_csts_bt (beneficiary type)
##################################################

# create a template
template_csts_bt <- expand.grid(
  member_states$member_state,
  2016:2020,
  beneficiary_types$beneficiary_type
)
names(template_csts_bt) <- c("member_state", "year", "beneficiary_type")
template_csts_bt <- dplyr::as_tibble(template_csts_bt)

# collapse
awards_csts_bt <- awards %>%
  dplyr::group_by(notification_year, member_state, beneficiary_type) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>%
  dplyr::ungroup()

# rename variable
awards_csts_bt <- dplyr::rename(awards_csts_bt, year = notification_year)

# merge in template
awards_csts_bt <- dplyr::left_join(template_csts_bt, awards_csts_bt, by = c("year", "member_state", "beneficiary_type"))

# code zeros
awards_csts_bt$count_awards[is.na(awards_csts_bt$count_awards)] <- 0
awards_csts_bt$total_amount_euros[is.na(awards_csts_bt$total_amount_euros)] <- 0

# merge in member state data
awards_csts_bt <- dplyr::left_join(awards_csts_bt, member_states, by = "member_state")

# merge in beneficiary type data
awards_csts_bt <- dplyr::left_join(awards_csts_bt, beneficiary_types, by = "beneficiary_type")

# arrange
awards_csts_bt <- dplyr::arrange(awards_csts_bt, year, member_state_id, beneficiary_type_id)

# key ID
awards_csts_bt$key_id <- 1:nrow(awards_csts_bt)

# select variables
awards_csts_bt <- dplyr::select(
  awards_csts_bt,
  key_id, year,
  member_state_id, member_state, member_state_code,
  beneficiary_type_id, beneficiary_type,
  count_awards, total_amount_euros
)

# save
save(awards_csts_bt, file = "data/awards_csts_bt.RData")

##################################################
# awards_csts_ai (aid instrument)
##################################################

# create a template
template_csts_ai <- expand.grid(
  member_states$member_state,
  2016:2020,
  aid_instruments$aid_instrument
)
names(template_csts_ai) <- c("member_state", "year", "aid_instrument")
template_csts_ai <- dplyr::as_tibble(template_csts_ai)

# collapse
awards_csts_ai <- awards %>%
  dplyr::group_by(notification_year, member_state, aid_instrument) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>%
  dplyr::ungroup()

# rename variable
awards_csts_ai <- dplyr::rename(awards_csts_ai, year = notification_year)

# merge in template
awards_csts_ai <- dplyr::left_join(template_csts_ai, awards_csts_ai, by = c("year", "member_state", "aid_instrument"))

# code zeros
awards_csts_ai$count_awards[is.na(awards_csts_ai$count_awards)] <- 0
awards_csts_ai$total_amount_euros[is.na(awards_csts_ai$total_amount_euros)] <- 0

# merge in member state data
awards_csts_ai <- dplyr::left_join(awards_csts_ai, member_states, by = "member_state")

# merge in aid instrument data
awards_csts_ai <- dplyr::left_join(awards_csts_ai, aid_instruments, by = "aid_instrument")

# arrange
awards_csts_ai <- dplyr::arrange(awards_csts_ai, year, member_state_id, aid_instrument_id)

# key ID
awards_csts_ai$key_id <- 1:nrow(awards_csts_ai)

# select variables
awards_csts_ai <- dplyr::select(
  awards_csts_ai,
  key_id, year,
  member_state_id, member_state, member_state_code,
  aid_instrument_id, aid_instrument,
  count_awards, total_amount_euros
)

# save
save(awards_csts_ai, file = "data/awards_csts_ai.RData")

##################################################
# awards_csts_ns (NACE sector)
##################################################

# create a template
template_csts_ns <- expand.grid(
  member_states$member_state,
  2016:2020,
  nace_sectors$nace_sector
)
names(template_csts_ns) <- c("member_state", "year", "nace_sector")
template_csts_ns <- dplyr::as_tibble(template_csts_ns)

# collapse
awards_csts_ns <- awards %>%
  dplyr::group_by(notification_year, member_state, nace_sector) %>%
  dplyr::summarize(
    count_awards = dplyr::n(),
    total_amount_euros = sum(amount_euros, na.rm = TRUE)
  ) %>%
  dplyr::ungroup()

# rename variable
awards_csts_ns <- dplyr::rename(awards_csts_ns, year = notification_year)

# merge in template
awards_csts_ns <- dplyr::left_join(template_csts_ns, awards_csts_ns, by = c("year", "member_state", "nace_sector"))

# code zeros
awards_csts_ns$count_awards[is.na(awards_csts_ns$count_awards)] <- 0
awards_csts_ns$total_amount_euros[is.na(awards_csts_ns$total_amount_euros)] <- 0

# merge in member state data
awards_csts_ns <- dplyr::left_join(awards_csts_ns, member_states, by = "member_state")

# merge in sector data
awards_csts_ns <- dplyr::left_join(awards_csts_ns, nace_sectors, by = "nace_sector")

# arrange
awards_csts_ns <- dplyr::arrange(awards_csts_ns, year, member_state_id, nace_sector_id)

# key ID
awards_csts_ns$key_id <- 1:nrow(awards_csts_ns)

# select variables
awards_csts_ns <- dplyr::select(
  awards_csts_ns,
  key_id, year,
  member_state_id, member_state, member_state_code,
  nace_sector_id, nace_sector, nace_sector_code,
  count_awards, total_amount_euros
)

# save
save(awards_csts_ns, file = "data/awards_csts_ns.RData")

################################################################################
# end R script
################################################################################
