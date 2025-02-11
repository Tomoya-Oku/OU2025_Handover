subroutine initial
    use variables
    use parameters
    implicit none
    integer :: num, i, j, k
    double precision :: x, y, z
    double precision :: ofstx1, ofsty1, ofstz1
    double precision :: stdist, ran, alpha, beta, cr
    double precision :: vx, vy, vz

    zmass = 1.00D+26*bunsi3/avoga
    sig   = sig33
    eps   = eps33
    cforce = 24.00D0*eps/sig
    xsyul = xsyul0
    ysyul = ysyul0
    zsyul = zsyul0
    write(9,*)xsyul
    write(9,*)ysyul
    write(9,*)zsyul

    num = 0
    x = 0.0000D0
    y = 0.0000D0
    z = 0.0000D0
    ofstx1 = 0.0000D0
    ofsty1 = 0.0000D0
    ofstz1 = 0.0000D0
    xcutof = xsyul - cutoff33*sig33
    ycutof = ysyul - cutoff33*sig33
    zcutof = zsyul - cutoff33*sig33

    stdist = 8.00D0
    do k=1,4
        z = ofstz1 + dble(k-1)*stdist/2.0D0
        do i=1,4
            x = ofstx1 + dble(i-1)*stdist/2.0D0
            do j=1,4
                if(mod(k,2) == 0) then
                    if(mod(i,2) == 0) then
                        y = ofsty1 + dble(j-1)*stdist
                    else
                        y = ofsty1 + dble(j-1)*stdist + stdist/2.0D0
                    endif
                else
                    if(mod(i,2) == 0) then
                        y = ofsty1 + dble(j-1)*stdist + stdist/2.0D0
                    else
                        y = ofsty1 + dble(j-1)*stdist
                    endif
                endif
                num = num + 1
                posx(num) = x
                posy(num) = y
                posz(num) = z
            end do
        end do
    end do

    num = 0
    cr = 1.00D-6
    do i=1, nkoss
        read(1,*)ran
        alpha = pi*ran
        read(2,*)ran
        beta = 2.000D0*pi*ran
        vx = dsin(alpha)*dcos(beta)*cr
        vy = dsin(alpha)*dsin(beta)*cr
        vz = dcos(alpha)*cr
        num = num + 1
        velx(num) = vx
        vely(num) = vy
        velz(num) = vz
    end do
end subroutine initial