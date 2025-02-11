import numpy as np

N_CO2 = np.array([25.0])

N_A = 6.02214076 * 10 ** 23

N_Cu = 48
N_O = 192
N_C = 288
N_H = 96

M_Cu = 63.546001434326172
M_O = 15.999400138854980
M_C = 12.010700225830078
M_H = 1.0079400539398193

M_MOF = N_Cu*M_Cu + N_O*M_O + N_C*M_C + N_H*M_H
print("M_MOF=" + str(M_MOF) + "[g/mol]")

uptake = (N_CO2 / M_MOF) * 1000
print("CO2 uptake=" + str(uptake) + "[mmol/g]")