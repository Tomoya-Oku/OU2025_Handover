subroutine boundary
    use variables
    use parameters
    implicit none
    integer :: i, j, kind

    do kind = 1, 3
        do i = 1, N(kind)
            do j = 1, 3
                if(pos(kind, i, j) < 0.00D0) then
                    pos(kind, i, j) = pos(kind, i, j) + SSIZE(j)
                else if(pos(kind, i, j) > SSIZE(j)) then
                    pos(kind, i, j) = pos(kind, i, j) - SSIZE(j)
                end if
            end do
        end do
    end do
    
end subroutine boundary