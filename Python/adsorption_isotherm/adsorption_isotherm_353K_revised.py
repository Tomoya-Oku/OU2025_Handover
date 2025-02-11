import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Parameter
n = 5000 # used to obtain mean value 
T = 353
press = np.array([0, 1, 2, 3, 4, 5, 6, 7])
fugacity_coeff = np.array(["1.25", "1.5", "1.75"])
fig_path = f'E:/Graduation Thesis/Figures/adsorption_isotherm_EPM2F_T={T}K_revised.svg'

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
exp_press_353K = np.array([
    0, 0.41666667, 0.97222222, 1.38888889, 1.94444444, 2.77777778, 3.61111111, 4.72222222,
    5.97222222, 7.77777778, 9.72222222, 11.80555556, 14.44444444
])

exp_uptake_mg_353K = np.array([
    0, 30.76923077, 61.53846154, 96.15384615, 134.61538462, 176.92307692, 219.23076923, 
    257.69230769, 292.30769231, 330.76923077, 369.23076923, 396.15384615, 423.07692308
])
exp_uptake_mmol_353K = exp_uptake_mg_353K / 44.0

# 吸着量[mmol/g]を計算
def calc_uptake(phi):
    Ngases = []
    uptakes = []
    for p in press:
        if p == 0:
            uptake = 0
        else:
            path = f"E:\\LAMMPS\\GCMC_revised\\EPM2F\\T={T}K\\phi={phi}\\EPM2F_T={T}K_P={p}bar_revised\\data\\Ngas.dat"
            data = pd.read_csv(path, delim_whitespace=True, skiprows=2, header=None)

            Ngas = data[1]
            Ngases.append(Ngas)

            Ngas_mean = np.mean(Ngas[-n:])
            uptake = (Ngas_mean / M_MOF) * 1000
        
        uptakes.append(uptake)

    return uptakes

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
plt.plot(exp_press_353K, exp_uptake_mmol_353K, marker='.', linestyle='-', color='black', label="Experiment")

for phi in fugacity_coeff:
    uptake = calc_uptake(phi)
    if phi == "1.25":
        marker = 'o'
        color = 'red'
    elif phi == "1.5":
        marker = '^'
        color = 'blue'
    elif phi == "1.75":
        marker = 's'
        color = 'green'

    plt.plot(press, uptake, marker=marker, color=color, linestyle='-', label=rf"$\phi = {phi}$")

# Plot
plt.xlim(left=0.0, right=7.1)
plt.ylim(bottom=0.0, top=8.0)
plt.xlabel("Pressure [bar]")
plt.ylabel(r"$\mathrm{CO_2}$ uptake [mmol/g]")
plt.gca().xaxis.set_major_locator(ticker.MultipleLocator(1))
plt.grid(False)
plt.legend(loc='lower right', frameon=False, markerscale=1.0)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

plt.show()