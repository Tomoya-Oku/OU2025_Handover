import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv("E:\\LAMMPS\\P=3.0bar_fugacity=0.90\\data\\acceptance.dat", delim_whitespace=True, skiprows=2, header=None)

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
    if s > 0:
        trans_acc.append((trans_ok[s]-trans_ok[s-1]) / (trans_attempt[s]-trans_attempt[s-1]))
        ins_acc.append((ins_ok[s]-ins_ok[s-1]) / (ins_attempt[s]-ins_attempt[s-1]))
        del_acc.append((del_ok[s]-del_ok[s-1]) / (del_attempt[s]-del_attempt[s-1]))
    else:
        trans_acc.append(0.0)
        ins_acc.append(0.0)
        del_acc.append(0.0)

plt.figure(figsize=(8,6))
plt.rcParams["font.size"] = 18

plt.plot(step, trans_acc, color="black", linewidth=1.5, label="Translation", )
plt.plot(step, ins_acc, color="blue", linewidth=1.5, label="Insertion")
plt.plot(step, del_acc, color="red", linewidth=1.5, label="Deletion")

# グラフの設定
plt.xlim(0, max(step))
plt.ylim(0, 0.15)
plt.xlabel("Step")
plt.ylabel("Acceptance")
plt.grid(True)
plt.legend()

# グラフを表示
plt.show()
