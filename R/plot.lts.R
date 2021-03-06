#' Plot the long term survival
#'
#' Plot function for the class \code{lts}.
#' @usage \method{plot}{lts}(x, ylim = NULL, xlim = NULL, ci = T, col = 1,
#'         ylab = NULL, xlab = "Time", add = F, \dots)
#' @param x Object of class \code{lts}.
#' @param ylim Limit of the y-axis.
#' @param xlim Limit of x-axis.
#' @param ci Logical. If \code{TRUE} (default), confidence intervals are added to the plot.
#' @param col Numeric or character indicating the colours of the curves.
#' @param ylab Label to be written on the y-axis. If \code{NULL}, this is based on \code{type}.
#' @param xlab Label to be written on the x-axis.
#' @param add Logical indicating whether to add to current plot window (default is FALSE).
#' @param ... Further argument passed to \code{plot} and \code{lines}.
#' @export
#' @method plot lts


plot.lts <- function(x, ylim = NULL, xlim = NULL, ci = T, col = 1,
                    ylab = NULL, xlab = "Time", add = F, ...){
  object <- x
  att <- attributes(object)
  if(is.null(ylab)){
    ylab <- switch(att$type,
                   surv = "Survival probability",
                   hazard = "Hazard",
                   cumhaz = "Cumulative hazard",
                   loghaz = "Log-hazard",
                   fail = "Distribution")
  }

  ci <- ci & att$var.type == "ci"

  if(length(col) == 1){
    col <- rep(col, length(object))
  }
  if(is.null(ylim)){
    if(ci){
      ylim <- range(unlist(lapply(object, function(x) x[, c("lower", "upper")])))
    }else{
      ylim <- range(unlist(lapply(object, function(x) x[, "Estimate"])))
    }
  }
  for(i in 1:length(object)){
    if(i == 1 & !add){
      plot(Estimate ~ att$time, data = object[[i]], ylim = ylim, xlim = xlim,
           type = "l", col = col[i], xlab = xlab, ylab = ylab, ...)
    }else{
      lines(Estimate ~ att$time, data = object[[i]], col = col[i], ...)
    }
    if(ci){
      lines(lower ~ att$time, data = object[[i]], lty = 2, col = col[i], ...)
      lines(upper ~ att$time, data = object[[i]], lty = 2, col = col[i], ...)
    }
  }
}
