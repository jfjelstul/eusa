################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

##################################################
# read in data
##################################################

# get list of files
files <- stringr::str_c("data-raw/transparency/", list.files("data-raw/transparency/"))

# read in data
raw <- list()
for (i in 1:length(files)) {
  temp <- read.csv(files[i], stringsAsFactors = FALSE)
  temp[, 18] <- as.character(temp[, 18])
  temp[, 17] <- as.character(temp[, 17])
  temp[, 7] <- as.character(temp[, 7])
  raw[[i]] <- temp
}
rm(i, temp, files)

# stack data frames
awards_raw <- dplyr::bind_rows(raw)
rm(raw)

# fix variables names
names(awards_raw) <- c(
  "member_state", "other_beneficiary", "title", "title_english",
  "case_number", "reference_number", "national_id",
  "beneficiary_name", "beneficiary_name_english", "beneficiary_type",
  "region", "nace_description", "aid_instrument", "aid_instrument_english",
  "objectives", "objectives_english", "nominal", "raw_amount",
  "currency", "notification_date", "authority_name", "authority_english", "publication_date"
)

##################################################
# save
##################################################

# save
save(awards_raw, file = "data-raw/working-files/awards_raw.RData")

################################################################################
# end R script
################################################################################
