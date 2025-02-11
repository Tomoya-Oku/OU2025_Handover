! パラメータ（もともとparate.datにあったもの）
module parameters
    implicit none
    integer, parameter :: nkoss = 64 !全分子数
    double precision, parameter :: syul0(3) = [double precision :: 64.0D0, 64.0D0, 64.0D0]
    double precision, parameter :: bunsi3 = 86.000D-3 ! 分子の質量  kg/mol
    double precision, parameter :: sig33 = 5.949D0 !分子のLennard-Jonesパラメータσ(無次元)
    double precision, parameter :: eps33 = 5.5130D-5 !分子のLennard-Jonesパラメータε(無次元)
    double precision :: atemp1 = 200D0 !系内（目標）温度  K
    double precision, parameter :: cutoff33 = 3.000D0 !カットオフ長さ/σ
    integer, parameter :: maxstep = 20000 !最大ステップ数
    double precision, parameter :: avoga = 6.022D+23 !アボガドロ数
    double precision, parameter :: boltz = 1.3806662D-23 !ボルツマン定数
    double precision, parameter :: pi = 3.141592654D0 !円周率
    double precision, parameter :: dt = 2.50D0 !無次元時間ステップ(無次元，有次元の場合fs)
    integer, parameter :: trnum = 32 ! トラッキングする分子の番号
end module parameters