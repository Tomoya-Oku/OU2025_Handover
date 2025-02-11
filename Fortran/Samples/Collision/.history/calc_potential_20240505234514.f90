subroutine calc_potential
	use variables
	use parameters
	implicit none
	integer :: i, i1, i2
	double precision :: divx, divy, divz, dist
	double precision :: dit2, dit4, dit6, dit8, dit12, dit14
	double precision :: ppp, force, forcex, forcey, forcez
	double precision :: vxene, vyene, vzene, vene

	do i1= 1, nkoss
		do i2= i1+1, nkoss
			divx = posx(i1)-posx(i2)
			divy = posy(i1)-posy(i2)
			divz = posz(i1)-posz(i2)

			if (divx < -xcutof) then
				divx = divx + xsyul
			else if(divx > xcutof) then
				divx = divx - xsyul
			endif

			if (divy < -ycutof) then
				divy = divy + ysyul
			else if(divy > ycutof) then
				divy = divy - ysyul
			endif

			if (divz < -zcutof) then
				divz = divz + zsyul
			else if(divz > zcutof) then
				divz = divz - zsyul
			endif

			divx = divx / sig

			if (divx > cutoff33) cycle
			if (divx < -cutoff33) cycle

			divy = divy/sig
			if (divy > cutoff33) cycle
			if (divy < -cutoff33) cycle

			divz = divz/sig
			if (divz > cutoff33) cycle
			if (divz < -cutoff33) cycle

			dit2 = divx*divx + divy*divy + divz*divz
			dist = dsqrt(dit2)

			if(dist > cutoff33) cycle

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
		end do
	end do
end subroutine calc_potential