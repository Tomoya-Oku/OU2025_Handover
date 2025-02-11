subroutine calc_ac(posx, posy, posz, velx, vely, velz)


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
    do i=1, nkoss
      forx(i) = 0.0000D0
      fory(i) = 0.0000D0
      forz(i) = 0.0000D0
      poten(i) = 0.0000D0
      ukine(i) = 0.0000D0
    end do

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

    real, dimension(4,2,3) :: k

    ! RK4 Method
    do i = 1, nkoss
        k(1,1,1) = calc_ac(posx(i), velx(i)) * dt ! k_1u
        k(1,1,2) = calc_ac(posy(i), vely(i)) * dt ! k_1v
        k(1,1,3) = calc_ac(posz(i), velz(i)) * dt ! k_1w
        k(1,2,1) = velx(i) * dt ! k_1x
        k(1,2,2) = vely(i) * dt ! k_1y
        k(1,2,3) = velz(i) * dt ! k_1z

        k(2,1,1) = calc_ac(posx(i) + k(1,2,1)*0.5, velx(i) + k(1,1,1)*0.5) * dt ! k_2u
        k(2,1,2) = calc_ac(posy(i) + k(1,2,2)*0.5, vely(i) + k(1,1,2)*0.5) * dt ! k_2v
        k(2,1,3) = calc_ac(posz(i) + k(1,2,3)*0.5, velz(i) + k(1,1,3)*0.5) * dt ! k_2w
        k(2,2,1) = (velx(i) + k(1,1,1)*0.5) * dt ! k_2x
        k(2,2,2) = (vely(i) + k(1,1,2)*0.5) * dt ! k_2y
        k(2,2,3) = (velz(i) + k(1,1,3)*0.5) * dt ! k_2z


    end do


end subroutine calc_RK4