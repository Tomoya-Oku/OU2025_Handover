subroutine correct_temp
    use variables, only: velx, vely, velz, zmass
    use parameters
    implicit none
    double precision :: temptp, vel2, aimtem, aimnot, baiss
    integer :: i

    temptp = 0.0d0
    do i = 1, nkoss
        vel2 = velx(i)**2 + vely(i)**2 + velz(i)**2
        temptp = temptp + vel2
    end do

    temptp = temptp / nkoss / 1.000d+16
    aimtem = atemp1
    aimnot = 3.0d0 * boltz * aimtem / zmass
    baiss = dsqrt(aimnot / temptp)

    do i = 1, nkoss
        velx(i) = velx(i) * baiss
        vely(i) = vely(i) * baiss
        velz(i) = velz(i) * baiss
    end do
end subroutine correct_temp