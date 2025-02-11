import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from matplotlib.ticker import MultipleLocator

press = [1,2,3,4,5,6,7]

for i in range(7):
    path = f"E:\\LAMMPS\\GCMC\\Legacy\\p={press[i]}bar_f=0.75_mu=0\\data\\energy_gas.dat"
    data = pd.read_csv(path, delim_whitespace=True, skiprows=2, header=None)
    step = data[0]
    pote = data[2]
    mean = np.mean(pote)

    print(f"mean(P={press[i]}bar): {mean}")
