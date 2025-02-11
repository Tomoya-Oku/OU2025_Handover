import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import pandas as pd

def main():
    input_dat = pd.read_table("energy.dat",header=None, delim_whitespace=True)

    x_data = input_dat[input_dat.keys()[0]]
    y_data1 = input_dat[input_dat.keys()[1]]
    y_data2 = input_dat[input_dat.keys()[2]]
    y_data3 = input_dat[input_dat.keys()[3]]

    plt.xlabel("Time[fs]")
    plt.ylabel("Energy[J]")
    plt.xlim(0, len(x_data) / 100)
    #plt.ylim(-1e-18, 3e-18)
    plt.gca().yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
    
    plt.grid(linestyle="dotted")

    plt.plot(x_data, y_data1, label="Total Energy", color="red")
    plt.plot(x_data, y_data2, label="Potential Energy", color="blue")
    plt.plot(x_data, y_data3, label="Kinetic Energy", color="green")
    plt.legend()
    plt.show()

###################################################################################################

main()