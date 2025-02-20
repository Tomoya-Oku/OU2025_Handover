subroutine cortra
    use variable, only: velx, vely, velz
    use parameters
    implicit none
    double precision :: trvx, trvy, trvz
    integer :: i, j

    trvx = 0.0d0
    trvy = 0.0d0
    trvz = 0.0d0

    do i = 1, nkoss
        trvx = trvx + velx(i)
        trvy = trvy + vely(i)
        trvz = trvz + velz(i)
    end do

    trvx = trvx / nkoss
    trvy = trvy / nkoss
    trvz = trvz / nkoss

    ! 速度ベクトルから平均を引いて中心補正
    do j = 1, nkoss
        velx(j) = velx(j) - trvx
        vely(j) = vely(j) - trvy
        velz(j) = velz(j) - trvz
    end do
end subroutine cortra