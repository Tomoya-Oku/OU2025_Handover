subroutine record_posvel
    use variables
    use parameters
    use functions
    implicit none
    integer :: i, kind, num

    num = 1

    ! 位置の記録 -> posit.dat
    do kind = 1, 3
        do i = 1, N(kind)
            write(DAT_POSIT, '(I8, 3E15.7)') num, pos(kind, i, X), pos(kind, i, Y), pos(kind, i, Z)
            num = num + 1
        end do
    end do

    ! 速度の記録 -> velocity.dat
    ! do kind = 1, 3
    !     do i = 1, N(kind)
    !         write(DAT_VELOCITY, '(2I8, 3E15.7)') kind, i, vel(kind, i, X), vel(kind, i, Y), vel(kind, i, Z)
    !     end do
    ! end do

    ! 計測用速度の記録 -> velene.dat
    ! do kind = 1, 3
    !     do i = 1, N(kind)
    !         write(DAT_VELENE, '(2I8, 3E15.7)') kind, i, velene(kind, i, X), velene(kind, i, Y), velene(kind, i, Z)
    !     end do
    ! end do

    ! 加速度
    ! do kind = 1, 3
    !     do i = 1, N(kind)
    !         write(DAT_ACCELERATION, '(2I8, 3E15.7)') kind, i, acc(kind, i, X), acc(kind, i, Y), acc(kind, i, Z)
    !     end do
    ! end do

end subroutine record_posvel

subroutine record_lammps
    use variables
    use parameters
    use functions
    implicit none
    integer :: i, kind, num, kind_num

    num = 1

    ! 位置の記録(LAMMPS) -> pos_lammps.dat
    do kind = 1, 3
        do i = 1, N(kind)
            if (kind == topPt) then
                if (isInterface(kind, i)) then
                    kind_num = 4
                else if (isPhantom(kind, i)) then
                    kind_num = 2
                else
                    kind_num = 6
                end if
            else if (kind == botPt) then
                if (isInterface(kind, i)) then
                    kind_num = 5
                else if (isPhantom(kind, i)) then
                    kind_num = 3
                else
                    kind_num = 7
                end if
            else 
                kind_num = 1
            end if

            write(DAT_POSL, '(2I4, 3E15.7)') num, kind_num, pos(kind, i, X), pos(kind, i, Y), pos(kind, i, Z)
            num = num + 1
        end do
    end do

    close(DAT_POSL)

end subroutine record_lammps

subroutine record_force
    use variables
    use parameters
    implicit none

    integer :: kind1, kind2, i1, i2

    do kind1 = 1, 3
        do kind2 = 1, 3
            do i1 = 1, N(kind1)
                do i2 = 1, N(kind2)
                    write(DAT_FORCE, '(5I8, 3E15.7)') nowstp, kind1, kind2, i1, i2, &
                    for(kind1, kind2, i1, i2, X), for(kind1, kind2, i1, i2, Y), for(kind1, kind2, i1, i2, Z)
                end do
            end do
        end do
    end do

end subroutine record_force

subroutine record_langevin_force
    use variables
    use parameters
    implicit none
    integer :: i, kind

    do kind = topPt, botPt
        do i = 1, N(kind)
            write(DAT_DFORCE, '(2I8, 3E15.7)') nowstp, i, F_D(kind, i, X), F_D(kind, i, Y), F_D(kind, i, Z)
            write(DAT_RFORCE, '(2I8, 3E15.7)') nowstp, i, F_R(kind, i, X), F_R(kind, i, Y), F_R(kind, i, Z)
        end do
    end do

end subroutine record_langevin_force

subroutine record_energy
    use variables
    use parameters
    implicit none

    write(DAT_ENERGY, '(I8, 3E15.7)') nowstp, energy(ALL, TOTAL), energy(ALL, POTENTIAL), energy(ALL, KINETIC)
    write(DAT_PT_ENERGY, '(I8, 3E15.7)') nowstp, energy(topPt, TOTAL)+energy(botPt, TOTAL), &
    energy(topPt, POTENTIAL)+energy(botPt, POTENTIAL), energy(topPt, KINETIC)+energy(botPt, KINETIC)
    write(DAT_TOP_PT_ENERGY, '(I8, 3E15.7)') nowstp, energy(topPt, TOTAL), energy(topPt, POTENTIAL), energy(topPt, KINETIC)
    write(DAT_BOT_PT_ENERGY, '(I8, 3E15.7)') nowstp, energy(botPt, TOTAL), energy(botPt, POTENTIAL), energy(botPt, KINETIC)
    write(DAT_AR_ENERGY, '(I8, 3E15.7)') nowstp, energy(Ar, TOTAL), energy(Ar, POTENTIAL), energy(Ar, KINETIC)

end subroutine record_energy

subroutine record_temp
    use variables
    use parameters
    implicit none

    write(DAT_TEMP, '(I8, 3E15.7)') nowstp, temp(topPt), temp(botPt), temp(AR)
    ! write(DAT_TEMP_INTERFACE, '(2E15.7)') temp_interface(U_PT), temp_interface(L_PT)
    ! write(DAT_TEMP_PHANTOM, '(2E15.7)') temp_phantom(U_PT), temp_phantom(L_PT)
end subroutine record_temp

subroutine record_tempDistribution
    use variables
    use parameters
    implicit none
    integer :: l, i

    ! 下部Pt, Phantom層
    do l = 1, PHANTOM_LAYER
        i = l
        write(DAT_TEMP_DISTRIBUTION, '(2I8, 2E15.7)') nowstp, l, OFST(botPt, Z) + i*STDIST(botPt)*0.5D0 , temp_phantom(botPt, i)
    end do

    ! 下部Pt, 界面
    do l = PHANTOM_LAYER+1, PHANTOM_LAYER+INTERFACE_LAYER
        i = l - PHANTOM_LAYER
        write(DAT_TEMP_DISTRIBUTION, '(2I8, 2E15.7)') nowstp, l, l*STDIST(botPt)*0.5D0, temp_interface(botPt, i) 
    end do
    
    ! Ar(分割)
    do l = PHANTOM_LAYER+INTERFACE_LAYER+1, PHANTOM_LAYER+INTERFACE_LAYER+PARTITION
        i = l - (PHANTOM_LAYER+INTERFACE_LAYER)
        write(DAT_TEMP_DISTRIBUTION, '(2I8, 2E15.7)') nowstp, l, z_mid(i), temp_layer(i)
    end do

    ! 上部Pt, 界面
    do l = PHANTOM_LAYER+INTERFACE_LAYER+PARTITION+1, PHANTOM_LAYER+2*INTERFACE_LAYER+PARTITION
        i = l - (PHANTOM_LAYER+INTERFACE_LAYER+PARTITION)
        write(DAT_TEMP_DISTRIBUTION, '(2I8, 2E15.7)') nowstp, l, OFST(topPt, Z)+(i-1)*STDIST(topPt)*0.5D0, temp_interface(topPt, i)
    end do

    ! 上部Pt, Phantom層
    do l = PHANTOM_LAYER+2*INTERFACE_LAYER+PARTITION+1, 2*PHANTOM_LAYER+2*INTERFACE_LAYER+PARTITION
        i = l - (PHANTOM_LAYER+2*INTERFACE_LAYER+PARTITION)
        write(DAT_TEMP_DISTRIBUTION, '(2I8, 2E15.7)') nowstp, l, OFST(topPt, Z)+(INTERFACE_LAYER+i-1)*STDIST(topPt)*0.5D0, &
        temp_phantom(topPt, i)
    end do 
    
end subroutine record_tempDistribution

subroutine record_pressure
    use variables
    use parameters
    implicit none

    write(DAT_PRESSURE, '(I8, 2E15.7)') nowstp, pressure

end subroutine record_pressure

subroutine record_heatflux
    use variables
    use parameters
    implicit none

    write(DAT_HEATFLUX, "(I8, 4E15.7)") nowstp, heatflux_interface(topPt), heatflux_interface(botPt), &
    heatflux_phantom(topPt), heatflux_phantom(botPt)

end subroutine record_heatflux

subroutine record_Q
    use variables
    use parameters
    implicit none

    write(DAT_Q, "(I8, 4E15.7)") nowstp, Q_interface(topPt), Q_interface(botPt), Q_phantom(topPt), Q_phantom(botPt)

end subroutine record_Q

subroutine record_finposvel
    use variables
    use parameters
    implicit none
    integer :: i, k, num

    do k = 1, 3
        do i = 1, N(k)
            write(DAT_PERIODIC, '(I8, 6E15.7)') num, pos(k,i,X), pos(k,i,Y), pos(k,i,Z), vel(k,i,X), vel(k,i,Y), vel(k,i,Z)
            num = num + 1
        end do
    end do

end subroutine record_finposvel