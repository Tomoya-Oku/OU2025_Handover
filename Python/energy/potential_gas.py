import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from matplotlib.ticker import MultipleLocator

p = 1
f = 1
mu = 0

adsorption_path = f"E:\\LAMMPS\\GCMC\\Legacy\\p={p}bar_f={f}_mu=0\\data\\energy_gas.dat"
desorption_path = f"E:\\LAMMPS\\MD_after_GCMC\\Test\\data\\energy_gas.dat"

adsorption = pd.read_csv(adsorption_path, delim_whitespace=True, skiprows=2, header=None)
desorption = pd.read_csv(desorption_path, delim_whitespace=True, skiprows=2, header=None)

step_adsorption = adsorption[0]
pe_adsorption = adsorption[2]
step_desorption = desorption[0]
time_desorption = step_desorption / (2*10**6)
pe_desorption = desorption[2]

mean_pe_adsorption = np.mean(pe_adsorption)
mean_pe_desorption = np.mean(pe_desorption)

print(f"mean(adsorption)={mean_pe_adsorption}, mean(desorption)={mean_pe_desorption}")

# グラフの設定
fig, axes = plt.subplots(1,2, figsize=(10, 5), sharey=True)

plt.rcParams["axes.labelsize"] = 16       # x軸, y軸ラベル文字サイズ
plt.rcParams["legend.fontsize"] = 14      # 凡例ラベル文字サイズ
plt.rcParams["xtick.labelsize"] = 20      # x軸 目盛り文字サイズ
plt.rcParams["ytick.labelsize"] = 20      # y軸 目盛り文字サイズ

axes[0].plot(step_adsorption, pe_adsorption, label='Adsorption', color="red")
axes[1].plot(time_desorption, pe_desorption, label='Desorption', color="blue")

axes[0].set_xlim(0, max(step_adsorption))
axes[1].set_xlim(0, max(time_desorption))

axes[0].set_xlabel('Step', fontsize=20)
axes[0].set_ylabel('Potential Energy [kcal/mol]', fontsize=20)
axes[1].set_xlabel('Time [ns]', fontsize=20)

axes[0].xaxis.set_major_locator(ticker.MultipleLocator(1000))
axes[1].xaxis.set_major_locator(ticker.MultipleLocator(0.1))

for i, ax in enumerate(axes.flat):
    ax.set_ylim(-150, -50)
    ax.yaxis.set_major_locator(MultipleLocator(10))
    ax.grid(True, linestyle='--', linewidth=0.5) # グリッドを追加
    ax.tick_params(axis='x', which='both', bottom=True, top=False, labelsize=14)
    ax.tick_params(axis='y', which='both', left=False, right=False, labelsize=14)

# 凡例
fig.tight_layout()

plt.savefig('E:\Presentation\\241224_midterm\\fig\\potential.jpeg', dpi=600, bbox_inches='tight')

# グラフを表示
plt.show()
