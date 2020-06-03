
# Desc:
#   Given a model type of bertrand/cournot along with the corresponding
#   model and variable to solve for, derive marginal revenue from model
# Inpt:
#   - q/p [str]: can be used interchangebly - depends on the model type
#                one is the variable to solve for, other is the model (demand/inverse demand)
#   - modeltype [str]: model type of 'bertrand' or 'cournot', not case sensitive
# Oupt:
#   - marginalRevenue [str]: str value of model 
deriveMarginalRevenue <- function(q, p, modeltype){
  
  # Initiatie model based on input model type
  if (tolower(modeltype) == 'bertrand'){
    x <- q
    y <- p
  } else if (tolower(modeltype) == 'cournot'){
    x <- p
    y <- q
  } 
  
  # Decompose the model
  decomposedq <- strsplit(x, ' ')
  
  # Reconstruct total revenue from decomposed model
  totalrevenue <- c(paste0(decomposedq[[1]][1], y),
                    paste0(decomposedq[[1]][2], y),
                    paste0(decomposedq[[1]][3], y))
  
  # Calculate marginal revenue
  marginalRevenue <- ""
  for (i in 1:length(totalrevenue)){
    if (grepl(paste0(y,y), totalrevenue[i], fixed = TRUE)){
      # Apply derivative, this is for when the variable is squared
      curVar <- paste0(as.numeric(gsub(paste0(y,y), "", totalrevenue[i]))*2, y)
    } else if (grepl(y, totalrevenue[i], fixed = TRUE)){
      # Apply derivative, this is for when variable is by itself
      curVar <- gsub(y, "", totalrevenue[i])
    } else {
      # Else don't take derivative
      curVar <- totalrevenue[i]
    }
    # Now paste MR into MR vector
    marginalRevenue[i] <- curVar
  }
  
  # Create MR model
  marginalRevenue <- paste(marginalRevenue, collapse = ' ')
  # Return MR model
  return(marginalRevenue)
  
}

# Desc:
#   Given marginal revenue model, marginal cost, and direction for 
#   which variable to solve for (ex: q1), calculate a firm's best 
#   response to the competitors setup
# Inpt:
#   - mr [str]: marginal revenue model
#   - mc [num]: numeric value of a firm's marginal cost
#   - solvefor [str]: str format of what variable to solve for, ex: q1, q2, p1, p2
# Oupt:
#   - bestResponse [str]: str format of best response function model
bestResponseFunction <- function(mr, mc, solvefor){
  
  # If statements to determine which variable corresponds with 
  # the competitor (ex: firm1 = q1, then oppfirmvar = q2)
  if (grepl('1', solvefor)){
    oppfirmvar <- paste0(gsub('1', '', solvefor), '2')
  }
  if (grepl('2', solvefor)){
    oppfirmvar <- paste0(gsub('2', '', solvefor), '1')
  }
  
  # Decompose MR into vector
  decomposedmr <- strsplit(mr, ' ')
  mr <- c(decomposedmr[[1]][1], decomposedmr[[1]][2], decomposedmr[[1]][3])
  
  # Now take marginal revenue and solve for best response function
  newMr <- ''
  for (i in 1:length(mr)){
    if (grepl("^[0-9\\.\\-]+$", mr[i], perl = TRUE)){
      newMr[i] <- as.numeric(mr[i])-as.numeric(mc)
    } else if (grepl(solvefor, mr[i], fixed = TRUE)){
      if (grepl('-', mr[i], fixed = TRUE)){
        oppSideDenominator <- as.numeric(gsub(solvefor, '', gsub('-', '', mr[i])))
      } else {
        oppSideDenominator <- as.numeric(gsub(solvefor, '', paste0('-', mr[i])))
      }
    } else {
      newMr[i] <- mr[i]
    }
  }
  newMr <- newMr[!is.na(newMr)]
  finalMr <- ''
  for (i in 1:length(newMr)){
    if (grepl("^[0-9\\.\\-]+$", newMr[i], perl = TRUE)){
      finalMr[i] <- as.numeric(newMr[i])/oppSideDenominator
    } else if (grepl(oppfirmvar, newMr[i], perl = TRUE)){
      curVal <- as.numeric(gsub(oppfirmvar, '', gsub("\\+|\\-", '', newMr[i])))/oppSideDenominator
      finalMr[i] <- paste0(substr(newMr[i],0,1), curVal, oppfirmvar)
    }
  }
  
  # Output lines to console 
  writeLines(paste0("\nFirm ", gsub("p|q", '', solvefor), "'s", " Best Response Function:\n", solvefor, " = ", paste(finalMr, collapse = ' ')))
  bestResponse <- paste(finalMr, collapse = ' ')
  return(bestResponse)
  
}

# Desc:
#   Given both firm's best response functions and the model type,
#   calculate the equilibrium output or price (dependent on model type)
# Inpt:
#   - br1/br2 [str]: both firm's best response functions in string format
#   - modeltype [str]: model type of 'bertrand' or 'cournot', not case sensitive
# Oupt:
#   - retrunlist [list]: two values, first is equilibrium val for first firm, second is equilibrium
#                        for second firm
calculateEquilibrium <- function(br1, br2, modeltype){
  
  # Initiatie model based on input model type
  if (tolower(modeltype) == 'bertrand'){
    solvefor <- 'p'
    pasteThis <- 'Price'
  } 
  if (tolower(modeltype) == 'cournot'){
    solvefor <- 'q'
    pasteThis <- 'Quantity'
  }
  
  # Decompose the best response functions
  decomposedbr1 <- strsplit(br1, ' ')
  decomposedbr2 <- strsplit(br2, ' ')
  
  # Create best response functions in vector format
  br1 <- c(decomposedbr1[[1]][1], decomposedbr1[[1]][2])
  br2 <- c(decomposedbr2[[1]][1], decomposedbr2[[1]][2])
  
  # Get opposite multiplier for math purposes
  br1oppMult <- as.numeric(gsub("\\+|p2|p1|q1|q2", "", br1[2]))
  br2oppMult <- as.numeric(gsub("\\+|p2|p1|q1|q2", "", br2[2]))
  
  # Solve for firm 1's equilibrium now
  plugInEquation1 <- ''
  for (i in 1:length(br2)){
    if (grepl("^[0-9\\.\\-]+$", br2[i], perl = TRUE)){
      plugInEquation1[i] <- as.numeric(br2[i])*br1oppMult
    } else {
      plugInEquation1[i] <- paste0(as.numeric(gsub("\\+|p2|p1|q1|q2", "", br2[i]))*br1oppMult, paste0(solvefor, '1'))
    }
  }
  plugInEquation1 <- c(br1[1], plugInEquation1)
  rightSide1 <- 0
  for (i in 1:length(plugInEquation1)){
    if (grepl("^[0-9\\.\\-]+$", plugInEquation1[i], perl = TRUE)){
      rightSide1 <- rightSide1 + as.numeric(plugInEquation1[i])
    } else {
      leftSideDenominator1 <- 1-as.numeric(gsub("\\+|p2|p1|q1|q2", "", plugInEquation1[i]))
    }
  }
  firm1val <- rightSide1/leftSideDenominator1
  
  # Solve for firm 2's equilibrium now
  plugInEquation2 <- ''
  for (i in 1:length(br1)){
    if (grepl("^[0-9\\.\\-]+$", br1[i], perl = TRUE)){
      plugInEquation2[i] <- as.numeric(br1[i])*br2oppMult
    } else {
      plugInEquation2[i] <- paste0(as.numeric(gsub("\\+|p2|p1|q1|q2", "", br1[i]))*br2oppMult, paste0(solvefor, '2'))
    }
  }
  plugInEquation2 <- c(br2[1], plugInEquation2)
  rightSide2 <- 0
  for (i in 1:length(plugInEquation2)){
    if (grepl("^[0-9\\.\\-]+$", plugInEquation2[i], perl = TRUE)){
      rightSide2 <- rightSide2 + as.numeric(plugInEquation2[i])
    } else {
      leftSideDenominator2 <- 1-as.numeric(gsub("\\+|p2|p1|q1|q2", "", plugInEquation2[i]))
    }
  }
  firm2val <- rightSide2/leftSideDenominator2
  
  # Output to console for review
  if (tolower(modeltype) == 'bertrand'){
    writeLines(paste0("\nBertrand Equilibrium:\n=====================\nFirm 1's ", pasteThis, ": $", prettyNum(firm1val, big.mark = ','), "\nFirm 2's ", pasteThis,": $", prettyNum(firm2val, big.mark = ','), "\n"))
  }
  if (tolower(modeltype) == 'cournot'){
    writeLines(paste0("\nCournot Equilibrium:\n====================\nFirm 1's ", pasteThis, ": ", prettyNum(firm1val, big.mark = ','), "\nFirm 2's ", pasteThis,": ", prettyNum(firm2val, big.mark = ','), "\n"))
  }
  
  # Returned values are in order of firm, firm 1 first then firm 2.  
  # Values are quantity or price (dependent on model)
  returnlist <- list(firm1val, firm2val)
  return(returnlist)
  
}

# Desc:
#   Function that compiles all other functions and can be run at once to calculate
#   the equilibrium in a linear 2-firm game for bertrand or cournot models.
# Inpt: 
#   - func1/func2 [str]: demand/inverse-demand function in str format with spaces between equation values
#         - Ex: "100 -2q1 -q2"
#   - mc1/mc2 [num]: numeric values of marginal cost for each firm
#   - modeltype [str]: string value of 'bertrand' or 'cournot', not case sensitive
# Oupt:
#   - returnEq [list]: two values, first is equilibrium val for first firm, second is equilibrium
#                      for second firm
equilibriumCompiler <- function(func1, func2, mc1, mc2, modeltype){
  
  # Cournot model compiler
  if (tolower(modeltype) == 'cournot'){
    mr1 <- deriveMarginalRevenue(q = 'q1', p = func1, modeltype = modeltype)
    mr2 <- deriveMarginalRevenue(q = 'q2', p = func2, modeltype = modeltype)
    
    br1 <- bestResponseFunction(mr = mr1, mc = mc1, solvefor = 'q1')
    br2 <- bestResponseFunction(mr = mr2, mc = mc2, solvefor = 'q2')
    
    returnEq <- calculateEquilibrium(br1 = br1, br2 = br2, modeltype = modeltype)
  }
  
  # Bertrand model compiler
  if (tolower(modeltype) == 'bertrand'){
    mr1 <- deriveMarginalRevenue(q = func1, p = 'p1', modeltype = modeltype)
    mr2 <- deriveMarginalRevenue(q = func2, p = 'p2', modeltype = modeltype)
    
    br1 <- bestResponseFunction(mr = mr1, mc = mc1, solvefor = 'p1')
    br2 <- bestResponseFunction(mr = mr2, mc = mc2, solvefor = 'p2')
    
    returnEq <- calculateEquilibrium(br1 = br1, br2 = br2, modeltype = modeltype)    
  }
  
  # Return equilibrium list
  return(returnEq)
  
}
