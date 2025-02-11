import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Parameter
figpath = 'E:/Graduation Thesis/Figures/adsorption_isotherm__T=298K_phi=0.75_LB.svg'
n = 5000 # used to obtain mean value 
press = np.array([0, 1, 2, 3, 4, 5, 6, 7])

# Constant
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

# Experiment Data (Unusually large microporous HKUST-1 via polyethylene glycol-templated synthesis: enhanced CO2 uptake with high selectivity over CH4 and N2)
exp_press_298K = np.array([
    0, 0.6595775255065375, 1.143842506107199, 1.8307228050007174, 2.417013938784307,
    3.3079465440436833, 4.400057479522917, 5.691909757149012, 7.399051587871816,
    9.305934760741483, 11.428366144560997, 13.96321310533122
])

exp_uptake_mg_298K = np.array([
    0, 107.28552953010478, 158.1261675528093, 211.8407817215117, 262.7101595056761,
    316.4822531972985, 375.94481965799685, 443.9143555108492, 497.91636729415154,
    560.4253484696077, 600.4598361833597, 632.1597930737175
])
exp_uptake_mmol_298K = exp_uptake_mg_298K / 44.0

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

# Plot Experiment Data
plt.plot(exp_press_298K, exp_uptake_mmol_298K, marker='.', linestyle='-', color='black', label="Experiment")

gm_Ngases = []
lb_Ngases = []
gm_uptakes = []
lb_uptakes = []
for p in press:
    if p == 0:
        gm_uptake = 0
        lb_uptake = 0
    else:
        gm_path = f"E:\\LAMMPS\\GCMC_revised\\T=298K\\phi=0.75\\EPM2F_T=298K_P={p}bar_revised\\data\\Ngas.dat"
        lb_path = f"E:\\LAMMPS\\GCMC_LB\\T=298K\\phi=0.75\\EPM2F_T=298K_P={p}bar_revised\\data\\Ngas.dat"
        gm_data = pd.read_csv(gm_path, delim_whitespace=True, skiprows=2, header=None)
        lb_data = pd.read_csv(lb_path, delim_whitespace=True, skiprows=2, header=None)

        gm_Ngas = gm_data[1]
        gm_Ngases.append(gm_Ngas)
        lb_Ngas = lb_data[1]
        lb_Ngases.append(lb_Ngas)

        gm_Ngas_mean = np.mean(gm_Ngas[-n:])
        lb_Ngas_mean = np.mean(lb_Ngas[-n:])

        gm_uptake = (gm_Ngas_mean / M_MOF) * 1000
        lb_uptake = (gm_Ngas_mean / M_MOF) * 1000

    gm_uptakes.append(gm_uptake)
    lb_uptakes.append(lb_uptake)

plt.plot(press, gm_uptakes, marker="o", color="red", linestyle='-', label="Geometric")
plt.plot(press, lb_uptakes, marker="o", color="blue", linestyle='-', label="Arithmetic")

# Plot
plt.xlim(left=0.0, right=7.1)
plt.ylim(bottom=0.0, top=16.0)
plt.xlabel("Pressure [bar]")
plt.ylabel(r"$\mathrm{CO_2}$ uptake [mmol/g]")
plt.gca().xaxis.set_major_locator(ticker.MultipleLocator(1))
plt.grid(False)
plt.legend(loc='lower right', frameon=False, markerscale=1.0)

plt.savefig(figpath, dpi=600, bbox_inches='tight')

plt.show()