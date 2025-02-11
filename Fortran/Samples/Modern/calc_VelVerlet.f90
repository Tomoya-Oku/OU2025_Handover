subroutine calc_VelVerlet
    use variables
    use parameters
    implicit none
	integer :: i
	double precision :: vene
	double precision, dimension(3) :: venes
    double precision, dimension(nkoss, 3) :: temp_vel
    double precision, dimension(nkoss) :: poten_original
    double precision, dimension(nkoss, 3) :: for_original

    ! 初期化
    ukine(:) = 0.0000D0

    call calc_potential ! ポテンシャル計算

    ! データのキープ
    poten_original(:) = poten(:)
    for_original(:,:) = for(:,:)

    ! 運動エネルギー計算
    do i = 1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    do i = 1, nkoss
        temp_vel(i,:) = vel(i,:) + 0.500D0*for(i,:)*dt
        pos(i,:) = pos(i,:) + temp_vel(i,:)*dt
    end do

    ! 再度ポテンシャル計算
    call calc_potential

    do i = 1, nkoss
        vel(i,:) = temp_vel(i,:) + 0.500D0*for(i,:)*dt
    end do

    ! ポテンシャルと力(加速度)を元の値に戻す
    poten(:) = poten_original(:)
    for(:,:) = for_original(:,:)

end subroutine calc_VelVerlet