gfortran -fcheck=all parameters.f90 variables.f90 functions.f90 boundary.f90 calc_potential.f90 calc_kinetic.f90 calc_energy.f90 calc_temp.f90 calc_heatflux.f90 integral.f90 velocity_scaling.f90 initialize.f90 calc_pressure.f90 record.f90 main.f90 -o main
main.exe
gfortran parameters.f90 variables.f90 pvch.f90 -o pvch
pvch.exe
pause