subroutine correct_trspeed
    use variables
    use parameters
    implicit none
    double precision, dimension(3) :: trv
    integer :: i

    trv(:) = 0.0D0

    do i = 1, nkoss
        trv(:) = trv(:) + vel(i,:)
    end do

    trv(:) = trv(:) / nkoss

    do i = 1, nkoss
        vel(i,:) = vel(i,:) - trv(:)
        velx(j) = velx(j) - trvx
        vely(j) = vely(j) - trvy
        velz(j) = velz(j) - trvz
    end do
end subroutine correct_trspeed