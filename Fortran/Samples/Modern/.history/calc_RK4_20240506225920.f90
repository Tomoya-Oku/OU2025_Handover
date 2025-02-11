subroutine calc_ac(posx, posy, posz)
    new_acc = acc + vel
    return new_acc
end subroutine calc_ac

subroutine calc_RK4
    use variables
    use parameters
    implicit none
    integer :: i, i1, i2
    double precision :: divx, divy, divz, dist
    double precision :: dit2, dit4, dit6, dit8, dit12, dit14
    double precision :: ppp, force, forcex, forcey, forcez
    double precision :: vxene, vyene, vzene, vene

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0
    ukine(:) = 0.0000D0

    ! ポテンシャル計算
    call calc_potential

    ! 運動エネルギー計算
    do i=1, nkoss
        vxene = velx(i) + forx(i)*0.500D0*dt
        vyene = vely(i) + fory(i)*0.500D0*dt
        vzene = velz(i) + forz(i)*0.500D0*dt
        vene = vxene*vxene + vyene*vyene + vzene*vzene
        ukine(i) = 0.500D0*zmass*vene
    end do

    double precision, dimension(nkoss, 4, 3) :: k_pos
    double precision, dimension(nkoss, 4, 3) :: k_vel
    double precision :: acc(nkoss) ! acceleration

    do i = 1, nkoss
        accx(i) = forx(i)
        accy(i) = fory(i)
        accz(i) = forz(i)
    end do

    ! RK4 Method
    do i = 1, nkoss
        k_x(i, i) = posx(i) + velx(i) * dt
        k_y(1, i) = posy(i) + vely(i) * dt
        k_z(1, i) = posz(i) + velz(i) * dt
        k_u(1, i) = velx(i) + calc_ac(posx(i), posy(i), posz(i)) * dt
        k_v(1, i) = vely(i) + calc_ac(posx(i), posy(i), posz(i)) * dt
        k_w(1, i) = velz(i) + calc_ac(posx(i), posy(i), posz(i)) * dt

        k_x(2, i) = posx(i) + (velx(i) + k_u(1, i)) * 0.5 * dt
        k_y(2, i) = posy(i) + (vely(i) + k_v(1, i)) * 0.5 * dt
        k_z(2, i) = posz(i) + (velz(i) + k_w(1, i)) * 0.5 * dt
        k_u(2, i) = velx(i) + calc_ac(posx(i)+k_x(1, i), posy(i)+k_y(1, i), posz(i)+k_z(1, i)) * dt
        k_v(2, i) = vely(i) + calc_ac(posx(i), posy(i), posz(i)) * dt
        k_w(2, i) = velz(i) + calc_ac(posx(i), posy(i), posz(i)) * dt

        velx(i) = velx(i) + (1/6) * (k(1,1,1) + 2*k(2,1,1) + 2*k(3,1,1) + k(4,1,1)) ! renew u
        vely(i) = vely(i) + (1/6) * (k(1,1,2) + 2*k(2,1,2) + 2*k(3,1,2) + k(4,1,2)) ! renew v
        velz(i) = velz(i) + (1/6) * (k(1,1,3) + 2*k(2,1,3) + 2*k(3,1,3) + k(4,1,3)) ! renew w

        posx(i) = posx(i) + (1/6) * (k(1,2,1) + 2*k(2,2,1) + 2*k(3,2,1) + k(4,2,1)) ! renew x
        posy(i) = posy(i) + (1/6) * (k(1,2,2) + 2*k(2,2,2) + 2*k(3,2,2) + k(4,2,2)) ! renew y
        posz(i) = posz(i) + (1/6) * (k(1,2,3) + 2*k(2,2,3) + 2*k(3,2,3) + k(4,2,3)) ! renew z
    end do

end subroutine calc_RK4