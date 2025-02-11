subroutine calc_potential
	use variables
	use parameters
	implicit none
	integer :: i, i1, i2
	!double precision :: divx, divy, divz, dist
	double precision, dimension(3) :: divs
	double precision :: dist, ppp, force, vene
	!double precision :: dit2, dit4, dit6, dit8, dit12, dit14
	double precision, dimension(6) :: dits
	!double precision :: ppp, force, forcex, forcey, forcez
	double precision, dimension(3) :: forces
	!double precision :: vxene, vyene, vzene, vene
	double precision, dimension(3) :: venes

	do i1= 1, nkoss
		LP1:do i2= i1+1, nkoss
				do j = 1,3
					divs(j) = pos(i1, j) - pos(i2, j)
				end do

				do j = 1,3
					if (divs(j) < -cutof(j)) then
						divs(j) = divs(j) + syul(j)
					else if(divs(j) > cutof(j)) then
						divs(j) = divs(j) - syul(j)
					endif
				end do

				do j = 1,3
					divs(j) = divs(j) / sig
					if (divs(j) > cutoff33) cycle LP1
					if (divs(j) < -cutoff33) cycle LP1
				end do

				dit2 = divs(1)*divs(1) + divs(2)*divs(2) + divs(3)*divs(3)
				dist = dsqrt(dit2)
				if(dist > cutoff33) cycle

				do j = 2,6
					dits(j) = dits(j-1) * dits(j-1)
					dits(j+1) = dits(j) * dits(j-1)
				end do

				dits(2) = dits(1)*dits(1)
				dits(3) = dits(2)*dits(1)
				dits(4) = dits(2)*dits(2)
				dits(5) = dits(3)*dits(3)
				dits(6) = dits(3)*dits(4)
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