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
end subroutine calc_bound