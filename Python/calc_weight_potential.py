import re
import numpy as np
import pandas as pd

coord_path = "E:\LAMMPS\GCMC\p=1bar_f=0.5_mu=-50\data\gcmc.data"
poten_path = ""
pattern = r"(\d+)\s+(\d+)\s+(\d+)\s+(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)\s+(-?\d+)\s+(-?\d+)\s+(-?\d+)"

def calc_dist(coord1, coord2):
    coord1 = np.array(coord1)
    coord2 = np.array(coord2)
    distance = np.linalg.norm(coord1 - coord2)
    return distance

# Read Potential Energy per atom data

data_Cu = []
data_O1 = []
data_O2 = []
data_C1 = []
data_C2 = []
data_C3 = []
data_H = []
data_C = []
data_O = []
with open(coord_path, 'r') as file:
    for line in file:
        if 'Velocities' in line:
            break
        
        match = re.match(pattern, line.strip())
        if match:
            numbers = match.groups()
            id = numbers[0]
            kind = numbers[2]
            x = numbers[4]
            y = numbers[5]
            z = numbers[6]
            if kind == '1':
                data_Cu.append([x, y, z, id])
            elif kind == '2':
                data_O1.append([x, y, z, id])
            elif kind == '3':
                data_O2.append([x, y, z, id])
            elif kind == '4':
                data_C1.append([x, y, z, id])
            elif kind == '5':
                data_C2.append([x, y, z, id])
            elif kind == '6':
                data_C3.append([x, y, z, id])
            elif kind == '7':
                data_H.append([x, y, z, id])
            elif kind == '8':
                data_C.append([x, y, z, id])
            elif kind == '9':
                data_O.append([x, y, z, id])

N_Cu = len(data_Cu)
N_O1 = len(data_O1)
N_O2 = len(data_O2)
N_C1 = len(data_C1)
N_C2 = len(data_C2)
N_C3 = len(data_C3)
N_H = len(data_H)
N_C = len(data_C)
N_O = len(data_O)

r_i_Cu = []
r_i_O1 = []
r_i_O2 = []
r_i_C1 = []
r_i_C2 = []
r_i_C3 = []
r_i_H = []
for i in N_C:
    for j in range(N_Cu):
        r_i_Cu.append(calc_dist(data_C[i][:-1], data_Cu[j][:-1]))
    for j in range(N_O1):
        r_i_O1.append(calc_dist(data_C[i][:-1], data_O1[j][:-1]))
    for j in range(N_O2):
        r_i_O2.append(calc_dist(data_C[i][:-1], data_O2[j][:-1]))
    for j in range(N_C1):
        r_i_C1.append(calc_dist(data_C[i][:-1], data_C1[j][:-1]))
    for j in range(N_C2):
        r_i_C2.append(calc_dist(data_C[i][:-1], data_C2[j][:-1]))
    for j in range(N_C3):
        r_i_C3.append(calc_dist(data_C[i][:-1], data_C3[j][:-1]))
    for j in range(N_H):
        r_i_H.append(calc_dist(data_C[i][:-1], data_H[j][:-1]))
        
r_i_Cu_mean = np.mean(r_i_Cu)
r_i_O1_mean = np.mean(r_i_O1)
r_i_O2_mean = np.mean(r_i_O2)
r_i_C1_mean = np.mean(r_i_C1)
r_i_C2_mean = np.mean(r_i_C2)
r_i_C3_mean = np.mean(r_i_C3)
r_i_H_mean = np.mean(r_i_H)

r_i_X_sum = np.sum(r_i_Cu_mean, r_i_O1_mean, r_i_O2_mean, r_i_C1_mean, r_i_C2_mean, r_i_C3_mean, r_i_H_mean)

r_i_Cu_norm = r_i_Cu_mean / r_i_X_sum
r_i_O1_norm = r_i_O1_mean / r_i_X_sum
r_i_O2_norm = r_i_O2_mean / r_i_X_sum
r_i_C1_norm = r_i_C1_mean / r_i_X_sum
r_i_C2_norm = r_i_C2_mean / r_i_X_sum
r_i_C3_norm = r_i_C3_mean / r_i_X_sum
r_i_H_norm  = r_i_H_mean  / r_i_X_sum

for i in N_C:


V_Cu = len(data_Cu)
V_O1 = len(data_O1)
V_O2 = len(data_O2)
V_C1 = len(data_C1)
V_C2 = len(data_C2)
V_C3 = len(data_C3)
V_H = len(data_H)
