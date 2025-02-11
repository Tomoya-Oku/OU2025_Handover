module variables
	use parameters
	implicit none
    double precision, dimension(nkoss, 3) :: pos ! 各分子の座標(番号, 座標)
	double precision, dimension(nkoss, 3) :: vel ! 各分子の速度(番号, 座標)
	double precision, dimension(nkoss, 3) :: for ! 各分子に働く力(番号, 座標)
	double precision, dimension(nkoss) :: poten, ukine ! 各分子のポテンシャルエネルギー，運動エネルギー
	double precision :: zmass, cforce ! 分子の質量，力の計算の係数
	double precision :: sig, eps ! 分子のLennard-Jonesパラメータ，σ，ε
	double precision, dimension(3) :: cutof ! ポテンシャルのカットオフ長さx,y,z方向
	integer :: nowstp ! 現在のステップ数
	double precision, dimension(3) :: syul ! ポテンシャルのカットオフ長さx,y,z方向，x,y,z方向の周期長さ
end module variables