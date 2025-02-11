cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      example.f
c      ナノ粒子の初期状態を分子動力学法で作成する．
c
c      必要ファイル:parate.dat，random0.dat,random1.dat
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c　倍精度計算の宣言
        implicit double precision(a-h,o-z)
************************************************************************
c パラメータファイルparate.datを読み込む
        include 'parate.dat'
************************************************************************
c 各分子の座標(x,y,z方向）
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
c 各分子の速度（x,y,z方向）
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
c 各分子に働く力（x,y,z方向）
        common /force/ forx(nkoss), fory(nkoss), forz(nkoss)
c 各分子のポテンシャルエネルギ，運動エネルギ
        common /enegy/ poten(nkoss), ukine(nkoss)
c 分子の質量，力の計算の係数
        common /mass/ zmass,cforce
c 分子のLennard-Jonesパラメータ，σ，ε
        common /sigeps/ sig, eps
c ポテンシャルのカットオフ長さx,y,z方向
        common /cutof/ xcutof, ycutof, zcutof
c 現在のステップ数
        common /steps/ nowstp
c x,y,z方向の周期長さ
        common /syuuki/ xsyul,ysyul,zsyul 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c 読み込み用乱数ファイル
        open(1,file='random1.dat')
        open(2,file='random0.dat')
        open(3,file='posit.dat')
c 各分子の速度データの出力
        open(4,file='veloc.dat')
c 系のエネルギーデータの出力
        open(7,file='energy.dat')
c 系の温度データの出力
c        open(8,file='tempe.dat')
c 系の周期長さの出力
        open(9,file='syuuki.dat')
c 各分子の最終位置データの出力
c        open(10,file='finpos.dat')
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
          nowstp=0
c 各分子の初期位置，初期速度などの設定
          call seting
c 系内の全分子の並進速度の補正
          call cortra
c 系内の全分子の温度の補正
          call scale2
c 系内の全分子の重心の補正
          call jyusin
c データの出力１
          call record
c データの出力２
          call record2
c メインルーチン　ここから
        do 100 i=1,maxstep
          nowstp = i
         if (mod(nowstp,500) .eq. 0) then
            write(6,*)nowstp
         endif
         if (mod(nowstp,100) .eq. 0) then
c 系内の全分子の温度の補正
          call cortra
c 系内の全分子の温度の補正
          call scale2
c 系内の全分子の重心の補正
          call jyusin
         endif
c 各分子に働く力，速度，位置の分子動力学計算
          call calcu
c 境界条件の付与
          call bound
        if(mod(nowstp, 100) .eq. 1) then
c データの出力１
          call record
c データの出力２
          call record2
        endif
 100    continue
c データの出力３
          call record3
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        stop
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine seting
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
        common /force/ forx(nkoss), fory(nkoss), forz(nkoss)
        common /enegy/ poten(nkoss), ukine(nkoss)
        common /mass/ zmass,cforce
        common /sigeps/ sig, eps
        common /cutof/ xcutof, ycutof, zcutof
        common /steps/ nowstp
        common /syuuki/ xsyul,ysyul,zsyul 
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
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
cccccccccccccccccccccccccccccccccccccccccccccccccc
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
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        stdist = 8.00D0
        do 99 k=1,4
          z = ofstz1 + dble(k-1)*stdist/2.0D0
            do 100 i=1,4
              x = ofstx1 + dble(i-1)*stdist/2.0D0
              do 105 j=1,4
             if(mod(k,2) .eq. 0) then
              if(mod(i,2) .eq. 0) then
                y = ofsty1 + dble(j-1)*stdist
              else
                y = ofsty1 + dble(j-1)*stdist + stdist/2.0D0
              endif
             else
              if(mod(i,2) .eq. 0) then
                  y = ofsty1 + dble(j-1)*stdist + stdist/2.0D0
              else
                  y = ofsty1 + dble(j-1)*stdist
              endif
            endif
              num = num + 1
              posx(num) = x
              posy(num) = y
              posz(num) = z
105             continue
100          continue
99          continue
cccccccccccccccccccccccccccccccccccccccccccccccccc
        num = 0
        cr = 1.00D-6
        do 200 i=1, nkoss
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
200     continue
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine cortra
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
************************************************************************
            trvx = 0.00000D0
            trvy = 0.00000D0
            trvz = 0.00000D0
        do 100 i= 1, nkoss
            trvx = trvx + velx(i)
            trvy = trvy + vely(i)
            trvz = trvz + velz(i)
100     continue
            trvx = trvx/dble(nkoss)
            trvy = trvy/dble(nkoss)
            trvz = trvz/dble(nkoss)
       do 200 j= 1, nkoss
            velx(j) = velx(j) - trvx
            vely(j) = vely(j) - trvy
            velz(j) = velz(j) - trvz
200    continue
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine jyusin
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
************************************************************************
            cmsx = xsyul0/2.00D0
            cmsy = ysyul0/2.00D0
            cmsz = zsyul0/2.00D0
            tcmsx = 0.0000D0
            tcmsy = 0.0000D0
            tcmsz = 0.0000D0
        do 100 i= 1, nkoss
            tcmsx= tcmsx + posx(i)
            tcmsy= tcmsy + posy(i)
            tcmsz= tcmsz + posz(i)
100     continue
            tcmsx = cmsx - tcmsx/dble(nkoss)
            tcmsy = cmsy - tcmsy/dble(nkoss)
            tcmsz = cmsz - tcmsz/dble(nkoss)
       do 200 j= 1, nkoss
            posx(j) = posx(j) + tcmsx 
            posy(j) = posy(j) + tcmsy
            posz(j) = posz(j) + tcmsz
200    continue
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine scale2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
        common /mass/ zmass,cforce
************************************************************************
        temptp = 0.00D0
        do 100 i= 1, nkoss
         vel2 = velx(i)*velx(i) + vely(i)*vely(i) +velz(i)*velz(i)
         temptp = temptp + vel2
100     continue
        temptp = temptp/dble(nkoss)/1.000D+16
        aimtem = atemp1
        aimnot = 3.00D0*boltz*aimtem/zmass
        baiss = dsqrt(aimnot/temptp)
        do 200 i200= 1, nkoss
          velx(i200) = velx(i200)*baiss
          vely(i200) = vely(i200)*baiss
          velz(i200) = velz(i200)*baiss
200     continue
        return        
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine calcu
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
        common /force/ forx(nkoss), fory(nkoss), forz(nkoss)
        common /enegy/ poten(nkoss), ukine(nkoss)
        common /mass/ zmass,cforce
        common /sigeps/ sig, eps
        common /cutof/ xcutof, ycutof, zcutof
        common /steps/ nowstp
        common /syuuki/ xsyul,ysyul,zsyul 
************************************************************************
        do 100 i100=1, nkoss
          forx(i100) = 0.0000D0
          fory(i100) = 0.0000D0
          forz(i100) = 0.0000D0
          poten(i100) = 0.0000D0
          ukine(i100) = 0.0000D0
100     continue
************************************************************************
        do 2200 i1= 1, nkoss
        do 2210 i2= i1+1, nkoss
            divx = posx(i1)-posx(i2)
            divy = posy(i1)-posy(i2)
            divz = posz(i1)-posz(i2)
ccccc
        if (divx .lt. -xcutof) then
          divx = divx + xsyul
        else if(divx .gt. xcutof) then
          divx = divx - xsyul
        endif
ccccc
        if (divy .lt. -ycutof) then
          divy = divy + ysyul
        else if(divy .gt. ycutof) then
          divy = divy - ysyul
        endif
ccccc
        if (divz .lt. -zcutof) then
          divz = divz + zsyul
        else if(divz .gt. zcutof) then
          divz = divz - zsyul
        endif
ccccc
        divx = divx/sig
        if (divx .gt. cutoff33) then
          goto 2210
        endif
        if (divx .lt. -cutoff33) then
          goto 2210
        endif
c
        divy = divy/sig
        if (divy .gt. cutoff33) then
          goto 2210
        endif
        if (divy .lt. -cutoff33) then
          goto 2210
        endif
c
        divz = divz/sig
        if (divz .gt. cutoff33) then
          goto 2210
        endif
        if (divz .lt. -cutoff33) then
          goto 2210
        endif
ccccccccccccccccccccccccccccccccccccccccccccccccccc
        dit2 = divx*divx + divy*divy + divz*divz
        dist = dsqrt(dit2)
        if(dist .gt. cutoff33) then
          goto 2210
        endif
          dit4 = dit2*dit2
          dit6 = dit4*dit2
          dit8 = dit4*dit4
          dit12 = dit6*dit6
          dit14 = dit8*dit6
        ppp = 4.00D0*eps*(1.00D0/dit12-1.00D0/dit6)
        force = cforce*(-2.00D0/dit14+1.00D0/dit8)
            forcex = -force*divx/zmass
            forcey = -force*divy/zmass
            forcez = -force*divz/zmass
            forx(i1) = forx(i1) + forcex
            forx(i2) = forx(i2) - forcex
            fory(i1) = fory(i1) + forcey
            fory(i2) = fory(i2) - forcey
            forz(i1) = forz(i1) + forcez
            forz(i2) = forz(i2) - forcez
            poten(i1) = poten(i1) + ppp*0.500D0
            poten(i2) = poten(i2) + ppp*0.500D0
2210    continue
2200    continue
*********************************************************
        do 5000 i=1, nkoss
          vxene = velx(i) + forx(i)*0.500D0*dt
          vyene = vely(i) + fory(i)*0.500D0*dt
          vzene = velz(i) + forz(i)*0.500D0*dt
          vene = vxene*vxene + vyene*vyene + vzene*vzene
          ukine(i) = 0.500D0*zmass*vene
5000    continue
        do 5100 i=1, nkoss
          velx(i) = velx(i) + forx(i)*dt
          vely(i) = vely(i) + fory(i)*dt
          velz(i) = velz(i) + forz(i)*dt
          posx(i) = posx(i) + velx(i)*dt
          posy(i) = posy(i) + vely(i)*dt
          posz(i) = posz(i) + velz(i)*dt
5100    continue
*********************************************************
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine bound
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
        common /syuuki/ xsyul,ysyul,zsyul 
************************************************************************
        do 100 i=1, nkoss
          if(posx(i) .lt. 0.00D0) then
              posx(i) = posx(i) + xsyul
          else if(posx(i) .gt. xsyul) then
              posx(i) = posx(i) - xsyul
          endif
          if(posy(i) .lt. 0.00D0) then
              posy(i) = posy(i) + ysyul
          else if(posy(i) .gt. ysyul) then
              posy(i) = posy(i) - ysyul
          endif
          if(posz(i) .lt. 0.00D0) then
              posz(i) = posz(i) + zsyul
          else if(posz(i) .gt. zsyul) then
              posz(i) = posz(i) - zsyul
          endif
100       continue
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine record
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
************************************************************************
        num = 0
        do 500 i=1, nkoss
          write(3,'(I6, 3D15.7)')i, posx(i), posy(i), posz(i)
          write(4,'(I6, 3D15.7)')i, velx(i), vely(i), velz(i)
500     continue
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine record2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /enegy/ poten(nkoss), ukine(nkoss)
************************************************************************
          totene = 0.00D0
          totpot = 0.00D0
          totkin = 0.00D0
         do 900 i900 = 1, nkoss
           totpot = totpot + poten(i900)
           totkin = totkin + ukine(i900)
900      continue
          totpot = totpot/1.00D16
          totkin = totkin/1.00D16
          totene = totpot + totkin
        temp = 2.000D0*totkin/(3.00D0*dble(nkoss)*boltz)
        write(7,'(4D15.7)')totene, totpot, totkin, temp
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine record3
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        implicit double precision(a-h,o-z)
        include 'parate.dat'
************************************************************************
        common /posit/ posx(nkoss), posy(nkoss), posz(nkoss)
        common /veloc/ velx(nkoss), vely(nkoss), velz(nkoss)
************************************************************************
        num = 0
        do 500 i=1, nkoss
          write(9,'(I6, 6D15.7)')i, posx(i), posy(i), posz(i),
     &                                velx(i), vely(i), velz(i)
500     continue
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc