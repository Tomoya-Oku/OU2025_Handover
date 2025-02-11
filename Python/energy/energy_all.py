import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

p = 1
f = 1
mu = 0

kes_mof = []
pes_mof = []
tes_mof = []
kes_gas = []
pes_gas = []
tes_gas = []

mof_path = f"E:\\LAMMPS\\GCMC\\p={p}bar_f={f}_mu=0\\data\\energy_mof.dat"
gas_path = f"E:\\LAMMPS\\GCMC\\p={p}bar_f={f}_mu=0\\data\\energy_gas.dat"

mof = pd.read_csv(mof_path, delim_whitespace=True, skiprows=2, header=None)
gas = pd.read_csv(gas_path, delim_whitespace=True, skiprows=2, header=None)

step = mof[0]
ke_mof = mof[1]
pe_mof = mof[2]
te_mof = mof[3]
ke_gas = gas[1]
pe_gas = gas[2]
te_gas = gas[3]

# グラフの設定
fig, ax = plt.subplots()

ax.plot(step, ke_mof, label='KE (MOF)', color="red")
ax.plot(step, pe_mof, label="PE (MOF)", color="blue")
ax.plot(step, te_mof, label="TE (MOF)", color="black")

ax.plot(step, ke_gas, label='KE (GAS)', color="red")
ax.plot(step, pe_gas, label="PE (GAS)", color="blue")
ax.plot(step, te_gas, label="TE (GAS)", color="black")

ax.xaxis.set_major_locator(ticker.MultipleLocator(1000))
ax.grid(True, linestyle='--', linewidth=0.5) # グリッドを追加
ax.tick_params(axis='x', which='both', bottom=True, top=False)
ax.tick_params(axis='y', which='both', left=False, right=False)

ax.set_xlabel('Step', fontsize=16)
ax.set_ylabel('Energy [kcal/mol]', fontsize=16)

# 凡例
fig.legend()

# グラフを表示
plt.show()
