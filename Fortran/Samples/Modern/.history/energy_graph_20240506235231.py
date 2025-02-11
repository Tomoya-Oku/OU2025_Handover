import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import pandas as pd

def main():
    input_dat = pd.read_table("energy.dat",header=None, delim_whitespace=True)

    time = input_dat[input_dat.keys()[0]]
    tote = input_dat[input_dat.keys()[1]]
    pote = input_dat[input_dat.keys()[2]]
    kine = input_dat[input_dat.keys()[3]]

    print(tote)

    plt.xlabel("Time[fs]")
    plt.ylabel("Energy[J]")
    #plt.xlim(0, len(time)*100)
    #plt.ylim(-1e-18, 3e-18)
    plt.gca().yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
    
    plt.grid(linestyle="dotted")

    plt.plot(time, tote, label="Total Energy", color="red")
    plt.plot(time, pote, label="Potential Energy", color="blue")
    plt.plot(time, kine, label="Kinetic Energy", color="green")
    plt.legend()
    plt.show()

###################################################################################################

main()