program main
    use variables, only: nowstp
    use parameters
    implicit none
    integer :: i
    integer :: time_begin, time_end, count_per_sec
    double precision :: time

    ! 読み込み用乱数ファイル
    open(DAT_RANDOM1, file='Random/random1.dat')
    open(DAT_RANDOM0, file='Random/random0.dat')

    ! シミュレーション条件の出力
    open(DAT_COND, file='Data/condition.dat')

    ! 各分子の位置・速度・加速度データの出力
    open(DAT_POSIT, file='Data/posit.dat')
    open(DAT_POSL, file='Data/pos_lammps.dat')
    open(DAT_VELOCITY, file='Data/velocity.dat')
    open(DAT_VELENE, file='Data/velene.dat')
    open(DAT_ACCELERATION, file='Data/acceleration.dat')

    ! 力
    open(DAT_FORCE, file='Data/force.dat')

    ! Langevin法におけるダンパ力・ランダム力
    open(DAT_DFORCE, file='Data/force_Dumper.dat')
    open(DAT_RFORCE, file='Data/force_Random.dat') 

    ! 系のエネルギーデータの出力
    open(DAT_ENERGY, file='Data/energy.dat')
    open(DAT_PT_ENERGY, file='Data/energy_Pt.dat')
    open(DAT_TOP_PT_ENERGY, file='Data/energy_topPt.dat')
    open(DAT_BOT_PT_ENERGY, file='Data/energy_botPt.dat')
    open(DAT_AR_ENERGY, file='Data/energy_Ar.dat')

    ! 系の周期長さの出力
    open(DAT_PERIODIC, file='Data/periodic.dat')

    ! 系の温度
    open(DAT_TEMP, file='Data/temperature.dat')
    ! 界面温度
    ! open(DAT_TEMP_INTERFACE, file='Data/temp_interface.dat')
    ! Phantom層温度
    ! open(DAT_TEMP_PHANTOM, file='Data/temp_phantom.dat')

    ! 温度分布
    open(DAT_TEMP_DISTRIBUTION, file='Data/temp_distribution.dat')

    ! 熱流束
    open(DAT_HEATFLUX, file='Data/heatflux.dat')
    open(DAT_Q, file='Data/Q.dat')

    ! 圧力
    open(DAT_PRESSURE, file='Data/pressure.dat')

    ! ログ
    open(DAT_LOG, file='Data/log.dat')
    
    ! Step = 0
    call initialize ! 各分子の初期位置・速度などの設定
    call boundary ! 境界条件
    call velocity_scaling ! 速度スケーリング法
    call record_posvel ! 初期位置・速度の記録
    call record_lammps ! LAMMPS用初期配置の記録
    call record_energy ! 初期エネルギーの記録
    call record_temp ! 温度の記録

    call system_clock(time_begin, count_per_sec)

    do i = 1, TOTALSTEP
        nowstp = i

        ! ステップ数が1000の倍数のとき
        if (mod(nowstp, 1000) == 0) then
            call system_clock(time_end)
            time = real(time_end - time_begin) / count_per_sec
            write(6,*) nowstp, "/", TOTALSTEP, "(", time, "s)" ! ターミナルに進捗を出力
        end if
    
        call integral ! 各分子に働く力，速度，位置の分子動力学計算
        call boundary ! 境界条件

        ! ステップ数が100の倍数のとき
        if (mod(nowstp, 100) == 0) then
            ! NVT
            if (nowstp <= NVTSTEP) then
                call velocity_scaling ! 速度スケーリング法
            end if
        end if

        ! ステップ数が1000の倍数のとき
        if (mod(nowstp, 1000) == 0) then
            call calc_kinetic ! 運動エネルギー計算
            call calc_energy ! エネルギー計算
            call calc_temp ! 温度計算
        end if

        ! 本計算
        if (nowstp >= CALCSTEP) then
            call calc_heatflux

            ! ステップ数が100の倍数のとき
            if (mod(nowstp, 100) == 0) then
                call calc_tempDistribution
                call calc_pressure

                ! call record_heatflux ! 熱流束の記録
                call record_Q ! 熱輸送量の記録
                call record_tempDistribution ! 温度分布の記録
                call record_pressure ! 圧力の記録
            end if
        end if

        ! ステップ数が100の倍数のとき
        if (mod(nowstp, 100) == 0) then
            call record_posvel ! 位置・速度の記録
            !call record_force ! 力の記録
            !call record_langevin_force ! Langevin法におけるダンパ力・ランダム力の記録
        end if

        ! ステップ数が1000の倍数のとき
        if (mod(nowstp, 1000) == 0) then
            call record_energy ! エネルギーの記録
            call record_temp ! 温度の記録
        end if
    end do

    call record_finposvel

end program main