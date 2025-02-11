module parameters
    implicit none

    ! 分子グループ
    enum, bind(c)
        enumerator :: topPt = 1, botPt = 2, Ar = 3, all = 4
    end enum

    ! 座標
    enum, bind(c)
        enumerator :: x = 1, y = 2, z = 3
    end enum

    ! エネルギー種別
    enum, bind(c)
        enumerator :: TOTAL = 1, POTENTIAL = 2, KINETIC = 3
    end enum

    !! 無次元化について
    ! M[kg]: 10^-26 -> 1
    ! L [m]: 10^-10 -> 1
    ! T [s]: 10^-15 -> 1
    ! E [J]: 10^-16 -> 1
    ! => [N]: [kg]*[m/s^2] = 10^-26 * 10^-10 * 10^30 = 10^-6 -> 1
    ! => [Pa]: [N]/[m^2] = 10^-6 * 10^20 = 10^14 -> 1
    ! => [W]: [J]/[s] = 10^-16 * 10^15 = 10^-1 -> 1
    ! => [W/m^2]: [W]/[m^2] = 10^-1 * 10^20 = 10^19 -> 1
    ! => [J/m^2]: [J]/[m^2] = 10^-16 * 10^20 = 10^4 -> 1

    ! 不変定数(有次元)
    double precision, parameter :: AVOGADRO = 6.022D23 ! Avogadro数
    double precision, parameter :: BOLTZMANN = 1.380649D-23 ! Boltzmann定数[J/K]
    double precision, parameter :: PI = 3.141592654D0 ! 円周率
    double precision, parameter :: TAU = 2.0D0 * PI
    double precision, parameter :: DIRAC = 1.054571817D-34 ! Dirac定数[Js]
    !double precision, parameter :: GAS_CONSTANT = 8.31451 ! 一般気体定数[J/mol*K]

    ! 実験パラメータ
    ! 分子数(x, y, z)
    integer, parameter :: xyz_Pt(3) = [integer :: 16, 8, 4]
    integer, parameter :: xyz_Ar(3) = [integer :: 11, 5, 25]
    integer, parameter :: PHANTOM_LAYER = 2 ! Phantom層の数
    integer, parameter :: TOTALSTEP = 5.0D2 ! 最大ステップ数
    integer, parameter :: NVTSTEP = 0.05D4 ! 温度補正を止めるステップ
    integer, parameter :: CALCSTEP = 1.0D4 ! 本計算を開始するステップ
    integer, parameter :: PARTITION = 20 ! 温度分布分割数
    double precision, parameter :: HEIGHT = 80.0D0 ! 系のz方向長さ[Å]
    double precision, parameter :: CUTOFFperSIG = 3.30D0 ! カットオフ長さ/σ
    double precision, parameter :: DT = 1.00D0 ! 無次元時間ステップ(無次元)
    double precision, parameter :: ALPHA_PtAr = 0.05D0 ! Pt-Pt間相互作用強さ
    double precision, parameter :: ATEMP_AR = 105.0D0 ! Ar目標温度[K]
    double precision, parameter :: ATEMP(2) = [double precision :: 130.0D0, 80.0D0] ! 目標温度[K]

    ! 分子数行列
    integer, parameter :: xyz(3, 3) = reshape([ &
       xyz_Pt(x), xyz_Pt(x), xyz_Ar(x), &
       xyz_Pt(y), xyz_Pt(y), xyz_Ar(y), &
       xyz_Pt(z), xyz_Pt(z), xyz_Ar(z) &
    ], [3, 3])

    ! 分子数関連
    integer, parameter :: N_topPt = xyz_Pt(1) * xyz_Pt(2) * xyz_Pt(3) ! 上部Pt 分子数
    integer, parameter :: N_botPt = xyz_Pt(1) * xyz_Pt(2) * xyz_Pt(3) ! 下部Pt 分子数
    integer, parameter :: N_Ar = xyz_Ar(1) * xyz_Ar(2) * xyz_Ar(3) ! Ar分子数
    integer, parameter :: N_All = N_topPt + N_botPt + N_Ar ! すべての分子数
    integer, parameter :: N(4) = [N_topPt, N_botPt, N_Ar, N_All]
    integer, parameter :: N_Max = max(N_topPt, N_botPt, N_Ar)

    integer, parameter :: N_LAYER = xyz_Pt(1)*xyz_Pt(2) ! 一層あたりの分子数
    integer, parameter :: INTERFACE_LAYER = xyz_Pt(Z) - PHANTOM_LAYER - 1 ! 界面の層数

    integer, parameter :: INTERFACE_START(2) = [1, N_LAYER*(PHANTOM_LAYER+1)+1]
    integer, parameter :: INTERFACE_END(2) = [N_LAYER*INTERFACE_LAYER, N(botPt)]
    integer, parameter :: PHANTOM_START(2) = [N_LAYER*INTERFACE_LAYER+1, N_LAYER+1]
    integer, parameter :: PHANTOM_END(2) = [N_LAYER*(INTERFACE_LAYER+PHANTOM_LAYER), N_LAYER*(PHANTOM_LAYER+1)]
    integer, parameter :: FIXED_START(2) = [N_LAYER*(INTERFACE_LAYER+PHANTOM_LAYER)+1, 1]
    integer, parameter :: FIXED_END(2) = [N(topPt), N_LAYER]

    double precision, parameter :: CUTOFFperSIG2 = CUTOFFperSIG * CUTOFFperSIG

    ! 分子固有定数
    double precision, parameter :: MOLMASS_Pt = 195.084D-3 ! Ptのモル質量[kg/mol]
    double precision, parameter :: MOLMASS_Ar = 39.948D-3 ! Arのモル質量[kg/mol]
    double precision, parameter :: MASS_Pt = MOLMASS_Pt / AVOGADRO * 1.0D26 ! Pt分子の質量(無次元)
    double precision, parameter :: MASS_Ar = MOLMASS_Ar / AVOGADRO * 1.0D26 ! Ar分子の質量(無次元)
    double precision, parameter :: MASS(3) = [MASS_Pt, MASS_Pt, MASS_Ar]
    double precision, parameter :: MASS_inv(3) = [1.0D0/MASS_Pt, 1.0D0/MASS_Pt, 1.0D0/MASS_Ar]

    ! L-Jパラメータ (+Lorentz-Berthelot則)
    double precision, parameter :: ALPHA_PtPt = 1.0D0 ! Pt-Pt間相互作用強さ
    double precision, parameter :: ALPHA_ArAr = 1.0D0 ! Ar-Ar間相互作用強さ
    double precision, parameter :: ALPHA(3,3) = reshape([ &
    ALPHA_PtPt, ALPHA_PtPt, ALPHA_PtAr, &
    ALPHA_PtPt, ALPHA_PtPt, ALPHA_PtAr, &
    ALPHA_PtAr, ALPHA_PtAr, ALPHA_ArAr ], shape(ALPHA))
    double precision, parameter :: SIG_PtPt = 2.54D0  ! Pt-Pt間σ(無次元)
    double precision, parameter :: EPS_PtPt = 109.2D-5 ! Pt-Pt間ε(無次元)
    double precision, parameter :: SIG_ArAr = 3.405D0  ! Ar-Ar間σ(無次元)
    double precision, parameter :: EPS_ArAr = 1.65399D-5 ! Ar-Ar間ε(無次元)
    double precision, parameter :: SIG_PtAr = (SIG_PtPt + SIG_ArAr) / 2.0D0   ! Pt-Ar間σ(無次元)
    double precision, parameter :: EPS_PtAr = dsqrt(EPS_PtPt*EPS_ArAr) ! Pt-Ar間ε(無次元)
    double precision, parameter :: SIG(3,3) = reshape([ &
    SIG_PtPt, SIG_PtPt, SIG_PtAr, &
    SIG_PtPt, SIG_PtPt, SIG_PtAr, &
    SIG_PtAr, SIG_PtAr, SIG_ArAr ], shape(SIG))
    double precision, parameter :: SIG_inv(3,3) = reshape([ &
    1.0D0/SIG_PtPt, 1.0D0/SIG_PtPt, 1.0D0/SIG_PtAr, &
    1.0D0/SIG_PtPt, 1.0D0/SIG_PtPt, 1.0D0/SIG_PtAr, &
    1.0D0/SIG_PtAr, 1.0D0/SIG_PtAr, 1.0D0/SIG_ArAr ], shape(SIG_inv))
    double precision, parameter :: EPS(3,3) = reshape([ &
    EPS_PtPt, EPS_PtPt, EPS_PtAr, &
    EPS_PtPt, EPS_PtPt, EPS_PtAr, &
    EPS_PtAr, EPS_PtAr, EPS_ArAr ], shape(EPS))

    ! L-Jポテンシャルから力を計算するための係数
    double precision, parameter :: COEF_PtPt = 24.00D0 * ALPHA_PtPt * EPS_PtPt / SIG_PtPt
    double precision, parameter :: COEF_PtAr = 24.00D0 * ALPHA_PtAr * EPS_PtAr / SIG_PtAr
    double precision, parameter :: COEF_ArAr = 24.00D0 * ALPHA_ArAr * EPS_ArAr / SIG_ArAr
    double precision, parameter :: COEF(3,3) = reshape([ &
    COEF_PtPt, COEF_PtPt, COEF_PtAr, &
    COEF_PtPt, COEF_PtPt, COEF_PtAr, &
    COEF_PtAr, COEF_PtAr, COEF_ArAr ], shape(COEF))

    ! 分子間安定距離
    double precision, parameter :: STDIST_Pt = 3.9231D0
    double precision, parameter :: STDIST_Ar = 5.26D0
    double precision, parameter :: STDIST(3) = [STDIST_Pt, STDIST_Pt, STDIST_Ar]

    ! 系のスケール
    double precision, parameter :: SSIZE(3) = [xyz(topPt, X)*(STDIST_Pt/2), xyz(topPt, Y)*STDIST_Pt, height]
    !double precision, parameter :: SSIZE(3) = [12.0D0, 12.0D0, 40.0D0]
    double precision, parameter :: ofst_topPt_X = (SSIZE(X) - (STDIST_Pt/2) * (xyz(topPt, X) - 1)) / 2.0D0
    double precision, parameter :: ofst_topPt_Y = (SSIZE(Y) - STDIST_Pt * (xyz(topPt, Y) - 0.5D0)) / 2.0D0
    double precision, parameter :: ofst_topPt_Z = SSIZE(3) - (STDIST(topPt)/2) * (xyz(topPt, Z) - 1)
    double precision, parameter :: ofst_topPt(3) = [ofst_topPt_X, ofst_topPt_Y, ofst_topPt_Z]
    double precision, parameter :: ofst_botPt_X = (SSIZE(X) - (STDIST_Pt/2) * (xyz(botPt, X) - 1)) / 2.0D0
    double precision, parameter :: ofst_botPt_Y = (SSIZE(Y) - STDIST_Pt * (xyz(botPt, Y) - 0.5D0)) / 2.0D0
    double precision, parameter :: ofst_botPt_Z = 0.0D0
    double precision, parameter :: ofst_botPt(3) = [ofst_botPt_X, ofst_botPt_Y, ofst_botPt_Z]
    double precision, parameter :: ofst_Ar_X = (SSIZE(X) - (STDIST_Ar/2) * (xyz(AR, X) - 1.0D0)) / 2.0D0
    double precision, parameter :: ofst_Ar_Y = (SSIZE(Y) - STDIST_Ar * (xyz(AR, Y) - 0.5D0)) / 2.0D0
    double precision, parameter :: ofst_Ar_Z = (SSIZE(Z) - (STDIST_Ar/2) * (xyz(AR, Z) - 1.0D0)) / 2.0D0
    double precision, parameter :: ofst_Ar(3) = [ofst_Ar_X, ofst_Ar_Y, ofst_Ar_Z]
    double precision, parameter :: OFST(3,3) = reshape([ &
    ofst_topPt(1), ofst_botPt(1), ofst_Ar(1), &
    ofst_topPt(2), ofst_botPt(2), ofst_Ar(2), &
    ofst_topPt(3), ofst_botPt(3), ofst_Ar(3) ], shape(OFST))

    double precision, parameter :: halfDT = 0.50D0 * DT

    ! 断面積
    double precision, parameter :: A = SSIZE(X) * SSIZE(Y)
    double precision, parameter :: A_inv = 1 / A

    ! 体積
    double precision, parameter :: V = A * (SSIZE(Z) - 2 * STDIST_Pt) ! TODO

    ! 圧力関連
    !double precision, parameter :: COEF_IP = (N(AR) / AVOGADRO) * GAS_CONSTANT * 1.0D16 / V

    ! ポテンシャルのカットオフ長さx,y,z方向
    double precision, parameter :: CUTOFF_PtPt(3) = SSIZE(:) - CUTOFFperSIG * SIG_PtPt
    double precision, parameter :: CUTOFF_PtAr(3) = SSIZE(:) - CUTOFFperSIG * SIG_PtAr
    double precision, parameter :: CUTOFF_ArAr(3) = SSIZE(:) - CUTOFFperSIG * SIG_ArAr
    double precision, parameter :: CUTOFF(3, 3, 3) = reshape( &
    [ CUTOFF_PtPt(1), CUTOFF_PtPt(1), CUTOFF_PtAr(1), &
      CUTOFF_PtPt(1), CUTOFF_PtPt(1), CUTOFF_PtAr(1), &
      CUTOFF_PtAr(1), CUTOFF_PtAr(1), CUTOFF_ArAr(1), &
      CUTOFF_PtPt(2), CUTOFF_PtPt(2), CUTOFF_PtAr(2), &
      CUTOFF_PtPt(2), CUTOFF_PtPt(2), CUTOFF_PtAr(2), &
      CUTOFF_PtAr(2), CUTOFF_PtAr(2), CUTOFF_ArAr(2), &
      CUTOFF_PtPt(3), CUTOFF_PtPt(3), CUTOFF_PtAr(3), &
      CUTOFF_PtPt(3), CUTOFF_PtPt(3), CUTOFF_PtAr(3), &
      CUTOFF_PtAr(3), CUTOFF_PtAr(3), CUTOFF_ArAr(3) ], &
    shape = [3, 3, 3])

    ! 速度スケーリング
    double precision, parameter :: N_Ar_inv = 1.0D0 / N(Ar)
    double precision, parameter :: COEF_VS = 3.00D0 * BOLTZMANN * ATEMP_AR / MASS(AR)

    ! Langevin法パラメータ
    double precision, parameter :: DEBYE_TEMP = 240.0D0 ! Debye温度(Pt)
    double precision, parameter :: DEBYE_FREQUENCY = (BOLTZMANN * 1.0D16) * DEBYE_TEMP / (DIRAC * 1.0D31)
    double precision, parameter :: GAMMA = 6.0D0 / PI / DEBYE_FREQUENCY
    double precision, parameter :: DAMPCOEF(2) = [-MASS(topPt) / GAMMA, -MASS(botPt) / GAMMA]
    double precision, parameter :: RANDCOEF(2) = [dsqrt(2.0D0 * (BOLTZMANN * 1.0D16) * ATEMP(topPt) * MASS(topPt) / GAMMA / DT ),&
    dsqrt(2.0D0 * (BOLTZMANN * 1.0D16) * ATEMP(botPt) * MASS(botPt) / GAMMA / DT )]

    ! 熱流束関連
    double precision, parameter :: z_interface_top = OFST(topPt, Z)
    double precision, parameter :: z_interface_bot = dble(xyz(topPt, Z)-1)*STDIST(topPt)/2.0D0
    double precision, parameter :: LAYER_WIDTH = (z_interface_top - z_interface_bot) / PARTITION

    ! record用
    integer, parameter :: DAT_RANDOM1 = 1
    integer, parameter :: DAT_RANDOM0 = 2
    integer, parameter :: DAT_POSIT = 3
    integer, parameter :: DAT_VELOCITY = 4
    integer, parameter :: DAT_VELENE = 5
    integer, parameter :: DAT_DFORCE = 22
    integer, parameter :: DAT_RFORCE = 23
    integer, parameter :: DAT_TEMP = 8
    integer, parameter :: DAT_PERIODIC = 9
    integer, parameter :: DAT_POS = 10
    integer, parameter :: DAT_MASK = 11
    integer, parameter :: DAT_LOG = 12
    integer, parameter :: DAT_ACCELERATION = 13
    integer, parameter :: DAT_TEMP_INTERFACE = 14
    integer, parameter :: DAT_ENERGY = 15
    integer, parameter :: DAT_TEMP_PHANTOM = 16
    integer, parameter :: DAT_TEMP_DISTRIBUTION = 17
    integer, parameter :: DAT_HEATFLUX = 18
    integer, parameter :: DAT_PRESSURE = 19
    integer, parameter :: DAT_CONDUCTIVITY = 20
    integer, parameter :: DAT_RESISTANCE = 21
    integer, parameter :: DAT_COND = 7
    integer, parameter :: DAT_Q = 24
    integer, parameter :: DAT_FORCE = 25
    integer, parameter :: DAT_PT_ENERGY = 26
    integer, parameter :: DAT_AR_ENERGY = 27
    integer, parameter :: DAT_TOP_PT_ENERGY = 28
    integer, parameter :: DAT_BOT_PT_ENERGY = 29
    integer, parameter :: DAT_POSL = 30

end module parameters