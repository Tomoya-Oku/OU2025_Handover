subroutine calc_potential
    use variables
    use parameters
    implicit none
    integer :: i1, i2, j, kind1, kind2
    double precision :: LJ_potential, force
    double precision :: div2, div4, div6, div8, div12, div14
    double precision :: divs(3)

    ! 初期化
    acc(:, :, :) = 0.0000D0
    for(:, :, :, :, :) = 0.0000D0
    pot(:, :) = 0.0000D0

    ! 1 = TOP Pt
    ! 2 = BOTTOM Pt
    ! 3 = Ar

    ! (kind1, kind2) = (1,1), (1,2), (1,3), (2,2), (2,3), (3,3)
    do kind1 = 1, 3
        do kind2 = kind1, 3
            if (kind1 == topPt .and. kind2 == botPt) cycle ! 上部Ptと下部Ptの計算をスキップ
            ! if (kind1 == topPt .and. kind2 == Ar) cycle ! 上部PtとArの計算をスキップ
            ! if (kind1 == botPt .and. kind2 == Ar) cycle ! 下部PtとArの計算をスキップ
            ! if (kind1 == topPt .and. kind2 == topPt) cycle ! 上部Ptと上部Ptの計算をスキップ
            ! if (kind1 == botPt .and. kind2 == botPt) cycle ! 下部Ptと下部Ptの計算をスキップ
            ! if (kind1 == Ar .and. kind2 == Ar) cycle ! ArとArの計算をスキップ
            
            do i1 = 1, N(kind1)
                LP: do i2 = 1, N(kind2)
                        ! 同じ粒子または重複（F_12 = F_21）
                        if (kind1 == kind2 .and. i1 >= i2) cycle LP

                        ! 相対位置ベクトル
                        divs(:) = pos(kind1, i1, :) - pos(kind2, i2, :)

                        ! xy周期境界条件による補正
                        do j = X, Y
                            if (divs(j) < -CUTOFF(kind1, kind2, j)) then
                                divs(j) = divs(j) + SSIZE(j)
                            else if (divs(j) > CUTOFF(kind1, kind2, j)) then
                                divs(j) = divs(j) - SSIZE(j)
                            end if
                        end do

                        divs(:) = divs(:) * SIG_inv(kind1, kind2)
                        div2 = sum(divs(:)*divs(:))

                        ! カットオフ
                        if (div2 > CUTOFFperSIG2) cycle LP

                        div4 = div2*div2
                        div6 = div4*div2
                        div8 = div4*div4
                        div12 = div6*div6
                        div14 = div8*div6

                        LJ_potential = 4.00D0*ALPHA(kind1, kind2)*EPS(kind1, kind2)*(1.00D0/div12 - 1.00D0/div6)
                        force = COEF(kind1, kind2)*(-2.00D0/div14 + 1.00D0/div8)
                        for(kind1, kind2, i1, i2, :) = -force * divs(:) ! 1の粒子が2の粒子から受ける力
                        for(kind2, kind1, i2, i1, :) = -for(kind1, kind2, i1, i2, :) ! 2の粒子が1の粒子から受ける力

                        ! 加速度を計算
                        acc(kind1, i1, :) = acc(kind1, i1, :) + for(kind1, kind2, i1, i2, :) * MASS_inv(kind1)
                        acc(kind2, i2, :) = acc(kind2, i2, :) + for(kind2, kind1, i2, i1, :) * MASS_inv(kind2)

                        pot(kind1, i1) = pot(kind1, i1) + LJ_potential*0.500D0
                        pot(kind2, i2) = pot(kind2, i2) + LJ_potential*0.500D0

                    end do LP
            end do
        end do
    end do
end subroutine calc_potential
