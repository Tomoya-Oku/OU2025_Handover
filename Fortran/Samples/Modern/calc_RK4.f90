subroutine calc_RK4
    use variables
    use parameters
    implicit none
    integer :: i, j
    double precision :: vene
    double precision, dimension(3) :: venes
    double precision, dimension(nkoss, 4, 3) :: k_pos
    double precision, dimension(nkoss, 4, 3) :: k_vel
    double precision, dimension(nkoss, 3) :: pos_original
    double precision, dimension(nkoss) :: poten_original
    double precision, dimension(nkoss, 3) :: for_original

    ! 初期化
    ukine(:) = 0.0000D0

    ! ポテンシャル計算
    call calc_potential

    ! データのキープ
    poten_original(:) = poten(:)
    for_original(:,:) = for(:,:)
    pos_original(:,:) = pos(:,:)

    ! 運動エネルギー計算
    do i=1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    ! RK4 Method
    do i = 1, nkoss
        k_pos(i, 1, :) = vel(i, :)
        k_vel(i, 1, :) = for(i, :)
    end do

    do j = 2, 3
        ! 加速度算出用に(x(t)+x^(k))/2を作る
        do i = 1, nkoss
            pos(i,:) = pos_original(i,:) + k_pos(i, j-1, :) * 0.500D0 * dt
        end do

        call calc_potential
    
        do i = 1, nkoss
            k_pos(i, j, :) = vel(i,:) + k_vel(i,j-1,:) * 0.500D0 * dt
            k_vel(i, j, :) = for(i, :)
        end do
    end do

    ! j=4
    do i = 1, nkoss
        pos(i,:) = pos_original(i,:) + k_pos(i, 3, :) * dt
    end do

    call calc_potential

    do i = 1, nkoss
        k_pos(i, 4, :) = vel(i,:) + k_vel(i,3,:) * dt
        k_vel(i, 4, :) = for(i, :)
    end do

    ! Result
    do i = 1, nkoss
        pos(i,:) = pos_original(i,:) + (dt/6.0D0) * (k_pos(i, 1, :) + 2.0*k_pos(i, 2, :) + 2.0*k_pos(i, 3, :) + k_pos(i, 4, :))
        vel(i,:) = vel(i,:) + (dt/6.0D0) * (k_vel(i, 1, :) + 2.0*k_vel(i, 2, :) + 2.0*k_vel(i, 3, :) + k_vel(i, 4, :))
    end do

    ! ポテンシャルと力(加速度)を元の値に戻す
    poten(:) = poten_original(:)
    for(:,:) = for_original(:,:)

end subroutine calc_RK4