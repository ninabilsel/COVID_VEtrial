This folder contains ecdf and violin plots for the distribution of each antibody marker readout at Day 1 and Day 57, 
each of the 32 subgroups defined by Trt X MinorityInd X HighRiskInd X (age 18-64, age 65-80) X Bserostatus.

Inverse probability of sampling into the subcohort weights are used in the estimation of the rcdf curves; henceforth we refer to these weights as "inverse probability of sampling" (IPS) weights. (weights are equal to:
    sample proportion with TwophasesampInd = 1 in each subgroup defined by Trt X MinorityInd X HighRiskInd X (age 18-64, age 65-80) X Bserostatus) if EventInd = 0
    1 if EventInd = 1)
