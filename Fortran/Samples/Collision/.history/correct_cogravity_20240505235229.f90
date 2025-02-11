subroutine correct_cogravity
    use variables, only: posx, posy, posz
    use parameters
    implicit none
    double precision :: cmsx, cmsy, cmsz
    double precision :: tcmsx, tcmsy, tcmsz
    integer :: i, j

    cmsx = xsyul0 / 2.0d0
    cmsy = ysyul0 / 2.0d0
    cmsz = zsyul0 / 2.0d0
    tcmsx = 0.0000D0
    tcmsy = 0.0000D0
    tcmsz = 0.0000D0

    do i= 1, nkoss
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