subroutine calc_bound
    use variables
    use parameters
    implicit none
    integer :: i

    do i = 1, nkoss
        do j = 1, 3
            if(pos(i, j) < 0.00D0) then
                pos(i, j) = pos(i, j) + syul(j)
            else if(pos(i, j) > syul(j)) then
                pos(i, j) = pos(i, j) - syul(j)
            endif
        end do
    end do

    do i = 1, nkoss
        if(pos(i, 1) < 0.00D0) then
            pos(i, 1) = pos(i, 1) + syul(1)
        else if(pos(i, 1) > syul(1)) then
            pos(i, 1) = pos(i, 1) - syul(1)
        endif

        if(pos(i, 2) < 0.00D0) then
            pos(i, 2) = pos(i, 2) + syul(2)
        else if(pos(i, 2) > syul(2)) then
            pos(i, 2) = pos(i, 2) - syul(2)
        endif

        if(pos(i, 3) < 0.00D0) then
            pos(i, 3) = pos(i, 3) + syul(3)
        else if(pos(i, 3) > syul(3)) then
            pos(i, 3) = pos(i, 3) - syul(3)
        endif
    end do
end subroutine calc_bound