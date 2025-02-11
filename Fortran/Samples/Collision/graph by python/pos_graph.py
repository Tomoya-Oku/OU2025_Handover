import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import pandas as pd
import numpy as np

def main():
    input_pos = pd.read_table("posvel.dat",header=None, delim_whitespace=True)

    time = input_pos[input_pos.keys()[0]]
    posx = input_pos[input_pos.keys()[1]]
    posy = input_pos[input_pos.keys()[2]]
    posz = input_pos[input_pos.keys()[3]]
    velx = input_pos[input_pos.keys()[4]]
    vely = input_pos[input_pos.keys()[5]]
    velz = input_pos[input_pos.keys()[6]]

    plt.xlabel("Time[fs]")
    plt.ylabel("Position")
    plt.xlim(0, len(time))
    #plt.ylim(-1e-18, 3e-18)
    plt.gca().yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
    
    plt.grid(linestyle="dotted")

    plt.plot(time, posx, label="posx", color="red")
    plt.plot(time, posy, label="posy", color="blue")
    plt.plot(time, posz, label="posz", color="green")
    # plt.plot(time, velx, label="velx", color="red", linestyle="dotted")
    # plt.plot(time, vely, label="vely", color="blue", linestyle="dotted")
    # plt.plot(time, velz, label="velz", color="green", linestyle="dotted")
    plt.legend()
    plt.show()

###################################################################################################

main()