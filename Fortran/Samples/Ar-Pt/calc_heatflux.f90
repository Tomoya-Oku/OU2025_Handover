subroutine calc_heatflux
    use variables
    use parameters
    use functions
    implicit none

    integer :: i, j, kind
    double precision :: Fv(2), Fv_L(2)

    Fv(:) = 0.0D0
    Fv_L(:) = 0.0D0
    heatflux_interface(:) = 0.0D0
    heatflux_phantom(:) = 0.0D0

    ! 界面の式
    do j = 1, N(Ar)
        do kind = topPt, botPt
            do i = INTERFACE_START(kind), INTERFACE_END(kind)
                Fv(kind) = Fv(kind) + DOT_PRODUCT(for(kind, Ar, i, j, :), velene(kind, i, :))
            end do
        end do
    end do

    ! Langevin法による式
    do kind = topPt, botPt
        do i = PHANTOM_START(kind), PHANTOM_END(kind)
            Fv_L(kind) = Fv_L(kind) + DOT_PRODUCT(F_D(kind, i, :)+F_R(kind, i, :), velene(kind, i, :))
        end do
    end do

    ! interface
    heatflux_interface(:) = Fv(:) * A_inv
    Q_interface(:) = Q_interface(:) + heatflux_interface(:) * DT * 1.0D4 ! 有次元化[J/m^2]

    ! phantom
    heatflux_phantom(:) = Fv_L(:) * A_inv
    Q_phantom(:) = Q_phantom(:) - heatflux_phantom(:) * DT  * 1.0D4 ! 有次元化[J/m^2]

end subroutine calc_heatflux