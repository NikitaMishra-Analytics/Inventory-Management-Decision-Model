################################################################################
# Student Name: Nikita Mishra
# Date: June 14, 2026
# Course: ALY-6050: Intro to Enterprise Analytics
# Section: Section 28
# ALY-6050 Module 4 Project - Inventory Management Decision Model
################################################################################

################################################################################
# LOAD REQUIRED LIBRARIES
################################################################################

required_packages <- c("ggplot2", "triangle", "fitdistrplus")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}

lapply(required_packages, install_if_missing)

#Explanation:
# Load packages required for visualization, simulation, and distribution fitting.

################################################################################
# PART I: EOQ MODEL
################################################################################

#-------------------------------------------------------------------------------
# 1. Define the Data, Uncontrollable Inputs, Model Parameters,
# and the Decision Variables that Influence the Total Inventory Cost
#-------------------------------------------------------------------------------

# Uncontrollable Inputs:
# D = Annual Demand
# C = Unit Cost
# S = Ordering Cost per Order
# Holding Rate = Annual Carrying Cost Rate

# Model Parameter:
# H = Holding Cost per Unit per Year

# Decision Variable:
# Q = Order Quantity

# Outputs:
# EOQ, Total Cost, and Annual Number of Orders

# Given Data

D <- 15000          # Annual Demand (units)
C <- 80             # Unit Cost ($)
holding_rate <- 0.18
S <- 220            # Ordering Cost per Order ($)

# Calculate Holding Cost per Unit per Year

H <- holding_rate * C

cat("Holding Cost per Unit =", H, "\n")

#Explanation:
# Define the inventory problem including inputs, parameters,
# decision variables, and outputs affecting total inventory cost.


#-------------------------------------------------------------------------------
# 2. Develop Mathematical Functions that Compute the Annual
# Ordering Cost and Annual Holding Cost Based on Average
# Inventory Held Throughout the Year and Use Them to Develop
# a Mathematical Model for the Total Inventory Cost
#-------------------------------------------------------------------------------

# Economic Order Quantity (EOQ)

EOQ <- sqrt((2 * D * S) / H)

cat("Economic Order Quantity (EOQ) =", round(EOQ,2), "\n")

# Total Cost Function

total_cost <- function(Q){
  
  ordering_cost <- (D / Q) * S
  
  holding_cost <- (Q / 2) * H
  
  total <- ordering_cost + holding_cost
  
  return(total)
}

#Explanation:
# Develop mathematical functions for ordering cost,
# holding cost, and total inventory cost.


#-------------------------------------------------------------------------------
# 3. Implement the Model in R
#-------------------------------------------------------------------------------

num_orders <- D / EOQ

cat("\nAnnual Number of Orders =",
    round(num_orders,2), "\n")

#Explanation:
# Implement the EOQ model in R and compute key outputs.


#-------------------------------------------------------------------------------
# 4. Use Data Tables to Find an Approximate Order Quantity
# that Results in the Smallest Total Cost
#-------------------------------------------------------------------------------

Q <- seq(100, 1500, by = 50)

TC <- total_cost(Q)

inventory <- data.frame(
  Order_Quantity = Q,
  Total_Cost = TC
)

print(inventory)

min_row <- inventory[which.min(inventory$Total_Cost), ]

cat("\nApproximate Optimal Q =", min_row$Order_Quantity)

cat("\nMinimum Total Cost =",
    round(min_row$Total_Cost,2), "\n")

#Explanation:
# Generate order quantities and identify the approximate
# quantity that minimizes total inventory cost.


#-------------------------------------------------------------------------------
# 5. Plot the Total Cost versus the Order Quantity
#-------------------------------------------------------------------------------

p <- ggplot(inventory,
            aes(x = Order_Quantity,
                y = Total_Cost)) +
  
  geom_line(color = "blue", linewidth = 1.2) +
  
  geom_point(color = "red", size = 2) +
  
  geom_vline(xintercept = EOQ,
             linetype = "dashed",
             color = "gray40") +
  
  labs(title = "Total Cost vs Order Quantity",
       x = "Order Quantity",
       y = "Total Cost ($)") +
  
  theme_minimal()

print(p)

#Explanation:
# Visualize the relationship between order quantity
# and total inventory cost.


#-------------------------------------------------------------------------------
# 6. Use the Excel Solver to Verify Your Result of Part 4 Above;
# That Is, Find the Order Quantity Which Would Yield a Minimum
# Total Cost
#-------------------------------------------------------------------------------

solver <- optimize(total_cost, interval = c(1, 5000))

cat("\nVerified Optimal Q =",
    round(solver$minimum, 2))

cat("\nVerified Minimum Total Cost =",
    round(solver$objective, 2), "\n")

# Note:
# The optimize() function in R serves as the equivalent
# of Excel Solver.

#Explanation:
# Use optimization to verify the order quantity
# that minimizes total inventory cost.


################################################################################
# PART II: SIMULATION UNDER DEMAND UNCERTAINTY
################################################################################

#-------------------------------------------------------------------------------
# STEP 1: Perform 1000 Simulation Runs
#-------------------------------------------------------------------------------

set.seed(123)

n <- 1000

# Generate annual demand from a triangular distribution

demand <- rtriangle(n,
                    a = 13000,
                    b = 17000,
                    c = 15000)

#Explanation:
# Simulate uncertain annual demand using a triangular distribution.


#-------------------------------------------------------------------------------
# Calculate EOQ for Each Simulation
#-------------------------------------------------------------------------------

EOQ_sim <- sqrt((2 * demand * S) / H)

#Explanation:
# Compute the optimal order quantity for each simulated demand value.


#-------------------------------------------------------------------------------
# Calculate Minimum Total Cost for Each Simulation
#-------------------------------------------------------------------------------

min_cost <- (demand / EOQ_sim) * S +
  (EOQ_sim / 2) * H

#Explanation:
# Calculate the minimum total inventory cost for each simulation run.


#-------------------------------------------------------------------------------
# Calculate Annual Number of Orders
#-------------------------------------------------------------------------------

orders <- demand / EOQ_sim

#Explanation:
# Determine the annual number of orders required under each scenario.


#-------------------------------------------------------------------------------
# Store Simulation Results
#-------------------------------------------------------------------------------

simulation <- data.frame(
  Demand = demand,
  EOQ = EOQ_sim,
  Total_Cost = min_cost,
  Orders = orders
)

print(head(simulation))

#Explanation:
# Store all simulation outputs for statistical analysis.


################################################################################
# Helper Functions
################################################################################

#-------------------------------------------------------------------------------
# Confidence Interval Function
#-------------------------------------------------------------------------------

ci_function <- function(x){
  
  mean_x <- mean(x)
  
  se <- sd(x) / sqrt(length(x))
  
  lower <- mean_x - 1.96 * se
  
  upper <- mean_x + 1.96 * se
  
  return(c(mean_x, lower, upper))
}

#Explanation:
# Calculate the mean and 95% confidence interval.


#-------------------------------------------------------------------------------
# Distribution Validation Function
#-------------------------------------------------------------------------------

validate_fit <- function(fit, label){
  
  cat("\n========== Validation:", label, "==========\n")
  
  plot(fit)
  
  ks <- ks.test(fit$data,
                "pnorm",
                mean = fit$estimate["mean"],
                sd   = fit$estimate["sd"])
  
  cat("KS statistic =",
      round(ks$statistic,4),
      " p-value =",
      round(ks$p.value,4), "\n")
  
  if (ks$p.value > 0.05){
    cat("Conclusion: Normal distribution is a good fit.\n")
  } else {
    cat("Conclusion: Normal fit is questionable.\n")
  }
}

#Explanation:
# Verify whether the Normal distribution adequately fits the data.


################################################################################
# 1(i) EXPECTED MINIMUM TOTAL COST
################################################################################

cost_ci <- ci_function(simulation$Total_Cost)

cat("\nTOTAL COST\n")
cat("Mean =",
    round(cost_ci[1],2), "\n")

cat("95% CI = (",
    round(cost_ci[2],2), ",",
    round(cost_ci[3],2), ")\n")

# Fit Normal Distribution

fit_cost <- fitdist(simulation$Total_Cost, "norm")

print(summary(fit_cost))

# Validate Distribution

validate_fit(fit_cost, "Total Cost")

#Explanation:
# Estimate the expected minimum total cost, construct a 95% confidence
# interval, and verify the fitted probability distribution.


################################################################################
# 1(ii) EXPECTED ORDER QUANTITY
################################################################################

eoq_ci <- ci_function(simulation$EOQ)

cat("\nEOQ\n")
cat("Mean =",
    round(eoq_ci[1],2), "\n")

cat("95% CI = (",
    round(eoq_ci[2],2), ",",
    round(eoq_ci[3],2), ")\n")

# Fit Normal Distribution

fit_eoq <- fitdist(simulation$EOQ, "norm")

print(summary(fit_eoq))

# Validate Distribution

validate_fit(fit_eoq, "EOQ")

#Explanation:
# Estimate the expected order quantity, construct a 95% confidence
# interval, and verify the fitted probability distribution.


################################################################################
# 1(iii) EXPECTED ANNUAL NUMBER OF ORDERS
################################################################################

order_ci <- ci_function(simulation$Orders)

cat("\nORDERS\n")
cat("Mean =",
    round(order_ci[1],2), "\n")

cat("95% CI = (",
    round(order_ci[2],2), ",",
    round(order_ci[3],2), ")\n")

# Fit Normal Distribution

fit_orders <- fitdist(simulation$Orders, "norm")

print(summary(fit_orders))

# Validate Distribution

validate_fit(fit_orders, "Number of Orders")

#Explanation:
# Estimate the expected annual number of orders, construct a 95%
# confidence interval, and verify the fitted probability distribution.


################################################################################
# HISTOGRAMS OF SIMULATION OUTPUTS
################################################################################

hist(simulation$Total_Cost,
     col = "lightblue",
     border = "black",
     main = "Distribution of Minimum Total Cost",
     xlab = "Minimum Total Cost ($)",
     ylab = "Frequency")

hist(simulation$EOQ,
     col = "lightgreen",
     border = "black",
     main = "Distribution of Order Quantity (EOQ)",
     xlab = "Order Quantity",
     ylab = "Frequency")

hist(simulation$Orders,
     col = "lightpink",
     border = "black",
     main = "Distribution of Annual Number of Orders",
     xlab = "Number of Orders",
     ylab = "Frequency")

#Explanation:
# Visualize the distributions of total cost, order quantity,
# and annual number of orders.


################################################################################
# END OF PROJECT
################################################################################