% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loglikelihoods.R
\name{general.haz}
\alias{general.haz}
\title{Extract general population hazard}
\usage{
general.haz(time, age, sex, year, data = NULL,
  ratetable = cuRe::survexp.dk)
}
\arguments{
\item{time}{Either a numeric vector of follow-up times (in days) or a character indicating the variable
containing the follow-up times in the data.}

\item{age}{Either a numeric vector of ages (in days) or a character indicating the variable containing the patient ages in the data.}

\item{sex}{Either a character vector or factor with the sex of each patient
or a character indicating the variable containing the patient sex in the data.}

\item{year}{Either a vector of class \code{Date} with the calendar time points
or a character indicating the variable containing the calendar times in the data.}

\item{data}{The data from which to extract variables from.
If \code{time}, \code{age}, \code{sex}, or \code{year} are not characters, this will not be used.}

\item{ratetable}{Object of class \code{ratetable} to extract background hazards from. Defaults to \code{survexp.dk}.}
}
\value{
An object of class \code{numeric} containing the yearly expected hazards.
}
\description{
Yearly general population hazards matched on age, gender, and calendar year is extracted from a ratetable.
}
\examples{
##Use data cleaned version of the colon cancer data from the rstpm2 package
data("colonDC")
set.seed(2)
colonDC <- colonDC[sample(1:nrow(colonDC), 1000), ]

##Extract general population hazards
bhaz1 <- general.haz(time = "FU", age = "agedays", sex = "sex", year = "dx",
                     data = colonDC, ratetable = survexp.dk)

bhaz2 <- general.haz(time = colonDC$FU, age = colonDC$agedays, sex = colonDC$sex,
                     year = colonDC$dx, ratetable = survexp.dk)
all(bhaz2 == bhaz1)
}
