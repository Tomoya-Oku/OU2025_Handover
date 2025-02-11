subroutine calc_ac(posx, posy, posz)
    new_acc = acc + vel
    return new_acc
end subroutine calc_ac

subroutine calc_RK4
    use variables
    use parameters
    implicit none
    integer :: i
    double precision :: vene
    double precision, dimension(nkoss, 4, 3) :: k_pos
    double precision, dimension(nkoss, 4, 3) :: k_vel
    double precision :: acc(nkoss, 3) ! acceleration

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0
    ukine(:) = 0.0000D0

    ! ポテンシャル計算
    call calc_potential

    ! 運動エネルギー計算
    do i=1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    ! 力を加速度に
    do i = 1, nkoss
        acc(i,:) = for(i,:)
    end do

    ! RK4 Method
    do i = 1, nkoss
        k_pos(i, 1, :) = pos(i, :) + vel(i, :)*dt
        k_vel(i, 1, :) = vel(i, :) + calc_ac(pos)*dt

        do j = 2,4
            k_pos(i, j, :) = pos(i, :) + (vel(i,:) + k_vel(i, j-1, :)) * 0.500D0 * dt
            k_vel(i, j, :) = vel(i, :) + calc_ac((pos + k_pos(i, j-1, :)) * 0.500D0) * dt
        end do

        pos(i,:) = (1/6) * (2*k_pos(i, 1, :) + k_pos(i, 2, :) + k_pos(i, 3, :) + 2*k_pos(i, 4, :))
        vel(i,:) = (1/6) * (2*k_vel(i, 1, :) + k_vel(i, 2, :) + k_vel(i, 3, :) + 2*k_vel(i, 4, :))
    end do

end subroutine calc_RK4