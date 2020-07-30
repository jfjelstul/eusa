###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

#################################################
# read in data
#################################################

# get list of files
files <- stringr::str_c("data-raw/", list.files("data-raw/"))

# read in data
raw <- list()
for(i in 1:length(files)) {
  temp <- read.csv(files[i], stringsAsFactors = FALSE)
  temp[, 18] <- as.character(temp[, 18])
  temp[, 17] <- as.character(temp[, 17])
  temp[, 7] <- as.character(temp[, 7])
  raw[[i]] <- temp
}
rm(temp)

# stack data frames
aid <- dplyr::bind_rows(raw)

# fix variables names
names(aid) <- c(
  "member_state", "other_beneficiary", "title", "title_english",
  "case_number", "reference_number", "national_id",
  "beneficiary_name", "beneficiary_name_english", "beneficiary_type",
  "region", "subsector", "aid_instrument", "aid_instrument_english",
  "objectives", "objectives_english", "nominal", "amount",
  "currency", "date", "authority", "authority_english", "publication_date"
)

# select variables
aid <- dplyr::select(aid, case_number, reference_number, date, publication_date, member_state, authority, beneficiary_name, beneficiary_type, subsector, region, aid_instrument, objectives, amount, currency)

# clean amount
aid$amount <- stringr::str_replace(aid$amount, "<|>", "")
aid$amount <- stringr::str_replace_all(aid$amount, ",", "")
aid$amount <- stringr::str_squish(aid$amount)

# is amount is in euros?
aid$euros <- as.numeric(stringr::str_detect(aid$amount, "EUR"))

# is the amount an estimate?
aid$estimate <- as.numeric(stringr::str_detect(aid$amount, "-"))

# table(aid$amount[aid$estimate == 1])

# recode estimates
aid$amount[aid$amount == "1000000 - 2000000"] <- (1000000 + 2000000) / 2
aid$amount[aid$amount == "10000000 - 30000000"] <- (10000000 + 30000000) / 2
aid$amount[aid$amount == "1000001 - 2000000"] <- (1000000 + 2000000) / 2
aid$amount[aid$amount == "2000000 - 5000000"] <- (2000000 + 5000000) / 2
aid$amount[aid$amount == "2000001 - 5000000"] <- (2000000 + 5000000) / 2
aid$amount[aid$amount == "30000 - 200000"] <- (30000 + 200000) / 2
aid$amount[aid$amount == "500000 - 1000000"] <- (500000 + 1000000) / 2
aid$amount[aid$amount == "5000000 - 10000000"] <- (5000000 + 10000000) / 2
aid$amount[aid$amount == "500001 - 1000000"] <- (500000 + 1000000) / 2
aid$amount[aid$amount == "60000 - 500000"] <- (60000 + 500000) / 2
aid$amount <- as.numeric(aid$amount)
aid$amount <- round(aid$amount)

# cut-off
aid$below_threshold <- as.numeric(aid$amount < 500000)

# clean aid instrument
aid$aid_instrument <- stringr::str_to_lower(aid$aid_instrument)
aid$aid_instrument[stringr::str_detect(aid$aid_instrument, "other|stateaidfinancingtype")] <- "other"
aid$aid_instrument[stringr::str_detect(aid$aid_instrument, "guarantee")] <- "guarantee"
aid$aid_instrument[aid$aid_instrument == "direct grant/ interest rate subsidy"] <- "direct grant/interest rate subsidy"
aid$aid_instrument[aid$aid_instrument == "loan/ repayable advances"] <- "loan/repayable advances"

table(aid$aid_instrument)

# firm size
aid$small_firms <- as.numeric(stringr::str_detect(aid$beneficiary_type, "Small and medium-sized entreprises"))
aid$large_firms <- 1 - aid$small_firms

#################################################
# fix dates
#################################################

# convert to date
aid$date <- lubridate::dmy(aid$date)

# change format
aid$date <- lubridate::ymd(aid$date)

# convert to date
aid$publication_date <- lubridate::dmy(aid$publication_date)

# change format
aid$publication_date <- lubridate::ymd(aid$publication_date)

#################################################
# currency conversion
#################################################

# Bulgaria (BGN, lev)
# Croatia (HRK, kuna)
# Czech Republic (CZK, koruna)
# Denmark (DKK, krone)
# Hungary (HUF, forint)
# Lithuania (LTL, litas)
# Sweden (SEK, krona)
# United Kingdom (GBP, pound)

table(aid$currency)

# list of non-Eurozone member states
list <- c("Bulgaria", "Croatia", "Czech Republic", "Denmark", "Hungary", "Sweden", "United Kingdom")

# set working directory
setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")

# read in data
rates <- read.csv("exchange_rates.csv", stringsAsFactors = FALSE)

# select variables
rates <- select(rates, Date, BGN, HRK, CZK, DKK, HUF, SEK, GBP)

# rename variable
names(rates)[names(rates) == "Date"] <- "date"

# fix date variable
rates$date <- as.Date(rates$date, format = "%Y-%m-%d")

# select observations
rates <- filter(rates, date > as.Date("2016/07/01", format = "%Y/%m/%d"))

# convert currencies
for(i in 1:nrow(dat)) {
  if(dat$member_state[i] %in% list & dat$euros[i] == 0) {
     x <- abs(rates$date - dat$date[i])
     index <- which(x == min(x))
     if(dat$member_state[i] == "Bulgaria") {
      v <- rates$BGN[index]
     }
     if(dat$member_state[i] == "Croatia") {
       v <- rates$HRK[index]
     }
     if(dat$member_state[i] == "Czech Republic") {
       v <- rates$CZK[index]
     }
     if(dat$member_state[i] == "Denmark") {
       v <- rates$DKK[index]
     }
     if(dat$member_state[i] == "Hungary") {
       v <- rates$HUF[index]
     }
     if(dat$member_state[i] == "Sweden") {
       v <- rates$SEK[index]
     }
     if(dat$member_state[i] == "United Kingdom") {
       v <- rates$GBP[index]
     }
     else {
       v <- 1
     }
     v <- 1 / v
     dat$award[i] <- dat$award[i] * v
  }
}

# log amount
dat$log_amount <- log(dat$amount + 1)

#################################################
# interest rates
#################################################

# setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")
#
# # read in data
# rates <- read.csv("interest_rates.csv", stringsAsFactors = FALSE)
#
# # fix dates
# dat$year <- as.numeric(str_extract(dat$date, "^[0-9]{4}"))
# dat$month <- str_extract(dat$date, "-[0-9]{2}-")
# dat$month <- as.numeric(str_replace_all(dat$month, "-", ""))
#
# # drop invalid date
# dat <- filter(dat, date != "2016-04-09")
#
# # get interest rate
# dat$interest_rate <- NA
# for(i in 1:nrow(dat)) {
#   if(dat$member_state[i] %in% unique(rates$member_state)) {
#     dat$interest_rate[i] <- rates$interest_rate[rates$member_state == dat$member_state[i] & rates$year == dat$year[i] & rates$month == dat$month[i]]
#   }
# }

#################################################
# election data
#################################################

# Austria: October 2017, November 2022
# Belgium: June 2019
# Estonia: March 2019
# Finland: April 2019
# France: April 2022
# Germany: September 2017, October 2021
# Ireland: April 2021
# Latvia: October 2018
# Lithuania: October 2016, October 2020
# Luxembourg: October 2018
# Netherlands: March 2017, March 2021
# Portugal: October 2019
# Slovakia: March 2020

elections <- read.csv("state_aid_elections.csv", stringsAsFactors = FALSE)
elections$last_date <- as.Date(elections$last_date, format = "%Y-%m-%d")
elections$next_date <- as.Date(elections$next_date, format = "%Y-%m-%d")

dat$next_election <- NA
for(i in 1:nrow(dat)) {
  dat$next_election[i] <- ifelse(dat$date[i] < elections$last_date[elections$member_state == dat$member_state[i]],
                                 as.numeric(elections$last_date[elections$member_state == dat$member_state[i]] - dat$date[i]),
                                 as.numeric(elections$next_date[elections$member_state == dat$member_state[i]] - dat$date[i]))
}

dat$ln_next_election <- log(dat$next_election)

#################################################
# NACE codes
#################################################

# set working directory
setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")

# read in data
nace <- read.csv("NACE_codes.csv", stringsAsFactors = FALSE)

# code
nace$code <- str_extract(nace$NACE, "^[A-Z0-9.]+")

# sector
nace$sector <- str_extract(nace$NACE, "^[A-Z]")

# description
nace$subsector <- str_extract(nace$NACE, "-.*")
nace$subsector <- str_replace(nace$subsector, "- ", "")
nace$subsector <- str_trim(nace$subsector)

# drop duplicates
nace$drop <- str_detect(nace$code, "\\.0$")
nace <- filter(nace, drop == FALSE)
nace$drop <- NULL
nace$duplicated <- duplicated(nace$subsector)
nace <- filter(nace, duplicated == FALSE)
nace$duplicated <- NULL

# catgories
nace$manufacturing <- as.numeric(str_detect(nace$sector, "C"))
nace$construction <- as.numeric(str_detect(nace$sector, "F"))
nace$services <- as.numeric(str_detect(nace$sector, "G|I"))
nace$infrastructure <- as.numeric(str_detect(nace$sector, "D|E|H|J"))
nace$other <- as.numeric(str_detect(nace$sector, "A|B|K|L|M|N|O|P|Q|R|S|T|U"))

# merge
nace$NACE <- NULL
dat <- left_join(dat, nace, by = "subsector")

# categorical variable
dat$group <- "Other"
dat$group[dat$manufacturing == 1] <- "Manufacturing"
dat$group[dat$construction == 1] <- "Construction"
dat$group[dat$services == 1] <- "Services"
dat$group[dat$infrastructure == 1] <- "Infrastructure"

#################################################
# Eurobarometer data
#################################################

# # set working directory
# setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")
#
# # read in data
# survey <- read.csv("firm_survey_data.csv", stringsAsFactors = FALSE)
#
# # reputation variables
# survey$Eurobarometer_reputation <- (survey$very_positive + survey$fairly_positive - (survey$very_negative + survey$fairly_negative)) / (survey$very_positive + survey$fairly_positive + survey$fairly_negative + survey$very_negative + survey$no_impact)
# survey$Eurobarometer_positive <- survey$very_positive + survey$fairly_positive
# survey$Eurobarometer_negative <- survey$very_negative + survey$fairly_negative
#
# # merge data
# dat <- left_join(dat, survey, by = "member_state")

#################################################
# EIB data
#################################################

# read in data
survey <- read.csv("EIB_reputation_survey.csv", stringsAsFactors = FALSE)

# rename variables
names(survey) <- c("member_state", "year", "sector", "size", "population", "EIB_net", "EIB_positive", "EIB_neutral", "EIB_negative")

# select variables
survey <- select(survey, member_state, sector, size, EIB_net, EIB_positive, EIB_neutral, EIB_negative)

# drop observations
survey <- filter(survey, member_state != "EU countries")
survey <- filter(survey, size == "All")
survey$member_state[survey$member_state == "the United Kingdom"] <- "United Kingdom"
survey$sector[survey$sector == "All"] <- "Other"
survey$size <- NULL

# merge
dat <- left_join(dat, survey, by = c("member_state" = "member_state", "group" = "sector"))

#################################################
# export
#################################################

# standardize function
standardize <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

# output data
output <- dat

# clean
output$subsector <- output$code
output$sensitivity <- -abs(output$EIB_negative - mean(output$EIB_negative))

# standardize variables
# output$negative_reputation <- standardize(output$EIB_negative)
# output$sensitivity <- standardize(output$sensitivity)
# output$treatment <- as.numeric(output$negative_reputation > -0.5 & output$negative_reputation < 0.5)
output$negative_reputation <- output$EIB_negative
output$negative_reputation_2 <- output$negative_reputation ^ 2
output$beneficiary <- output$beneficiary_name

# choose observations
output <- select(output, member_state, authority, euros, group, sector, subsector, group, aid_instrument, beneficiary, SMEs, amount, log_amount, negative_reputation, negative_reputation_2, sensitivity, next_election, ln_next_election, CEEC, euros, estimate, imputed, small_award, below_threshold)

# export data
write.csv(output, "state_aid_final.csv", row.names = FALSE, na = "")

##################################################################################################
##################################################################################################
# analysis
##################################################################################################
##################################################################################################

# libraries
library(multiwayvcov)
library(lmtest)

# colors
color1 <- "#3D639D"
color2 <- "#D16639"
color3 <- "#E2A247"
color4 <- "#0F95C9"
color5 <- "#13A29B"
color1b <- "#7692BC"
color2b <- "#E09D73"
color3b <- "#F6DEB5"

# set working directory
setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")

# read in data
output <- read.csv("state_aid_final.csv", stringsAsFactors = FALSE)

# prepare data
dat <- filter(output, below_threshold == 0 & group != "Other" & aid_instrument != "Other" & estimate == 0 & imputed == 0)
dat <- na.omit(dat)

# convert to factors
dat$member_state <- as.factor(dat$member_state)
dat$authority <- as.factor(dat$authority)
dat$group <- as.factor(dat$group)
dat$sector <- as.factor(dat$sector)
dat$subsector <- as.factor(dat$subsector)
dat$aid_instrument <- as.factor(dat$aid_instrument)

# plot data
plot1 <- ggplot(data = dat, aes(x = negative_reputation, y = log_amount)) +
  geom_point(color = "#768BB6", fill = color1, alpha = 0.3) +
  geom_smooth(method = "loess", span = 1, color = color2, fill = color2, alpha = 0.5, size = 0.5) +
  xlab("Negative Reputation") +
  ylab("Award Value (Log)") +
  ggtitle("Panel A") +
  theme_bw()
plot2 <- ggplot(data = dat, aes(x = sensitivity, y = log_amount)) +
  geom_point(color = color1, fill = color1, alpha = 0.3) +
  geom_smooth(method = "lm", color = color2, fill = color2, alpha = 0.5, size = 0.5) +
  xlab("Sensitivity") +
  ylab("Award Value (Log)") +
  ggtitle("Panel B") +
  theme_bw()

plot3 <- ggplot(data = dat, aes(x = negative_reputation, y = log_amount)) +
  geom_point(color = color1, fill = color1, alpha = 0.3) +
  geom_smooth(method = "loess", span = 0.4, color = color2, fill = color2, alpha = 0.5, size = 0.5) +
  xlab("Negative Reputation") +
  ylab("Award Value (Log)") +
  theme_bw()
plot3

# model formulas
f1 <- log_amount ~ sensitivity + SMEs + aid_instrument + member_state + sector
f2 <- log_amount ~ negative_reputation + negative_reputation_2 + SMEs + aid_instrument + member_state + sector
f3 <- log_amount ~ negative_reputation + SMEs + aid_instrument + sector

# run models
mod1 <- lm(f1, dat)
mod2 <- lm(f2, dat)
mod3 <- lm(f3, dat)

# look at results
round(coeftest(mod1, mod1$vcov)[1:3,], 5)
round(coeftest(mod2, mod2$vcov)[1:4,], 5)
round(coeftest(mod3, mod3$vcov)[1:3,], 5)

dat$upcoming_election <- as.numeric(dat$next_election < 365)
dat$large_firm <- 1 - dat$SMEs

# models
f <- log_amount ~ negative_reputation + upcoming_election + large_firm + member_state + aid_instrument + sector
mod <- lm(f, dat)
mod$vcov <- cluster.vcov(mod, ~ member_state + sector, force_posdef = TRUE)
round(coeftest(mod, mod$vcov), 3)

# clustered standard errors
# vcov <- cluster.vcov(mod1, ~ member_state + sector, force_posdef = TRUE)
# round(coeftest(mod1, vcov)[1:4,], 5)
# vcov <- cluster.vcov(mod1, ~ member_state + sector + authority + subsector, force_posdef = TRUE)
# round(coeftest(mod1, vcov)[1:4,], 5)

# bootstrapped clustered standard errors
# set.seed(17463)
# boot <- cluster.boot(mod, ~ member_state + sector, R = 300, boot_type = "wild", force_posdef = TRUE)
# round(coeftest(mod, boot)[1:4,], 5)

# simulated data
sim1 <- data.frame(sensitivity = seq(-3.9, 1.9, 0.1), SMEs = mean(x$SMEs), aid_instrument = "Direct grant/ Interest rate subsidy", member_state = "Germany", sector = "C")
pred1 <- predict(mod1, sim1, type = "response", se.fit = TRUE)
sim1$b <- pred1$fit
sim1$se <- pred1$se.fit
sim2 <- data.frame(negative_reputation = seq(-1.9, 2.7, 0.1), negative_reputation_2 = seq(-1.9, 2.7, 0.1) ^ 2, SMEs = mean(x$SMEs), aid_instrument = "Direct grant/ Interest rate subsidy", member_state = "France", sector = "C")
pred2 <- predict(mod2, sim2, type = "response", se.fit = TRUE)
sim2$b <- pred2$fit
sim2$se <- pred2$se.fit

# predicted values (direct grant/interest rate subsidy, Germany, C)
plot3 <- ggplot() +
  geom_line(data = sim2, aes(x = negative_reputation, y = b), color = color1) +
  geom_ribbon(data = sim2, aes(x = negative_reputation, ymin = b - 1.96 * se, ymax = b + 1.96 * se), fill = color1, color = color1, alpha = 0.5) +
  xlab("Negative Reputation") +
  ylab("Award Value (Log)") +
  ggtitle("Panel C") +
  theme_bw()
plot4 <- ggplot() +
  geom_line(data = sim1, aes(x = sensitivity, y = b), color = color1) +
  geom_ribbon(data = sim1, aes(x = sensitivity, ymin = b - 1.96 * se, ymax = b + 1.96 * se), fill = color1, color = color1, alpha = 0.5) +
  xlab("Sensitivity") +
  ylab("Award Value (Log)") +
  ggtitle("Panel D") +
  theme_bw()

# save
setwd("~/Dropbox/Professional/Projects/State Aid Paper/Plots/")
png(filename = "results.png", width = 12, height = 9, units = "in", res = 150)
grid.arrange(plot1, plot2, plot3, plot4, ncol = 2, nrow = 2, widths = c(1, 1), heights = c(1, 1))
dev.off()

#################################################
# summary statistics
#################################################

# set working directory
setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")

# read in data
dat <- read.csv("state_aid_final.csv", stringsAsFactors = FALSE)

plot1 <- ggplot() +
  geom_density(data = output, aes(x = log_amount), size = 0.5, color = color1, fill = color1, alpha = 0.5, adjust = 1.25) +
  geom_vline(xintercept = 13.12236, linetype = "dashed", color = "black", size = 0.5) +
  xlab("Log(Award Value)") +
  ylab("Density") +
  ggtitle("Panel A") +
  theme_bw() +
  theme(plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

plot2 <- ggplot() +
  geom_density(data = output, aes(x = negative_reputation), size = 0.5, color = color1, fill = color1, alpha = 0.5, adjust = 1.25) +
  xlab("Negative Reputation") +
  ylab("Density") +
  ggtitle("Panel B") +
  theme_bw() +
  theme(plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

plot3 <- ggplot() +
  geom_density(data = output, aes(x = sensitivity), size = 0.5, color = color1, fill = color1, alpha = 0.5, adjust = 1.5) +
  xlab("Sensitivity") +
  ylab("Density") +
  ggtitle("Panel C") +
  theme_bw() +
  theme(plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# save
setwd("~/Dropbox/Professional/Projects/State Aid Paper/Plots/")
png(filename = "densities.png", width = 12, height = 5, units = "in", res = 150)
grid.arrange(plot1, plot2, plot3, ncol = 3, nrow = 1, widths = c(1, 1, 1), heights = 1)
dev.off()

#################################################
# aid instrument summary
#################################################

plot <- ggplot(x, aes(x = factor(aid_instrument))) +
  geom_bar(width = 0.8, position = position_dodge(), fill = color1) +
  xlab(NULL) +
  ylab("Proportion of Respondents") +
  # ylim(0, 0.8) +
  # scale_fill_manual(guide = "none", values = c(color1, color2, color3, color4)) +
  theme_bw() +
  theme(legend.position = "bottom",
        legend.direction = "vertical",
        plot.margin = unit(c(0.5, 0, 0.5, 0.5), "cm"))

table(x$aid_instrument) / nrow(x)

#################################################
# coefficent plot
#################################################

# # set working directory
# setwd("~/Dropbox/Professional/Projects/State Aid Paper/Data/")
#
# # read in data
# coefficients <- read.csv("coefficients.csv", stringsAsFactors = FALSE)
# coefficients$var <- factor(coefficients$var, levels = coefficients$var[nrow(coefficients):1])
# coefficients <- filter(coefficients, var != "Intercept")
#
# # make plot
# plot <- ggplot(coefficients) +
#   geom_hline(yintercept = 0, linetype = "dashed", color = "black", size = 0.5) +
#   geom_pointrange(aes(x = var, y = b, ymin = lb, ymax = ub), color = "#768BB6", fill = "#768BB6", size = 0.5) +
#   coord_flip () +
#   geom_vline(xintercept = 7.5, linetype = "solid", color = "black", size = 0.25) +
#   geom_vline(xintercept = 16.5, linetype = "solid", color = "black", size = 0.25) +
#   geom_vline(xintercept = 28.5, linetype = "solid", color = "black", size = 0.25) +
#   scale_y_continuous(breaks = seq(-30, 40, by = 5)) +
#   xlab(NULL) +
#   ylab("Coefficient Estimate") +
#   theme_bw() +
#   theme(panel.grid.minor = element_blank(),
#         panel.grid.major.x = element_blank())
#
# # view plot
# plot

#################################################
# end R script
#################################################
