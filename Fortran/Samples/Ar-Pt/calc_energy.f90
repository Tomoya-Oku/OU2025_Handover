subroutine calc_energy
    use variables
    use parameters
    implicit none
    integer :: i, kind

    energy(:, :) = 0.00D0

    ! エネルギーの合計計算
    do kind = 1, 3
        do i = 1, N(kind)
            energy(kind, POTENTIAL) = energy(kind, POTENTIAL) + pot(kind, i)
            energy(kind, KINETIC) = energy(kind, KINETIC) + kin(kind, i)
        end do
    end do

    ! グループ別全E = グループ別全ポテンシャル + グループ別全運動エネルギー
    energy(:, TOTAL) = energy(:, POTENTIAL) + energy(:, KINETIC)

    ! 全E = 全ポテンシャル + 全運動エネルギー
    energy(ALL, :) = energy(topPt, :) + energy(botPt, :) + energy(AR, :)

    ! 有次元化
    energy(:, :)  = energy(:, :) * 1.00D-16
    
end subroutine calc_energy