subroutine calc_LeapFlog
    use variables
    use parameters
    implicit none
	integer :: i
	double precision :: vene
	double precision, dimension(3) :: venes

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0
    ukine(:) = 0.0000D0

    call calc_potential ! ポテンシャル計算

    ! 運動エネルギー計算
    do i = 1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    if (nowstp <= 500) then
        do i = 1, nkoss/2
            vel(i,1) = vel(i,1) + for(i,1)*dt
            vel(i,2) = vel(i,2) + for(i,2)*dt
            vel(i,3) = vel(i,3) + (for(i,3)-g)*dt
            pos(i,:) = pos(i,:) + vel(i,:)*dt
        end do

        do i = nkoss/2+1, nkoss
            vel(i,1) = vel(i,1) + for(i,1)*dt
            vel(i,2) = vel(i,2) + for(i,2)*dt
            vel(i,3) = vel(i,3) + (for(i,3)+g)*dt
            pos(i,:) = pos(i,:) + vel(i,:)*dt
        end do
    else
        do i = 1, nkoss
            vel(i,:) = vel(i,:) + for(i,:)*dt
            pos(i,:) = pos(i,:) + vel(i,:)*dt
        end do
    end if
end subroutine calc_LeapFlog