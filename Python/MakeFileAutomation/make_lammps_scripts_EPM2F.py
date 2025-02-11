import re
import os
import numpy as np

temperature = np.array([273])
phi = np.array([0.55, 0.6, 0.65])
pressure = np.array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0])

os.chdir('E:/')
path = os.getcwd()
print(path)

input_path = "E:/Python/MakeFileAutomation/original_gcmc.lammps"

def replace_lammps_script(input_file, output_file, replacements):
    try:
        # 元ファイルを読み込み
        with open(input_file, 'r', encoding='utf-8') as file:
            content = file.read()

        # 指定された置換を実行
        for old, new in replacements.items():
            content = re.sub(old, new, content)

        # 結果を新しいファイルに書き出し
        with open(output_file, 'w', encoding='utf-8') as file:
            file.write(content)

        print(f"'{output_file}' に置換されたスクリプトが保存されました。")

    except FileNotFoundError:
        print(f"エラー: ファイル '{input_file}' が見つかりません。")
    except Exception as e:
        print(f"エラーが発生しました: {e}")

for t in temperature:
    for f in phi:
            output_dir = f"E:\\LAMMPS\\GCMC_revised\\T={t}K\\phi={f}"
            os.makedirs(output_dir, exist_ok=True)
            for p in pressure:
                output_file = f"T={t}K_phi={f}_P={p}bar.lammps"
                output = os.path.join(output_dir, output_file)

                # 置換内容の指定
                replacements = {
                    r"variable T equal -?\d+(\.\d+)?": f"variable T equal {t}",  # 温度の変更
                    r"variable fugacity_coeff equal -?\d+(\.\d+)?": f"variable fugacity_coeff equal {f}",  # フガシティ係数の変更
                    r"variable pressure_bar equal -?\d+(\.\d+)?": f"variable pressure_bar equal {p}",  # 圧力の変更
                }

                # プログラムを実行
                replace_lammps_script(input_path, output, replacements)
        
