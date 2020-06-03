#------------------------------------------#
# Example Linear Two-firm Oligopoly Script #
#------------------------------------------#
source("oligopoly_bertrand_cournot_source.R")

#------------------#
# Bertrand Example #
#------------------#
# Use when competing for prices
# The example below follows this problem demo: https://www.youtube.com/watch?v=YrnqUPW96lY
marginalCost1 = 0
marginalCost2 = 0

q1 = '72 -3p1 +2p2'
q2 = '72 -3p2 +2p1'

oupt <- equilibriumCompiler(func1 = q1, func2 = q2, # These are your models
                            mc1 = marginalCost1, mc2 = marginalCost2, # These are MC
                            modeltype = 'bertrand') # This is model type

#-----------------# 
# Cournot Example #
#-----------------#
# Use when competing for quantities (oil)
# This example below follows this problem demo: https://www.youtube.com/watch?v=An_2r6Ae_28
marginalCost1 <- 40
marginalCost2 <- 40

p1 <- '100 -1q1 -1q2'
p2 <- '100 -1q1 -1q2'

oupt <- equilibriumCompiler(func1 = p1, func2 = p2, # These are the models 
                            mc1 = marginalCost1, mc2 = marginalCost2,  # These are MC
                            modeltype = 'cournot') # This is model type
