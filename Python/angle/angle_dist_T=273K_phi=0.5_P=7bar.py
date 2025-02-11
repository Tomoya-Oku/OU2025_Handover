import re
import numpy as np
import seaborn as sb
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Parameter
T = 273
phi = 0.5
press = 7

fig_path = f'E:/Graduation Thesis/Figures/angle_dist_T={T}K_phi={phi}_P={press}bar.svg'

# re pattern for detecting co2 molecule
pattern = re.compile(r"^\d+\.\d+")
except_pattern = re.compile(r"\d\.\d+e[+-]\d+\s\d\.\d+e[+-]\d+")

def modify_file():
    with open(input_path, "r") as infile, open(modified_path, "w") as outfile:
        outfile.write("angle\n")
        for line in infile:
            # 行がパターンに一致すれば書き出す
            if pattern.match(line) and not except_pattern.match(line):
                outfile.write(line)

    print('Finished extracting valid lines!')

# Font
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['mathtext.fontset'] = 'stix' # math fontの設定
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

fig, ax = plt.subplots(figsize=(10, 6))

# Path
input_path = f"E:/LAMMPS/MD/energy_per_atom_T={T}K_phi={phi}/data/angles.dat"
modified_path = f"E:/LAMMPS/MD/energy_per_atom_T={T}K_phi={phi}/data/angles_modified.dat"

# If you had made modified files once, you don't have to implement this function!
# modify_file()

data = pd.read_csv(modified_path, delim_whitespace=True)
datalist = data["angle"].to_numpy()

bins = np.histogram_bin_edges(datalist, bins='auto')
sb.histplot(data=datalist, bins=bins, alpha=1.0, color="orange", element="poly", lw=0, ax=ax)

ax.set_xlabel("Angle [deg]", fontsize=15)
ax.set_ylabel(r"$N_\mathrm{CO_2}$", fontsize=15)

ax.set_xlim(165, 180)
ax.set_ylim(0, 40000)

ax.xaxis.set_major_locator(ticker.MultipleLocator(5))
ax.yaxis.set_major_locator(ticker.MultipleLocator(5000))

ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=12)
ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=12)

ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))

ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False, pad=11)
ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

plt.show()