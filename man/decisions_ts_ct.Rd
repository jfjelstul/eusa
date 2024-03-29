% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/decisions_ts_ct.R
\docType{data}
\name{decisions_ts_ct}
\alias{decisions_ts_ct}
\title{Decision-level time-series data by case type}
\format{
A data frame with 7 variables:
\describe{
\item{key_id}{\code{numeric}. An ID number that uniquely identifies each
observation in the dataset. }
\item{year}{\code{numeric}. The year the case was opened by the
Commission.}
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
\item{decision_type_id}{\code{numeric}. An ID number that uniquely
identifies each type of decision the Commission can make in a state aid
case.}
\item{decision_type}{\code{string}. The type of the decision.}
\item{count_cases}{\code{numeric}. A count of the number of cases opened by
the Commission at this level of aggregation.}
}
}
\usage{
decisions_ts_ct
}
\description{
This dataset includes aggregated data on the number of each type of
decision per year (time-series data) broken down by case type. There is one
observation per year per decision type per case type (1988-2020).
}
\keyword{datasets}
