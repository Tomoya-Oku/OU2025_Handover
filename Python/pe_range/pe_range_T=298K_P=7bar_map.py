import re
import numpy as np
import seaborn as sb
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from mpl_toolkits.axes_grid1.inset_locator import inset_axes

# Parameter
T = 298
phi = 0.75
p = 7

cif_path = "E:/LAMMPS/generate_init/inmc/in111_cif.dat"
fig_path = f'E:/Graduation Thesis/Figures/pe_map_T={T}K_phi={phi}_P={p}bar.svg'

# re pattern for detecting co2 molecule
pattern = re.compile(r"^\s*\d+\s+\d+\s+(-?\d+(\.\d+)?\s+){4}-?\d+(\.\d+)?\s*$")

def modify_energy_file():
    # Extract valid lines
    with open(input_path, "r") as infile, open(CO2_modified_path, "w") as outfile:
        outfile.write("id type x y z ke pe\n")
        for line in infile:
            # 行がパターンに一致すれば書き出す
            if pattern.match(line):
                outfile.write(line)

    print('Finished extracting valid lines!')

# Path
input_path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={p}bar_revised/data/energy_gas_per_atom.dat"
CO2_modified_path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={p}bar_revised/data/energy_gas_per_atom_modified_CO2.dat"

# If you had made modified files once, you don't have to implement this function!
# modify_energy_file()

data = pd.read_csv(CO2_modified_path, delim_whitespace=True)
data_sorted = data.sort_values(by="id").reset_index(drop=True)

all_x = data_sorted["x"].to_numpy()
all_y = data_sorted["y"].to_numpy()
all_z = data_sorted["z"].to_numpy()
all_pe = data_sorted["pe"].to_numpy()

CO2_x = all_x[::3]
CO2_y = all_y[::3]
CO2_z = all_z[::3]
CO2_pe = np.add.reduceat(all_pe, np.arange(0, len(all_pe), 3))

R1_x = []
R1_y = []
R1_z = []
R1_pe = []

R2_x = []
R2_y = []
R2_z = []
R2_pe = []

R3_x = []
R3_y = []
R3_z = []
R3_pe = []
for i in range(len(CO2_pe)):
    if CO2_pe[i] <= -5.0:
        R1_x.append(CO2_x[i])
        R1_y.append(CO2_y[i])
        R1_z.append(CO2_z[i])
        R1_pe.append(CO2_pe[i])
    elif -5.0 < CO2_pe[i] < 0:
        R2_x.append(CO2_x[i])
        R2_y.append(CO2_y[i])
        R2_z.append(CO2_z[i])
        R2_pe.append(CO2_pe[i])
    else:
        R3_x.append(CO2_x[i])
        R3_y.append(CO2_y[i])
        R3_z.append(CO2_z[i])
        R3_pe.append(CO2_pe[i])

# Font
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['mathtext.fontset'] = 'stix' # math fontの設定
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

fig, ax = plt.subplots(1, 1, figsize=(8, 8))

# Axes
plt.rcParams["axes.labelsize"] = 16 # x軸, y軸ラベル文字サイズ
plt.rcParams["xtick.labelsize"] = 16      # x軸 目盛り文字サイズ
plt.rcParams["ytick.labelsize"] = 16      # y軸 目盛り文字サイズ
plt.rcParams['xtick.direction'] = 'in' #x軸の目盛りの向き
plt.rcParams['ytick.direction'] = 'in' #y軸の目盛りの向き
plt.rcParams["xtick.minor.visible"] = True  #x軸補助目盛りの追加
plt.rcParams["ytick.minor.visible"] = True  #y軸補助目盛りの追加
plt.rcParams['xtick.top'] = True  #x軸の上部目盛り
plt.rcParams['ytick.right'] = True  #y軸の右部目盛り

# Legend
plt.rcParams["legend.fontsize"] = 14      # 凡例ラベル文字サイズ
plt.rcParams["legend.fancybox"] = False  # 丸角OFF
plt.rcParams["legend.framealpha"] = 1  # 透明度の指定、0で塗りつぶしなし
plt.rcParams["legend.edgecolor"] = 'black'  # edgeの色を変更
plt.rcParams["legend.markerscale"] = 5 #markerサイズの倍率

sc = plt.scatter(CO2_x, CO2_y, marker='.', c=CO2_pe, cmap='inferno', s=2, vmin=-15, vmax=5)
fig.colorbar(sc, label='Potential Energy [kcal/mol]', ax=ax)

ax.set(aspect=1)

ax.set_xlabel(r"$x~[\rm{\AA}]$")
ax.set_ylabel(r"$y~[\rm{\AA}]$")

ax.set_xlim(0.0, 26.343000411987305)
ax.set_ylim(0.0, 26.343000411987305)

ax.xaxis.set_major_locator(ticker.MultipleLocator(2))
ax.yaxis.set_major_locator(ticker.MultipleLocator(2))

ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=14)
ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=14)

ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))

ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False)
ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)

plt.grid(False)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

plt.show()

