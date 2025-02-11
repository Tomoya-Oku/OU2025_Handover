program pvch
      use parameters
      implicit none

      double precision  posx,posy,posz
      real    pomx,pomy,pomz
      real    ponx,pony,ponz
      real    vlx2,vly2,vlz2
      integer :: num1, k22, j, i, i75
      !dimension  mcolor(nkosu)
      integer :: moltype = 1
      integer :: nmol = nkoss
      ! manual change
      integer :: ndat= 200
      integer :: ntime0 = 0
      integer :: ndt = 1
      integer :: ns = 5
      integer :: no = 14
      integer :: ng = 2
      integer :: ng2 = 10

      open(1,file='posit.dat')
      open(2,file='pos.dat')
      open(3,file='mask.dat')
      open(4,file='syuuki.dat')

      read(4,*)vlx2
      read(4,*)vly2
      read(4,*)vlz2
      write(2,'(3I7)') moltype,nmol,ndat
      write(2,'(3F15.5)') vlx2,vly2,vlz2
      write(2,'(2I7)') ntime0, ndt

      do k22=1,ndat
            do j=1, nkoss
                  read(1,'(I6,3D15.7)')num1, ponx, pony, ponz
                  pomx = ponx
                  pomy = pony
                  pomz = ponz
                  write(2,'(3E15.7)') pomx, pomy, pomz
            end do
      end do

      do i=1,ndat
            do i75=1,nkoss
                  write(3,'(I7)')ns
            end do
      end do
end program pvch