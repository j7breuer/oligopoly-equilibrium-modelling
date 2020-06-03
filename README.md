# Oligopoly Equilibrium Modelling in R
This code started as a fun regex puzzle I was challenging myself with that turned into something potentially useful.  That puzzle was how to derive marginal revenue, best response functions, and output/price equilibrium given demand or inverse demand functions.  The catch was to do this without using any calculus functions in R, only use regex and simple mathematical operators (*/+-).  The processes outlined above use partial derivatives, linear algebra, etc.  In a program such as Matlab, this can be easily done.  In R it can not.  The real puzzle is to use regex to create my own functions to calculate partial derivates, integrate equations, etc.

### For example:
Take x<sup>2</sup>.  The derivative of x<sup>2</sup> is 2x.  How do you get from x<sup>2</sup> to 2x in R without running a derivative calculator on x<sup>2</sup>.  You extract the 2 after the ^ and multiply it by x's coefficient of '1' to get 2.  Paste 2 in front of the base variable 'x' and now you have 2x.

## Getting Started
Using this repository assumes a few prerequisites:
1. The user has advanced micro-economic theory knowledge of Bertrand and Cournot equilibrium calculations
2. The user understands how to construct demand and inverse demand functions

## Installation
To use any of these functions, please clone the repo and navigate to example_run_script.R.  The run script is below with comments:
```R
#----------#
# Bertrand #
#----------#
marginalCost1 = 0
marginalCost2 = 0

q1 = '72 -3p1 +2p2' # Firm 1's demand function (note how this is linear)
q2 = '72 -3p2 +2p1' # Firm 2's demand function (note how this is linear)

oupt <- equilibriumCompiler(func1 = q1, func2 = q2, # These are the demand functions 
                            mc1 = marginalCost1, mc2 = marginalCost2, # These are MC associated for both firms
                            modeltype = 'bertrand') # This is model type - options are cournot/bertrand
                            
#---------#
# Cournot #
#---------#
marginalCost1 <- 40
marginalCost2 <- 40

p1 <- '100 -1q1 -1q2' # Firm 1's inverse demand function (note how this is linear)
p2 <- '100 -1q1 -1q2' # Firm 2's inverse demand function (note how this is linear)

oupt <- equilibriumCompiler(func1 = p1, func2 = p2, # These are the inverse demand functions 
                            mc1 = marginalCost1, mc2 = marginalCost2,  # These are MC associated for both firms
                            modeltype = 'cournot') # This is model type - options are cournot/bertrand

```
## R Dependencies
This is solely built out of base-R and will remain so.

## Code Constraints
Currently, this code only works on linear demand functions and in a 2 player equilibrium problem.  The demand functions must come in the format of having spaces between each variable in the equation.  Ex: 2x<sub>1</sub>+3x<sub>2</sub> must be in the format of 2x1 +3y2.

## Author
J Breuer - j7breuer@gmail.com.  Please reach out with any questions.

## Updates
This code will likely be expanded on over the next few years.  A few goals to outline, in order of priorities:
1. Create demand function input flexibility - for example, remove need to have spaces between variables in equations
2. Integrate non-linear demand functions
3. Integrate 3 player scenarios (3 demand functions)
4. Integrate n player scenarios
5. Build in stackelberg equilibrium option 
