cccccccccccccccccccccccccccccccccccccccccccccccccccc
c      pvch.f 
c
c    pvwin用可視化，分子位置ファイル，色ファイルの出力
c    必要ファイル：position.dat，syuuki.dat
c    pvwin用のデータの形式については，pvwinのＨＰにある
c    使い方を参照ください．
cccccccccccccccccccccccccccccccccccccccccccccccccccc
      include 'parate.dat'
cccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision  posx,posy,posz
      real    pomx,pomy,pomz
c      dimension  mcolor(nkosu)
cccccccccccccccccccccccccccccccccccccccccccccccccccc
      moltype = 1
      nmol = nkoss
ccccc manual change
      ndat= 200
      ntime0 = 0
      ndt = 1
      ns = 5
      no = 14
      ng = 2
      ng2 = 10
ccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(1,file='posit.dat')
      open(2,file='pos.dat')
      open(3,file='mask.dat')
      open(4,file='syuuki.dat')
cccccccccccccccccccccccccccccccccccccccccccccccc
      read(4,*)vlx2
      read(4,*)vly2
      read(4,*)vlz2
      write(2,'(3I7)') moltype,nmol,ndat
      write(2,'(3F15.5)') vlx2,vly2,vlz2
      write(2,'(2I7)') ntime0, ndt
cccccccccccccccccccccccccccccccccccccccccccccccc
      do 230 k22=1,ndat
      do 210 j=1, nkoss
         read(1,'(I6,3D15.7)')num1, ponx, pony, ponz
          pomx = ponx
          pomy = pony
          pomz = ponz
        write(2,'(3E15.7)') pomx, pomy, pomz
210   continue
230   continue
      do 700 i=1,ndat
        do 750 i75=1,nkoss
           write(3,'(I7)')ns
750    continue    
700     continue
      stop
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccc
