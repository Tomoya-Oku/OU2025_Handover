subroutine correct_trspeed
    use variables
    use parameters
    implicit none
    double precision, dimension(3) :: trv = 0.00000D0
    integer :: i

    do i = 1, nkoss
        trv(:) = trv(:) + vel(i,:)
        !write(6,*) "trv: ", trv(1), trv(2), trv(3)
    end do

    trv(:) = trv(:) / nkoss

    do i = 1, nkoss
        vel(i,:) = vel(i,:) - trv(:)
    end do
end subroutine correct_trspeed