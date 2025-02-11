subroutine calc_temp
    use variables
    use parameters
    implicit none

    integer :: l

    temp(topPt:botPt) = 2.0D0 * energy(topPt:botPt, KINETIC) / (3.0D0 * N_LAYER*(xyz(topPt, Z)-1) * BOLTZMANN) ! 固定層を除いて計算
    temp(AR) = 2.0D0 * energy(AR, KINETIC) / (3.0D0 * N(AR) * BOLTZMANN)

    do l = 1, INTERFACE_LAYER
        temp_interface(:, l) = 2.0D0 * kin_interface_sum(:, l) / (3.0D0 * N_LAYER * BOLTZMANN)
    end do
    
    do l = 1, PHANTOM_LAYER
        temp_phantom(:, l) = 2.0D0 * kin_phantom_sum(:, l) / (3.0D0 * N_LAYER * BOLTZMANN)
    end do
    
end subroutine calc_temp

subroutine calc_tempDistribution
    use variables
    use parameters
    implicit none

    integer :: i, j
    integer :: count = 0 ! 指定層の中にある粒子数
    double precision :: z_min, z_max
    double precision :: vel2_sum = 0.0D0 ! 速度の2乗和

    do i = 1, PARTITION
        z_max = z_interface_bot + LAYER_WIDTH * i
        z_min = z_interface_bot + LAYER_WIDTH * (i-1)
        z_mid(i) = z_min + LAYER_WIDTH * 0.50D0 ! 層の代表z座標

        ! 指定層にある粒子について速度の2乗和を計算
        do j = 1, N(Ar)
            if ((z_min <= pos(Ar, j, Z)) .and. (pos(Ar, j, Z) < z_max)) then
                vel2_sum = vel2_sum + sum(velene(Ar, j, :)*velene(Ar, j, :))
                count = count + 1
            end if
        end do

        ! 指定層にある粒子について運動エネルギーを計算+有次元化
        kin_layer(i) = 0.500D0 * MASS(Ar) * vel2_sum * 1.00D-16

        ! 指定層にある粒子について温度を計算
        temp_layer(i) = 2.0D0 * kin_layer(i) / (3.0D0 * count * BOLTZMANN)

        count = 0
        vel2_sum = 0.0D0
    end do
end subroutine calc_tempDistribution