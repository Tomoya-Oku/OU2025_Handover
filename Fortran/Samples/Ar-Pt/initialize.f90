subroutine initialize
    use variables
    use parameters
    use functions
    implicit none
    integer :: unit
    integer :: num = 1, i, j, k, kind
    double precision :: ran, r1, r2, cr = 1.00D-6
    double precision, dimension(3) :: init_xyz
    double precision, dimension(3) :: w

    ! メモリ動的割り当て
    allocate(pos(3, N_Max, 3))
    allocate(vel(3, N_Max, 3))
    allocate(acc(3, N_Max, 3))
    allocate(for(3, 3, N_Max, N_Max, 3))
    allocate(pot(3, N_Max))
    allocate(kin(3, N_Max))
    allocate(velene(3, N_Max, 3))
    allocate(velene_temp(3, N_Max, 3))

    ! 初期化
    pos(:, :, :) = 0.0D0
    vel(:, :, :) = 0.0D0
    acc(:, :, :) = 0.0D0
    for(:, :, :, :, :) = 0.0D0
    pot(:, :) = 0.0D0
    kin(:, :) = 0.0D0
    velene(:, :, :) = 0.0D0
    velene_temp(:, :, :) = 0.0D0
    F_D(:, :, :) = 0.0D0
    F_R(:, :, :) = 0.0D0
    heatflux_interface(:) = 0.0D0
    Q_interface(:) = 0.0D0
    heatflux_phantom(:) = 0.0D0
    Q_phantom(:) = 0.0D0

    ! ターミナルおよびcondition.datに条件を出力
    do unit = 6, 7
        write(unit, *) "Step"
        write(unit, *) " -TOTAL STEP:", TOTALSTEP
        write(unit, *) " -NVT STEP:", NVTSTEP
        write(unit, *) " -CALCULATION STEP:", CALCSTEP
        write(unit, *) " -dt:", DT

        write(unit, *) "System"
        write(unit, *) " -Size (x,y,z) [nm]:", SSIZE(x) / 10, SSIZE(y) / 10, SSIZE(z) / 10
        write(unit, *) " -Area of cross section [nm^2]:", A / 1.0D2
        write(unit, *) " -Volume (except walls) [nm^3]:", V / 1.0D3
        write(unit, *) " -The number of TOP Pt:", xyz(topPt, X), "x", xyz(topPt, Y), "x", xyz(topPt, Z), "=", N(topPt)
        write(unit, *) " -The number of BOTTOM Pt:", xyz(botPt, X), "x", xyz(botPt, Y), "x", xyz(botPt, Z), "=", N(botPt)
        write(unit, *) " -The number of Ar:", xyz(AR, X), "x", xyz(AR, Y), "x", xyz(AR, Z), "=", N(AR)

        write(unit, *) "L-J Potential"
        write(unit, *) " -ALPHA(Pt-Pt):", ALPHA(topPt, topPt)
        write(unit, *) " -ALPHA(Ar-Ar):", ALPHA(Ar, Ar)
        write(unit, *) " -ALPHA(Pt-Ar):", ALPHA(topPt, Ar)
        write(unit, *) " -SIGMA(Pt-Pt):", SIG(topPt, topPt)
        write(unit, *) " -EPSILON(Pt-Pt):", EPS(topPt, topPt)
        write(unit, *) " -SIGMA(Ar-Ar):", SIG(AR, AR)
        write(unit, *) " -EPSILON(Ar-Ar):", EPS(AR, AR)
        write(unit, *) " -SIGMA(Pt-Ar) based on LB:", SIG(topPt, AR)
        write(unit, *) " -EPSILON(Pt-Ar) based on LB:", EPS(topPt, AR)

        write(unit, *) "Velocity Scaling"
        write(unit, *) " -Aim temperature of Ar:", ATEMP_AR

        write(unit, *) "Langevin Thermostat"
        write(unit, *) " -Aim temperature of TOP Pt & BOTTOM Pt:", ATEMP(topPt), ATEMP(botPt)
        write(unit, *) " -Debye temperature:", DEBYE_TEMP
        write(unit, *) " -Debye frequency:", DEBYE_FREQUENCY
        write(unit, *) " -GAMMA(dumper coeffecient):", GAMMA
        write(unit, *) " -DAMPCOEF(TOP, BOTTOM):", DAMPCOEF(topPt), DAMPCOEF(botPt)
        write(unit, *) " -RANDCOEF(TOP, BOTTOM):", RANDCOEF(topPt), RANDCOEF(botPt)

        write(unit, *) "Properties of molecules"
        write(unit, *) " -MASS(Pt, Ar) [10^-25kg]:", MASS_Pt, MASS_Ar
        write(unit, *) " -STABLE DISTANCE(Pt, Ar) [nm]:", STDIST_Pt/10.0D0, STDIST_Ar/10.0D0

        write(unit, *) "Temperature distribution"
        write(unit, *) " -The number of layers:", PARTITION
        write(unit, *) " -Layer thickness:", LAYER_WIDTH
        write(unit, *) " -z_interface_top:", z_interface_top
        write(unit, *) " -z_interface_bot:", z_interface_bot

    end do

    close(DAT_COND)

    do i = 1, 3
        write(DAT_PERIODIC,*) SSIZE(i)
    end do
    
    ! 初期配置
    do kind = 1, 3 ! 分子の種類
        do k = 1, xyz(kind, Z) ! z
            init_xyz(Z) = OFST(kind, Z) + dble(k-1)*STDIST(kind)/2.0D0
            do i = 1, xyz(kind, X) ! x
                init_xyz(X) = OFST(kind, X) + dble(i-1)*STDIST(kind)/2.0D0
                do j = 1, xyz(kind, Y) ! y
                    ! iとkの偶奇が一致する
                    if(mod(k,2) == mod(i,2)) then
                        init_xyz(Y) = OFST(kind, Y) + dble(j-1)*STDIST(kind) + STDIST(kind)/2.0D0
                    else
                        init_xyz(Y) = OFST(kind, Y) + dble(j-1)*STDIST(kind)
                    end if
                    pos(kind, num, :) = init_xyz(:)
                    num = num + 1
                end do
            end do
        end do
        num = 1
    end do

    ! Arに初期速度を与える
    do i = 1, N(AR)
        read(DAT_RANDOM1, *) ran
        r1 = PI*ran
        read(DAT_RANDOM0, *) ran
        r2 = 2.000D0*PI*ran
        w(1) = dsin(r1)*dcos(r2)*cr
        w(2) = dsin(r1)*dsin(r2)*cr
        w(3) = dcos(r1)*cr
        vel(AR, i, :) = w(:)
    end do

    write(6,*) ""
    write(6,*) "Initializing has finished."

end subroutine initialize