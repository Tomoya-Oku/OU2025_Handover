import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

press = ["5.0", "10.0", "15.0"]
mu = ["-50.0", "-10.0", "10.0", "50.0"]

trans_accs = []
ins_accs = []
del_accs = []

for f in mu:
    for p in press:
        path = f"E:\\LAMMPS\\P={p}bar_mu={f}\\data\\acceptance.dat"

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
fig, axes = plt.subplots(4, 3, figsize=(12, 9), sharey=True)

# 各サブプロットにデータを描画
for i, ax in enumerate(axes.flat):
    ax.plot(step, trans_accs[i], label='Translation', color="black")
    ax.plot(step, ins_accs[i], label="Insertion", color="blue")
    ax.plot(step, del_accs[i], label="Deletion", color="red")

    if i % 3 == 0:
        press = "5.0"
    elif i % 3 == 1:
        press = "10.0"
    elif i % 3 == 2:
        press = "15.0"

    if 0 <= i and i <= 2:
        mu = "-50.0"
    elif 3 <= i and i <= 5:
        mu = "-10.0"
    elif 6 <= i and i <= 8:
        mu = "10.0"
    elif 9 <= i and i <= 11:
        mu = "50.0"

    ax.set_xlim(0, max(step))
    ax.set_ylim(0, 0.15)

    ax.set_title(f'P={press} bar, mu={mu}', fontsize=12)  # 各サブプロットにタイトルを追加
    ax.grid(True, linestyle='--', linewidth=0.5) # グリッドを追加
    ax.tick_params(axis='x', which='both', bottom=True, top=False)
    ax.tick_params(axis='y', which='both', left=False, right=False)

# 共通のラベル
fig.supxlabel('Step', fontsize=16)
fig.supylabel('Acceptance', fontsize=16)

# 凡例
fig.legend(
    ["Translation", "Insertion", "Deletion"],  # 凡例のラベル
    loc='lower right',                   # 配置（図の中央下部）
    ncol=3,                               # 列数
    fontsize=10,                          # フォントサイズ
    bbox_to_anchor=(0.925, 0.045)            # 凡例の位置調整（図の外側下部）
)

# レイアウトの調整
fig.tight_layout(rect=[0.05, 0.05, 0.95, 0.95])  # ラベルとグラフが被らないように調整

# グラフを表示
plt.show()
