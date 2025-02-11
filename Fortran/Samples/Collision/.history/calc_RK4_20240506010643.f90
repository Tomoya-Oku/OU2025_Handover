subroutine

subroutine calc_acceleration(position,velocity,acceleration)
! Routine drives calculation of all different acceleration terms
    use nbodydata,only: N
    implicit none
    real,dimension(3,N), intent(in) :: position,velocity
    real,dimension(3,N), intent(out) :: acceleration
    
    acceleration(:,:) = 0.0
    
    call calc_drag_terms(position,velocity,acceleration)
end subroutine calc_acceleration

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

    ! Begin calculating k-coefficients (for velocity and position)
    ! First k-coeff for velocity = acceleration
    call calc_acceleration(position,velocity,k1vel)

    ! First k-coeff for position = velocity
    k1pos(:,:) = velocity(:,:)

    ! Second k-coeff for velocity = acceleration at r=pos + 0.5*dt*k1pos
    nextpos = position(:,:) + 0.5*dt*k1pos(:,:)
    nextvel = velocity(:,:) + 0.5*dt*k1vel(:,:)

    call calc_acceleration(nextpos,nextvel,k2vel)

    ! Second k-coeff for position = vvelocity + 0.5*k1vel
    k2pos(:,:) = velocity(:,:) + 0.5*dt*k1vel(:,:)

    ! Third velocity k-coeff
    nextpos = position(:,:) + 0.5*dt*k2pos(:,:)
    nextvel = velocity(:,:) + 0.5*dt*k2vel(:,:)
    call calc_acceleration(nextpos,nextvel,k3vel)

    ! Third position k-coeff
    k3pos(:,:) = velocity(:,:) + 0.5*dt*k2vel(:,:)

    ! Fourth velocity k-coeff
    nextpos = position(:,:)+ dt*k3pos(:,:)
    nextvel = velocity(:,:) + dt*k3vel(:,:)
    call calc_acceleration(nextpos,nextvel,k4vel)

    ! Fourth position k-coeff
    k4pos(:,:) = velocity(:,:) + dt*k3vel(:,:)

    ! New position and velocity
    newposition(:,:) = position(:,:) + (dt/6.0)*(k1pos(:,:) + 2.0*k2pos(:,:) + 2.0*k3pos(:,:) + k4pos(:,:))
    newvelocity(:,:) = velocity(:,:) + (dt/6.0)*(k1vel(:,:) + 2.0*k2vel(:,:) + 2.0*k3vel(:,:) + k4vel(:,:))

end subroutine calc_RK4