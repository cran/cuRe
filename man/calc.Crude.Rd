% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc.Crude.R
\name{calc.Crude}
\alias{calc.Crude}
\title{Crude event probabilities}
\usage{
calc.Crude(
  object,
  newdata = NULL,
  type = c("disease", "other", "condother"),
  time = NULL,
  tau = 100,
  reverse = FALSE,
  var.type = c("ci", "se", "n"),
  exp.fun = NULL,
  ratetable = cuRe::survexp.dk,
  rmap,
  scale = ayear,
  smooth.exp = FALSE,
  pars = NULL,
  link = "loglog",
  n = 100
)
}
\arguments{
\item{object}{Fitted model to do predictions from. Possible classes are
\code{gfcm}, \code{cm}, \code{stpm2}, and \code{pstpm2}.}

\item{newdata}{Data frame from which to compute predictions. If empty, predictions are made on the the data which
the model was fitted on.}

\item{type}{Probability to compute. Possible values are \code{disease} (default),
\code{other}, and \code{condother} (see details).}

\item{time}{Time points at which to compute predictions. If empty, a grid of 100 time points between 0
and \code{tau} is selected.}

\item{tau}{Upper bound of the integral used to compute the probability of disease-related death (see details).
The argument is only used for \code{type = condother}. Default is 100.}

\item{reverse}{Logical. If \code{TRUE}, 1 - probability is provided (default is \code{FALSE}).
Only applicable for \code{type = condother}.}

\item{var.type}{Character. Possible values are "\code{ci}" (default) for confidence intervals,
"\code{se}" for standard errors, and "\code{n}" for neither.}

\item{exp.fun}{Object of class \code{list} containing functions for the expected survival
of each row in \code{newdata}. If not specified, the function computes the expected
survival based on \code{newdata} using the \code{survival::survexp} function. If \code{newdata} is not provided,
the expected survival is based on the data which the model was fitted on.}

\item{ratetable}{Object of class \code{ratetable} used to compute the general population survival.
Default is \code{survexp.dk}.}

\item{rmap}{List to be passed to \code{survexp} from the \code{survival} package if \code{exp.fun = NULL}.
Detailed documentation on this argument can be found by \code{?survexp}.}

\item{scale}{Numeric. Passed to the \code{survival::survexp} function and defaults to 365.24.
That is, the time scale is assumed to be in years.}

\item{smooth.exp}{Logical. If \code{TRUE}, the general population survival function is smoothed by the function
\code{smooth.spline} using the the argument \code{all.knots = TRUE}.}

\item{pars}{A vector of parameter values for the model given in \code{object}. Currently not used.}

\item{link}{Link function for computing variance in order to restrict confidence intervals to [0, 1].
Default is \code{loglog}.}

\item{n}{Number of knots used for the Gauss-Legendre quadrature.}
}
\value{
A list containing the crude probability estimates
of each individual in \code{newdata}.
}
\description{
Function for computing crude event probabilties based on relative survival models.
}
\details{
The function estimates crude probabilities by using the relative survival, expected survival,
and the cause-specific hazard function.
The crude cumulative incidence of disease-related death (\code{type = "disease"}) is
\deqn{P(T \leq t, D = disease) = \int_0^t S^*(u) R(u) \lambda(u)du.}
The crude cumulative incidence of death from other causes (\code{type = "other"}) is
\deqn{P(T \leq t, D = other) = \int_0^t S^*(u) R(u) h^*(u)du.}
The conditional probability of eventually dying from other causes than disease (\code{type = "condother"}) is
\deqn{P(D = other| T > t) = \frac{P(D = disease) - P(T \leq t, D = disease)}{P(T > t)}.}
The probability of disease-related death, P(D = disease),
can be computed by using \code{type = "disease"} and choosing a sufficiently large time point.
For P(D = other| T>t), the argument \code{tau} controls this time point (default is 100).
}
\examples{
##Use data cleaned version of the colon disease data from the rstpm2 package
data("colonDC")
set.seed(2)
colonDC <- colonDC[sample(1:nrow(colonDC), 1000), ]

##Extract general population hazards
colonDC$bhaz <- general.haz(time = "FU", rmap = list(age = "agedays", sex = "sex", year= "dx"),
                            data = colonDC, ratetable = survexp.dk)

##Spline-base cure model
#Fit cure model
fit <- rstpm2::stpm2(Surv(FUyear, status) ~ 1, data = colonDC, df = 6,
                     bhazard = colonDC$bhaz, cure = TRUE)

#Compute the probability of disease-related death
res <- calc.Crude(fit, time = seq(0, 20, length.out = 50),
                  rmap = list(age = agedays, sex = sex, year = dx),
                  var.type = "n")
plot(res)

#Compute the conditional probability of dying from other causes than disease
res <- calc.Crude(fit, time = seq(0, 20, length.out = 50), type = "condother",
                  rmap = list(age = agedays, sex = sex, year = dx), var.type = "n")
plot(res)


#Simple parametric cure model
#Fit cure model
fit <- fit.cure.model(Surv(FUyear, status) ~ 1, data = colonDC, bhazard = "bhaz",
                      type = "mixture", dist = "weibull", link = "logit")

#Compute the probability of disease-related death
res <- calc.Crude(fit, time = seq(0, 20, length.out = 50),
                  rmap = list(age = agedays, sex = sex, year = dx),
                  var.type = "n")
plot(res)

#Compute the conditional probability of disease-related death
res2 <- calc.Crude(fit, time = seq(0, 20, length.out = 50), type = "condother",
                  rmap = list(age = agedays, sex = sex, year = dx), reverse = TRUE,
                  var.type = "n")
plot(res2)
}
