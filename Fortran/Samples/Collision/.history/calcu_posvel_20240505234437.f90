subroutine calc_posvel
    use variable
    use parameters
    implicit none
    integer :: i, i1, i2
    double precision :: divx, divy, divz, dist
    double precision :: dit2, dit4, dit6, dit8, dit12, dit14
    double precision :: ppp, force, forcex, forcey, forcez
    double precision :: vxene, vyene, vzene, vene
    double precision, dimension(nkoss) :: x_1, x_2, x_3, x_4
    double precision, dimension(nkoss) :: y_1, y_2, y_3, y_4
    double precision, dimension(nkoss) :: z_1, z_2, z_3, z_4
    double precision, dimension(nkoss) :: u_1, u_2, u_3, u_4
    double precision, dimension(nkoss) :: v_1, v_2, v_3, v_4
    double precision, dimension(nkoss) :: w_1, w_2, w_3, w_4

    ! 初期化
    do i=1, nkoss
      forx(i) = 0.0000D0
      fory(i) = 0.0000D0
      forz(i) = 0.0000D0
      poten(i) = 0.0000D0
      ukine(i) = 0.0000D0
    end do

    call calc_potential !ポテンシャル計算

    do i=1, nkoss
        vxene = velx(i) + forx(i)*0.500D0*dt
        vyene = vely(i) + fory(i)*0.500D0*dt
        vzene = velz(i) + forz(i)*0.500D0*dt
        vene = vxene*vxene + vyene*vyene + vzene*vzene
        ukine(i) = 0.500D0*zmass*vene
    end do

    ! Runge-Kutta
    do i = 1, nkoss
        k_1u(i) = forx(i)*dt
        k_1v(i) = fory(i)*dt
        k_1w(i) = forz(i)*dt
        k_1x(i) = velx(i)*dt
        k_1y(i) = vely(i)*dt
        k_1z(i) = velz(i)*dt
    end do

    call calc_potential !ポテンシャルを再計算

    ! Runge-Kutta
    do i = 1, nkoss
        k_2u(i) = forx(i)*dt
        k_2v(i) = fory(i)*dt
        k_2w(i) = forz(i)*dt
        k_2x(i) = (velx(i) + k_1u*0.5)*dt
        k_2y(i) = (vely(i) + k_1v*0.5)*dt
        k_2z(i) = (velz(i) + k_1w*0.5)*dt
    end do


end subroutine calc_posvel