subroutine integral
    use variables
    use parameters
    use functions
    implicit none
    double precision :: rand(4), w(3)
    integer :: kind, i

    call calc_potential ! ポテンシャル計算

    ! 更新
    do kind = 1, 3
        do i = 1, N(kind)
            if (isPhantom(kind, i)) then
                ! Box-Muller法
                call random_number(rand)
                w(X) = dsqrt(-2.0D0 * dlog(rand(1))) * dcos(TAU * rand(2))
                w(Y) = dsqrt(-2.0D0 * dlog(rand(2))) * dcos(TAU * rand(3))
                w(Z) = dsqrt(-2.0D0 * dlog(rand(3))) * dcos(TAU * rand(1))

                F_D(kind, i, :) = DAMPCOEF(kind) * vel(kind, i, :) ! 時刻tでのダンパ力
                F_R(kind, i, :) = RANDCOEF(kind) * w(:) ! 時刻tでのランダム力

                acc(kind, i, :) = acc(kind, i, :) + (F_D(kind, i, :) + F_R(kind, i, :)) * MASS_inv(kind) ! 時刻tでの加速度
            end if
                
            if (isNotFixed(kind, i)) then
                velene(kind, i, :) = vel(kind, i, :) + acc(kind, i, :) * halfDT ! v(t)
                vel(kind, i, :) = vel(kind, i, :) + acc(kind, i, :)*DT ! v(t+DT/2) = v(t-DT/2) + a(t)DT
                pos(kind, i, :) = pos(kind, i, :) + vel(kind, i, :)*DT ! r(t+DT) = r(t) + v(t+DT/2)DT
            end if
        end do
    end do

end subroutine integral