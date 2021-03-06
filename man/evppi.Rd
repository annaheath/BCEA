\name{evppi}
\alias{evppi}
\alias{evppi.default}
\title{
Expected Value of Perfect Partial Information (EVPPI) for selected parameters
}
\description{
Calculates the Expected Value of Perfect Partial Information (EVPPI) for subsets 
of parameters. Uses GAM non-parameteric regression for single parameter EVPPI and 
the SPDE-INLA method for larger parameter subsets.
}
\usage{
evppi(parameter,input,he,N=NULL,plot=F,residuals=T,...)

\method{evppi}{default}(parameter,input,he,N=NULL,plot=F,residuals=T,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{parameter}{
A vector of parameters for which the EVPPI should be calculated. This can be given as a 
string (or vector of strings) of names or a numeric vector, corresponding to the column 
numbers of important parameters.
}
\item{input}{
A matrix containing the simulations for all the parameters monitored by the call to 
JAGS or BUGS. The matrix should have column names matching the names of the parameters 
and the values in the vector parameter should match at least one of those values.
}
\item{he}{
A \code{bcea} object (the result of the call to the function \code{\link{bcea}}).
}
\item{N}{
The number of PSA simulations used to calculate the EVPPI. The default uses all the 
available samples.
}
\item{plot}{
A logical value indicating whether the triangular mesh for SPDE-INLA should be plotted.
Default set to F.
}
\item{residuals}{
A logical value indicating whether the fitted values for the SPDE-INLA method should be 
outputted. Default set to T.
}
\item{...}{
Additional arguments.
The default methods to compute the EVPPI are:
 - For single-parameter: GAM regression.
 - For multi-parameter: INLA/SPDE.
However, it is possible (mainly for backward compatibility) to use different methods.
For single-parameter, the user can specify the method of Sadatsafavi et al or the
method of Strong & Oakley. In order to do so, it is necessary to include the extra
parameter \code{method} which takes as value a string \code{"sad"} in the former case 
and a string \code{"so"} in the latter. In case "sal" is selected, then it is possible 
to also specify the number of "separators" (e.g. \code{n.seps=3}). If none is specified, 
the default value \code{n.seps=1} is used. If \code{"so"} is used as method for the 
calculation of the EVPPI, then the user *needs* to also specify the number of "blocks" 
(e.g. \code{n.blocks=20}).

For multi-parameter, the user can select 3 possible methods. If \code{method="GAM"} (BCEA
will accept also \code{"gam"}, \code{"G"} or \code{"g"}), then the computations are based 
on GAM regression. The user can also specify the formula for the regression. The default 
option is to use a tensor product (e.g. if there are two main parameters, \code{p1} and 
\code{p2}, this amounts to setting \code{formula="te(p1,p2)"}, which indicates that the 
two parameters interact). Alternatively, it is possible to specify a model in which the 
parameters are independent using the notation \code{formula="s(p1)+s(p2)"}. This may lead 
to worse accuracy in the estimates.

The second possible method is the GP regression derived by Strong et al. This is used
if \code{method="GP"} (BCEA will also accept the specification \code{method="gp"}).
In this case, the user can also specify the number of PSA runs that should be used
to estimate the hyperparameters of the model (e.g. \code{n.sim=100}). This value is
set by default to 500.
Finally, it is also possible to specify some INLA-related options. These are all rather 
technical and are described in detail in Baio, Berardi and Heath. 
The optional parameter vector \code{int.ord} can take integer values (c(1,1) is 
default) and will force the predictor to include interactions: if \code{int.ord=c(k,h)}, 
then all k-way interactions will be used for the effects and all h-way interactions will
be used for the costs. Also, the user can specify the feature of the mesh for the 
"spatial" part of the model. The optional parameter \code{cutoff} (default 
0.3) controls the density of the points inside the mesh. Acceptable values are typically 
in the interval (0.1,0.5), with lower values implying more points (and thus better 
approximation and greatercomputational time). The construction of the boundaries for 
the mesh can becontrolled by the optional inputs \code{convex.inner} (default = -0.4) 
and \code{convex.outer} (default = -0.7). These should be negative values and can be 
decreased (say to -0.7 and -1, respectively) to increase the distance between the points 
and the outer boundary, which also increases precision and computational time. The 
optional argument\code{robust} can be set to TRUE, in which case INLA will use a t prior 
distribution for the coefficients of the linear predictor. Finally, the user can
control the accuracy of the INLA grid-search for the estimation of the hyperparameters.
This is done by setting a value \code{h.value} (default=0.00005). Lower values imply
a more refined search (and hence better accuracy), at the expense of computational 
speed.
The method argument can also be given as a list allowing different regression methods
for the effects and costs, and the different incremental decisions. The first list 
element should contain a vector of methods for the incremental effects and the second
for the costs, for example \code{method=list(c("GAM"),c("INLA"))}. The \code{int.ord}
argument can also be given as a list to give different interaction levels for each
regression curve.
}
}
\details{
The single parameter EVPPI has been calculated using the non-parametric GAM regression 
developed by Strong et al. (2014). The multi-parameter EVPPI is calculated using the 
SPDE-INLA regression method for Gaussian Process regression developed by Heath et al. 
(2015) 
}
\value{ 
\item{evppi}{The computed values of evppi for all values of the parameter of 
willingness to pay}
\item{index}{A numerical vector with the index associated with the parameters for which 
the EVPPI was calculated}
\item{k}{The vector of values for the willingness to pay}
\item{evi}{The vector of values for the overall EVPPI}
\item{fitted.costs}{The fitted values for the costs}
\item{fitted.effects}{The fitted values for the effects}
\item{parameters}{A single string containing the names of the parameters for which the 
EVPPI was calculated, used for plotting the EVPPI}
\item{time}{Computational time (in seconds)}
\item{fit.c}{The object produced by the model fit for the costs}
\item{fit.e}{The object produced by the model fit for the effects}
\item{formula}{The formula used to fit the model}
\item{method}{A string indicating the method used to estimate the EVPPI}
}
\references{
Strong M., Oakley J. and Brennan A. (2014). Estimating multi-parameter partial 
Expected Value of Perfect Information from a probabilistic sensitivity analysis sample: 
a non-parametric regression approach. Medical Decision Making.

Sadatsafavi M., Bansback N., Zafari Z., Najafzadeh M., Marra C. (2013). Need for 
speed: an efficient algorithm for calculation of single-parameter expected value 
of partial perfect information. Value in Health

Baio G. (2012). Bayesian Methods in Health Economics. CRC/Chapman Hall, London

Heath A., Manolopoulou I., Baio G. (2016). Estimating the Expected Value of Partial Perfect 
Information in Health Economic Evaluations using Integrated Nested Laplace Approximation. 
Statistics in Medicine. http://onlinelibrary.wiley.com/doi/10.1002/sim.6983/full
}
\author{
Anna Heath, Gianluca Baio
}
\examples{
# See Baio G., Dawid A.P. (2011) for a detailed description of the 
# Bayesian model and economic problem
#
# Load the processed results of the MCMC simulation model
# data(Vaccine)
# 
# Runs the health economic evaluation using BCEA
# m <- bcea(e,c,ref=2,interventions=treats)
#
# Computes the EVPPI for a bunch of parameters
# inp <- CreateInputs(vaccine)
# Computes the EVPPI using INLA/SPDE
# x0 <- evppi(parameter=c(38:40),input=inp$mat,he=m)
# Now uses GAM regression
# x1 <- evppi(parameter=c(38:40),input=inp$mat,he=m,method="GAM")
# Now uses the GP regression
# x2 <- evppi(parameter=c(38:40),input=inp$mat,he=m,method="GP")
# Now plots the results
# plot(x0)
# points(x0$k,x0$evppi,lwd=2,lty=2,t="l")
# points(x1$k,x1$evppi,t="l",col="red")
# points(x2$k,x2$evppi,t="l",col="blue")
}
\seealso{
\code{\link{plot.evppi}}, \code{\link{bcea}}
}
\keyword{Health economic evaluation}
\keyword{Expected value of partial information}
