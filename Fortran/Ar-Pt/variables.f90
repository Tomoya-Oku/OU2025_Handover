module variables
    use parameters
    implicit none

    integer :: nowstp = 0 ! 現在のステップ数

    ! 座標(種類，番号, 座標)
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    double precision, allocatable, dimension(:, :, :) :: pos
    
    ! 速度(種類，番号, 座標)
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    double precision, allocatable, dimension(:, :, :) :: vel

    ! 加速度(種類，番号, 座標)
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    double precision, allocatable, dimension(:, :, :) :: acc

    ! 力(種類，番号，座標)
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    ! e.g. for(U_PT, AR, i, j, :): i番目のU_PTがj番目のARから受ける力
    double precision, allocatable, dimension(:, :, :, :, :) :: for

    ! ポテンシャル(種類，番号)
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    double precision, allocatable, dimension(:, :) :: pot

    ! 運動エネルギー(種類，番号)
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    double precision, allocatable, dimension(:, :) :: kin

    ! 計測用速度
    ! 種類: 1: 上部Pt，2: 下部Pt，3: Ar
    double precision, allocatable, dimension(:, :, :) :: velene
    double precision, allocatable, dimension(:, :, :) :: velene_temp

    ! 界面粒子の運動エネルギー
    double precision :: kin_interface_sum(2, INTERFACE_LAYER)

    ! Phantom層粒子の運動エネルギー
    double precision :: kin_phantom_sum(2, PHANTOM_LAYER)

    ! 温度分布関連
    double precision :: kin_layer(PARTITION)
    double precision :: temp_layer(PARTITION)
    double precision :: sum_temp(PARTITION)
    double precision :: mean_temp(PARTITION)
    double precision :: z_mid(PARTITION) ! 層の代表z座標

    ! 分子の種類
    ! total_enegy, total_potential, total_kinetic
    double precision :: energy(4, 3)
    ! temperature
    double precision :: temp(3), temp_interface(2, INTERFACE_LAYER), temp_phantom(2, PHANTOM_LAYER)

    ! Langevin法
    ! ダンパ力，ランダム力 (x/y/z)
    double precision :: F_D(2, max(N(topPt), N(botPt)), 3), F_R(2, max(N(topPt), N(botPt)), 3) 

    ! 圧力
    double precision :: F_sum, pressure

    ! 熱流束関連
    double precision :: heatflux_interface(2)
    double precision :: Q_interface(2)
    double precision :: heatflux_phantom(2)
    double precision :: Q_phantom(2)

end module variables