% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cases.R
\docType{data}
\name{cases}
\alias{cases}
\title{Case-level data}
\format{
A data frame with 42 variables:
\describe{
\item{key_id}{\code{numeric}. An ID number that uniquely identifies each
observation in the dataset. }
\item{case_id}{\code{string}. An ID number that uniquely identifies each
state aid case. Assigned by the Commission. The Commission changed the
format of case numbers in 2010. Before this change, the case number
indicated the type(s) of the procedure associated with the case. After this
change, all case numbers have the format \code{SA.#####}.}
\item{procedure_numbers}{\code{string}. Numbers that uniquely identifiy
each procedure associated with a case. If there are multiple procedures,
the procedure numbers are listed and separated by a comma. After the
Commission changed the format of case numbers in 2010, only procedure
numbers indicate the types of procedures associated with a case.}
\item{member_state_id}{\code{numeric}. An ID number that uniquely
identifies each member state. This ID number is assigned when member states
are sorted by accession date and then alphabetically. }
\item{member_state}{\code{string}. The name of the member state that the
Commission opened the case against. }
\item{member_state_code}{\code{string}. A two letter code assigned by the
Commission that uniquely identifies each member state. }
\item{department_id}{\code{numeric}. An ID number that uniquely identifies
each Directorate-General (DG) of the Commission. There are three DGs that
can open state aid cases. The DG for Competition (COMP) is coded \code{1},
the DG for Agriculture and Rural Development (AGRI) is coded \code{2}, and
the DG for Maritime Affairs and Fisheries (MARE) is coded \code{3}.}
\item{department}{\code{string}. The name of the Directorate-General (DG)
of the Commission that opened the state aid case.}
\item{department_code}{\code{string}. A multi-letter code assigned by the
Commission that uniquely identifies each Directorate-General (DG) of the
Commission. }
\item{case_type_id}{\code{numeric}. An ID number that uniquely identifies
each type of state aid cases. Coded \code{1} for cases that involve state
aid measures granted through Commission-approved schemes that is not
notifiable, coded \code{2} for cases that involve state aid measures
granted through Commission-approved schemes where the Commission has
required that the member state notify any aid granted through the scheme,
and coded \code{3} for cases that involve ad hoc state aid measures that
are not granted through a scheme.}
\item{case_type}{\code{string}. The type of the state aid case. There are
three types of cases. Coded \code{Scheme} for cases that involve state aid
measures granted through Commission-approved schemes that is not
notifiable, coded \code{Individual application} for cases that involve
state aid measures granted through Commission-approved schemes where the
Commission has required that the member state notify any aid granted
through the scheme, and coded \code{Ad hoc} for cases that involve ad hoc
state aid measures that are not granted through a scheme.}
\item{procedure_types}{\code{string}. A list of the types of procedures
associated with the case, separated by a comma. Procedure types are listed
in the order that the Commission opened the procedures. Possible values
include: \code{Contradictory aid}, for state aid that the Commission
suspects violates the rules of the internal market, as defined by Article
107 of the Treaty of the Functioning of the European Union (TFEU);
\code{Existing aid}, for existing state aid measures; \code{Notified aid},
for state aid that the member state has notified to the Commission;
\code{Unnotified aid}, for state aid that the member state has not notified
to the Commission; \code{General block exemption}, for state aid that is
exempt from notification under the General Block Exemption Regulation
(GBER); and \code{Special block exemption}, for state aid that is exempt
from notification under a specific block exemption.}
\item{contradictory_aid}{\code{dummy}. A dummy variable indicating whether
the case relates to whether the Commission suspects that the state aid
measure is contradictory to the rules of the single market, as defined by
Article 107 of the Treaty of the Functioning of the European Union (TFEU).
Coded \code{1} if it does and \code{0} if it does not.}
\item{existing_aid}{\code{dummy}. A dummy variable indicating whether the
case relates to existing state aid measures. Coded \code{1} if it does and
\code{0} if it does not.}
\item{notified_aid}{\code{dummy}. A dummy variable indicating whether the
case relates to state aid notified by the member state. Coded \code{1} if
it does and \code{0} if it does not.}
\item{unnotified_aid}{\code{dummy}. A dummy variable indicating whether the
case relates to state aid that is not notified by the member state. Coded
\code{1} if it does and \code{0} if it does not.}
\item{general_block_exemption}{\code{dummy}. A dummy variable indicating
whether the case relates to state that is exempt from notification under
the General Block Exemption Regulation (GBER). Coded \code{1} if it does
and \code{0} if it does not.}
\item{specific_block_exemption}{\code{dummy}. A dummy variable indicating
whether the case relates to state aid that is exempt from notification
under a specific block exemption. Coded \code{1} if it does and \code{0} if
it does not.}
\item{notification_date}{\code{date}. The date the member state notified
the Commission of the state aid measure in the format \code{YYYY-MM-DD}. }
\item{notification_year}{\code{numeric}. The year the member state notified
the Commission of the state aid measure.}
\item{notification_month}{\code{numeric}. The month the member state
notified the Commission of the state aid measure.}
\item{notification_day}{\code{numeric}. The day the member state notified
the Commission of the state aid measure.}
\item{outcome_date}{\code{date}. The date the Commission took its last
decision in the case in the format \code{YYYY-MM-DD}.}
\item{outcome_year}{\code{numeric}. The year the Commission took its last
decision in the case.}
\item{outcome_month}{\code{numeric}. The month the Commission took its last
decision in the case.}
\item{outcome_day}{\code{numeric}. The day the Commission took its last
decision in the case.}
\item{decisions}{\code{string}. A list of all of the decisions made by the
Commission in the case, separated by a semicolon.}
\item{count_decisions}{\code{numeric}. The total number of decisions made
by the Commission in the case. }
\item{outcome}{\code{string}. The outcome of the case. Possible values
include: \code{Exempt from notification}, \code{Does not constitute aid},
\code{No objection}\code{Positive Decision}, \code{Negative Decision},
\code{Conditional decision}. Coded \code{Notification withdrawn} if the
member state withdrew the notification, either before the formal
investigation procedure under Article 10(1) of Council Regulation (EU)
2015/1589, formerly Article 8(1) of Council Regulation (EC) No 659/1999, or
during the formal investigation procedure under Article 10(2) of Council
Regulation (EU) 2015/1589, formerly Article 8(2) of Council Regulation (EC)
No 659/1999. }
\item{outcome_phase_1}{\code{string}. If the Commission opened a
preliminary investigation, the outcome of that phase of the procedure.
Possible values include: \code{Does not constitute aid}, \code{No
objection}, \code{Formal investigation}, and \code{Notification withdrawn}.
Coded \code{Not applicable} if the Commission did not open a preliminary
investigation, which is when it determines that the state aid measure is
exempt from notification under Article 108(2) of the Treaty on the
Functioning of the European Union (TFEU).}
\item{outcome_phase_2}{\code{string}. If the Commission opened a formal
investigation, the outcome of that phase of the procedure. Possible values
include: \code{Conditional decision}, \code{Does not constitute aid},
\code{Negative decision}, \code{Notification withdrawn}, and \code{Positive
decision}. Coded \code{Not applicable} if the Commission did not open a
formal investigation under Article 4(4) of Council Regulation (EU)
2015/1589, formerly Article 4(4) of Council Regulation (EC) No 659/1999.
Coded \code{Missing record} for a small number of observations where the
Commission does not report data.}
\item{exempt}{\code{dummy}. A dummy variable indicating whether the state
aid measure is exempt from notification under Article 108(2) of the Treaty
on the Functioning of the European Union (TFEU).}
\item{preliminary_investigation}{\code{dummy}. A dummy variable indicating
whether the Commission decided to open a preliminary investigation under
Article 108 of the Treaty on the Functioning of the European Union (TFEU).}
\item{formal_investigation}{\code{dummy}. A dummy variable indicating
whether the Commission decided to open a formal investigation under Article
4(4) of Council Regulation (EU) 2015/1589, formerly Article 4(4) of Council
Regulation (EC) No 659/1999.}
\item{no_objection}{\code{dummy}. A dummy variable indicating whether the
Commission decided not to raise an objection to the state aid measure under
Article 4(3) of Council Regulation (EU) 2015/1589, formerly Article 4(3) of
Council Regulation (EC) No 659/1999. }
\item{not_aid}{\code{dummy}. A dummy variable indicating whether the
Commission decided that the state aid measure did not constitute state aid,
according to Article 107 of the Treaty on the Functioning of the European
Union (TFEU), under Article 4(2) of Council Regulation (EU) 2015/1589,
formerly Article 4(2) of Council Regulation (EC) No 659/1999. }
\item{positive}{\code{dummy}. A dummy variable indicating whether, after a
formal investigation, the Commission decided under article 9(3) of Council
Regulation (EU) 2015/1589, formerly Article 7(3) of Council Regulation (EC)
No 659/1999, to approve the state aid measure because it was compatible
with the rules of the single market, as defined by Article 107 of the
Treaty of the Functioning of the European Union (TFEU).}
\item{negative}{\code{dummy}. A dummy variable indicating whether, after a
formal investigation, the Commission decided under article 9(5) of Council
Regulation (EU) 2015/1589, formerly Article 7(5) of Council Regulation (EC)
No 659/1999, to not approve the state aid measure because it was not
compatible with the rules of the single market, as defined by Article 107
of the Treaty of the Functioning of the European Union (TFEU).}
\item{conditional}{\code{dummy}. A dummy variable indicating whether, after
a formal investigation, the Commission decided under article 9(4) of
Council Regulation (EU) 2015/1589, formerly Article 7(4) of Council
Regulation (EC) No 659/1999, to approve the state aid measure subject to
conditions to make the measure compatible with the rules of the single
market, as defined by Article 107 of the Treaty of the Functioning of the
European Union (TFEU).}
\item{withdrawal}{\code{dummy}. A dummy variable indicating whether the
member state that notified the state aid measure withdrew the measure,
either before the formal investigation procedure under Article 10(1) of
Council Regulation (EU) 2015/1589, formerly Article 8(1) of Council
Regulation (EC) No 659/1999, or during the formal investigation procedure
under Article 10(2) of Council Regulation (EU) 2015/1589, formerly Article
8(2) of Council Regulation (EC) No 659/1999. }
\item{referral}{\code{dummy}. A dummy variable indicating whether, after a
formal investigation, the Commission decided to refer the state aid case to
the Court of Justice of the European Union (CJEU) under Article 14 of
Council Regulation (EU) 2015/1589, formerly Article 12 of Council
Regulation (EC) No 659/1999, for noncompliance with an injunction, under
Article 108(2) of the Treaty on the Functioning of the European Union
(TFEU), for noncompliance with a Commission decision, or under Article
260(2) of the Treaty on the Functioning of the European Union (TFEU), for
noncompliance with a judgment of the Court.}
\item{recovery}{\code{dummy}. A dummy variable indicating whether, after a
formal investigation, the Commission decided under 16(1) of Council
Regulation (EU) 2015/1589, formerly 14(1) of Council Regulation (EC) No
659/1999, that the member state that notified that state aid measure must
take all necessary measures to recover aid from the beneficiary.}
}
}
\usage{
cases
}
\description{
This dataset include data on state aid cases. There is one observation per
case (1988-2020). The dataset includes information on the department
responsible for the case, the member state that the case is against, and
decisions taken by the Commission in the case.
}
\keyword{datasets}
