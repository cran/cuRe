% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cbc.R
\name{cbc}
\alias{cbc}
\title{Restricted cubic splines with cure}
\usage{
cbc(x, knots, ortho = TRUE, R.inv = NULL, intercept = TRUE)
}
\arguments{
\item{x}{Values to evaluate the basis functions in.}

\item{knots}{Chosen knots for the spline.}

\item{ortho}{Logical. If \code{TRUE} (default) orthogonalization of the basis matrix is carried out.}

\item{R.inv}{Matrix or vector containing the values of the R matrix from the QR decomposition of the basis matrix.
This is used for making new predictions based on the initial orthogonalization.
Therefore the default is \code{NULL}.}

\item{intercept}{Logical. If \code{FALSE}, the intercept of the restricted cubic spline is removed.}
}
\value{
A matrix with containing the basis functions evaluated in \code{x}.
}
\description{
Function for computing the basis matrix for restricted cubic splines which are constant beyond the last knot
}
\references{
Andersson T.M.-L., et al. (2011) Estimating and modelling cure in population-based cancer
studies within the framework of flexible parametric survival models.
\emph{BMC Medical Research Methodology}, 11:96.
}
