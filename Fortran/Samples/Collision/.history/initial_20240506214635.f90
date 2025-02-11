subroutine initial
    use variables
    use parameters
    implicit none
    integer :: num, i, j, k
    double precision :: xyz(3)
    double precision :: ofst1(3)
    double precision :: stdist, ran, alpha, beta, cr
    double precision :: vel(3)

    zmass = 1.00D+26*bunsi3/avoga
    sig   = sig33
    eps   = eps33
    cforce = 24.00D0*eps/sig
    syul(:) = syul0(:)
    do i = 1,3
        write(9,*)syul(i)
    end do

    num = 0
    pos(:) = 0.0000D0
    ofst(:) = 0.0000D0

    do i = 1,3
        cutof(i) = syul(i) - cutoff33*sig33
    end do

    stdist = 8.00D0
    do k=1,4
        xyz(3) = ofst1(3) + dble(k-1)*stdist/2.0D0
        do i=1,4
            xyz(1) = ofst1(1) + dble(i-1)*stdist/2.0D0
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