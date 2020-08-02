###########################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
###########################################################################

###########################################################################
# cases
###########################################################################

#' EU State Aid Cases
#'
#' A dataset of all state aid cases opened by the European Commission against EU
#' member states from 2000 through 2020 under Article 108 of the Treaty on the
#' Function of the European Union (TFEU) and Council Regulation (EC) No
#' 659/1999, updated by Council Regulation (EU) 2015/1589. These regulations
#' have a legal basis in Article 109 TFEU.
#'
#' @docType data
#'
#' @usage cases
#'
#' @format A tibble with 33 variables and 33,715 observations:
#' \describe{
#'
#' \item{\code{key_ID}}{Numeric. An ID number that uniquely identifies all
#' observations.}
#'
#' \item{\code{case_number}}{String. An ID number that uniquely identifies each
#' case.}
#'
#' \item{\code{procedure_number}}{String. A list of ID numbers that indentify
#' the proceedures associated with the case, separated by a comma.}
#'
#' \item{\code{member_state}}{String. The name of the member state that notified
#' that state aid measure.}
#'
#' \item{\code{directorate_general}}{String. The name of the Directorate-General
#' of the Commission that opened the case against the member state. Possible
#' values include: \itemize{\item{Agriculture and Rural Development},
#' \item{Competition}, and \item{Maritime Affairs and Fisheries}.}}
#'
#' \item{\code{directorate_general_code}}{String. The alphabetical code for the
#' Directorate-General of the Commission that opened the case against the member
#' state. Possible values include: \itemize{\item{\code{AGRI} (for DG
#' Agriculture and Rural Development)}, \item{\code{COMP} (for DG Competition)},
#' and \item{\code{MARE} (for DG Maritime Affairs and Fisheries)}.}}
#'
#' \item{\code{case_type}}{String. The type of the case. Possible values
#' include: \itemize{\item{\code{ad hoc case}} \item{\code{individual
#' application}} \item{\code{scheme}} \item{\code{not applicable}}}}
#'
#' \item{\code{notification_date}}{String. The date the state aid measure was
#' notified to the Commission under Article 108(3) TFEU in the format
#' \code{YYYY-MM-DD.}}
#'
#' \item{\code{decision_date}}{String. The date of the last decision made by the
#' Commission in the case in the format \code{YYYY-MM-DD}. Coded \code{NA} if
#' the measure is exempt from notification under Article 108(4) TFEU.}
#'
#' \item{\code{decisions}}{String. A list of decisions made by the Commission in
#' the case in chronological order, separated by a semi-colon. Possible values
#' include: \itemize{
#' \item{\code{Article 4(2) of Council Regulation (EC) No
#' 659/1999: decision does not constitute aid}. During its preliminary
#' investigation, Commission decided that the state aid measure notified by the
#' member state does not constitute state aid under Article 107 of the Treaty on
#' the Functioning of the European Union (TFEU).}
#' \item{\code{Article 4(3) of Council
#' Regulation (EC) No 659/1999: decision not to raise objections}. During its
#' preliminary investigation, Commission decided not to raise objections to the
#' state aid measure notified by the member state because the measure is
#' compatible with the rules of the single market, consistent with Article 107
#' of the Treaty on the Functioning of the European Union (TFEU).}
#' }}
#'
#' \item{\code{count_decisions}}{Numeric. The number of decisions made by the
#' Commission in the case. Coded \code{NA} if the state aid measure was exempt
#' from notification under Article 108(3) of the Treaty on the Functioning of
#' the European Union.}
#'
#' \item{\code{outcome}}{String. The outcome of the case. Possible values
#' include: \itemize{ \item{\code{exempt from notification} — The measure
#' notified by the member state is exempt from notification under Article 108(3)
#' TFEU so the Commission did not conduct a preliminary investigation.}
#' \item{\code{does not constitute aid} — Either during its preliminary
#' investigation or after a formal investigation, the Commission decided that
#' the measure notified by the member state does not constitute state aid under
#' Article 107 TFEU.} \item{\code{no objection} — During its preliminary
#' investigation, the Commisison decided that it had no objection to the state
#' aid measure because the measure is compatible with the rules of the single
#' market, consistent with Article 107 TFEU.} \item{\code{positive decision} —
#' After a formal investigation, the Commission decided that the state aid
#' measure is compatible with the rules of the single market, consistent with
#' Article 107 TFEU.} \item{\code{negative decision} — After a formal
#' investigation, the Commission decided that the state aid measure is not
#' compatible with the rules of the single market, consistent with Article 107
#' TFEU.} \item{\code{conditional decision} — After a formal investigation, the
#' Commission decided to approvate the state aid measure subject to conditions
#' to make the measure compatible with the rules of the single market,
#' consistent with Article 107 TFEU.} \item{\code{notification withdrawn} — The
#' member state that notified the state aid measure withdrew its notification,
#' either during the Commission's preliminary investigation or during a formal
#' investigation.} \item{\code{missing record} — The
#' Commission initiated a formal investigation but the database of state aid
#' cases managed by DG Competition does not record the Commission making any
#' decisions after initiating the formal investigation.} }}
#'
#' \item{\code{outcome_preliminary}}{String.}
#'
#' \item{\code{outcome_formal}}{String.}
#'
#' \item{\code{exempt}}{Numeric.}
#'
#' \item{\code{preliminary_investigation}}{Numeric.}
#'
#' \item{\code{formal_investigation}}{Numeric.}
#'
#' \item{\code{no_objection}}{Numeric.}
#'
#' \item{\code{not_aid}}{Numeric.}
#'
#' \item{\code{positive}}{Numeric.}
#'
#' \item{\code{negative}}{Numeric.}
#'
#' \item{\code{conditional}}{Numeric.}
#'
#' \item{\code{withdrawal}}{Numeric.}
#'
#' \item{\code{referral}}{Numeric.}
#'
#' \item{\code{recovery}}{Numeric.}
#'
#' \item{\code{start_date}}{String.}
#'
#' \item{\code{end_date}}{String.}
#'
#' \item{\code{aid_instruments}}{String.}
#'
#' \item{\code{count_aid_instruments}}{Numeric.}
#'
#' \item{\code{NACE_codes}}{String.}
#'
#' \item{\code{count_NACE_codes}}{Numeric.}
#'
#' \item{\code{OJ_citations}}{String.}
#'
#' \item{\code{count_OJ_citations}}{Numeric.}
#'
#' \item{\code{related_cases}}{String.}
#'
#' \item{\code{count_related_cases}}{Numeric.}
#'
#' }
#'
"cases"

###########################################################################
# decisions
###########################################################################

#' EU State Aid Decisions
#'
#' A dataset of all decisions in state aid cases opened by the European Commission
#' against EU member states from 2000 through 2020.
#'
#' @docType data
#'
#' @usage cases
#'
#' @format A tibble with X variables and X observations:
#'
#' \describe{
#'
#' \item{\code{key_ID}}{Numeric. An ID number that uniquely identifies all
#' observations.}
#'
#' }
#'
"decisions"

###########################################################################
# awards
###########################################################################

#' EU State Aid Awards
#'
#' A dataset of all awards granted by EU member states to firms
#' as part of approved state aid schemes from 2016 through 2020.
#'
#' The State Aid Modernisation programme (SAM) was adopted in 2014
#' and came into force on 1 July 2016.
#'
#' @docType data
#'
#' @usage cases
#'
#' @format A tibble with X variables and X observations:
#'
#' \describe{
#'
#' \item{\code{key_ID}}{Numeric. An ID number that uniquely identifies all
#' observations.}
#'
#' }
#'
"awards"

###########################################################################
# NACE codes
###########################################################################

#' NACE codes
#'
#' A dataset of NACE codes and descriptions.
#'
#' The Statistical Classification of Economic Activities in the European
#' Community (NACE, after the French "nomenclature statistique des activités
#' économiques dans la Communauté européenne") is the EU's industry standard
#' classification system (see Regulation (EC) No 1893/2006). NACE codes have
#' four levels: \itemize{\item Level 1: 21 sectors with letters (A to U) \item
#' Level 2: 88 divisions with two-digit codes (01 to 99) \item Level 3: 72
#' groups with three-digit codes (01.1 to 99.0) \item Level 4: 615 classes with
#' four-digit codes (01.11 to 99.00)}
#'
#' @docType data
#'
#' @usage nace
#'
#' @format A tibble with 4 variables and 839 observations:
#' \describe{
#'
#' \item{\code{key_ID}}{Numeric. A unique identifier for each observation.}
#'
#' \item{\code{NACE_sector}}{String. The NACE sector for the observation
#' (letters A to U).}
#'
#' \item{\code{NACE_code}}{String. The NACE sector, divison, group, or class
#' for the observation.}
#'
#' \item{\code{NACE_description}}{String. The NACE description for the sector,
#' division, group, or class.}
#'
#' }
#'
"nace"

###########################################################################
# end R script
###########################################################################
