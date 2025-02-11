import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

T = 298
phi = 0.75
P = 7

cell_length = 26.343000411987305

path = f"E:/LAMMPS/GCMC_revised/T={T}K/phi={phi}/EPM2F_T={T}K_P={P}bar_revised/data/gcmc_modified.dat"

def count_co2_per_region(data_file, axis='x', n=20):
    # データファイルの読み込み
    columns = ['atom_id', 'mol_id', 'type_id', 'charge', 'x', 'y', 'z', 'p', 'q', 'r']
    data = pd.read_csv(data_file, delim_whitespace=True, names=columns)

    # CO₂分子のフィルタリング
    co2_data = data[(data['mol_id'] != 1) & (data['type_id'] == 8)]

    # 選択した軸に基づいて分割
    if axis not in ['x', 'y', 'z']:
        raise ValueError("Axis must be one of 'x', 'y', or 'z'")

    # 軸に基づいて座標を取得
    coordinates = co2_data[axis]

    # 各領域の幅
    delta_x = cell_length / n

    # 領域ごとにCO₂分子をカウント
    x = np.linspace(0, cell_length, n)
    print(x)

    count = []
    for c in coordinates:
        if x[n-1] <= c and c < x[n]:
            count.append()
    
    co2_counts, _ = np.histogram(coordinates, bins=x)

    # ヒートマップ作成用データ
    heatmap_data = co2_counts.reshape(1, -1)

    # ヒートマップの描画
    plt.figure(figsize=(8, 8))
    plt.imshow(heatmap_data, aspect='auto', cmap='hot', extent=[0, cell_length, 0, 1])
    plt.colorbar(label='Number of CO₂ molecules')
    plt.title(f'CO₂ Density Heatmap (Axis: {axis.upper()}, n={n})')
    plt.xlabel(f'{axis.upper()} Coordinate (Å)')
    plt.ylabel('Density')
    plt.show()

count_co2_per_region(path, axis='x', n=10)