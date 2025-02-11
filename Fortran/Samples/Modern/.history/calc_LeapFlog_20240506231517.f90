subroutine calc_LeapFlog
    use variables
    use parameters
    implicit none
    integer :: i, i1, i2
    double precision :: divx, divy, divz, dist
    double precision :: dit2, dit4, dit6, dit8, dit12, dit14
    double precision :: ppp, force, forcex, forcey, forcez
    double precision :: vxene, vyene, vzene, vene
    double precision, dimension(nkoss, 4, 3) :: k_pos
    double precision, dimension(nkoss, 4, 3) :: k_vel
    double precision :: acc(nkoss, 3) ! acceleration

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0
    ukine(:) = 0.0000D0

    call calc_potential !ポテンシャル計算

    ! 運動エネルギー計算
    do i=1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    do i=1, nkoss
        vel(i,:) = vel(i,:) + for(i,:)*dt
        pos(i,:) = pos(i,:) + vel(i,:)*dt
    end do

end subroutine calc_LeapFlog