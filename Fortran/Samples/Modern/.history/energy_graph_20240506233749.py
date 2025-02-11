import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import pandas as pd

def main():
###################################################################################################
    input_csv = pd.read_csv("energy.csv") #エラー処理

    x_data = input_csv[input_csv.keys()[0]]
    y_data1 = input_csv[input_csv.keys()[1]]
    y_data2 = input_csv[input_csv.keys()[2]]
    y_data3 = input_csv[input_csv.keys()[3]]

###################################################################################################

    plt.xlabel("Time[fs]")
    plt.ylabel("Energy[J]")

###################################################################################################

    plt.xlim(0, 40000)
    #plt.ylim(-1e-18, 3e-18)
    plt.gca().yaxis.set_major_formatter(ScalarFormatter(useMathText=True))

###################################################################################################

    plt.grid(linestyle="dotted")

###################################################################################################
    
    plt.plot(x_data, y_data1, label="Total Energy", color="red")
    plt.plot(x_data, y_data2, label="Potential Energy", color="blue")
    plt.plot(x_data, y_data3, label="Kinetic Energy", color="green")
    plt.legend()
    plt.show()

###################################################################################################

main()