subroutine correct_trspeed
    use variables
    use parameters
    implicit none
    double precision, dimension(3) :: trv
    integer :: i, j

    trv(:) = 0.0D0

    do i = 1, nkoss
        trvx = trvx + velx(i)
        trvy = trvy + vely(i)
        trvz = trvz + velz(i)
    end do

    trvx = trvx / nkoss
    trvy = trvy / nkoss
    trvz = trvz / nkoss

    do j = 1, nkoss
        velx(j) = velx(j) - trvx
        vely(j) = vely(j) - trvy
        velz(j) = velz(j) - trvz
    end do
end subroutine correct_trspeed