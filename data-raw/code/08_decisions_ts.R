################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

# source files
source("data-raw/code/utilities/base_data.R")

##################################################
# decisions_ts
##################################################

# create a template
template_ts <- expand.grid(
  1988:2020,
  decision_types$decision_type,
  stringsAsFactors = FALSE
)
names(template_ts) <- c("year", "decision_type")

# collapse
decisions_ts <- decisions %>%
  dplyr::group_by(year, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge in template
decisions_ts <- dplyr::left_join(template_ts, decisions_ts, by = c("year", "decision_type"))

# convert to a tibble
decisions_ts <- dplyr::as_tibble(decisions_ts)

# code zeros
decisions_ts$count_decisions[is.na(decisions_ts$count_decisions)] <- 0

# merge in decision stage data
decisions_ts <- dplyr::left_join(decisions_ts, decision_types, by = "decision_type")

# arrange
decisions_ts <- dplyr::arrange(decisions_ts, year, decision_type_id)

# key ID
decisions_ts$key_id <- 1:nrow(decisions_ts)

# select variables
decisions_ts <- dplyr::select(
  decisions_ts,
  key_id, year,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_ts, file = "data/decisions_ts.RData")

##################################################
# decisions_ts_ct
##################################################

# create a template
template_ts_ct <- expand.grid(
  1988:2020,
  case_types$case_type,
  decision_types$decision_type,
  stringsAsFactors = FALSE
)
names(template_ts_ct) <- c("year", "case_type", "decision_type")

# collapse
decisions_ts_ct <- decisions %>%
  dplyr::group_by(year, case_type, decision_type) %>%
  dplyr::summarize(
    count_decisions = dplyr::n()
  ) %>%
  dplyr::ungroup()

# merge in template
decisions_ts_ct <- dplyr::left_join(template_ts_ct, decisions_ts_ct, by = c("year", "case_type", "decision_type"))

# convert to a tibble
decisions_ts_ct <- dplyr::as_tibble(decisions_ts_ct)

# code zeros
decisions_ts_ct$count_decisions[is.na(decisions_ts_ct$count_decisions)] <- 0

# merge in case type data
decisions_ts_ct <- dplyr::left_join(decisions_ts_ct, case_types, by = "case_type")

# merge in decision stage data
decisions_ts_ct <- dplyr::left_join(decisions_ts_ct, decision_types, by = "decision_type")

# arrange
decisions_ts_ct <- dplyr::arrange(decisions_ts_ct, year, case_type_id, decision_type_id)

# key ID
decisions_ts_ct$key_id <- 1:nrow(decisions_ts_ct)

# select variables
decisions_ts_ct <- dplyr::select(
  decisions_ts_ct,
  key_id, year,
  case_type_id, case_type,
  decision_type_id, decision_type,
  count_decisions
)

# save
save(decisions_ts_ct, file = "data/decisions_ts_ct.RData")

################################################################################
# end R script
################################################################################
