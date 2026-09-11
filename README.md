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
