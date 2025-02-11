subroutine calc_potential
	use variables
	use parameters
	implicit none
	integer :: i, i1, i2
	!double precision :: divx, divy, divz, dist
	double precision, dimension(3) :: divs
	double precision :: dist, ppp, force, vene
	double precision :: dit2, dit4, dit6, dit8, dit12, dit14
	!double precision :: ppp, force, forcex, forcey, forcez
	double precision, dimension(3) :: forces
	!double precision :: vxene, vyene, vzene, vene
	double precision, dimension(3) :: venes

	do i1= 1, nkoss
		LP1:do i2= i1+1, nkoss
				divs(:) = pos(i1, :) - pos(i2, :)

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

				dit4 = dit2*dit2
				dit6 = dit4*dit2
				dit8 = dit4*dit4
				dit12 = dit6*dit6
				dit14 = dit8*dit6

				ppp = 4.00D0*eps*(1.00D0/dit12-1.00D0/dit6)
				force = cforce*(-2.00D0/dit14+1.00D0/dit8)

				do j = 1,3
					forces(j) = -force * divs(j) / zmass
				end do

				do j = 1,3
					for(i1, j) = for(i1, j) + forces(j)
					for(i2, j) = for(i2, j) - forces(j)
				end do

				poten(i1) = poten(i1) + ppp*0.500D0
				poten(i2) = poten(i2) + ppp*0.500D0
		end do
	end do
end subroutine calc_potential