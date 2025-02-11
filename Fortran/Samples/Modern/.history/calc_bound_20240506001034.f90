subroutine calc_bound
    use variables, only: posx, posy, posz, xsyul, ysyul, zsyul
    use parameters
    implicit none
    integer :: i

    do i = 1, nkoss
        if(posx(i) < 0.00D0) then
            posx(i) = posx(i) + xsyul
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