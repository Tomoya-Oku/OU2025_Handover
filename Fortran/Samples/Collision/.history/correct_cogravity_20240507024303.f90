subroutine correct_cogravity
    use variables
    use parameters
    implicit none
    double precision, dimension(3) :: cms
    double precision, dimension(3) :: tcms
    integer :: i

    cms(:) = syul0(:) / 2.0D0
    tcms(:) = 0.0000D0

    do i = 1, nkoss
        tcms(:) = tcms(:) + pos(i,:)
    end do

    tcms(:) = cms(:) - tcms(:) / dble(nkoss)
   
    do i = 1, nkoss
        pos(i,:) = pos(i,:) + tcms(:)
    end do
end subroutine correct_cogravity