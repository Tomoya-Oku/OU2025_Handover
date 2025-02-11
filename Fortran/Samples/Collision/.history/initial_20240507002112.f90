subroutine initial
    use variables
    use parameters
    implicit none
    integer :: num, i, j, k
    double precision :: xyz(3)
    double precision :: ofst1(3)
    double precision :: stdist, ran, alpha, beta, cr
    double precision :: v(3)

    zmass = 1.00D+26 * bunsi3 / avoga
    sig = sig33
    eps = eps33
    cforce = 24.00D0 * eps / sig
    syul(:) = syul0(:)
    do i = 1,3
        write(9,*)syul(i)
    end do

    num = 0
    xyz(:) = 0.0000D0
    ofst1(:) = 0.0000D0

    cutof(:) = syul(:) - cutoff33 * sig33

    stdist = 8.00D0
    do k=1,4
        xyz(3) = ofst1(3) + dble(k-1)*stdist/2.0D0
        do i=1,4
            xyz(1) = ofst1(1) + dble(i-1)*stdist/2.0D0
            do j=1,4
                if(mod(k,2) == 0) then
                    if(mod(i,2) == 0) then
                        xyz(2) = ofst1(2) + dble(j-1)*stdist
                    else
                        xyz(2) = ofst1(2) + dble(j-1)*stdist + stdist/2.0D0
                    endif
                else
                    if(mod(i,2) == 0) then
                        xyz(2) = ofst1(2) + dble(j-1)*stdist + stdist/2.0D0
                    else
                        xyz(2) = ofst1(2) + dble(j-1)*stdist
                    endif
                endif
                num = num + 1
                pos(num, :) = xyz(:)
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
        v(1) = dsin(alpha)*dcos(beta)*cr
        v(2) = dsin(alpha)*dsin(beta)*cr
        v(3) = dcos(alpha)*cr
        num = num + 1
        vel(num, :) = v(:)
    end do
end subroutine initial