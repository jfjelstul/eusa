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
#' \item{\code{procedure_number}}{String. A list of ID numbers that identify
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
#' \item{\code{case_type}}{String. The type of the case. Coded \code{NA} if no
#' case type is recorded in the database. Possible values include:
#' \itemize{\item{\code{ad hoc case} — A case involving a state aid measure that
#' was not granted as part of a scheme that was already approved by the
#' Commission. } \item{\code{individual application} — A case involving a state
#' aid measure that was granted as part of a scheme that was already approved by
#' the Commission (i.e., an individual application of the scheme). }
#' \item{\code{scheme} — A cases involving a state aid scheme where a member
#' state can grant awards without each award being approved individually by the
#' Commission.}}}
#'
#' \item{\code{notification_date}}{String. The date that the member state
#' responsible for the state aid mesasure notified the measure to the Commission
#' under Article 108(3) TFEU in the format \code{YYYY-MM-DD.}}
#'
#' \item{\code{decision_date}}{String. The date of the most recent decision made
#' by the Commission in the case in the format \code{YYYY-MM-DD}. Coded
#' \code{NA} if the measure is exempt from notification under Article 108(4)
#' TFEU.}
#'
#' \item{\code{decisions}}{String. A list of decisions made by the Commission in
#' the case in chronological order, separated by a semi-colon. Possible values
#' include: \itemize{
#' \item{\code{Article 108(4) of the Treaty on the Functioning of the European
#' Union (TFEU): exempt from notification under Article 108(3)} — The state aid
#' measure notified by the member state is exempt from notification under
#' Article 108(3) TFEU, either because the measure is exempt under the General
#' Block Exemption Regulation (GBER) (Commission Regulation (EC) No 800/2008),
#' or because the aid is de minimis.}
#' \item{\code{Article 4(2) of Council Regulation (EC) No 659/1999: decision
#' does not constitute aid} — After a preliminary examination, Commission
#' decided that the state aid measure notified by the member state does not
#' constitute state aid under Article 107 TFEU.}
#' \item{\code{Article 4(3) of Council Regulation (EC) No 659/1999: decision not
#' to raise objections} — After a preliminary examination, Commission decided
#' not to raise objections to the state aid measure notified by the member state
#' because the measure is compatible with the rules of the single market, as
#' defined by Article 107 TFEU.}
#' \item{\code{Article 4(4) of Council Regulation (EC) No 659/1999: decision to
#' initiate the formal investigation procedure} — After a preliminary
#' examination the Comission decided to initiate a formal investigation to
#' determine whether the state aid measure notified by the member state is
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU.}
#' \item{\code{Article 4(4) of Council Regulation (EC) No 659/1999: decision to
#' extend proceedings} — The Commission decided to extend the two-month
#' preliminary examination phase of the state aid procedure.}
#' \item{\code{Article 7(2) of Council Regulation (EC) No 659/1999: decision
#' does not constitute aid (after formal investigation procedure)} — After a
#' formal investigation, the Commission decided that the state aid measure
#' notified by the member state does not constitute state aid under Article 107
#' TFEU.}
#' \item{\code{Article 7(3) of Council Regulation (EC) No 659/1999: positive
#' decision} — After a formal investigation, the Commission decided that the
#' state aid measure notified by the member state is compatible with the rules
#' of the single market, as defined by Article 107 TFEU, and approved the
#' measure.}
#' \item{\code{Article 7(4) of Council Regulation (EC) No 659/1999: conditional
#' decision} — After a formal investigation, the Commission decided to approve
#' the state aid mesasure notified by the member state subject to conditions to
#' make the measure compatible with the rules of the single market, as defined
#' by Article 107 TFEU.}
#' \item{\code{Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999:
#' negative decision with recovery} — After a formal investigation, the
#' Commission decided that the state aid measure notified by the member state is
#' not compatible with the rules of the single market, as defined by Article 107
#' TFEU, and decided that the member state must take all necessary measures to
#' recover the aid from the beneficiary.}
#' \item{\code{Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999:
#' negative decision with recovery} — After a formal investigation, the
#' Commission decided that the state aid measure notified by the member state is
#' not compatible with the rules of the single market, as defined by Article 107
#' TFEU, and did not approve the measure.}
#' \item{\code{Article 7(5) of Council Regulation (EC) No 659/1999: negative
#' decision on notified aid} — After a formal investigation, the Commission
#' decided that the state aid measure notified by the member state is not
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU.}
#' \item{\code{Article 8(1) of Council Regulation (EC) No 659/1999: withdrawal
#' of notification (before formal investigation procedure)} — The member state
#' that notified the state aid measure decided to withdraw the notification
#' before the formal investigation procedure.}
#' \item{\code{Article 8(2) of Council Regulation (EC) No 659/1999: withdrawal
#' of notification (after formal investigation procedure)} — The member state
#' that notified the state aid measure decided to withdraw the notification
#' after the formal investigation procedure.}
#' \item{\code{Article 9 of Council Regulation (EC) No 659/1999: revocation of a
#' decision} — The Commission decided to revoke a previous decision because
#' information provided by the member state that the Commisison used in making
#' the decision was incorrect.}
#' \item{\code{Article 10(3) of Council Regulation (EC) No 659/1999: information
#' injunction} — The Commission decided to require the member state to provide
#' additional information after the member state did not provide information
#' that the Commission requested or provided incomplete information.}
#' \item{\code{Article 11(1) of Council Regulation (EC) No 659/1999: suspension
#' injunction} — The Commission decided to require the member state to suspend
#' the state aid measure until the Commission has decided whether the measure is
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU.}
#' \item{\code{Article 18 of Council Regulation (EC) No 659/1999: proposal for
#' appropriate measures} — The Commission decided to issue a recommendation
#' proposing appropriate measures to be taken by the member state because the
#' state aid scheme is not compatible with the rules of the single market, as
#' defined by Article 107 TFEU.}
#' \item{\code{Article 260(2) (ex Article 228(2)) of the Treaty on the
#' Functioning of the European Union (TFEU): referral to the Court of Justice
#' (non-compliance with a Court judgment)} — The Commission decided to refer the
#' case to the Court of Justicefor non-compliance with a Court judgment.}
#' \item{\code{Article 108(2) (ex Article 88(2)) of the Treaty on the
#' Functioning of the European Union (TFEU): referral to the Court of Justice
#' (non-implementation of a Commission decision)} — The Commission decided to
#' refer the case to the Court of Justice for non-implementation of a Commission
#' decision issued under Article 108(2) TFEU.}
#' \item{\code{Article 23(1) of Council Regulation (EC) No 659/1999: referral to
#' the Court of Justice (non-compliance with a decision)} — The Commission
#' decided to refer the case to the Court of Justice for non-compliance with a
#' Commission decision issued under Article 108(2) TFEU.}
#' \item{\code{Article 12 of Council Regulation (EC) No 659/1999: referral to
#' the Court of Justice (non-compliance with an injunction)} — The Commission
#' decided to refer the case to the Court of Justice for non-compliance with an
#' injunction issued under Article 10(3) or Article 11(1) of Council Regulation
#' (EC) No 659/1999.}
#' }}
#'
#' \item{\code{count_decisions}}{Numeric. The number of decisions made by the
#' Commission in the case. Coded \code{NA} if the state aid measure was exempt
#' from notification under Article 108(3) of the Treaty on the Functioning of
#' the European Union.}
#'
#' \item{\code{outcome}}{String. The outcome of the case. Possible values
#' include: \itemize{
#' \item{\code{exempt from notification} — The state aid measure notified by the
#' member state is exempt from notification under Article 108(3) TFEU, either
#' because the measure is exempt under the General Block Exemption Regulation
#' (GBER) (Commission Regulation (EC) No 800/2008), or because the aid is de
#' minimis.}
#' \item{\code{does not constitute aid} — Either after a preliminary
#' examination or after a formal investigation, the Commission decided that
#' the measure notified by the member state does not constitute state aid under
#' Article 107 TFEU.}
#' \item{\code{no objection} — After a preliminary examination, Commission
#' decided not to raise objections to the state aid measure notified by the
#' member state because the measure is compatible with the rules of the single
#' market, as defined by Article 107 TFEU.}
#' \item{\code{positive decision} — After a formal investigation, the Commission
#' decided that the state aid measure notified by the member state is compatible
#' with the rules of the single market, as defined by Article 107 TFEU, and
#' approved the measure.}
#' \item{\code{negative decision} — After a formal investigation, the Commission
#' decided that the state aid measure notified by the member state is not
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU, and did not approve the measure.}
#' \item{\code{conditional decision} — After a formal investigation, the
#' Commission decided to approve the state aid measure subject to conditions
#' to make the measure compatible with the rules of the single market,
#' as defined in Article 107 TFEU.}
#' \item{\code{notification withdrawn} — The member state that notified the
#' state aid measure withdrew the notification, either during the preliminary
#' examination or during a formal investigation.}
#' \item{\code{missing record} — The Commission initiated a formal investigation
#' but the database of state aid cases managed by the Directorate-General of
#' Competition does not record the Commission making any decisions after
#' initiating the formal investigation under Article 7 of Council Regulation
#' (EC) No 659/1999.}
#' }}
#'
#' \item{\code{outcome_phase_1}}{String. The outcome of the first phase of the
#' state aid procedure (the preliminary examination).}
#'
#' \item{\code{outcome_phase_2}}{String. The outcome of the second phase of the
#' state aid procedure (the formal investigation). Coded \code{not applicable}
#' if the Commission did not initiate a formal investigation under Article 7 of
#' Council Regulation (EC) No 659/1999.}
#'
#' \item{\code{exempt}}{Numeric. A dummy variable indicating whether the state
#' aid measure is exempt from the Article 108(3) TFEU notification requirement
#' under Article 108(4) TFEU.}
#'
#' \item{\code{preliminary_examination}}{Numeric. A dummy variable indicating
#' whether the Commission initiated a preliminary examination under Article
#' 108(2) TFEU.}
#'
#' \item{\code{formal_investigation}}{Numeric. A dummy variable indicating
#' whether the Commission initiated a formal investigation under Article 7 of
#' Council Regulation (EC) No 659/1999.}
#'
#' \item{\code{no_objection}}{Numeric. A dummy variable indicating whether the
#' Commission decided not to raise an objection under Article 4(3) of Council
#' Regulation (EC) No 659/1999.}
#'
#' \item{\code{not_aid}}{Numeric. A dummy variable indicating whether the
#' Commission decided that the measure does not constitute aid under Article 107
#' TFEU, either after the preliminary examination under Article 4(2) of Council
#' Regulation (EC) No 659/1999, or after a formal investigation under Article
#' 7(2) of Council Regulation (EC) No 659/1999.}
#'
#' \item{\code{positive}}{Numeric. A dummy variable indicating whether the
#' Commission decided that the measure is compatible with the rules of the
#' single market, as defined in Article 107 TFEU.}
#'
#' \item{\code{negative}}{Numeric. A dummy variable indicating whether the
#' Commission decided that the measure is not compatible with the rules of the
#' single market, as defined in Article 107 TFEU.}
#'
#' \item{\code{conditional}}{Numeric. A dummy variable indicating whether the
#' Commission decided to approve the state aid measure subject to conditions to
#' make the measure compatible with the rules of the single market, as defined
#' in Article 107 TFEU.}
#'
#' \item{\code{withdrawal}}{Numeric. A dummy variable indicating whether the
#' member state withdrew the notification, either before the formal investigaton
#' procedure, under Article 8(1) of Council Regulation (EC) No 659/1999, or
#' after the formal investigation procedure, under Article 8(2) of Council
#' Regulation (EC) No 659/1999.}
#'
#' \item{\code{referral}}{Numeric. A dummy variable indicating whether the
#' Commission referred the case to the Court of Justice for non-compliance with
#' a decision under Article 23(1) of Councl Regulation (EC) No 659/1999, for
#' non-implementation of a Commission decision under Article 108(2) (ex Article
#' 88(2)) of the Treaty on the Functioning of the European Union (TFEU), for
#' non-compliance with a Court judgment under Article 260(2) (ex Article 228(2))
#' of the Treaty on the Functioning of the European Union (TFEU), or for
#' non-compliance with an injunction under Article 12 of Council Regulation (EC)
#' No 659/1999.}
#'
#' \item{\code{recovery}}{Numeric. A dummy variable indicating whether the
#' Commission decided that the measure is not compatible with the rules of the
#' single market, as defined in Article 107 TFEU, and decided that the member
#' state must take all necessary measures to recover the aid from the
#' beneficiary.}
#'
#' \item{\code{start_date}}{String. The start date of the state aid measure in
#' the format \code{YYYY-MM-DD}. Coded \code{NA} if not applicable.}
#'
#' \item{\code{start_date}}{String. The end date of the state aid measure
#' in the format \code{YYYY-MM-DD}. Coded \code{NA} if not applicable.}
#'
#' \item{\code{aid_instruments}}{String. A list of instruments used by the state
#' aid measure, separated by a comma. Coded \code{NA} if no specific instruments
#' are reported. Possible values include:
#' \itemize{
#' \item{\code{debt write-off} — Definition.}
#' \item{\code{direct grant} — Definition.}
#' \item{\code{direct grant/interest rate subsidy} — Definition.}
#' \item{\code{fiscal measure} — Definition.}
#' \item{\code{guarantee} — Definition.}
#' \item{\code{interest subsidy} — Definition.}
#' \item{\code{loan/repayable advances} — Definition.}
#' \item{\code{other forms of equity intervention} — Definition.}
#' \item{\code{other forms of tax advantage} — Definition.}
#' \item{\code{provision of risk capital} — Definition.}
#' \item{\code{provision of risk finance} — Definition.}
#' \item{\code{reduction of social security contributions} — Definition.}
#' \item{\code{reimbursable grant} — Definition.}
#' \item{\code{repayable advances} — Definition.}
#' \item{\code{soft loan} — Definition.}
#' \item{\code{subsidised services} — Definition.}
#' \item{\code{tax advantage or tax exemption} — Definition.}
#' \item{\code{tax allowance} — Definition.}
#' \item{\code{tax base reduction} — Definition.}
#' \item{\code{tax deferment} — Definition.}
#' \item{\code{tax rate reduction} — Definition.}
#' }}
#'
#' \item{\code{count_aid_instruments}}{Numeric. The number of instruments used
#' by the state aid measure.}
#'
#' \item{\code{NACE_codes}}{String. A list of NACE codes associated with the
#' state aid measure, separated by a comma. Coded \code{NA} if no specific NACE
#' codes are reported.}
#'
#' \item{\code{count_NACE_codes}}{Numeric. The number of NACE codes associated
#' with the state aid measure.}
#'
#' \item{\code{OJ_citations}}{String. A list of citations in the Official
#' Journal (OJ) for decisions associated with the case, separated by a comma.}
#'
#' \item{\code{count_OJ_citations}}{Numeric. The number of Official Journal (OJ)
#' citations for decisions associated with the case. Coded \code{NA} if there
#' are no citations.}
#'
#' \item{\code{related_cases}}{String. A list of case numbers for related cases,
#' according to the Commission, separated by a comma. Coded \code{NA} if the
#' Commission does not identify any related cases.}
#'
#' \item{\code{count_related_cases}}{Numeric. The number of related cases,
#' according to the Commission.}
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
#' \item{\code{case_number}}{String. An ID number that uniquely identifies each
#' case.}
#'
#' \item{\code{procedure_number}}{String. A list of ID numbers that identify
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
#' \item{\code{case_type}}{String. The type of the case. Coded \code{NA} if no
#' case type is recorded in the database. Possible values include:
#' \itemize{\item{\code{ad hoc case} — A case involving a state aid measure that
#' was not granted as part of a scheme that was already approved by the
#' Commission. } \item{\code{individual application} — A case involving a state
#' aid measure that was granted as part of a scheme that was already approved by
#' the Commission (i.e., an individual application of the scheme). }
#' \item{\code{scheme} — A cases involving a state aid scheme where a member
#' state can grant awards without each award being approved individually by the
#' Commission.}}}
#'
#' \item{\code{notification_date}}{String. The date that the member state
#' responsible for the state aid mesasure notified the measure to the Commission
#' under Article 108(3) TFEU in the format \code{YYYY-MM-DD.}}
#'
#' \item{\code{decision_ID}}{Numeric. An ID number that uniquely identifies each
#' decision within a case.}
#'
#' \item{\code{decisions}}{String. A description of the decision made by the
#' Commission. Possible values include: \itemize{
#' \item{\code{Article 108(4) of the Treaty on the Functioning of the European
#' Union (TFEU): exempt from notification under Article 108(3)} — The state aid
#' measure notified by the member state is exempt from notification under
#' Article 108(3) TFEU, either because the measure is exempt under the General
#' Block Exemption Regulation (GBER) (Commission Regulation (EC) No 800/2008),
#' or because the aid is de minimis.}
#' \item{\code{Article 4(2) of Council Regulation (EC) No 659/1999: decision
#' does not constitute aid} — After a preliminary examination, Commission
#' decided that the state aid measure notified by the member state does not
#' constitute state aid under Article 107 TFEU.}
#' \item{\code{Article 4(3) of Council Regulation (EC) No 659/1999: decision not
#' to raise objections} — After a preliminary examination, Commission decided
#' not to raise objections to the state aid measure notified by the member state
#' because the measure is compatible with the rules of the single market, as
#' defined by Article 107 TFEU.}
#' \item{\code{Article 4(4) of Council Regulation (EC) No 659/1999: decision to
#' initiate the formal investigation procedure} — After a preliminary
#' examination the Comission decided to initiate a formal investigation to
#' determine whether the state aid measure notified by the member state is
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU.}
#' \item{\code{Article 4(4) of Council Regulation (EC) No 659/1999: decision to
#' extend proceedings} — The Commission decided to extend the two-month
#' preliminary examination phase of the state aid procedure.}
#' \item{\code{Article 7(2) of Council Regulation (EC) No 659/1999: decision
#' does not constitute aid (after formal investigation procedure)} — After a
#' formal investigation, the Commission decided that the state aid measure
#' notified by the member state does not constitute state aid under Article 107
#' TFEU.}
#' \item{\code{Article 7(3) of Council Regulation (EC) No 659/1999: positive
#' decision} — After a formal investigation, the Commission decided that the
#' state aid measure notified by the member state is compatible with the rules
#' of the single market, as defined by Article 107 TFEU, and approved the
#' measure.}
#' \item{\code{Article 7(4) of Council Regulation (EC) No 659/1999: conditional
#' decision} — After a formal investigation, the Commission decided to approve
#' the state aid mesasure notified by the member state subject to conditions to
#' make the measure compatible with the rules of the single market, as defined
#' by Article 107 TFEU.}
#' \item{\code{Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999:
#' negative decision with recovery} — After a formal investigation, the
#' Commission decided that the state aid measure notified by the member state is
#' not compatible with the rules of the single market, as defined by Article 107
#' TFEU, and decided that the member state must take all necessary measures to
#' recover the aid from the beneficiary.}
#' \item{\code{Articles 7(5) and 14(1) of Council Regulation (EC) No 659/1999:
#' negative decision with recovery} — After a formal investigation, the
#' Commission decided that the state aid measure notified by the member state is
#' not compatible with the rules of the single market, as defined by Article 107
#' TFEU, and did not approve the measure.}
#' \item{\code{Article 7(5) of Council Regulation (EC) No 659/1999: negative
#' decision on notified aid} — After a formal investigation, the Commission
#' decided that the state aid measure notified by the member state is not
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU.}
#' \item{\code{Article 8(1) of Council Regulation (EC) No 659/1999: withdrawal
#' of notification (before formal investigation procedure)} — The member state
#' that notified the state aid measure decided to withdraw the notification
#' before the formal investigation procedure.}
#' \item{\code{Article 8(2) of Council Regulation (EC) No 659/1999: withdrawal
#' of notification (after formal investigation procedure)} — The member state
#' that notified the state aid measure decided to withdraw the notification
#' after the formal investigation procedure.}
#' \item{\code{Article 9 of Council Regulation (EC) No 659/1999: revocation of a
#' decision} — The Commission decided to revoke a previous decision because
#' information provided by the member state that the Commisison used in making
#' the decision was incorrect.}
#' \item{\code{Article 10(3) of Council Regulation (EC) No 659/1999: information
#' injunction} — The Commission decided to require the member state to provide
#' additional information after the member state did not provide information
#' that the Commission requested or provided incomplete information.}
#' \item{\code{Article 11(1) of Council Regulation (EC) No 659/1999: suspension
#' injunction} — The Commission decided to require the member state to suspend
#' the state aid measure until the Commission has decided whether the measure is
#' compatible with the rules of the single market, as defined by Article 107
#' TFEU.}
#' \item{\code{Article 18 of Council Regulation (EC) No 659/1999: proposal for
#' appropriate measures} — The Commission decided to issue a recommendation
#' proposing appropriate measures to be taken by the member state because the
#' state aid scheme is not compatible with the rules of the single market, as
#' defined by Article 107 TFEU.}
#' \item{\code{Article 260(2) (ex Article 228(2)) of the Treaty on the
#' Functioning of the European Union (TFEU): referral to the Court of Justice
#' (non-compliance with a Court judgment)} — The Commission decided to refer the
#' case to the Court of Justicefor non-compliance with a Court judgment.}
#' \item{\code{Article 108(2) (ex Article 88(2)) of the Treaty on the
#' Functioning of the European Union (TFEU): referral to the Court of Justice
#' (non-implementation of a Commission decision)} — The Commission decided to
#' refer the case to the Court of Justice for non-implementation of a Commission
#' decision issued under Article 108(2) TFEU.}
#' \item{\code{Article 23(1) of Council Regulation (EC) No 659/1999: referral to
#' the Court of Justice (non-compliance with a decision)} — The Commission
#' decided to refer the case to the Court of Justice for non-compliance with a
#' Commission decision issued under Article 108(2) TFEU.}
#' \item{\code{Article 12 of Council Regulation (EC) No 659/1999: referral to
#' the Court of Justice (non-compliance with an injunction)} — The Commission
#' decided to refer the case to the Court of Justice for non-compliance with an
#' injunction issued under Article 10(3) or Article 11(1) of Council Regulation
#' (EC) No 659/1999.}
#' }}
#'
#' }
#'
"decisions"

###########################################################################
# awards
###########################################################################

#' EU State Aid Awards
#'
#' A dataset of all awards granted by EU member states to firms as part of
#' approved state aid schemes from 2016 through 2020. The unit of observation is
#' an individual state aid award granted through a state aid scheme already
#' approved by the Commission or as an ad hoc state aid measure approved by the
#' Commission.
#'
#' The State Aid Modernisation programme (SAM) was adopted in 2014
#' and came into force on 1 July 2016.
#'
#' @docType data
#'
#' @usage cases
#'
#' @format A tibble with 22 variables and 92,968 observations:
#'
#' \describe{
#'
#' \item{\code{key_ID}}{Numeric. An ID number that uniquely identifies all
#' observations.}
#'
#' \item{\code{case_number}}{String. An ID number that uniquely identifies the
#' Commission state aid case assocaited with the award.}
#'
#' \item{\code{reference_number}}{String. An ID number that uniquely identifies
#' each state aid award.}
#'
#' \item{\code{notification_date}}{String. The date the member state notified
#' the award to the Comission under the transparency requirements in the format
#' \code{YYYY-MM-DD}.}
#'
#' \item{\code{publication_date}}{String. The date the Commission published the
#' award in the transparency database.}
#'
#' \item{\code{member_state}}{String. The name of the member state that notified
#' the award.}
#'
#' \item{\code{authority}}{String. The name of the national, regional, or local
#' government authority that granted the state aid award. Note that this
#' variable is not cleaned. The text of the names appears exactly how it is
#' entered in the transparency database.}
#'
#' \item{\code{region}}{String. The name of the region where the state aid award
#' was granted. This variable uses the Nomenclature des Unités Territoriales
#' Statistiques (NUTS) classification system for subnational territories. Note
#' that this variable is not cleaned. The text of the names appears exactly how
#' it is entered in the transparency database.}
#'
#' \item{\code{beneficiary_name}}{String. The name of the firm that recieved the
#' state aid award. Note that this variable is not cleaned. The text of the
#' names appears exactly how it is entered in the transparency database.}
#'
#' \item{\code{beneficiary_type}}{String. The type of the firm that received the
#' state aid award. Possible values include \code{small and medium-sized
#' enterprise (SME)} and \code{large enterprise}}.
#'
#' \item{\code{NACE_sector}}{String. The NACE sector of the firm that received the state aid award.
#' NACE sectors are identified by the letters A to U.}
#'
#' \item{\code{NACE_code}}{String. The NACE sector, division, group, or class of the firm that received
#' the state aid award. Note that some firms are coded at a higher level of specificity than others in the transparency database.}
#'
#' \item{\code{NACE_description}}{String. The NACE description of the sector, division, group, or class of the firm
#' that received the state aid award.}
#'
#' \item{\code{aid_instrument}}{The policy instrument used in granting the
#' award. Possible values include: \itemize{
#' \item{\code{direct grant} — Definition.}
#' \item{\code{direct grant/interest rate subsidy} — Definition.}
#' \item{\code{guarantee} — Definition.}
#' \item{\code{interest subsidy} — Definition.}
#' \item{\code{loan/repayable advances} — Definition.}
#' \item{\code{other} — Definition.}
#' \item{\code{provision of risk capital} — Definition.}
#' \item{\code{provision of risk finance} — Definition.}
#' \item{\code{reduction of social security contributions} — Definition.}
#' \item{\code{reimbursable grant} — Definition.}
#' \item{\code{repayable advances} — Definition.}
#' \item{\code{soft loan} — Definition.}
#' \item{\code{subsidised services} — Definition.}
#' \item{\code{tax advantage or tax exemption} — Definition.}
#' \item{\code{tax allowance} — Definition.}
#' \item{\code{tax base reduction} — Definition.}
#' \item{\code{tax rate reduction} — Definition.}
#' }}
#'
#' \item{\code{raw_amount}}{Numeric. The amount of the award denominated in the
#' currency of the member state that provided the award. Coded \code{NA} if the
#' amount of the award is not recorded in the transparency database. This is the
#' actual or estimated economic value of the award as reported by the member
#' state, not only the nominal amount. When reporting the value of the award,
#' member states can report a range if the exact value would reveal valuable
#' information to the competitors of the beneficiary. When this occurs, the
#' value of this variable is the midpoint of the reported range. Note that
#' values are not comparable across observations because different observations
#' are denominated in different currencies.}
#'
#' \item{\code{currency}}{String. The currency that the raw amount of the award
#' is denominated in. Coded \code{NA} if the amount of the award is not reported
#' in the transparency database. Possible values include: \itemize{
#' \item{\code{euro} (EUR, European Union)}
#' \item{\code{forint} (HUF, Hungary)}
#' \item{\code{koruna} (CZK, Czech Republic)}
#' \item{\code{krona} (SEK, Sweden)}
#' \item{\code{krone} (DKK, Denmark)}
#' \item{\code{kuna} (HRK, Croatia)}
#' \item{\code{lev} (BGN, Bulgaria)}
#' \item{\code{pound} (GBP, United Kingdom)}
#' }}
#'
#' \item{\code{range}}{Numeric. A dummy variable indicating whether the member
#' state reported the amount of the award as a range. Coded \code{NA} if the
#' amount of the award is not reported in the transparency database.}
#'
#' \item{\code{range_min}}{Numeric. If the member state reported the amount of the award
#' as a range, the minimum value of the award. Coded \code{NA} if the member
#' state did not report the amount as the range or if the amount of the award is
#' not reported in the transparency database.}
#'
#' \item{\code{range_max}}{Numeric. If the member state reported the amount of the award
#' as a range, the maximum value of the award. Coded \code{NA} if the member
#' state did not report the amount as the range or if the amount of the award is
#' not reported in the transparency database.}
#'
#' \item{\code{exchange_rate}}{Numeric. The value of one unit of the currency of the
#' member state that granted the award in euros on the weekday to the
#' notificate date that a exchange rate quotation is available. Used to convert
#' the raw amount of the state aid award to euros. This is an exchange rate
#' quotation in which the currency of the member state is the fixed currency and
#' the euro is the variable currency. For example, if the currency in question
#' is the pound sterling (GBR), and the GBR/EUR exchange rate is approximately
#' 1.2, then one pound is equivalent to 1.2 euros. If the value of the award was
#' reported in euros, the value will be 1. The daily exchange rate quotations
#' are from Yahoo Finance.}
#'
#' \item{\code{adjusted_amount}}{Numeric. The amount of the award in euros. Coded
#' \coded{NA}. This is the raw value of the award in the currency of the member
#' state that granted the award times the exchange rate (the value of one unit
#' of that currency in euros). Unlike the raw amount, this variable is directly
#' comparable across observations.}
#'
#' \item{\code{voluntary}}{Numeric. A dummy variable indicating whether the amount
#' of the state aid award is under the manditory reporting theshold.}
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
