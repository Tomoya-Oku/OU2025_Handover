subroutine correct_temp
    use variables, only: vel, zmass
    use parameters
    implicit none
    double precision :: temptp, vel2, aimtem, aimnot, baiss
    integer :: i

    temptp = 0.00D0
    do i = 1, nkoss
        vel2 = vel(i,1)*vel(i,1) + vel(i,2)*vel(i,2) + vel(i,3)*vel(i,3)
        temptp = temptp + vel2
    end do

    temptp = temptp / dble(nkoss) / 1.000D+16
    aimtem = atemp1
    aimnot = 3.00D0 * boltz * aimtem / zmass
    baiss = dsqrt(aimnot / temptp)

    do i = 1, nkoss
        vel(i, :) = vel(i, :) * baiss
    end do
end subroutine correct_temp