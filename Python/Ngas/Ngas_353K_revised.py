import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

fig_path = f'E:/Graduation Thesis/Figures/Ngas_T=353K_revised.svg'

n = 5000 # used to obtain mean value 
T = 353
press = np.array([1, 2, 3, 4, 5, 6, 7])
fugacity_coeff = np.array(["1.25", "1.5", "1.75"])

Ngases = []
means = []
for f in fugacity_coeff:
    for p in press:
        path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={f}/EPM2F_T={T}K_P={p}bar_revised/data/Ngas.dat"
        data = pd.read_csv(path, delim_whitespace=True, skiprows=2, header=None)

        step = data[0]
        Ngas = data[1]
        Ngases.append(Ngas)

        mean = np.mean(Ngas[-n:])
        means.append(mean)

# Font
plt.rcParams['mathtext.fontset'] = 'cm' # math fontの設定
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

# グラフの設定
fig, axes = plt.subplots(3, 7, figsize=(12, 8), sharey=True)

# 各サブプロットにデータを描画
for i, ax in enumerate(axes.flat):
    ax.plot(step, Ngases[i], color="black")
    ax.axhline(y=means[i], color='red', linestyle='-', linewidth=2)

    p = press[i % 7]

    if 0 <= i and i <= 6:
        fugacity = "1.25"
    elif 7 <= i and i <= 13:
        fugacity = "1.5"
    elif 14 <= i and i <= 20:
        fugacity = "1.75"

    ax.set_title(rf'$P={p}\,\mathrm{{bar}},\ \phi={fugacity}$', fontsize=11, pad=12)  # 各サブプロットにタイトルを追加

    ax.set_xlim(0, max(step))
    ax.set_ylim(0, 200)

    ax.xaxis.set_major_locator(ticker.MultipleLocator(2500))
    ax.yaxis.set_major_locator(ticker.MultipleLocator(50))

    ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=12)
    ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=12)

    ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
    ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))

    ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False)
    ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)

# 共通のラベル
fig.supxlabel('Step', fontsize=15)
fig.supylabel(r'The number of $\mathrm{CO_2}$ molecules', fontsize=15)

plt.subplots_adjust(hspace=0.5, wspace=0.5)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

# グラフを表示
plt.show()
