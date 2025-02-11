import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# re pattern for detecting co2 molecule
pattern = re.compile(r"^\s*\d+\s+\d+\s+(-?\d+(\.\d+)?\s+){4}-?\d+(\.\d+)?\s*$")

# Path
input_path = "E:/LAMMPS/MD/EPM2F/energy_per_atom/data/energy_gas_per_atom.dat"
CO2_modified_path = "E:/LAMMPS/MD/EPM2F/energy_per_atom/data/energy_gas_per_atom_modified_CO2.dat"
C_modified_path = "E:/LAMMPS/MD/EPM2F/energy_per_atom/data/energy_gas_per_atom_modified_C.dat"
O_modified_path = "E:/LAMMPS/MD/EPM2F/energy_per_atom/data/energy_gas_per_atom_modified_O.dat"

def modify_energy_file():
    # making co2
    with open(input_path, "r") as infile, open(CO2_modified_path, "w") as outfile:
        outfile.write("id type x y z ke pe\n")
        for line in infile:
            # 行がパターンに一致すれば書き出す
            if pattern.match(line):
                outfile.write(line)

    print('Finished making CO2 modified file!')

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
C_pe_permol = np.add.reduceat(C_pe, np.arange(0, len(C_pe), 3))
O_pe_permol = np.add.reduceat(O_pe, np.arange(0, len(O_pe), 3))

plt.figure(figsize=(10, 6))

# Font
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['mathtext.fontset'] = 'stix' # math fontの設定
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

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

bins = np.histogram_bin_edges(np.concatenate([CO2_pe_permol, C_pe_permol, O_pe_permol]), bins='auto')
plt.hist(CO2_pe_permol, bins=bins, color='orange', edgecolor='black', alpha=0.7, label='CO2')
plt.hist(C_pe_permol, bins=bins, color='gray', edgecolor='black', alpha=0.7, label='C')
plt.hist(O_pe_permol, bins=bins, color='red', edgecolor='black', alpha=0.7, label='O')

# Plot
plt.xlim(-15, 10)
plt.ylim(0, 5000)
plt.xlabel("Potential Energy [kcal/mol]")
plt.ylabel(r"$N_\mathrm{CO_2}$")
plt.grid(False)
plt.legend(frameon=False)

plt.savefig('E:/Graduation Thesis/Figures/potential_distribution_EPM2F_T=398K.svg', dpi=600, bbox_inches='tight')

plt.show()