import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

fig_path = f'E:/Graduation Thesis/Figures/acc_T=298K_revised.svg'

n = 5000 # used to obtain mean value 
T = 298
press = np.array([1, 2, 3, 4, 5, 6, 7])
fugacity_coeff = np.array(["0.5", "0.75", "1.0"])

trans_accs = []
ins_accs = []
del_accs = []
for f in fugacity_coeff:
    for p in press:
        path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={f}/EPM2F_T={T}K_P={p}bar_revised/data/acceptance.dat"
        data = pd.read_csv(path, delim_whitespace=True, skiprows=2, header=None)

        step = data[0]
        trans_ok = data[1]
        trans_attempt = data[2]
        ins_ok = data[3]
        ins_attempt = data[4]
        del_ok = data[5]
        del_attempt = data[6]

        trans_acc = []
        ins_acc = []
        del_acc = []
        for s in range(len(step)):
            if trans_attempt[s] != 0:
                trans_acc.append(trans_ok[s] / trans_attempt[s])
            else:
                trans_acc.append(0.0)

            if ins_attempt[s] != 0:
                ins_acc.append(ins_ok[s] / ins_attempt[s])
            else:
                ins_acc.append(0.0)

            if ins_attempt[s] != 0:
                del_acc.append(del_ok[s] / del_attempt[s])
            else:
                del_acc.append(0.0)

        trans_accs.append(trans_acc)
        ins_accs.append(ins_acc)
        del_accs.append(del_acc)

# Font
plt.rcParams['mathtext.fontset'] = 'cm' # math fontの設定
plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams["font.size"] = 15 # 全体のフォントサイズ

# グラフの設定
fig, axes = plt.subplots(3, 7, figsize=(12, 8), sharey=True)

# 各サブプロットにデータを描画
for i, ax in enumerate(axes.flat):
    trans = ax.plot(step, trans_accs[i], label='Translation', color="black")
    insertion = ax.plot(step, ins_accs[i], label="Insertion", color="blue")
    deletion = ax.plot(step, del_accs[i], label="Deletion", color="red", linestyle='dashed', linewidth=1.0)

    p = press[i % 7]

    if 0 <= i and i <= 6:
        fugacity = "0.50"
    elif 7 <= i and i <= 13:
        fugacity = "0.75"
    elif 14 <= i and i <= 20:
        fugacity = "1.0"

    ax.set_title(rf'$P={p}~\mathrm{{bar}},\ \phi={fugacity}$', fontsize=11, pad=12)  # 各サブプロットにタイトルを追加

    ax.set_xlim(0, max(step))
    ax.set_ylim(0, 0.20)

    ax.xaxis.set_major_locator(ticker.MultipleLocator(2500))
    #ax.yaxis.set_major_locator(ticker.MultipleLocator(0.2))

    ax.set_xticklabels(ax.get_xticks(), fontfamily='Times New Roman', fontsize=12)
    ax.set_yticklabels(ax.get_yticks(), fontfamily='Times New Roman', fontsize=12)

    ax.xaxis.set_major_formatter(ticker.FormatStrFormatter('%d'))
    ax.yaxis.set_major_formatter(ticker.FormatStrFormatter('%.2f'))

    ax.tick_params(axis='x', which='both', bottom=True, top=True, direction='in', labeltop=False)
    ax.tick_params(axis='y', which='both', left=True, right=True, direction='in', labeltop=False)

# 共通のラベル
fig.supxlabel('Step', fontsize=15)
fig.supylabel('Acceptance Rate', fontsize=15)

plt.subplots_adjust(hspace=0.5, wspace=0.5)

fig.legend(
    ["Translation", "Insertion", "Deletion"], 
    loc='lower center', 
    ncol=3,
    bbox_to_anchor=(0.5, 0.02),
    fontsize=14, 
    frameon=False, 
    markerscale=5.0
)

plt.savefig(fig_path, dpi=600, bbox_inches='tight')

# グラフを表示
plt.show()
