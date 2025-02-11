subroutine correct_cogravity
    use variables
    use parameters
    implicit none
    double precision, dimension(3) :: cms
    double precision, dimension(3) :: tcms
    integer :: i, j

    cms(:) = syul0(i) / 2.0D0
    tcms(:) = 0.0000D0

    do i = 1, nkoss
        tcmsx= tcmsx + posx(i)
        tcmsy= tcmsy + posy(i)
        tcmsz= tcmsz + posz(i)
    end do

    tcmsx = cmsx - tcmsx/dble(nkoss)
    tcmsy = cmsy - tcmsy/dble(nkoss)
    tcmsz = cmsz - tcmsz/dble(nkoss)
   
    do j= 1, nkoss
        posx(j) = posx(j) + tcmsx 
        posy(j) = posy(j) + tcmsy
        posz(j) = posz(j) + tcmsz
    end do
end subroutine correct_cogravity