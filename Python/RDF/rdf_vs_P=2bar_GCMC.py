import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

p = 2
fig_path = f'E:/Graduation Thesis/Figures/RDF_vs_temp_P={p}bar.svg'

# RDFデータを読み込む（4行のヘッダをスキップ）
phi = 0.4
Cu_273K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_Cu.dat", delim_whitespace=True, skiprows=4, header=None)
O1_273K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_O1.dat", delim_whitespace=True, skiprows=4, header=None)
O2_273K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_O2.dat", delim_whitespace=True, skiprows=4, header=None)
C1_273K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_C1.dat", delim_whitespace=True, skiprows=4, header=None)
C2_273K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_C2.dat", delim_whitespace=True, skiprows=4, header=None)
C3_273K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_C3.dat", delim_whitespace=True, skiprows=4, header=None)
H_273K  = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=273K/phi={phi}/EPM2F_T=273K_P={p}bar_revised/data/rdf_H.dat", delim_whitespace=True, skiprows=4, header=None)

phi = 0.75
Cu_298K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_Cu.dat", delim_whitespace=True, skiprows=4, header=None)
O1_298K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_O1.dat", delim_whitespace=True, skiprows=4, header=None)
O2_298K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_O2.dat", delim_whitespace=True, skiprows=4, header=None)
C1_298K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_C1.dat", delim_whitespace=True, skiprows=4, header=None)
C2_298K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_C2.dat", delim_whitespace=True, skiprows=4, header=None)
C3_298K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_C3.dat", delim_whitespace=True, skiprows=4, header=None)
H_298K  = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=298K/phi={phi}/EPM2F_T=298K_P={p}bar_revised/data/rdf_H.dat", delim_whitespace=True, skiprows=4, header=None)

phi = 1.75
Cu_353K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_Cu.dat", delim_whitespace=True, skiprows=4, header=None)
O1_353K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_O1.dat", delim_whitespace=True, skiprows=4, header=None)
O2_353K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_O2.dat", delim_whitespace=True, skiprows=4, header=None)
C1_353K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_C1.dat", delim_whitespace=True, skiprows=4, header=None)
C2_353K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_C2.dat", delim_whitespace=True, skiprows=4, header=None)
C3_353K = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_C3.dat", delim_whitespace=True, skiprows=4, header=None)
H_353K  = pd.read_csv(f"E:/LAMMPS/GCMC_revised/T=353K/phi={phi}/EPM2F_T=353K_P={p}bar_revised/data/rdf_H.dat", delim_whitespace=True, skiprows=4, header=None)

# 2列目に距離 r、3列目に RDF g(r) があるので、これを抽出
r_Cu_273K = Cu_273K[1]
rdf_Cu_273K = Cu_273K[2]
r_O1_273K = O1_273K[1]
rdf_O1_273K = O1_273K[2]
r_O2_273K = O2_273K[1]
rdf_O2_273K = O2_273K[2]
r_C1_273K = C1_273K[1]
rdf_C1_273K = C1_273K[2]
r_C2_273K = C2_273K[1]
rdf_C2_273K = C2_273K[2]
r_C3_273K = C3_273K[1]
rdf_C3_273K = C3_273K[2]
r_H_273K = H_273K[1]
rdf_H_273K = H_273K[2]

r_Cu_298K = Cu_298K[1]
rdf_Cu_298K = Cu_298K[2]
r_O1_298K = O1_298K[1]
rdf_O1_298K = O1_298K[2]
r_O2_298K = O2_298K[1]
rdf_O2_298K = O2_298K[2]
r_C1_298K = C1_298K[1]
rdf_C1_298K = C1_298K[2]
r_C2_298K = C2_298K[1]
rdf_C2_298K = C2_298K[2]
r_C3_298K = C3_298K[1]
rdf_C3_298K = C3_298K[2]
r_H_298K = H_298K[1]
rdf_H_298K = H_298K[2]

r_Cu_353K = Cu_353K[1]
rdf_Cu_353K = Cu_353K[2]
r_O1_353K = O1_353K[1]
rdf_O1_353K = O1_353K[2]
r_O2_353K = O2_353K[1]
rdf_O2_353K = O2_353K[2]
r_C1_353K = C1_353K[1]
rdf_C1_353K = C1_353K[2]
r_C2_353K = C2_353K[1]
rdf_C2_353K = C2_353K[2]
r_C3_353K = C3_353K[1]
rdf_C3_353K = C3_353K[2]
r_H_353K = H_353K[1]
rdf_H_353K = H_353K[2]

fig, axes = plt.subplots(2, 4, figsize=(8, 6), sharey=True)    

# Font
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['mathtext.fontset'] = 'stix' # math fontの設定
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

# 各サブプロットにデータを描画
axes[0, 0].plot(r_Cu_273K, rdf_Cu_273K, label='T=273 K ', color="red", linewidth=1.0)
axes[0, 0].plot(r_Cu_298K, rdf_Cu_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[0, 0].plot(r_Cu_353K, rdf_Cu_353K, label='T=353 K', color="green", linewidth=1.0)
axes[0, 0].set_title("Cu - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

axes[0, 1].plot(r_O1_273K, rdf_O1_273K, label='T=273 K', color="red", linewidth=1.0)
axes[0, 1].plot(r_O1_298K, rdf_O1_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[0, 1].plot(r_O1_353K, rdf_O1_353K, label='T=353 K', color="green", linewidth=1.0)
axes[0, 1].set_title("O(1) - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

axes[0, 2].plot(r_O2_273K, rdf_O2_273K, label='T=273 K', color="red", linewidth=1.0)
axes[0, 2].plot(r_O2_298K, rdf_O2_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[0, 2].plot(r_O2_353K, rdf_O2_353K, label='T=353 K', color="green", linewidth=1.0)
axes[0, 2].set_title("O(2) - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

axes[0, 3].axis("off")

axes[1, 0].plot(r_C1_273K, rdf_C1_273K, label='T=273 K', color="red", linewidth=1.0)
axes[1, 0].plot(r_C1_298K, rdf_C1_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[1, 0].plot(r_C1_353K, rdf_C1_353K, label='T=353 K', color="green", linewidth=1.0)
axes[1, 0].set_title("C(1) - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

axes[1, 1].plot(r_C2_273K, rdf_C2_273K, label='T=273 K', color="red", linewidth=1.0)
axes[1, 1].plot(r_C2_298K, rdf_C2_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[1, 1].plot(r_C2_353K, rdf_C2_353K, label='T=353 K', color="green", linewidth=1.0)
axes[1, 1].set_title("C(2) - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

axes[1, 2].plot(r_C3_273K, rdf_C3_273K, label='T=273 K', color="red", linewidth=1.0)
axes[1, 2].plot(r_C3_298K, rdf_C3_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[1, 2].plot(r_C3_353K, rdf_C3_353K, label='T=353 K', color="green", linewidth=1.0)
axes[1, 2].set_title("C(3) - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

axes[1, 3].plot(r_H_273K, rdf_H_273K, label='T=273 K', color="red", linewidth=1.0)
axes[1, 3].plot(r_H_298K, rdf_H_298K, label='T=298 K', color="blue", linewidth=1.0)
axes[1, 3].plot(r_H_353K, rdf_H_353K, label='T=353 K', color="green", linewidth=1.0)
axes[1, 3].set_title("H - C(CO₂)", fontfamily="Times New Roman", fontsize=14)

for i, ax in enumerate(axes.flat):
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 4)

    ax.xaxis.set_major_locator(ticker.MultipleLocator(2))
    ax.yaxis.set_major_locator(ticker.MultipleLocator(0.5))

    ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=12)
    ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=12)

    ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
    
    ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False)
    ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)

# 共通のラベル
fig.supxlabel(r"$r\,[\mathrm{\AA}]$", fontsize=15)
fig.supylabel(r"$g(r)$", fontsize=15)

# 凡例
fig.legend(
    ["T=273 K", "T=298 K", "T=353 K"],  # 凡例のラベル
    loc='upper right',                   # 配置（図の中央下部）
    bbox_to_anchor=(0.92, 0.90),
    ncol=1,                               # 列数
    fontsize=14,                          # フォントサイズ
    frameon=False,
    fancybox=False
)

plt.subplots_adjust(hspace=0.25)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

# グラフを表示
plt.show()
