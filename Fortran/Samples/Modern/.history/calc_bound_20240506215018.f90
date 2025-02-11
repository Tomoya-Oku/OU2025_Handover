subroutine calc_bound
    use variables
    use parameters
    implicit none
    integer :: i

    do i = 1, nkoss
        if(pos(i, 1) < 0.00D0) then
            pos(i, 1) = pos(i, 1) + syul(1)
        else if(posx(i) > xsyul) then
            posx(i) = posx(i) - xsyul
        endif

        if(posy(i) < 0.00D0) then
            posy(i) = posy(i) + ysyul
        else if(posy(i) > ysyul) then
            posy(i) = posy(i) - ysyul
        endif

        if(posz(i) < 0.00D0) then
            posz(i) = posz(i) + zsyul
        else if(posz(i) > zsyul) then
            posz(i) = posz(i) - zsyul
        endif
    end do
end subroutine calc_bound