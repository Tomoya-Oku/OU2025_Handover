import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import pandas as pd
import numpy as np

def main():
    input_pos_LF = pd.read_table("pos_LF.dat",header=None, delim_whitespace=True)
    input_pos_VV = pd.read_table("pos_VV.dat",header=None, delim_whitespace=True)
    input_pos_RK = pd.read_table("pos_RK.dat",header=None, delim_whitespace=True)

    time = input_pos_LF[input_pos_LF.keys()[0]]
    posx_LF = input_pos_LF[input_pos_LF.keys()[1]]
    posy_LF = input_pos_LF[input_pos_LF.keys()[2]]
    posz_LF = input_pos_LF[input_pos_LF.keys()[3]]
    posx_VV = input_pos_VV[input_pos_VV.keys()[1]]
    posy_VV = input_pos_VV[input_pos_VV.keys()[2]]
    posz_VV = input_pos_VV[input_pos_VV.keys()[3]]
    posx_RK = input_pos_RK[input_pos_RK.keys()[1]]
    posy_RK = input_pos_RK[input_pos_RK.keys()[2]]
    posz_RK = input_pos_RK[input_pos_RK.keys()[3]]

    plt.xlabel("Time[fs]")
    plt.ylabel("Position")
    plt.xlim(0, len(time))
    #plt.ylim(-1e-18, 3e-18)
    plt.gca().yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
    
    plt.grid(linestyle="dotted")

    plt.plot(time, posx_LF, label="posx(RK4)", color="red")
    # plt.plot(time, posy_LFL, label="posy(RK4)", color="blue")
    # plt.plot(time, posz_LFL, label="posz(RK4)", color="green")
    plt.plot(time, posx_VV, label="posx(VVL)", color="red", linestyle="dotted")
    # plt.plot(time, posy_VVL, label="posy(VVL)", color="blue", linestyle="dotted")
    # plt.plot(time, posz_VVL, label="posz(VVL)", color="green", linestyle="dotted")
    plt.plot(time, posx_RK, label="posx(LFL)", color="red", linestyle="dashed")
    # plt.plot(time, posy_RK4, label="posy(LFL)", color="blue", linestyle="dashed")
    # plt.plot(time, posz_RK4, label="posz(LFL)", color="green", linestyle="dashed")
    plt.legend()
    plt.show()

###################################################################################################

main()