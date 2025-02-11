import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

n = 5000 # used to obtain mean value 

press = ["5.0", "10.0", "15.0"]
mu = ["-50.0", "-10.0", "10.0", "50.0"]

Ngases = []
means = []
for f in mu:
    for p in press:
        path = f"E:\\LAMMPS\\GCMC\\EPM2F\\T=298K\\P={p}bar_mu={f}\\data\\Ngas.dat"

        data = pd.read_csv(path, delim_whitespace=True, skiprows=2, header=None)

        step = data[0]
        Ngas = data[1]
        Ngases.append(Ngas)

        mean = np.mean(Ngas[-n:])
        means.append(mean)

# グラフの設定
fig, axes = plt.subplots(4, 3, figsize=(12, 9), sharey=True)

# 各サブプロットにデータを描画
for i, ax in enumerate(axes.flat):
    ax.plot(step, Ngases[i], color="black")
    ax.axhline(y=means[i], color='red', linestyle='-', linewidth=1, label='Mean (from 5,000 to 10,000 step)')

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
    ax.set_ylim(0, 200)

    ax.set_title(f'P={press} bar, mu={mu}, mean={round(means[i], 1)}', fontsize=12)  # 各サブプロットにタイトルを追加
    ax.grid(True, linestyle='--', linewidth=0.5) # グリッドを追加
    ax.tick_params(axis='x', which='both', bottom=True, top=False)
    ax.tick_params(axis='y', which='both', left=False, right=False)

# 共通のラベル
fig.supxlabel('Step', fontsize=16)
fig.supylabel(r'Number of $\mathrm{CO_2}$ molecules', fontsize=16)

# 凡例
legend = fig.legend(
    ["Mean (from 5,000 to 10,000 step)"],  # 凡例のラベル
    loc='lower right',                   # 配置（図の中央下部）
    ncol=1,                               # 列数
    fontsize=10,                          # フォントサイズ
    bbox_to_anchor=(0.925, 0.045)            # 凡例の位置調整（図の外側下部）
)

# レイアウトの調整
fig.tight_layout(rect=[0.05, 0.05, 0.95, 0.95])  # ラベルとグラフが被らないように調整

# グラフを表示
plt.show()
