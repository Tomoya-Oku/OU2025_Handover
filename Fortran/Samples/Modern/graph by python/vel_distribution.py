import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter

#おぬしの設定によって書き換えるのじゃ！############################################################
N = 700 # グラフの分割数
nkoss = 128 # 分子数
T = 300 # 温度[K]
boundary_step = 10000 #温度補正を止めたステップ数
xlim = 800 # x軸の最大値
ylim = 0.005 # y軸の最大値
###################################################################################################

def Maxwell_distribution(velocity_array):
    p = []
    m = 1.428 * 10**-25 #分子の質量[kg]
    k = 1.3806662 * 10**-23 #Boltzmann定数[J/K]

    A = pow(m / (2*np.pi*k*T), 1.5) #係数

    for v in velocity_array:
        B = 4 * np.pi * v**2
        C = - (m * v**2) / (2 * k * T)
        p.append(A * B * np.exp(C))

    return p

def main():
    input_dat = pd.read_table("velocity.dat",header=None, delim_whitespace=True)

    start = int(nkoss*(boundary_step/100)-1)

    #datデータの読み込み
    v_x = input_dat[input_dat.keys()].iloc[start:,1].tolist()
    v_y = input_dat[input_dat.keys()].iloc[start:,2].tolist()
    v_z = input_dat[input_dat.keys()].iloc[start:,3].tolist()

    #実際の速さ(無次元化を解除，小数点以下6桁に丸める)
    v = []
    for i in range(len(v_x)):
        _v = pow((v_x[i]**2 + v_y[i]**2 + v_z[i]**2), 1/2) * (10**5)
        v.append(round(_v, 6))

    #確率分布の近似計算
    x_data = np.linspace(min(v), max(v), N+1)
    dx = (max(v) - min(v)) / N

    # print("min(v) = " + str(min(v)))
    # print("max(v) = " + str(max(v)))
    # print("dx= " + str(dx))

    data_length = len(x_data)

    y_data = []
    for i in range(len(x_data)):
        count = 0
        for j in range(len(v)):
            # x_dataの前後dx/2にある速度データvの個数を数える
            if (x_data[i] - (dx/2) <= v[j]) and (v[j] < x_data[i] + (dx/2)):
                count += 1
        print("Progress: " + "{:.1f}".format(i / data_length * 100) + "%")
        y_data.append(count / len(v))

###################################################################################################

    #Maxwell分布のプロットデータ
    x_Maxwell = np.linspace(0,xlim, N)
    y_Maxwell = Maxwell_distribution(x_Maxwell)

###################################################################################################

    #グラフの設定，表示
    plt.xlabel("Velocity[m/s]")
    plt.ylabel("Probability")

    plt.xlim(0, xlim)
    plt.ylim(0, ylim)

    plt.grid(linestyle="dotted")

    plt.plot(x_data, y_data, label="MD Simulation", color="black")
    plt.plot(x_Maxwell, y_Maxwell, label="Maxwell's Distribution", color="red")
    plt.legend()
    plt.show()

###################################################################################################

main()