#' Run a \emph{t} test for comparing means using summary statistics
#'
#' This gives you the ability to run \emph{t} tests to compare means using just
#' summary statistics, such as mean, standard deviation, and n. This is helpful
#' when the raw data underlying the summary statistics are not available.
#'
#' @param x1,x2 Sample means
#' @param s1,s2 Sample standard devaitions
#' @param n1,n2 Sample group sizes
#' @param alternative Upper, lower, or two-sided hypothesis
#' @param method Calculation method for degrees of freedom
#' @param conf.level Confidence level
#' @examples
#' # Just plug in some summary data
#' summary_t_test(25,20,2,3,15,10, a = "l", m = "s")
#'
#' # Using chickwts data from datasets
#' summary_chicks <- tapply(
#'   chickwts$weight,
#'   chickwts$feed,
#'   function(x) c(mean = mean(x), sd = sd(x), n = length(x))
#' )
#'
#' # We now have a named list of vectors containing summary stats
#' summary_chicks
#'
#' # Execute the t test using summary stats
#' with(summary_chicks,
#'      summary_t_test(
#'        linseed["mean"],
#'        soybean["mean"],
#'        linseed["sd"],
#'        soybean["sd"],
#'        linseed["n"],
#'        soybean["n"],
#'        alternative = "less",
#'        method = "sat"
#'        )
#'      )
#'
#' # Compare with stats::t.test using raw data
#' t.test(
#'   weight ~ feed,
#'   chickwts,
#'   feed %in% c("linseed", "soybean"),
#'   alternative = "less"
#' )
#'
#' @return An object of class \code{"htest"}.
#' @author Paul W. Egeler, M.S., GStat
#' @references
#' P.V. Rao. (2007). \emph{Statistical Research Methods in the Life Sciences}.
#' pp 139-140. ISBN-13: 978-0-495-41422-3. ISBN-10: 0-495-41422-0
#' @export
summary_t_test <- function(
  x1,x2,s1,s2,n1,n2,
  alternative = c("two.sided","less","greater"),
  method = c("pooled","satterthwaite","cochran"),
  conf.level = 0.95
  ) {

  alternative <- match.arg(alternative)
  method <- match.arg(method)

  if (method != "satterthwaite")
    stop("Only 'satterthwaite' method available")

  xd <- x1 - x2
  se <- sqrt(s1**2 / n1 + s2**2 / n2)

  k_inv <-
    (s1**2 / n1 / (s1**2 / n1 + s2**2 / n2))**2 / (n1 - 1) +
    (s2**2 / n2 / (s1**2 / n1 + s2**2 / n2))**2 / (n2 - 1)

  # nu <- floor(1/k_inv)
  nu <- 1/k_inv

  t_calc <- xd / se

  if (alternative == "two.sided") {

    p <- stats::pt(abs(t_calc), nu, lower.tail = FALSE) * 2
    cint <- stats::qt((1 - conf.level) / 2, nu, lower.tail = FALSE)
    cint <- c(-cint, cint)

  } else if (alternative == "greater") {

    p <- stats::pt(t_calc, nu, lower.tail = FALSE)
    cint <- c(stats::qt(1 - conf.level, nu), Inf)

  } else {

    p <- stats::pt(t_calc,nu)
    cint <- c(-Inf, stats::qt(conf.level, nu))

  }

  cint <- xd + cint * se

  names(t_calc) <- "t"
  names(nu) <- "df"
  attr(cint, "conf.level") <- conf.level
  names(xd) <- "difference in means"

  structure(
    list(
      statistic = t_calc,
      parameter = nu,
      p.value = p,
      conf.int = cint,
      estimate = xd,
      null.value = {# Place-holder until users can enter their own null.value
        null.value <- 0
        names(null.value) <- "difference in means"
        null.value
        },
      alternative = alternative,
      method = paste0("Two Sample t-test (", method, ")"),
      data.name = "summary statistics"
    ),
    class = "htest"
  )


}
