subroutine initial
    use variables
    use parameters
    implicit none
    integer :: num, i, j, k
    double precision :: stdist, ran, alpha, beta, cr
    double precision, dimension(3) :: xyz
    double precision, dimension(3) :: ofst1
    double precision, dimension(3) :: v

    zmass = 1.00D+26 * bunsi3 / avoga
    sig = sig33
    eps = eps33
    cforce = 24.00D0 * eps / sig
    syul(:) = syul0(:)
    do i = 1,3
        write(9,*)syul(i)
    end do

    num = 0
    cutof(:) = syul(:) - cutoff33 * sig33
    stdist = 8.00D0
    
    do k=1,4
        xyz(3) = ofst1(3) + dble(k-1)*stdist/2.0D0
        !write(6,*) 'xyz(3): ', xyz(3)
        do i=1,4
            xyz(1) = ofst1(1) + dble(i-1)*stdist/2.0D0
            !write(6,*) 'xyz(1): ', xyz(1)
            do j=1,4
                ! iとkの偶奇が一致する
                if(mod(k,2) == mod(i,2)) then
                    xyz(2) = ofst1(2) + dble(j-1)*stdist
                else
                    xyz(2) = ofst1(2) + dble(j-1)*stdist + stdist/2.0D0
                endif
                !write(6,*) 'xyz(2): ', xyz(2)
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