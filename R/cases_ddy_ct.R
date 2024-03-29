################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
# automatically generated by the codebookr R package
################################################################################

#' Case-level directed dyad-year data by case type
#' 
#' This dataset includes aggregated data on the number of state aid cases per
#' department per member state per year (directed dyad-year data) broken down
#' by case type. There is one observation per department per member state per
#' year per case type (1988-2020), excluding directed dyad-years where the
#' state was not a member of the EU. The dataset uses current department
#' names.
#' 
#' @format A data frame with 11 variables:
#' \describe{
#' \item{key_id}{\code{numeric}. An ID number that uniquely identifies each
#' observation in the dataset. }
#' \item{year}{\code{numeric}. The year the case was opened by the
#' Commission.}
#' \item{department_id}{\code{numeric}. An ID number that uniquely identifies
#' each Directorate-General (DG) of the Commission. There are three DGs that
#' can open state aid cases. The DG for Competition (COMP) is coded \code{1},
#' the DG for Agriculture and Rural Development (AGRI) is coded \code{2}, and
#' the DG for Maritime Affairs and Fisheries (MARE) is coded \code{3}.}
#' \item{department}{\code{string}. The name of the Directorate-General (DG)
#' of the Commission that opened the state aid case.}
#' \item{department_code}{\code{string}. A multi-letter code assigned by the
#' Commission that uniquely identifies each Directorate-General (DG) of the
#' Commission. }
#' \item{member_state_id}{\code{numeric}. An ID number that uniquely
#' identifies each member state. This ID number is assigned when member states
#' are sorted by accession date and then alphabetically. }
#' \item{member_state}{\code{string}. The name of the member state that the
#' Commission opened the case against. }
#' \item{member_state_code}{\code{string}. A two letter code assigned by the
#' Commission that uniquely identifies each member state. }
#' \item{case_type_id}{\code{numeric}. An ID number that uniquely identifies
#' each type of state aid cases. Coded \code{1} for cases that involve state
#' aid measures granted through Commission-approved schemes that is not
#' notifiable, coded \code{2} for cases that involve state aid measures
#' granted through Commission-approved schemes where the Commission has
#' required that the member state notify any aid granted through the scheme,
#' and coded \code{3} for cases that involve ad hoc state aid measures that
#' are not granted through a scheme.}
#' \item{case_type}{\code{string}. The type of the state aid case. There are
#' three types of cases. Coded \code{Scheme} for cases that involve state aid
#' measures granted through Commission-approved schemes that is not
#' notifiable, coded \code{Individual application} for cases that involve
#' state aid measures granted through Commission-approved schemes where the
#' Commission has required that the member state notify any aid granted
#' through the scheme, and coded \code{Ad hoc} for cases that involve ad hoc
#' state aid measures that are not granted through a scheme.}
#' \item{count_cases}{\code{numeric}. A count of the number of cases opened by
#' the Commission at this level of aggregation.}
#' }
"cases_ddy_ct"

################################################################################
# end R script
################################################################################

