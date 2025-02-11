subroutine record_posvel
    use variables
    use parameters
    implicit none
    integer :: i
    do i = 1, nkoss
        write(3, '(I6, 3E15.7)') i, pos(i,1), pos(i,2), pos(i,3)
        write(4, '(I6, 3E15.7)') i, vel(i,1), vel(i,2), vel(i,3)
    end do
end subroutine record_posvel

subroutine record_energy
    use variables, only: poten, ukine
    use parameters
    implicit none
    double precision :: totene, totpot, totkin, temp
    integer :: i

    ! 初期化
    totene = 0.00D0
    totpot = 0.00D0
    totkin = 0.00D0

    ! エネルギーの合計計算
    do i = 1, nkoss
        totpot = totpot + poten(i)
        totkin = totkin + ukine(i)
    end do

    ! 無次元化
    totpot = totpot / 1.00d16
    totkin = totkin / 1.00d16
    totene = totpot + totkin

    ! 温度計算
    temp = 2.0d0 * totkin / (3.0d0 * dble(nkoss) * boltz)

    write(7, '(4E15.7)') totene, totpot, totkin, temp
end subroutine record_energy

subroutine record_finposvel
    use variables
    use parameters
    implicit none
    integer :: i

    do i = 1, nkoss
        write(9, '(I6, 6E15.7)') i, pos(i,1), pos(i,2), pos(i,3), vel(i,1), vel(i,2), vel(i,3)
    end do
end subroutine record_finposvel