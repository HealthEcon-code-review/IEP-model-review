# Code Repository – Insurer-Enabled Prevention (IEP) Model

This repository contains the R code used for simulations and figure generation in the manuscript  
**“Incentive Structures for Insurer-Enabled Prevention: A Game-Theoretic Model of Occupational Health under Demographic Ageing”** (submitted to *The Geneva Papers on Risk and Insurance - Issues and Practice*).

The code includes:
- Simulation of rebate thresholds under asymmetric observability
- Modelling of insurer and employer incentives across varying age and risk profiles
- Simulation of alternative absence trajectories 

### Usage
All code was written and tested in R (version 4.5.0).  
Scripts are modular and can be run independently.

### Structure
- `02_rebate_thresholds.R`: Computes rebate feasibility ranges for insurer–employer alignment  
- `03_insurer_utility.R`: Calculates insurer utility gains by age and absence trajectory  
- `04_employer_utility.R`: Simulates employer utility under different assumptions  
- `05_absence_trajectories.R`: Defines age-dependent baseline absence patterns  

> ⚠️ This version is anonymised for peer review. A citable version will be archived on Zenodo upon acceptance.
