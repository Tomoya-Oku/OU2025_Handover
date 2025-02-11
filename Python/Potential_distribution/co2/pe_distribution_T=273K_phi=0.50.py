import re
import numpy as np
import seaborn as sb
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Parameter
T = 273
phi = 0.5
press = [1, 2, 3, 4, 5, 6, 7]

fig_path = f'E:/Graduation Thesis/Figures/pe_dist_EPM2F_T={T}K_phi={phi}.svg'

# re pattern for detecting co2 molecule
pattern = re.compile(r"^\s*\d+\s+\d+\s+(-?\d+(\.\d+)?\s+){4}-?\d+(\.\d+)?\s*$")

def modify_energy_file():
    # making co2
    with open(input_path, "r") as infile, open(CO2_modified_path, "w") as outfile:
        outfile.write("id type x y z ke pe\n")
        for line in infile:
            # 行がパターンに一致すれば書き出す
            if pattern.match(line):
                outfile.write(line)

    print('Finished extracting valid lines!')

    # making c
    with open(CO2_modified_path, "r") as infile, open(C_modified_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "8":  # type 列が 8 の場合はスキップ
                continue
            
            # 条件に一致しない行を書き出す
            outfile.write(line)

    print('Finished making C modified file!')

    # making o
    with open(CO2_modified_path, "r") as infile, open(O_modified_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "9":  # type 列が 8 の場合はスキップ
                continue
            
            # 条件に一致しない行を書き出す
            outfile.write(line)

    print('Finished making O modified file!')

# Font
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['mathtext.fontset'] = 'stix' # math fontの設定
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

fig, axes = plt.subplots(4, 2, figsize=(8, 12), sharey=True)

CO2_pe_permols = []
C_pe_permols = []
O_pe_permols = []
for p in press:
    # Path
    input_path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={p}bar_revised/data/energy_gas_per_atom.dat"
    CO2_modified_path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={p}bar_revised/data/energy_gas_per_atom_modified_CO2.dat"
    C_modified_path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={p}bar_revised/data/energy_gas_per_atom_modified_C.dat"
    O_modified_path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={p}bar_revised/data/energy_gas_per_atom_modified_O.dat"

    # If you had made modified files once, you don't have to implement this function!
    # modify_energy_file()

    CO2_data = pd.read_csv(CO2_modified_path, delim_whitespace=True)
    C_data = pd.read_csv(C_modified_path, delim_whitespace=True)
    O_data = pd.read_csv(O_modified_path, delim_whitespace=True)

    CO2_data_sorted = CO2_data.sort_values(by="id").reset_index(drop=True)
    C_data_sorted = C_data.sort_values(by="id").reset_index(drop=True)
    O_data_sorted = O_data.sort_values(by="id").reset_index(drop=True)

    CO2_pe = CO2_data_sorted["pe"].to_numpy()
    C_pe = C_data_sorted["pe"].to_numpy()
    O_pe = O_data_sorted["pe"].to_numpy()

    CO2_pe_permol = np.add.reduceat(CO2_pe, np.arange(0, len(CO2_pe), 3))
    C_pe_permol = C_pe
    O_pe_permol = O_pe

    CO2_pe_permols.append(CO2_pe_permol)
    C_pe_permols.append(C_pe_permol)
    O_pe_permols.append(O_pe_permol)

for i, ax in enumerate(axes.flat):
    if i == 7:
        ax.axis("off")
        break

    bins = np.histogram_bin_edges(np.concatenate([CO2_pe_permols[i], C_pe_permols[i], O_pe_permols[i]]), bins='auto')
    sb.histplot(data=CO2_pe_permols[i], bins="auto", stat="density", alpha=1.0, color="orange", element="poly", lw=0, ax=ax)
    sb.histplot(data=C_pe_permols[i], bins="auto", stat="density", alpha=0.5, color="gray", element="poly", lw=0, ax=ax)
    sb.histplot(data=O_pe_permols[i], bins="auto", stat="density", alpha=0.5, color="red", element="poly", lw=0, ax=ax)

    ax.set_xlabel("")
    ax.set_ylabel("")

    ax.set_title(rf"$P={press[i]}$ bar", fontfamily="Times New Roman", fontsize=14)

    ax.set_xlim(-15, 5)
    ax.set_ylim(0, 1)

    ax.xaxis.set_major_locator(ticker.MultipleLocator(5))
    ax.yaxis.set_major_locator(ticker.MultipleLocator(0.2))

    ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=12)
    ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=12)

    ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
    ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%.1f'))
    
    ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False)
    ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)


# 共通のラベル
fig.supxlabel("Potential Energy [kcal/mol]", fontsize=15, y=0.05)
fig.supylabel("Probability Density", fontsize=15)

# 凡例
fig.legend(
    [r"$\mathrm{CO_2}$", r"$\mathrm{C}$", r"$\mathrm{O}$"],  # 凡例のラベル
    loc='lower right',                   # 配置（図の中央下部）
    bbox_to_anchor=(0.8, 0.125),
    ncol=1,                               # 列数
    fontsize=14,                          # フォントサイズ
    frameon=False,
    fancybox=False
)

plt.subplots_adjust(hspace=0.5)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

plt.show()