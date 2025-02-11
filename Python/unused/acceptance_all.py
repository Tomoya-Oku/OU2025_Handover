import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

press = np.array([1, 3, 5, 7])
fugacity_coeff = np.array(["0.5", "0.75", "1"])

trans_accs = []
ins_accs = []
del_accs = []

for f in fugacity_coeff:
    for p in press:
        path = f"E:\\LAMMPS\\GCMC\\p={p}bar_f={f}_mu=0\\data\\acceptance.dat"

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

# グラフの設定
fig, axes = plt.subplots(3, 4, figsize=(8, 6), sharey=True)

# 各サブプロットにデータを描画
for i, ax in enumerate(axes.flat):
    ax.plot(step, trans_accs[i], label='Translation', color="black")
    ax.plot(step, ins_accs[i], label="Insertion", color="blue")
    ax.plot(step, del_accs[i], label="Deletion", color="red")

    p = press[i % 4]

    if 0 <= i and i <= 3:
        fugacity = "0.50"
    elif 4 <= i and i <= 7:
        fugacity = "0.75"
    elif 8 <= i and i <= 11:
        fugacity = "1.0"

    ax.set_xlim(0, max(step))
    ax.set_ylim(0, 0.15)

    ax.set_title(rf'$P={p}\,\mathrm{{bar}},\ \phi={fugacity}$', fontsize=10)  # 各サブプロットにタイトルを追加
    ax.xaxis.set_major_locator(ticker.MultipleLocator(1000))
    ax.grid(True, linestyle='--', linewidth=0.5) # グリッドを追加
    ax.tick_params(axis='x', which='both', bottom=True, top=False)
    ax.tick_params(axis='y', which='both', left=False, right=False)

# 共通のラベル
fig.supxlabel('Step', fontsize=16)
fig.supylabel('Acceptance Rate', fontsize=16)

# 凡例
fig.legend(
    ["Translation", "Insertion", "Deletion"],  # 凡例のラベル
    loc='lower right',                   # 配置（図の中央下部）
    ncol=3,                               # 列数
    fontsize=10,                          # フォントサイズ
    bbox_to_anchor=(0.945, 0.06)            # 凡例の位置調整（図の外側下部）
)

# レイアウトの調整
fig.tight_layout(rect=[0.05, 0.05, 0.95, 0.95])  # ラベルとグラフが被らないように調整

# グラフを表示
plt.show()
