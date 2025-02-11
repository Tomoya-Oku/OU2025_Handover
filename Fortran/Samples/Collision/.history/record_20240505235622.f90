subroutine record_posvel
    use variables, only: posx, posy, posz, velx, vely, velz
    use parameters
    implicit none
    integer :: i
    do i = 1, nkoss
        write(3, '(I6, 3D15.7)') i, posx(i), posy(i), posz(i)
        write(4, '(I6, 3D15.7)') i, velx(i), vely(i), velz(i)
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

    ! エネルギーを大きな数で割る処理（正規化や単位変換のため）
    totpot = totpot / 1.00d16
    totkin = totkin / 1.00d16
    totene = totpot + totkin

    ! 温度計算
    temp = 2.0d0 * totkin / (3.0d0 * dble(nkoss) * boltz)

    write(7, '(4D15.7)') totene, totpot, totkin, temp
end subroutine record_energy

subroutine record_finposvel
    use variables, only: posx, posy, posz, velx, vely, velz
    use parameters
    implicit none
    integer :: i
    do i = 1, nkoss
        write(9, '(I6, 6D15.7)') i, posx(i), posy(i), posz(i), velx(i), vely(i), velz(i)
    end do
end subroutine record_finposvel