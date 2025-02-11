module variables
	use parameters
	implicit none
    double precision, dimension(nkoss) :: posx, posy, posz ! 各分子の座標(x,y,z方向）
	double precision, dimension(nkoss) :: velx, vely, velz ! 各分子の速度（x,y,z方向）
	double precision, dimension(nkoss) :: forx, fory, forz ! 各分子に働く力（x,y,z方向）
	double precision, dimension(nkoss) :: poten, ukine ! 各分子のポテンシャルエネルギー，運動エネルギー
	double precision :: zmass, cforce ! 分子の質量，力の計算の係数
	double precision :: sig, eps ! 分子のLennard-Jonesパラメータ，σ，ε
	double precision :: xcutof, ycutof, zcutof ! ポテンシャルのカットオフ長さx,y,z方向
	integer :: nowstp ! 現在のステップ数
	double precision :: xsyul, ysyul, zsyul ! ポテンシャルのカットオフ長さx,y,z方向，x,y,z方向の周期長さ
end module variables