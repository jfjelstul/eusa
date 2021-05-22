################################################################################
# Joshua C. Fjelstul, Ph.D.
# eusa R package
################################################################################

create_template <- function(..., names) {
  filter_template <- function(x) {
    if ("member_state" %in% names(x)) {
      x$drop <- FALSE
      x$drop[x$member_state %in% c("Austria", "Finland", "Sweden") & x$year < 1995] <- TRUE
      x$drop[x$member_state %in% c("Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia") & x$year < 2004] <- TRUE
      x$drop[x$member_state %in% c("Bulgaria", "Romania") & x$year < 2007] <- TRUE
      x$drop[x$member_state == "Croatia" & x$year < 2013] <- TRUE
      x <- dplyr::filter(x, !drop)
      x <- dplyr::select(x, -drop)
    }

    # return
    return(x)
  }

  template <- expand.grid(..., stringsAsFactors = FALSE)
  names(template) <- names
  template <- dplyr::as_tibble(template)
  template <- filter_template(template)
  return(template)
}

################################################################################
# end R script
################################################################################
