import re
import numpy as np
import seaborn as sb
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Parameter
T = 353
phi = 1.5
press = 7

fig_path = f'E:/Graduation Thesis/Figures/mof_pe_dist_T={T}K_phi={phi}.svg'

# Path
original_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_mof_per_atom.dat"
modified_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_mof_per_atom_modified.dat"
Cu_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_Cu.dat"
O1_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_O1.dat"
O2_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_O2.dat"
C1_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_C1.dat"
C2_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_C2.dat"
C3_path = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_C3.dat"
H_path  = f"E:/LAMMPS/MD/T={T}K_phi={phi}_P={press}bar/data/energy_H.dat"

# re pattern for detecting co2 molecule
pattern = re.compile(r"^\s*\d+\s+\d+\s+(-?\d+(\.\d+)?\s+){4}-?\d+(\.\d+)?\s*$")

def modify_energy_file():
    # Extract valid line
    with open(original_path, "r") as infile, open(modified_path, "w") as outfile:
        outfile.write("id type x y z ke pe\n")
        for line in infile:
            if pattern.match(line):
                outfile.write(line)

    print('Finished extracting valid lines!')

    # Extract Cu line
    with open(modified_path, "r") as infile, open(Cu_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "1":
                outfile.write(line)

    print('Finished making Cu modified file!')

    # Extract O(1) line
    with open(modified_path, "r") as infile, open(O1_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "2":
                outfile.write(line)

    print('Finished making O(1) modified file!')

    # Extract O(2) line
    with open(modified_path, "r") as infile, open(O2_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "3":
                outfile.write(line)

    print('Finished making O(2) modified file!')

    # Extract C(1) line
    with open(modified_path, "r") as infile, open(C1_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "4":
                outfile.write(line)

    print('Finished making C(1) modified file!')

    # Extract C(2) line
    with open(modified_path, "r") as infile, open(C2_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "5":
                outfile.write(line)

    print('Finished making C(2) modified file!')

    # Extract C(3) line
    with open(modified_path, "r") as infile, open(C3_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "6":
                outfile.write(line)

    print('Finished making C(3) modified file!')

    # Extract H line
    with open(modified_path, "r") as infile, open(H_path, "w") as outfile:
        for line in infile:
            # ヘッダー行はそのまま書き出す
            if line.strip().startswith("id type"):
                outfile.write(line)
                continue
            
            # データ行を分割して type 列を確認
            parts = line.split()
            if len(parts) > 1 and parts[1] == "7":
                outfile.write(line)

    print('Finished making H modified file!')

# Font
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['mathtext.fontset'] = 'stix' # math fontの設定
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

fig, ax = plt.subplots(figsize=(12, 8))

# If you had made modified files once, you don't have to implement this function!
# modify_energy_file()

Cu_data = pd.read_csv(Cu_path, delim_whitespace=True)
O1_data = pd.read_csv(O1_path, delim_whitespace=True)
O2_data = pd.read_csv(O2_path, delim_whitespace=True)
C1_data = pd.read_csv(C1_path, delim_whitespace=True)
C2_data = pd.read_csv(C2_path, delim_whitespace=True)
C3_data = pd.read_csv(C3_path, delim_whitespace=True)
H_data  = pd.read_csv(H_path, delim_whitespace=True)

Cu_pe = Cu_data["pe"].to_numpy()
O1_pe = O1_data["pe"].to_numpy()
O2_pe = O2_data["pe"].to_numpy()
C1_pe = C1_data["pe"].to_numpy()
C2_pe = C2_data["pe"].to_numpy()
C3_pe = C3_data["pe"].to_numpy()
H_pe  = H_data["pe"].to_numpy()

bins = np.histogram_bin_edges(np.concatenate([Cu_pe, O1_pe, O2_pe, C1_pe, C2_pe, H_pe]), bins='auto')
sb.histplot(data=Cu_pe, bins=bins, stat="density", color="orange", alpha=1, element="poly", lw=0, ax=ax, label="Cu")
sb.histplot(data=O1_pe, bins=bins, stat="density", color="red", alpha=1, element="poly", lw=0, ax=ax, label="O(1)")
sb.histplot(data=O2_pe, bins=bins, stat="density", color="magenta", alpha=1, element="poly", lw=0, ax=ax, label="O(2)")
sb.histplot(data=C1_pe, bins=bins, stat="density", color="cyan", alpha=0.75, element="poly", lw=0, ax=ax, label="C(1)")
sb.histplot(data=C2_pe, bins=bins, stat="density", color="lime", alpha=1, element="poly", lw=0, ax=ax, label="C(2)")
sb.histplot(data=C3_pe, bins=bins, stat="density", color="gold", alpha=1, element="poly", lw=0, ax=ax, label="C(3)")
sb.histplot(data=H_pe, bins=bins, stat="density", color="black", alpha=1, element="poly", lw=0, ax=ax, label="H")

ax.set_xlabel("Potential Energy [kcal/mol]", fontsize=16, labelpad=6)
ax.set_ylabel("Probability Density", fontsize=16, labelpad=6)

ax.set_xlim(-20, 100)
ax.set_ylim(0, 1)

ax.xaxis.set_major_locator(ticker.MultipleLocator(10))
ax.yaxis.set_major_locator(ticker.MultipleLocator(0.2))

ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=15)
ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=15)

ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%.1f'))

ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False)
ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)

plt.legend(frameon=False)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

plt.show()