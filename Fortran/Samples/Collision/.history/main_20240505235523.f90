program main
	use variables, only: nowstp
    use parameters
	implicit none
	integer :: i

	! 読み込み用乱数ファイル
		open(1,file='random1.dat')
		open(2,file='random0.dat')
		open(3,file='posit.dat')
	! 各分子の速度データの出力
		open(4,file='velocity.dat')
	! 系のエネルギーデータの出力
		open(7,file='energy.dat')
	! 系の温度データの出力
	!   open(8,file='temp.dat')
	! 系の周期長さの出力
		open(9,file='period_length.dat')
	! 各分子の最終位置データの出力
	!   open(10,file='finpos.dat')

    nowstp = 0
	
	call initial ! 各分子の初期位置，初期速度などの設定
	call correct_trspeed ! 系内の全分子の並進速度の補正
	call correct_temp ! 系内の全分子の温度の補正
	call correct_cogravity ! 系内の全分子の重心の補正
	call record_posvel ! データの出力１
	call record_energy ! データの出力２

	do i = 1, maxstep
		nowstp = i
		! ステップ数が500の倍数のとき
		if (mod(nowstp,500) == 0) then
			write(6,*) nowstp
		endif
		! ステップ数が100の倍数のとき
		if (mod(nowstp,100) == 0) then
			call cortra	! 系内の全分子の温度の補正
			call scale2 ! 系内の全分子の温度の補正
			call jyusin	! 系内の全分子の重心の補正
		endif
	
		call calcu ! 各分子に働く力，速度，位置の分子動力学計算
		call bound ! 境界条件の付与
		
		! ステップ数が100の倍数+1のとき
		if(mod(nowstp, 100) == 1) then
			call record ! データの出力１
			call record2 ! データの出力２
		endif
	end do

	call record3 ! データの出力３
	
end program main