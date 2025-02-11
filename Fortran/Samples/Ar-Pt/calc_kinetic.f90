subroutine calc_kinetic
    use variables
    use parameters
    use functions
    implicit none
    integer :: i, kind, l = 1
    double precision :: vel2

    ! 初期化
    kin(:, :) = 0.0000D0

    ! 運動エネルギー計算
    do kind = 1, 3
        do i = 1, N(kind)
            vel2 = sum(velene(kind, i, :)*velene(kind, i, :))
            kin(kind, i) = 0.500D0 * MASS(kind) * vel2

            ! 上部Pt
            if (kind == topPt) then
                ! 界面
                if (isInterface(topPt, i)) then
                    do l = 1, INTERFACE_LAYER
                        if (N_LAYER*(l-1)+1 <= i .and. i <= N_LAYER*(l)) then
                            kin_interface_sum(topPt, l) = kin_interface_sum(topPt, l) + kin(topPt, i)
                        end if
                    end do
                ! Phantom層
                else if (isPhantom(topPt, i)) then
                    do l = 1, PHANTOM_LAYER
                        if (N_LAYER*(INTERFACE_LAYER+l-1)+1 <= i .and. i <= N_LAYER*(INTERFACE_LAYER+l)) then
                            kin_phantom_sum(topPt, l) = kin_phantom_sum(topPt, l) + kin(topPt, i)
                        end if
                    end do
                end if
            ! 下部Pt
            else if (kind == botPt) then
                ! 界面
                if (isInterface(botPt, i)) then
                    do l = 1, INTERFACE_LAYER
                        if (N_LAYER*(PHANTOM_LAYER+l)+1 <= i .and. i <= N_LAYER*(PHANTOM_LAYER+l+1)) then
                            kin_interface_sum(botPt, l) = kin_interface_sum(botPt, l) + kin(botPt, i)
                        end if
                    end do
                ! Phantom層
                else if (isPhantom(botPt, i)) then
                    do l = 1, PHANTOM_LAYER
                        if ((N_LAYER*l)+1 <= i .and. i <= N_LAYER*(l+1)) then
                            kin_phantom_sum(botPt, l) = kin_phantom_sum(botPt, l) + kin(botPt, i)
                        end if
                    end do
                end if
            end if
        end do
    end do

    kin_interface_sum(:, :) = kin_interface_sum(:, :) * 1.00D-16
    kin_phantom_sum(:, :) = kin_phantom_sum(:, :) * 1.00D-16

end subroutine calc_kinetic