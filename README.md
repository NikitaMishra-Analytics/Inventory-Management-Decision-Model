# Inventory Management Decision Model
## Excel Optimization, Sensitivity Analysis & Monte Carlo Simulation

An inventory management decision model developed to determine the optimal order quantity that minimizes total annual inventory cost.

The project applies the Economic Order Quantity (EOQ) model, Excel Data Tables, Excel Solver, two-way sensitivity analysis, and a 1,000-trial Monte Carlo simulation to evaluate inventory decisions under both stable and uncertain demand.

> **Academic Project:** Northeastern University — ALY-6050: Enterprise Analytics

---

## Project Overview

The objective of this project is to determine how much inventory a manufacturing client should order at a time while balancing:

- Ordering costs
- Inventory holding costs
- Annual demand
- Order frequency

The analysis first develops a deterministic EOQ model using fixed demand assumptions and then evaluates the model under demand uncertainty using Monte Carlo simulation.

The model was implemented using **Microsoft Excel and R**.

---

## Business Problem

A manufacturing company needs to determine the optimal order quantity for a key engine component.

Ordering too frequently increases ordering costs, while ordering too much at once increases inventory holding costs.

The goal is to find the order quantity that minimizes total annual inventory cost.

---

## Input Assumptions

| Parameter | Value |
|---|---:|
| Annual Demand | 15,000 units |
| Unit Cost | $80 |
| Ordering Cost | $220 per order |
| Annual Holding Rate | 18% |
| Holding Cost per Unit | $14.40 |

---

## Key Results

The EOQ model produced the following results:

| Metric | Result |
|---|---:|
| Economic Order Quantity (EOQ) | 677 units |
| Minimum Annual Inventory Cost | ~$9,748.85 |
| Annual Ordering Cost | ~$4,874.42 |
| Annual Holding Cost | ~$4,874.42 |
| Annual Number of Orders | ~22.16 |
| Data Table Approximation | 700 units |

The Excel Solver result and the R optimization result both verified an optimal order quantity of approximately **677 units**.

---

## Methodology

### 1. Economic Order Quantity (EOQ)

The EOQ model was used to determine the order quantity that minimizes the combined ordering and holding costs.

The total annual inventory cost was modeled as:

```text
Total Cost = Ordering Cost + Holding Cost
           = (D / Q) * S + (Q / 2) * H
```

where `D` = annual demand, `Q` = order quantity (decision variable), `S` = ordering cost per order, and `H` = holding cost per unit per year (`H = holding rate x unit cost`).

Setting the derivative of `TC(Q)` to zero and solving gives the closed-form EOQ:

```text
EOQ = sqrt((2 * D * S) / H)
```

At the EOQ, annual ordering cost and annual holding cost are exactly equal — the defining property of the optimum.

### 2. Data Table Search & Visualization

An Excel/R data table evaluated total cost across a range of order quantities (Q = 100 to 1,500, in increments of 50). The lowest-cost grid point was **Q = 700 units** ($9,754.29), bracketing the true optimum. A plot of Total Cost vs. Order Quantity confirmed the expected U-shaped cost curve, with the minimum sitting at the EOQ (677 units).

### 3. Excel Solver Verification

Excel Solver was used to minimize `TC(Q)` directly, and R's `optimize()` function served as an independent cross-check. Both returned **Q ≈ 677.00 units** at a minimum total cost of **$9,748.85**, matching the closed-form formula and confirming the data-table approximation.

### 4. Two-Way Sensitivity (What-If) Analysis

A two-way data table in Excel varied the ordering cost (S) and the holding-cost rate (i) simultaneously and recorded the resulting minimum total cost for each combination. Results showed:

- Total cost increases as either parameter increases.
- The holding-cost rate has the larger effect on total cost — e.g., at S = $220, cost rises from ~$7,266 at i = 10% to ~$11,717 at i = 26%.
- The optimal order quantity moves inversely with the holding rate (larger H → smaller EOQ), consistent with the EOQ formula's square-root relationship.

This identifies the holding-cost rate as the parameter management should estimate most carefully.

### 5. Monte Carlo Simulation Under Demand Uncertainty (Part II)

All Part I parameters were held fixed except annual demand, which was modeled as a **triangular distribution** (min = 13,000, max = 17,000, mode = 15,000 units). A **1,000-trial Monte Carlo simulation** was run in R (fixed seed for reproducibility). For each trial, the EOQ, minimum total cost, and annual number of orders were recomputed from the Part I formulas, and the full set of outcomes was analyzed statistically:

- A **95% confidence interval** was constructed for each output.
- A **Normal distribution** was fit to each output via maximum likelihood (`fitdistrplus`).
- A **Kolmogorov–Smirnov (KS) test** verified the goodness of fit for each.

---

## Simulation Results (Part II)

| Output | Mean | 95% Confidence Interval | Best-Fit Distribution |
|---|---:|---|---|
| Minimum Total Cost | $9,742.77 | ($9,726.39, $9,759.15) | Normal (μ=$9,742.77, σ=$264.13) |
| Order Quantity (EOQ) | 676.58 units | (675.44, 677.72) | Normal (μ=676.58, σ=18.34) |
| Annual Number of Orders | 22.14 | (22.11, 22.18) | Normal (μ=22.14, σ=0.60) |

All three KS tests returned the same statistic (0.027) and p-value (**p ≈ .44**), since order quantity, total cost, and number of orders are each monotonic transformations of the same simulated demand values. Because p > .05 in every case, the Normal distribution is a statistically supported fit.

**Key takeaway:** the simulated results are tightly centered on the deterministic Part I values (677 units, $9,748.85, 22.16 orders), confirming that the EOQ policy is robust to realistic demand uncertainty, with narrow confidence intervals across all three outputs.

---

## Conclusion & Recommendation

The deterministic EOQ model recommends ordering **~677 units per replenishment** (~22 orders/year) at a minimum total annual cost of **~$9,749**, verified independently by the data table, Excel Solver, and R's `optimize()`. Introducing demand uncertainty via simulation changes little — expected cost of $9,742.77, order quantity of ~676.58 units, and ~22.14 orders/year — all falling within tight 95% confidence intervals and well-fit by a Normal distribution.

**Recommendation:** Adopt the EOQ policy of ordering approximately **677 units per replenishment**. Monitor realized ordering and holding costs against these projections, and re-run the model if unit cost, ordering cost, or the holding-cost rate changes materially.

---

## Repository Contents

| File | Description |
|---|---|
| `ALY6050-MOD4Project_Instructions.pdf` | Assignment instructions and grading rubric |
| `Inventory_Management_Analysis.docx` | Full written report (APA format) summarizing methodology, results, and recommendations |
| `Inventory_Management_Decision_Model.xlsx` | Excel workbook — EOQ model, data table, Solver setup, and two-way sensitivity table |
| `Inventory_Management_Simulation.R` | R script — EOQ model (Part I) and Monte Carlo simulation with distribution fitting (Part II) |

---

## Tools Used

- **Microsoft Excel** — Data Tables, Solver, two-way sensitivity analysis
- **R** — `ggplot2` (visualization), `triangle` (triangular distribution sampling), `fitdistrplus` (distribution fitting & KS testing)

---

## References

Carnell, R. (2024). *triangle: Provides the standard distribution functions for the triangle distribution* [R package]. The Comprehensive R Archive Network. https://CRAN.R-project.org/package=triangle

Delignette-Muller, M. L., & Dutang, C. (2015). fitdistrplus: An R package for fitting distributions. *Journal of Statistical Software, 64*(4), 1–34. https://doi.org/10.18637/jss.v064.i04

Evans, J. R. (2020). *Business analytics: Methods, models, and decisions* (3rd ed.). Pearson.

R Core Team. (2024). *R: A language and environment for statistical computing*. R Foundation for Statistical Computing. https://www.R-project.org/
