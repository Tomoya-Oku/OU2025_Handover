subroutine calc_posvel
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

    call calc_potential !ポテンシャル計算

    do i=1, nkoss
        vxene = velx(i) + forx(i)*0.500D0*dt
        vyene = vely(i) + fory(i)*0.500D0*dt
        vzene = velz(i) + forz(i)*0.500D0*dt
        vene = vxene*vxene + vyene*vyene + vzene*vzene
        ukine(i) = 0.500D0*zmass*vene
    end do

    do i=1, nkoss
        velx(i) = velx(i) + forx(i)*dt
        vely(i) = vely(i) + fory(i)*dt
        velz(i) = velz(i) + forz(i)*dt
        posx(i) = posx(i) + velx(i)*dt
        posy(i) = posy(i) + vely(i)*dt
        posz(i) = posz(i) + velz(i)*dt
    end do

end subroutine calc_posvel