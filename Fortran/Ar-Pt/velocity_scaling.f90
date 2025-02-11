subroutine velocity_scaling
    use variables
    use parameters
    implicit none
    double precision :: vel2_sum, vel2_mean, bias
    integer :: i

    vel2_sum = 0.00D0 ! すべての分子の速度の2乗和
    do i = 1, N(AR)
        vel2_sum = vel2_sum + sum(vel(AR, i, :)*vel(AR, i, :))
    end do
    
    vel2_mean = vel2_sum * N_Ar_inv * 1.000D-16 ! 速度2乗の平均・後のために有次元化
    bias = dsqrt(COEF_VS / vel2_mean)
    vel(AR, :, :) = vel(AR, :, :) * bias
    ! do i = 1, N(AR)
    !     vel(AR, i, :) = vel(AR, i, :) * bias
    ! end do

end subroutine velocity_scaling