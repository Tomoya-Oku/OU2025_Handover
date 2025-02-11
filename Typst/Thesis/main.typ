#import "format.typ": *
#import "@preview/physica:0.9.2": *
#import "@preview/chem-par:0.0.1": *

#show: chem-style

// for main text
#set text(
    lang: "ja",  // 英語しか使わない文書では"en"とする（もしくは指定しない）
    font: ("Times New Roman", "Yu Mincho"),
    // font: (日本語文字を含まないフォント, 日本語文字を含むフォント),  となっている
)

// for headings
#let heading_font(body) = {
    set text(font: ("Yu Gothic", "Times New Roman"))  // weightの指定は反映されないらしい
    // font: (日本語文字を含まないフォント, 日本語文字を含むフォント),  となっている
    body
}
#show heading: heading_font  // heading_fontを適用する

//Strokes for table
#set table(
  stroke: (_, y) => (
       top: if y <= 1 { 1pt } else { 0pt },
       bottom: 1pt,
  ),
  inset: 8pt,
  align: center
)

#show: master_thesis.with(
  title: "HKUST-1のCO2吸着特性と\nそのエネルギー状態に関する分子シミュレーション",
  author: "奥　朋哉",
  university: "大阪大学",
  faculty: "工学部",
  department: "応用理工学科",
  major: "機械工学科目",
  mentor1: "芝原　正彦",
  mentor1-post: "教授",
  mentor2: "藤原　邦夫",
  mentor2-post: "准教授",
  class: "卒業",
  date: ("2025", "7", "2", "10"),
  bibliography-file: "references.bib",
)

= 序論

#pagebreak()

== 研究背景・目的

MOF (Metal-Organic frameworks) は近年，新規多孔性材料として注目を集めている．MOFは金属錯体のクラスターを有機配位子 (linker, ligand) で架橋した構造を持ち，その大きな表面積と空孔率によって優れた吸着性能を可能としている@itou2024．これによりMOFは流体の貯蔵や分離のほか，触媒や生物学，医学分野の技術にも応用が期待されている@Li2024．また，MOFを構成する金属イオンと有機配位子の組み合わせを変えることで様々な特性を持つMOFを作製することができ，Moosaviらによると2020年時点で90000種類以上のMOFが合成されており，500000種類以上のMOFの存在が予測されている@Moosavi2020．

MOFの流体貯蔵・分離機能は地球温暖化をはじめとする環境問題やエネルギー問題へ貢献することが期待されており，温室効果ガスとされる大気中のCO2をMOFにより分離する試みはNuada社 (英) ，Mosaic Materials社 (米) などのベンチャー企業で実用化に向けて研究・開発が進められているが，未だ大規模な実践段階に至っていない．特に熱工学的な分野では，流体がMOFに吸着する際に発生する熱 (吸着熱) が吸着効率を低下させるため，放熱を目的とした熱輸送の効率化が課題とされている．Ghanbariらの研究@Ghanbari2020 では，様々なMOFのCO2吸着選択性 (adsorption selectivity) について調査がなされており，CO2の吸着性能は低圧領域では吸着熱に依存し，高圧領域ではMOFの表面積に依存することが述べられている．したがって，実用化にあたって空気の圧縮が不要であるような低圧領域では吸着性能の向上のために，特に吸着熱に関する理解が重要であると考えられる．

現在，MOFの金属イオンを入れ替えることにより派生生成物を作製し，純粋なMOFに比べて，その吸着性能を向上させる研究がシミュレーションおよび実験の両方で数多く行なわれている．しかし，基盤となる純粋なMOFに対する気体吸着の際の微視的なメカニズムに関する十分な知見は得られておらず，特にエネルギーの面から吸着現象を解析している研究は少ない．そのため，MOFの気体吸着の際のエネルギー状態に関する新たな知見を得ることは，MOFの吸着性能向上に加えて，新規のMOF構造の発見にも貢献することが期待される．

一般的に，流体の吸着現象を解析する方法としては実験による方法と，GCMC (Grand Canonical Monte Carlo) シミュレーションや分子動力学 (Molecular Dynamics : MD) シミュレーションなどの分子シミュレーションを用いる方法がある．特に分子間におけるエネルギーの授受を解析する上では，ミクロなスケールから流体の吸着現象を解析することが可能である分子シミュレーションは最も有効な手段の一つである．
そこで本研究では，分子シミュレーションを用いて，代表的なMOFであるHKUST-1とCO2 (気体) 間での吸着現象を再現し，HKUST-1のCO2吸着時のエネルギー状態に関して新たな知見を得ることを目的とした．HKUST-1 (CuBTC, MOF - 199) は1999年に報告された銅を基盤とするMOFであり@chui1999 ，CO2やCH4をはじめとした気体の吸着に対して極めて高い性能を有していることから数多くの研究がなされている．なお，HKUST-1という名称はMOFが発見された"Hong Kong University of Science and Technology"の略称である"HKUST"に因んでいる．

== 本論文の構成

本論文は全4章で構成されている．第1章では研究背景および研究目的を述べた．第2章ではMDシミュレーションとGCMCシミュレーションの概要，シミュレーション環境と計算モデル，用いたポテンシャル関数について述べる．第3章ではシミュレーションの結果および考察を述べる．第4章では結論および今後の課題と展望を述べる．

= 研究方法

#pagebreak()

== 分子動力学法 (Molecular Dynamics)

本研究では，CO2分子の吸着平衡状態を再現するために分子動力学 (Molecular Dynamics : MD) 法を用いてシミュレーションを行なった．MDシミュレーションとは，粒子に対してNewtonの運動方程式である@newton を数値的に解くことにより，粒子の運動を追跡する方法@kamiyama_md である．
$ 
  vb(F)_i = m_i vb(a)_i
$ <newton>
ここで，$vb(F)_i$は粒子$i$に働く力ベクトル，$m_i$は粒子$i$の質量，$vb(a)_i$は粒子$i$の加速度ベクトルである．
また，粒子間の相互作用をポテンシャル関数によって表すことで相互作用力が計算できる．粒子$i, j$間に作用するスカラーポテンシャルを$phi.alt_(i j)$とすると，粒子$i, j$間に作用する力のベクトル$vb(F)_(i j)$は@potential のように表される．
$ 
  vb(F)_(i j) = - vb(upright(nabla)) phi.alt_(i j) =- (partial phi.alt_(i j)) / (partial vb(r)_(i j))
$ <potential>
ここで，$vb(r)_(i j)$は粒子$i, j$間の相対位置ベクトルである．

== 数値積分法 (velocity Verlet法)

本研究では，MDシミュレーションにおける数値積分法として，velocity Verlet法を用いた．本節ではvelocity Verlet法の理論について述べる．時刻$t$における粒子$i$の位置ベクトル，速度ベクトル，加速度ベクトル，質量，力ベクトルをそれぞれ$vb(r)_i, space vb(v)_i, space vb(a)_i, space m_i, space vb(F)_i$，時間刻みを$Delta t$として，$vb(r)_i (t+Delta t)$を2次の項までTaylor展開すると，@taylor のように表される．
$ 
  vb(r)_i (t+Delta t) = vb(r)_i (t) + Delta t dot(vb(r))_i (t) + (Delta t^2) / 2! dot.double(vb(r))_i (t)
$ <taylor>
ただし，$dot(vb(r))_i (t)$は$vb(r)_i (t)$の1階時間微分，$dot.double(vb(r))_i (t)$は$vb(r)_i (t)$の2階時間微分である．
$vb(v)_i (t+Delta t), space vb(a)_i (t+Delta t)$についても同様にTaylor展開を行なうと，@taylor_v, @taylor_a が得られる．
$ 
  vb(v)_i (t+Delta t) = vb(v)_i (t) + Delta t dot(vb(v))_i (t) + (Delta t^2) / 2! dot.double(vb(v))_i (t)
$ <taylor_v>
$ 
  vb(a)_i (t+Delta t) = vb(a)_i (t) + Delta t dot(vb(a))_i (t) + (Delta t^2) / 2! dot.double(vb(a))_i (t)
$ <taylor_a>
ただし，$dot(vb(v))_i (t), space dot(vb(a))_i (t)$はそれぞれ$vb(a)_i (t), space vb(v)_i (t)$の1階時間微分，
$dot.double(vb(v))_i (t), space dot.double(vb(a))_i (t)$はそれぞれ$vb(a)_i (t), space vb(v)_i (t)$の2階時間微分である．
@taylor_a は@taylor_aa のように変形できる．
$ 
  dot(vb(a))_i (t) = (vb(a)_i (t+Delta t) - vb(a)_i (t)) / (Delta t) - (Delta t) /2 dot.double(vb(a))_i (t)
$ <taylor_aa>
$dot(vb(v))_i (t) = vb(a)_i (t), space dot.double(vb(v))_i (t) = dot(vb(a))_i (t)$であるから，@taylor_aa を@taylor_v に代入すると，
$
  vb(v)_i (t+Delta t) = vb(v)_i (t) + (Delta t) / 2 (vb(F)_i (t+Delta t) + vb(F)_i (t)) / m_i
$ <verlet>
を得る．@taylor と@verlet を用いて，1ステップごとに各原子の位置と速度を更新していく．

#pagebreak()

== GCMC (Grand Canonical Monte Carlo) シミュレーション
=== GCMCの理論<sec_gcmc>

本研究ではHKUST-1へのCO2分子の吸着を再現するためにGCMC (Grand Canonical Monte Carlo, 大正準モンテカルロ) シミュレーションを用いた．Monte Carlo (MC) 法とは，分子の配置を一定の確率法則の下で乱数を用いて作成する確率論的な方法であり，MD法は決定論的である点で異なる．
その中でも，化学ポテンシャル$mu$，体積$V$，温度$T$が規定された大正準集団 (Grand Canonical ensemble) に対するMCシミュレーションがGCMCシミュレーションである．なお，化学ポテンシャルとは@chem_potential で定義され，粒子1個あたりのGibbsの自由エネルギー，または可逆断熱および体積一定条件下で系の粒子を1個追加するために必要なエネルギーを表す@kamiyama_mc．
以上の点を踏まえると，GCMCシミュレーションでは系内の粒子数は計算1ステップごとに変化することに注意されたい．
$ 
  mu = e - T s + P v = ((partial E) / (partial N))_(S, V)
$ <chem_potential>

ただし，$e, s, v$ はそれぞれ粒子1個あたりの内部エネルギー，エントロピー，体積であり，$T, P, E, N, S, V$ はそれぞれ系全体の温度，圧力，内部エネルギー，粒子数，エントロピー，体積である．本研究のGCMCシミュレーションでは，現在多く用いられているMetropolis の方法を使用し，化学ポテンシャル$mu$は常に$mu = 0 "kcal/mol"$としてシミュレーションを行なった．これは，本研究で行なったGCMCシミュレーションでは$mu$の値を変化させた際に，HKUST-1に対するCO2分子の吸着量に変化が見られなかったためである．//TODO: このことについては巻末の付録を参照されたい．

本研究ではHKUST-1を構成する原子を固定した状態でCO2分子の座標をGCMCシミュレーションにより決定する．
GCMCシミュレーションでは，体積$V$の計算系が体積$V_0$の仮想的なガスの供給源 (拡張系) の中に配置されているとし，CO2分子は計算系の領域外では相互作用しないものとする．計算系を含む拡張系全体に存在するCO2分子数を$M$個，計算系中のCO2分子数を$N$個とすると，拡張系全体の大分配関数$Q$は@eq_grand_canonical_partition_function のように表される．
$
  Q (M, V, V_0, T) = sum_(N=0)^(M) (V^N (V_0-V)^(M-N)) / (Lambda^(3M) N! (M-N)!) integral d vb(s)^(M-N) integral d vb(s)^N exp[-beta U(vb(s)^N)]
$<eq_grand_canonical_partition_function>
ここで，$vb(s)$は計算系の一辺の長さを$L$としたときの分子の変位$vb(r)$を$vb(s)=vb(r) "/" L$として正規化したものである．$Lambda$は熱的de Broglie波長と呼ばれ，@eq_de_Broglie のように表される．
$
  Lambda = sqrt(h^2 / (2pi m k_(upright(B)) T))
$<eq_de_Broglie>
ただし，$m$は分子の質量，$h$はPlanck定数を表す．また，$beta$は@eq_beta で定義される．
$
  beta = 1 / (k_(upright(B)) T)
$<eq_beta>
このとき，$V' equiv V_0 - V$とおくと，確率密度$Phi$は@eq_phi で表される．
$
  Phi (vb(s)^M;N) = V^N V'^(M-N) / (Q (M, V, V', T) Lambda^(3M) N! (M-N)!) exp[-beta U(vb(s)^N)]
$<eq_phi>
ここで，仮想的なガス供給源が無限大であるとして，$M -> infinity, space V' -> infinity, space M "/" V' -> rho$とする．理想気体の化学ポテンシャル$mu$は
$
  mu = k_(upright(B)) T ln(Lambda^3 rho)
$
と表されるので，@eq_grand_canonical_partition_function は@eq_grand_canonical_partition_function_2 のように表せる．
$
  Q (M, V, V_0, T) = sum_(N=0)^(infinity) (exp(beta mu N) V^N) / (Lambda^(3N) N!) integral d vb(s)^N exp[-beta U(vb(s)^N)]
$<eq_grand_canonical_partition_function_2>

また，@eq_phi は，@eq_phi_2 のように表せる．
$
  Phi_(mu V T) (vb(s)^M;N) prop sum_(N=0)^(infinity) (exp(beta mu N) V^N) / (Lambda^(3N) N!) exp[-beta U(vb(s)^N)]
$<eq_phi_2>

=== GCMCのアルゴリズム (Metropolisの方法)

GCMCシミュレーションでは，@eq_phi_2 に基づいて，作成した系の新しい状態の受理および棄却を行なう．1ステップあたりのCO2分子の平行移動の試行回数を$N_("translate")$，挿入・削除の試行回数を$N_("exchange")$とし，GCMCのアルゴリズムを以下に示す．

1. 系の中からCO2分子を無作為に1つ選び，乱数を用いて分子に変位を与える．これによって作られた状態は@eq_acc_trans の確率で受理される．この操作を$N_("translate")$回繰り返す．
$
  "acc"(vb(s)->vb(s')) = min(1, exp{-beta [U(vb(s'^N))-U(vb(s)^N)]})
$<eq_acc_trans>

2. 次に分子の挿入・削除を行なう．挿入の場合，分子を追加する座標を無作為に決定し，分子が挿入された状態は@eq_acc_ins の確率で受理される．削除の場合，無作為に削除する分子を決定し，分子が削除された状態を@eq_acc_del の確率で受理する．これらの操作は$N_("exchange")$回繰り返され，分子の挿入・削除は等確率で行なわれる．
$
  "acc"(N->N+1) = min(1, V/(Lambda^3(N+1))exp{beta[mu-U(N+1)+U(N)]})
$<eq_acc_ins>
$
  "acc"(N->N+1) = min(1, (Lambda^3N)/V exp{-beta[mu+U(N-1)-U(N)]})
$<eq_acc_del>

手順1, 2を1ステップとして計算を行なう．本研究では，$N_("translate"), space N_("exchange")$はともに100とした．これは，どの計算条件についてもCO2分子数が100程度であり，計算負荷と結果の妥当性の両方を検証し，適当であると考えたためである．また，GCMCシミュレーションでは，最初に5000ステップの緩和計算を行なった後に5000ステップの本計算を行なった．

CO2分子の吸着量を決定する物理量として，主に温度，圧力，そしてフガシティ係数 (fugacity coefficient) があり，GCMCシミュレーションを行なう際にはこれらを設定する必要がある．実際に設定した温度，圧力，フガシティ係数については，@sec_fugacity_coeff を参照されたい．なお，ここでの圧力は計算系の圧力ではなく，仮想的なガス供給源の圧力を表す．また，フガシティ係数$phi.alt$は@fugacity_coeff で定義され，その気体が理想気体からどの程度乖離しているかを表す．
$
  phi.alt = f / P
$<fugacity_coeff>
ただし，$f$はフガシティ，$P$は理想分圧である．フガシティ$f$は逃散能や散逸能とも呼ばれ，圧力の単位をもつ．//TODO: フガシティおよびフガシティ係数については巻末の付録を参照されたい．

=== 試行受理率 (acceptance rate) <sec_acc_rate>

GCMCシミュレーションの妥当性を評価する値の1つとして，試行受理率 (acceptance rate) がある．本研究では，並進移動・分子の挿入・分子の削除のそれぞれの試行に対して，試行受理率を@eq_acc_rate として定義した．
$
  "acceptance rate" = N_("success") / N_("attempt")
$<eq_acc_rate>
ただし，$N_("success"), space N_("attempt")$はそれぞれ全ステップにおける総試行成功回数と総試行回数である．

#pagebreak()

== 計算の高速化手法

MDまたはGCMCシミュレーションにおいて，すべての粒子の組み合わせについて相互作用力の計算を行なうことは計算負荷が大きく，多くの時間を要する．そこで，本研究ではカットオフと粒子登録法 (book keeping method) を用いることで計算にかかる時間を短縮した．カットオフとは粒子間の距離がカットオフ距離以上離れている場合には相互作用を計算しない手法である．これにより，相互作用を計算する原子・分子の組合せを大幅に少なくすることができる．しかし，カットオフを導入するだけではすべての粒子の組み合わせについて粒子間距離を計算することになる．そこで，粒子登録法により，すべての粒子についてカットオフ距離内に入り得る粒子のIDを一定のステップの間保持することで粒子間距離を計算する組み合わせを大幅に少なくした．

本研究では@sec_potential で述べるvan der Waals力 (12-6 Lennard-Jonesポテンシャル) ，およびCoulomb力を求める計算について，ともにカットオフ距離を$12.0 " " angstrom$ としている．また，粒子登録半径は$16.0 " " angstrom$として計算し，粒子登録のリストは1ステップ毎に更新するが，すべての粒子が1つも$4.0 " " angstrom$以上動かなかった場合は更新されない．
// variable skin equal 2.0*${displace}*${neighbor_interval}
// neighbor ${skin} bin
// neigh_modify every ${neighbor_interval} delay 0 check yes 

== 単位設定

MDまたはGCMCシミュレーションでは，ナノスケール ($times 10^(-9)$) の物理量を用いて計算する必要がある．しかし，計算機の計算精度には限界があるため，数値計算を行う上で丸め誤差による桁落ちが生じることにより計算精度が大きく下がる恐れがある．これを防ぐため，本研究では各物理量に対して@unit のように単位設定を行なった@lammps_doc．

#linebreak()

#tab(
  table(
    columns: 2,
    table.header(
      [Unit Type], [Unit]
    ),
    "質量", "g/mol",
    "距離", $angstrom$,
    "時間", $"fs"$,
    "エネルギー", $"kcal/mol"$,
    "圧力", $"atm"$,
    "電荷", $upright(e)$
  ),
  caption: "Setting of units."
)<unit>

#pagebreak()

== 温度制御法

本研究ではNosé-Hoover法によって系の温度制御を行なった．
この手法では，計算系と熱浴を合わせた拡張系においてミクロカノニカルアンサンブル ($N, V, E$ 一定の統計集団) が得られると仮定し，熱浴の温度を制御することで計算系のカノニカルアンサンブル ($N, V, T$ 一定の統計集団) を得る．ただし，$N$は系内の分子数，$V$は系の体積，$E$は系の内部エネルギー，$T$は系の温度である．

ミクロカノニカルアンサンブルではハミルトニアン$H_0$は@eq_nve_hamiltonian のように表される．
$
  H_0 = sum_(i=1)^N vb(p)_i^2 / (2m_i) + U(r)
$<eq_nve_hamiltonian>

ただし，$vb(p)_i$は粒子$i$の運動量，$m_i$は粒子$i$の質量，$U(r)$は系のポテンシャルエネルギーである．

Noséの熱浴では，熱浴の自由度$𝑠$を追加し運動量$vb(p)_i$と時間ステップ$Delta t$をそれぞれ@eq_nose_scale1 ，@eq_nose_scale2 のようにスケールする．
$
  vb(p)_i = vb(p)'_i / s
$<eq_nose_scale1>
$  
  Delta t = (Delta t') / s
$<eq_nose_scale2>

ここで，$vb(p)'$を仮想運動量，$Delta t'$を仮想時間と呼ぶ．そして，拡張系のハミルトニアン$H_N$を@eq_exp_hamiltonian のように導入する．
$
  H_N = sum_(i=1)^N vb(p)_i^2 / (2m_i) + U(r) + P_s^2/(2Q) + upright(g) k_upright(B) T_0 ln(s)
$<eq_exp_hamiltonian>
$P_s$は能勢の熱浴の自由度$𝑠$に対する正準共役な運動量，$Q$は熱浴の質量を表し，$upright(g)$は系の自由度を表すパラメータ，$k_upright(B)$はBoltzmann定数，$T_0$は設定温度である．
$r, space vb(p)', space s, space P_s$を正準変数として@eq_exp_hamiltonian から正準方程式を計算し，仮想時間を現実時間に置き換えると，
$
  dot(vb(r)) = vb(p)_i / m_i
$<eq_transform1>
$
  dot(vb(p))_i = vb(F)_i - dot(s)/s vb(p)_i
$<eq_transform2>
$
  dot(s) = s P_s/Q
$<eq_transform3>
$
  dot(P)_s = sum_(i=1)^N vb(p)_i^2 / m_i - upright(g) k_upright(B) T_0
$<eq_transform4>

となる．ここに，@eq_zeta で表されるHooverによる熱浴$zeta$を導入する．
$
  zeta = 1/s (d s) /(d t) = P_s / Q
$<eq_zeta>
$zeta$を用いて@eq_transform1 ～ @eq_transform4 を変形すると，
$
  dot(vb(r))_i = vb(p)_i / m_i
$
$
  dot(vb(p))_i = vb(F)_i - zeta vb(p)_i
$
$
  dot(zeta) = 1/Q (sum_(i=1)^N vb(p)_i^2 / m_i - upright(g) k_upright(B) T_0)
$
となり，Nosé-Hooverの熱浴が得られる．

#pagebreak()

== 境界条件

分子シミュレーションにおいて系の領域は有限であるため，適切な境界条件 (boundary conditions) を設定する必要がある．本研究ではMDおよびGCMCシミュレーションの両方で周期境界条件 (periodic boundary conditions : PBCs) を適用した．周期境界条件とは@fig_pbc で示すように，基本セルと呼ばれる計算対象のセルの周囲に基本セルを模した仮想的なセルを配置することで，ある面から基本セルを飛び出した粒子が反対側の仮想セルより再び基本セルに流入する境界条件である．これにより，基本セルを計算する分の計算負荷のみでバルク系を再現できる．

#linebreak()

#img(
  image("Figures/PBC.svg", width: 50%),
  caption: [Concept of periodic boundary conditions.],
) <fig_pbc>

#pagebreak()

== 計算モデルとHKUST-1の構造について<sec_hkust>

本研究で用いた計算モデルを@fig_model に示す．系の大きさは$26.343" "angstrom times 26.343" "angstrom times 26.343" "angstrom$であり，吸着媒となるHKUST-1の単位格子と，吸着質であるCO2分子が配置されている．茶色の粒子は銅原子，赤色の粒子は酸素原子，灰色の粒子は炭素原子，白色の粒子は水素原子を表しており，本論文では，それぞれの原子をCu原子, O原子, C原子, H原子と表記する．

#linebreak()

#img(
  image("Figures/hkust-1.jpg", width: 60%),
  caption: [Simulation model: HKUST-1 and CO2 molecules.],
) <fig_model>

#linebreak()

HKUST-1の単位格子中にはCu原子が48個，O原子が192個，C原子が288個，H原子が96個含まれており，HKUST-1の初期配置はChuiらの研究@chui1999 に基づいて作成されたものを使用している．ただし，@tab_distinction_of_carbon  に示すようにHKUST-1中のC原子はその結合している原子によって区別される．また，@fig_distinction_of_oxygen に示すようにO - Cu - Oの角度がO(1) - Cu - O(1)，O(1) - Cu - O(2)，O(2) - Cu - O(2) の3種類存在することから，O原子についても2種類に区別される．

#linebreak()

#tab(
  table(
    columns: 2,
    table.header(
      [Atom Type], [Description]
    ),
    "C(1)", "カルボキシ基の炭素原子",
    "C(2)", "ベンゼン環中の炭素原子かつカルボキシ基に接続する原子",
    "C(3)", "ベンゼン環中の炭素原子かつ水素原子に接続する原子"
  ),
  caption: "Type distinction of carbon atoms in HKUST-1."
)<tab_distinction_of_carbon>

#linebreak()

#img(
  image("Figures/distinction_of_oxygen.svg", width: 75%),
  caption: [Type distinction of oxygen atoms in HKUST-1. ],
) <fig_distinction_of_oxygen>

#linebreak()

さらに，Liらの研究@Li2021 をはじめとして，一般的にHKUST-1の吸着サイト (Cage) は3つあるとされているが  ，本研究では周期境界条件を適用したシミュレーションを行なうため，実質的に@fig_adsorption_site で示す2つの吸着サイト: Lケージ (Large Cage) およびSケージ (Small Cage) を考えることとし，Sケージ内に入るための小孔を窓 (window) と呼ぶ．

#img(
  image("Figures/adsorption_cages.svg", width: 65%),
  caption: [Adsorption Cages in HKUST-1. ],
) <fig_adsorption_site>

#pagebreak()

== ポテンシャル関数 (HKUST-1) <sec_potential>

本研究では，HKUST-1に対してZhaoらによる力場@zhao2011 を適用した．使用したのは以下の@pair～@improper_potential である．

=== 非結合相互作用 (pair) <sec_pair>

非結合相互作用であるvan der Waals力とCoulomb力を表現するポテンシャルとして，本研究では12-6 Lennard-Jonesポテンシャルに粒子間のCoulomb力の項を加えた@pair を使用した．
$
  E_("pair") = 4 epsilon_(i j) {(sigma_(i j)/r_(i j))^12 - (sigma_(i j)/r_(i j))^6} + (q_i q_j) / r_(i j)
$ <pair>

ここで，$sigma_(i j), space epsilon_(i j)$は粒子$i, j$間における12-6 Lennard-Jonesポテンシャルのパラメータであり，$sigma_(i j)$は長さ，$epsilon_(i j)$はエネルギーの次元を持つ．
$r_(i j)$は粒子$i, j$間の相対原子間距離であり，HKUST-1分子内およびHKUST-1分子内原子とCO2分子内原子での異種原子間の相互作用については@geometric1，@geometric2 として計算を行なう．
$
  sigma_(i j) &= sqrt(sigma_(i i) sigma_(j j))
  
$ <geometric1>
$
  epsilon_(i j) &= sqrt(epsilon_(i i) epsilon_(j j))
$ <geometric2>

ここで，$sigma_(i i), space epsilon_(i i)$は同種粒子間のパラメータである．
また，$q_i, space q_j$はそれぞれ粒子$i, space j$がもつ電荷を表し，@pair 第2項のCoulombの法則についてはCGS静電単位系を用いている．
非結合相互作用によるパラメータを@hkust_pair に示す．

#linebreak()

#tab(
  table(
    columns: 4,
    table.header(
      [Atom Type], [$q " "[upright(e)]$], [$epsilon "[kcal/mol]"$], [$sigma [angstrom]$]
    ),
    "Cu", "1.098", "0.005", "3.114",
    "O", "-0.665", "0.096", "3.033",
    "C", "0.778", "0.095", "3.473",
    "H", "0.109", "0.015", "2.846",
  ),
  caption: [Potential parameters of HKUST-1 for nonbonded interaction @zhao2011.]
)<hkust_pair>

#pagebreak()

=== 2体間結合ポテンシャル (bond)

@fig_bond のように，結合している2原子間の相互作用を表現するポテンシャルとして，本研究では@bond_potential で表されるMorseポテンシャルを用いた．
$
  E_("bond") = D[1-e^(-alpha (b-b_0))]^2
$<bond_potential>
ここで，$D$はエネルギーの次元をもつパラメータであり，ポテンシャルの谷の深さを表す．$alpha$は$[upright(m)^(-1)]$の次元をもつパラメータであり，ポテンシャルの谷の幅を表す，$b$は原子間距離，$b_0$はMorseポテンシャルによるエネルギーが$0$になる原子間距離である．Morseポテンシャルのパラメータを@tab_morse に示す．

#linebreak()

#tab(
  table(
    columns: 4,
    table.header(
      [Bond Type], [$D "[kcal/mol]"$], [$alpha [Å^(-1)]$], [$b_0 "[Å]"$]
    ),
    "Cu - O", "85.769", "2.85", "1.969",
    "O - C(1)", "135.0", "2.00", "1.260",
    "C(1) - C(2)", "87.84", "2.00", "1.456",
    "C(2) - C(3)", "120.0", "2.00", "1.355",
    "C(3) - H", "116.0", "1.77", "0.931",
  ),
  caption: [Potential parameters of HKUST-1 for bond interaction (Morse potential) @zhao2011.]
)<tab_morse>

#linebreak()

#img(
  image("Figures/bond_blender.png", width: 100%),
  caption: [Concept of bond. ],
) <fig_bond>

#pagebreak()

=== 3体間角度ポテンシャル (angle)

@fig_angle のように，隣接して結合している3原子間の成す角度による作用を表現するポテンシャルとして，本研究では@angle_potential で表されるHarmonic angleポテンシャルを用いた．
$
  E_("angle") = K_theta (theta-theta_0)^2
$<angle_potential>
ここで，$K_theta$はエネルギーの次元をもつパラメータであり，ポテンシャルの谷の幅を表す．$theta$は2つの結合がなす角，$theta_0$はこのポテンシャルによるエネルギーが$0$となる角度を表す．
Harmonic angleポテンシャルのパラメータを@tab_angle に示す．

#linebreak()

#tab(
  table(
    columns: 3,
    table.header(
      [Angle Type], [$K_theta space ["kcal/(mol" dot "rad"^2)]$], [$theta_0 space [deg]$]
    ),
    "O(1) - Cu - O(1)", "50.160", "170.2",
    "O(2) - Cu - O(2)", "50.160", "170.2",
    "O(1) - Cu - O(2)", "12.000", "90.0",
    "Cu - O - C(1)", "40.470", "127.5",
    "O - C(1) - O", "145.000", "128.5",
    "O - C(1) - C(2)", "54.495", "116.2",
    "C(1) - C(2) - C(3)", "34.680", "119.9",
    "C(3) - C(2) - C(3)", "90.000", "120.1",
    "C(2) - C(3) - C(2)", "90.000", "119.9",
    "C(2) - C(3) - H", "37.000", "120.0"
  ),
  caption: [Potential parameters of HKUST-1 for angle interaction (Harmonic angle potential) @zhao2011.]
)<tab_angle>

#linebreak()

#img(
  image("Figures/angle_blender.png", width: 75%),
  caption: [Concept of angle.],
) <fig_angle>

#pagebreak()

=== 4体間二面角ポテンシャル (dihedral torsion)

@fig_dihedral のように隣接して結合した4原子間が形成する立体的なねじれによる相互作用を表現するポテンシャルとして，本研究では@torsion_potential で表されるHarmonic dihedralポテンシャルを用いた．
$
  E_("torsions") = K_phi [1+d cos(n phi)]
$<torsion_potential>
@fig_dihedral の4つの隣接する原子では，左側の3原子と右側の3原子を用いて2つの平面を定義することができ，@torsion_potential 中の$phi$はその2つの面がなす角を表す．また，$K_phi$はエネルギーの次元をもつパラメータであり，ポテンシャルの谷の深さを表す．$d, space n$は無次元のパラメータである．Harmonic dihedralポテンシャルのパラメータを@tab_dihedral に示す．

#linebreak()

#tab(
  table(
    columns: 4,
    table.header(
      [Dihedral torsion Type], [$K_phi "[kcal/mol]"$], [$d$], [$n$]
    ),
    "Cu - O - C(1) - C(2)", "3.00", "-1", "2",
    "Cu - O - C(1) - O", "3.00", "-1", "2",
    "C(2) - C(3) - C(2) - C(3)", "3.00", "-1", "2",
    "C(1) - C(2) - C(3) - C(2)", "3.00", "-1", "2",
    "C(1) - C(2) - C(3) - H", "3.00", "-1", "2",
    "C(3) - C(2) - C(3) - H", "3.00", "-1", "2",
    "O - C(1) - C(2) - C(3)", "2.50", "-1", "2"
  ),
  caption: [Potential parameters of HKUST-1 for dihedral torsion interaction @zhao2011.]
)<tab_dihedral>

#linebreak()

#img(
  image("Figures/dihedral_blender.png", width: 75%),
  caption: [Concept of dihedral torsion.],
) <fig_dihedral>

#pagebreak()

=== 4体間二面角ポテンシャル (improper torsion)

@fig_improper のようにY字型に結合した4原子が形成する立体的なねじれによる相互作用を表現するポテンシャルとして，本研究では@improper_potential で表されるCVFF (Consistent Valence Force Field) ポテンシャルを用いた．
$
  E_("improper") = K_chi [1+d cos(n chi)]
$<improper_potential>
中心の原子を含む3原子と，中心の原子を除いた外側の3原子を用いて，それぞれで平面が定義することができ，@improper_potential 中の$chi$はその2つの平面のなす角を表す．また，$K_chi$はエネルギーの次元をもつパラメータであり，ポテンシャルの谷の深さを表す．$d, space n$は無次元のパラメータである．CVFFポテンシャルのパラメータを@tab_improper に示す．

#linebreak()

#tab(
  table(
    columns: 4,
    table.header(
      [Improper torsion Type], [$K_chi "[kcal/mol]"$], [$d$], [$n$]
    ),
    "H - C(3) - C(2) - C(2)", "0.37", "-1", "2",
    "C(1) - C(2) - C(3) - C(3)", "10.0", "-1", "2",
    "C(2) - C(1) - O - O", "10.0", "-1", "2"
  ),
  caption: [Potential parameters of HKUST-1 for improper torsion interaction @zhao2011.]
)<tab_improper>

#linebreak()

#img(
  image("Figures/improper_blender.png", width: 75%),
  caption: [Concept of improper torsion.],
) <fig_improper>

#pagebreak()

== ポテンシャル関数 (CO2)
=== 力場モデルの選択

現在，多くの分子シミュレーションにおいて，TraPPE (Transferable Potentials for Phase Equilibria) ，EPM 2 (Elementary Physical Model 2) などがCO2分子の力場モデルとして用いられている．一般的にそれぞれのモデルには長所・短所が存在し，シミュレーションを行なう温度や圧力などの環境によって適切なモデルを用いる必要がある．
// まず，上に挙げたTraPPE，EPM 2および本研究で用いたEPM 2 (flexible) モデルの概要を述べる．

// EPM 2モデルは1995年に発表され，従来のEPMモデルを改良し，臨界状態での特性を予測するために開発された力場モデルである．このモデルでは，気液共存状態における密度について，実験値にほぼ一致する結果を得ることができる@Harris1995．C - O間の距離とO - C - Oの結合角度は実験値である$1.163" "Å, " " 180 degree$にそれぞれ固定されており，柔軟な結合角を持たせたフレキシブルモデルと剛体モデルの間では，臨界温度と気液共存時の特性の両方において同様な結果を示したことが報告されている．

// TraPPEモデルは2001年に発表され，様々な化合物，状態点，組成において高い精度で熱物性の予測ができるとされている力場モデルである@TraPPE．EPM 2モデルでは，n-アルカン + CO2混合系の相図において，非対称相互作用に特別な結合規則を適用しない限り，定性的な表現しかできないとされており，これを修正するため，n-アルカンのTraPPE-EH (Explicit Hydrogen) モデルと一致するように開発されたモデルがTraPPEである@Potoff2001．C - O間の距離とO - C - Oの結合角度は実験値である$1.16" "angstrom, " " 180 degree$にそれぞれ固定されており，フレキシブルモデルと剛体モデルの間では同様な相平衡特性を示したことが報告されている．

本研究ではCO2分子のモデルとして，ThuatらによるEPM 2 (flexible) モデルを用いてシミュレーションを行なった．EPM 2 (flexible) モデルはC - O 間の結合距離とO - C - O結合角を$180 degree$に固定せず，それぞれMorseポテンシャルと調和ポテンシャルを用いて記述したモデルである．このモデルでは剛体のEPM 2モデルと比較して，高温域での熱伝導率の予測精度が向上した一方，熱伝導率の過大評価をしたことが報告されている@Trinh2014．このモデルを使用することで，剛体モデルに比べてより正確な吸着現象を再現できると考えられる．

=== 非結合相互作用 (pair)

@tab_epm2 に@pair で示した12-6 Lennard-JonesおよびCoulombポテンシャルのパラメータを示す．

#linebreak()

#tab(
  table(
    columns: 4,
    table.header(
      [Atom Type], [$q$ [e]], [$epsilon$ [kcal/mol]], [$sigma$ [Å]]
    ),
    "C", $0.6512$, $0.055898$, $2.757$,
    "O", $-0.3256$, $0.159984$, $3.033$
  ),
  caption: "Potential parameters of CO2 for nonbonded interaction."
)<tab_epm2>

#linebreak()

=== 2体間結合ポテンシャル (bond)

@co2_bond に@bond_potential で示したMorseポテンシャルのパラメータを示す．

#linebreak()

#tab(
  table(
    columns: 4,
    table.header(
      [Bond Type], [$D "[kcal/mol]"$], [$alpha [Å^(-1)]$], [$b_0 "[Å]"$]
    ),
    "C - O", "481.776", "2.35", "1.149"
  ),
  caption: "Potential parameters of CO2 for bond interaction."
)<co2_bond>

#linebreak()

=== 3体間角度ポテンシャル (angle)

@co2_angle に@angle_potential で示した調和ポテンシャルのパラメータを示す．

#linebreak()

#tab(
  table(
    columns: 3,
    table.header(
      [Angle Type], [$K_theta space ["kcal/(mol" dot "rad"^2)]$], [$theta_0 space [deg]$]
    ),
    "O - C - O", "147.7", "180.0"
  ),
  caption: "Potential parameters of CO2 for angle interaction."
)<co2_angle>

== 吸着等温線 (adsorption isotherm)

吸着等温線 (adsorption isotherm) はMOFの吸着性能を示すために実験，シミュレーションの両方で一般的に用いられている．本研究では吸着量に関わるフガシティ係数$phi.alt$を適切な値に調整することでAloufiらの実験値による吸着等温線@Aloufi2024 に近づけた．なお，HKUST-1に対するCO2吸着量 (uptake) はHKUST-1単位質量 [g]あたりに吸着したCO2の物質量 [mmol]とし，計算には@eq_uptake を用いた．
$
  "uptake" &= 1000 times N_("CO2")/N_(upright(A)) times  times 1/m_"HKUST-1"\
  &= 1000 times N_("CO2")/N_(upright(A)) times 1/(M_("HKUST-1") times display(1/N_(upright(A))))\
  &= 1000 times N_("CO2")/M_("HKUST-1") "[mmol/g]"
$<eq_uptake>
ただし，$N_(upright(A))$はAvogadro数，$N_("CO2")$は吸着したCO2分子数，$m_("HKUST-1")$はHKUST-1の質量，$M_("HKUST-1")$はHKUST-1の分子量である．ここで，HKUST-1にはCu原子が48個，O原子が192個，C原子が288個，H原子が96個含まれることから，$M_("HKUST-1")$は@eq_M_HKUST-1 により計算できる．
$
  M_("HKUST-1") = 48M_("Cu")+192M_(upright(O))+288M_(upright(C))+96M_(upright(H)) = 9678 "[g/mol]"
$<eq_M_HKUST-1>
ただし，$M_("Cu")," " M_(upright(O))," " M_(upright(C))," " M_(upright(H))$はそれぞれCu, O, C, H原子の原子量である．

== 動径分布関数 (Radial Distribution Function : RDF)

動径分布関数 (Radial Distribution Function : RDF) $g(r)$は@eq_rdf で定義され，ある粒子から距離$r$の位置に特定の粒子が存在する度合いを1を基準として表したものである．

$
  g(r) = (angle.l n(r) angle.r) / (rho dot 4pi r^2 dot d r)
$<eq_rdf>
ただし，$angle.l n(r) angle.r$ は基準粒子から半径$[r, space r+d r]$の球殻内にある粒子の数の時間平均，$rho$は系全体の平均数密度を表す．

== 時間平均のとり方について

本研究ではLAMMPSのfix ave/timeコマンドにより，データの時間平均を記録した@lammps_avetime ．このコマンドではどれほどの頻度で平均値を計算するかを示す変数として$N_"every"," " N_"repeat", " " N_"freq"$が用いられる．例えば，$N_"every"=2," " N_"repeat"=6, " " N_"freq"$=100と設定すれば，$100" "(=N_"freq")$ ステップごとに平均値を算出することになり，$6" "(=N_"repeat")$ 個のステップ数$90, space 92, space 94, space 96, space 98, space 100$での平均値が100ステップ目の平均値となる．以降も同様に，200ステップ目の平均値にはステップ数$190, space 192, space 194, space 196, space 198, space 200$の平均値が，300ステップ目の平均値にはステップ数$290, space 292, space 294, space 296, space 298, space 300$の平均値が用いられる．

本研究では基本的に$N_"every"=1," " N_"repeat"=10, " " N_"freq"$=10と設定してシミュレーションを行なった．これは10ステップごとに時間平均を計算することを意味し，10ステップ目にはステップ数$1, space 2, space 3, space ..., space 10$の平均値が用いられ，20ステップ目にはステップ数$11, space 12, space 13, space ..., space 20$の平均値が用いられ，... というように計算される．

#pagebreak()

== 計算手順

本研究では，GCMCシミュレーションおよびMDシミュレーションは全てLAMMPS (Large-scale Atomic/Molecular Massively Parallel Simulator) を用いて行なう．

=== GCMCシミュレーションの妥当性の確認<sec_validity>

本研究では，GCMCシミュレーションの妥当性を確認するために，系内の温度とCO2分子数，および@sec_acc_rate で述べた試行受理率を用いる．また，GCMCシミュレーションの最終位置情報を用いてMDシミュレーションを行ない，それぞれの平衡状態におけるRDFを比較することでGCMCシミュレーションが正しく行なわれているかを確認する．

MDシミュレーションでは，GCMCシミュレーションで得られた原子の最終位置を初期配置として，CO2分子の吸着平衡状態を再度作成する．まず，Nosé-Hoover法を用いて，系内の全分子を0.2 ns間，GCMCシミュレーションと同様の温度に温度制御を行なう．その後，温度制御を解除し，1.8 ns間の緩和計算を行なった後，ミクロカノニカルアンサンブルの状態で2.0 ns間の本計算を行なう．

=== フガシティ係数の決定 <sec_fugacity_coeff>

本研究では，複数の設定温度$T$や設定圧力$P$で解析を行なうため，$(T, space P)$の組み合わせに対して適切なフガシティ係数$phi.alt$を設定する必要がある．そこで，$T=273, " " 298, " "353 " " upright(K)$，$P=1," " 2," " 3," " 4," " 5," " 6," " 7" bar"$とし，$(T, space P)$の組み合わせに対して$phi.alt$を変化させて吸着等温線を描画する．その後，各$(T, space P)$において吸着量が実験値に近い$phi.alt$をフガシティ係数として採用する．

=== HKUST-1に対するCO2の吸着平衡状態の作成 <sec_procedure_gcmc>

@sec_fugacity_coeff で採用したフガシティ係数$phi.alt$を用いて，ポテンシャルエネルギーおよびRDFの解析を行なう．ポテンシャルエネルギーの分布の解析では，粒子1個あたりがもつポテンシャルエネルギーについてその個数分布を調査した．RDFの解析では，HKUST-1内の各原子Cu，O(1)，O(2)，C(1)，C(2)，C(3)，Hを基準として，CO2分子中のC原子に対するRDFを調査した．

なお，CO2分子のポテンシャルエネルギーの分布にはGCMCシミュレーションの本計算におけるアンサンブル全てにおける原子の座標を使用し，RDFには本計算全体のアンサンブル平均を用いた．HKUST-1内原子のポテンシャルエネルギーの分布には@sec_validity で示したMDシミュレーションの本計算における10000ステップごとの原子の座標を使用し，RDFには本計算全体の時間平均を用いた．

= 結果・考察

#pagebreak()

== GCMCシミュレーションの妥当性
=== 系内温度とCO2分子数 <sec_temp_ke_Ngas>

GCMCシミュレーションの本計算におけるCO2分子の温度変化を@fig_temp_273K ～ @fig_temp_353K に，CO2分子数の変化を@fig_Ngas_273K ～ @fig_Ngas_353K に示す．なお，どちらも設定温度$T=273, " "298, " "353 " "upright(K)$のそれぞれについて示している．ただし，図中の赤線は各値のアンサンブル平均を示しており，フガシティ係数$phi.alt$については@sec_adsorption_isotherm で述べる吸着等温線の実験値に近いものを選択している．

@fig_temp_273K ～ @fig_temp_353K から，設定温度が高いほど温度のゆらぎは大きくなることが分かる．特に353 Kの場合にはゆらぎはかなり大きく，平均値も設定温度から大きく離れている．
この原因として，@fig_Ngas_273K ～ @fig_Ngas_353K に示したCO2分子数が温度上昇に伴って少なくなることが考えられる．平均CO2分子数は，$T=273 space upright(K)$では最大150個程度，$T=298 space upright(K)$では最大120個程度，$T=353 space upright(K)$では最大75個程度と温度上昇に伴い少なくなっており，これによりCO2分子数が少なくなるほどCO2分子1個あたりの温度が平均温度に強い影響を及ぼすと考えられる．

また，@fig_temp_273K，@fig_temp_298K では高圧になるほど温度のゆらぎが小さくなる傾向が見られる．これも同様に，@fig_Ngas_273K ，@fig_Ngas_298K から高圧になるにつれ平均CO2分子数は増加するため，CO2分子1個あたりの温度が平均温度に及ぼす影響が小さくなるため，ゆらぎが小さくなったと考えられる．

また，@fig_temp_273K ～ @fig_temp_353K の温度に比べ，CO2分子数のゆらぎは小さく，GCMCシミュレーションの特性上，CO2分子数を一定値に収束させることは難しいため，吸着分子数としてはアンサンブル平均を用いることが妥当であると考えられる．

#linebreak()

#img(
  image("Figures/temperature_T=273K_revised.svg", width: 100%),
  caption: [Temperature of CO2 during GCMC simulation at $ " "T=273 space upright(K)$.],
) <fig_temp_273K>

#img(
  image("Figures/temperature_T=298K_revised.svg", width: 100%),
  caption: [Temperature of CO2 during GCMC simulation at $ " "T=298 space upright(K)$.],
) <fig_temp_298K>

#linebreak()

#img(
  image("Figures/temperature_T=353K_revised.svg", width: 100%),
  caption: [Temperature of CO2 during GCMC simulation at $ " "T=353 space upright(K)$.],
) <fig_temp_353K>

#pagebreak()

// #img(
//   image("Figures/ke_T=273K_revised.svg", width: 100%),
//   caption: [Kinetic energy of CO2 during GCMC simulation at $ " "T=273 upright(K)$.],
// ) <fig_ke_273K>

// #linebreak()

// #img(
//   image("Figures/ke_T=298K_revised.svg", width: 100%),
//   caption: [Kinetic energy of CO2 during GCMC simulation at $ " "T=298 upright(K)$.],
// ) <fig_ke_298K>

// #pagebreak()

// #img(
//   image("Figures/ke_T=353K_revised.svg", width: 100%),
//   caption: [Kinetic energy of CO2 during GCMC simulation at $ " "T=353 upright(K)$.],
// ) <fig_ke_353K>

// #linebreak()

#img(
  image("Figures/Ngas_T=273K_revised.svg", width: 100%),
  caption: [The number of CO2 molecules during GCMC simulation at $ " "T=273 space upright(K)$.],
) <fig_Ngas_273K>

#linebreak()

#img(
  image("Figures/Ngas_T=298K_revised.svg", width: 100%),
  caption: [The number of CO2 molecules during GCMC simulation at $ " "T=298 space upright(K)$.],
) <fig_Ngas_298K>

#pagebreak()

#img(
  image("Figures/Ngas_T=353K_revised.svg", width: 100%),
  caption: [The number of CO2 molecules during GCMC simulation at $ " "T=353 space upright(K)$.],
) <fig_Ngas_353K>

#pagebreak()

=== 試行受理率 (acceptance rate)

GCMCシミュレーションの本計算における試行受理率 (acceptance rate) を各設定温度$T=273, " "298, " "353 " "upright(K)$について@fig_acc_273K ～ @fig_acc_353K に示す．ただし，黒線，青線，赤線はそれぞれ並進移動，分子の挿入，分子の削除の試行受理率を表している．

@fig_acc_273K ～ @fig_acc_353K から，どの場合についても試行受理率は20%を下回っているが，一般的に試行受理率はシミュレーションごとに様々であるため，具体的な数値が妥当であるかを検証することは難しい．したがって，本節では定性的な特徴に限って考察を行なう．

まず，@fig_acc_273K ～ @fig_acc_353K のどの場合についても試行受理率は収束しており，分子の挿入と削除は同じ試行受理率で行なわれたことが確認できる．このことは@sec_temp_ke_Ngas のCO2分子数にも関連して，おおよそCO2分子の交換が平衡状態に達し，吸着平衡状態になったといえる．

また，並進移動と分子の交換の両方で，高圧になるほど試行受理率が低下する傾向がみられる．@sec_temp_ke_Ngas での高圧になるほど吸着CO2分子数が多くなることを考えると，これは高圧になるに従って，CO2分子の数密度が大きくなり，CO2分子の並進移動や交換が行なわれにくくなることが原因であると考えられる．

// さらに，どの場合についても初めの数ステップで急な増加または減少が起こっている．本研究でのGCMCシミュレーションでは本計算の前に5000ステップの緩和計算を行なっているため，このような現象は通常起こらないと考えられる．これは緩和計算と本計算とでLAMMPSコマンドであるfix gcmcを分けていることに起因していると考えられるが，具体的な理由の特定には至っていない．

#linebreak()

#img(
  image("Figures/acc_T=273K_revised.svg", width: 100%),
  caption: [Acceptance rate during GCMC simulation at $ " "T=273 space upright(K)$.],
) <fig_acc_273K>

#img(
  image("Figures/acc_T=298K_revised.svg", width: 100%),
  caption: [Acceptance rate during GCMC simulation at $ " "T=298 space upright(K)$.],
) <fig_acc_298K>

#linebreak()

#img(
  image("Figures/acc_T=353K_revised.svg", width: 100%),
  caption: [Acceptance rate during GCMC simulation at $ " "T=353 space upright(K)$.],
) <fig_acc_353K>

#pagebreak()

=== MDシミュレーションでの平衡状態におけるRDFとの比較

本節では，GCMCとMDシミュレーションの両方で同じ設定温度・数密度の下，吸着平衡状態を作成し，それらのRDFを比較した．MDシミュレーションを行なうにあたっては，初期状態をGCMCシミュレーションにより得られた最終位置データとし，GCMCシミュレーションでの設定温度$T$と同じ温度で0.2 nsの温度制御を行なった後，1.8 nsの緩和計算を行ない，2.0 nsの本計算を行なった．

@fig_rdf_vs_MD_273K_0.5_7bar ～ @fig_rdf_vs_MD_353K_1.5_7bar に，それぞれ$T=273, " " 298, " " 353 " " upright(K)$におけるGCMCとMDでの吸着平衡状態におけるRDFの比較を示す．ただし，どの設定温度についても設定圧力$P=7 "bar"$のデータを用いた．これは，高圧であるほど吸着分子数が増えるため，より正確なRDFが得られると考えたためである．@fig_rdf_vs_MD_273K_0.5_7bar ～ @fig_rdf_vs_MD_353K_1.5_7bar より，GCMCとMDシミュレーションの間でRDFの形状には大きな差がないことが分かり，どちらのシミュレーション手法においてもほぼ同一の吸着平衡状態が得られると考えられる．

なお，MDシミュレーションに比べてGCMCシミュレーションのRDFの変動が激しいことに関しては，サンプルデータの少なさが原因であると考えられる．MDシミュレーションにおいては本計算4 nsの時間平均，すなわち時間刻みが0.5 fsであることを考えると，$8 times 10^6$ステップのアンサンブル平均であるのに対し，GCMCにおいては本計算5000ステップのアンサンブル平均となっている．

#linebreak()

#img(
  image("Figures/RDF_MD_T=273K_phi=0.5_P=7bar.svg", width: 90%),
  caption: [Comparison of radial distribution function between GCMC and MD simulation \ at $ " "T=273" "upright(K)," "phi.alt=0.50, " and" P=7 "bar"$.],
) <fig_rdf_vs_MD_273K_0.5_7bar>

#img(
  image("Figures/RDF_MD_T=298K_phi=0.75_P=7bar.svg", width: 90%),
  caption: [Comparison of radial distribution function between GCMC and MD simulation \ at $ " "T=298" "upright(K)," "phi.alt=0.75, " and" P=7 "bar"$.],
) <fig_rdf_vs_MD_298K_0.75_7bar>

#linebreak()

#img(
  image("Figures/RDF_MD_T=353K_phi=1.5_P=7bar.svg", width: 90%),
  caption: [Comparison of radial distribution function between GCMC and MD simulation \ at $ " "T=353" "upright(K)," "phi.alt=1.5, " and" P=7 "bar"$.],
) <fig_rdf_vs_MD_353K_1.5_7bar>

#pagebreak()

== 吸着等温線とフガシティ係数の決定<sec_adsorption_isotherm>

@sec_temp_ke_Ngas の結果から，CO2分子数のアンサンブル平均を吸着CO2分子数とみなして吸着量の算出を行なった．このときの異なるフガシティ係数$phi.alt$に対する吸着等温線は温度$T=273, " "298, " "353 upright(" K")$のそれぞれについて@fig_adsorption_isotherm_273K ～ @fig_adsorption_isotherm_353K のようになった．なお，@fig_adsorption_isotherm_273K ～ @fig_adsorption_isotherm_353K には得られた吸着等温線が実験値に近いもののみ描画している．

#img(
  image("Figures/adsorption_isotherm_EPM2F_T=273K_revised.svg", width: 75%),
  caption: [Adsorption isotherms of CO2 on HKUST-1 at $ " "T=273 " " upright(K)$ for three different fugacity coefficients.],
) <fig_adsorption_isotherm_273K>

#linebreak()

#img(
  image("Figures/adsorption_isotherm_EPM2F_T=298K_revised.svg", width: 75%),
  caption: [Adsorption isotherms of CO2 on HKUST-1 at $ " "T=298 " " upright(K)$ for three different fugacity coefficients.],
) <fig_adsorption_isotherm_298K>

#img(
  image("Figures/adsorption_isotherm_EPM2F_T=353K_revised.svg", width: 75%),
  caption: [Adsorption isotherms of CO2 on HKUST-1 at $ " "T=353 " " upright(K)$ for three different fugacity coefficients.],
) <fig_adsorption_isotherm_353K>

#linebreak()

@fig_adsorption_isotherm_273K ～ @fig_adsorption_isotherm_353K から，設定温度$T=273, " "298, " " 353 " "upright("K")$のそれぞれに対応するフガシティ係数$phi.alt$を決定する．フガシティ係数$phi.alt$は理想気体との乖離度を示し，設定温度$T$だけでなく，設定圧力$P$の大きさによっても左右される．また，一般的に実在気体は高温・低圧にすることによって理想気体 ($phi.alt = 1$) に近づくことが知られている．これらを踏まえて，本研究では$T=273, " "298, " " 353 " "upright("K")$のそれぞれに対して，各設定温度$T$に対応するフガシティ係数$phi.alt$をそれぞれ@tab_phi のように定めた．

#linebreak()

#tab(
  table(
    columns: (50pt, 75pt, 75pt, 75pt),
    table.header(
      [$P space ["bar"]$], [$T=273 space upright(K)$], [$T=298 space upright(K)$], [$T=353 space upright(K)$],
    ),
    $1$, $0.40$, $1.0$, $1.75$,
    $2$, $0.40$, $0.75$, $1.75$,
    $3$, $0.40$, $0.75$, $1.75$,
    $4$, $0.40$, $0.75$, $1.75$,
    $5$, $0.45$, $0.75$, $1.5$,
    $6$, $0.50$, $0.75$, $1.5$,
    $7$, $0.50$, $0.75$, $1.5$
  ),
  caption: [Fugacity coefficients for each $P$ and $T$.]
)<tab_phi>

#pagebreak()

== 吸着平衡時のポテンシャルエネルギーの分布<sec_dist>

=== CO2分子のポテンシャルエネルギーの分布<sec_dist1>

@fig_pe_dist_273K ～ @fig_pe_dist_353K にCO2分子とCO2分子内のC原子，O原子それぞれ1個あたりがもつポテンシャルエネルギーの設定圧力ごとの分布を示す．なお，設定温度$T= 273, " "298, " "353 space upright(K)$のそれぞれについて示しており，各設定温度$T$について@tab_phi で示した対応するフガシティ係数$phi.alt$を設定している．
また，ポテンシャルエネルギーの分布はCO2分子，C原子，O原子のそれぞれについて各面積が1になるような正規化を施している．すなわち，@fig_pe_dist_273K ～ @fig_pe_dist_353K の縦軸は確率密度を表している．
このポテンシャルエネルギーは1つのCO2分子に対し，他のCO2分子を含むすべての原子・分子との相互作用から計算されているため，HKUST-1内原子との相互作用のみによるポテンシャルエネルギーを示していないことに注意されたい．

@fig_pe_dist_273K ～ @fig_pe_dist_353K から，どの設定温度についても設定圧力が高圧になるにつれて吸着分子数が多くなり，ポテンシャルエネルギーの分布は滑らかになっている．特に，$T= 353 space upright(K), space P=1 "bar"$のようなCO2分子の数密度が極めて小さい (@fig_Ngas_353K) とき，CO2分子同士の相互作用による影響を無視できると考えられるが，この条件においてはポテンシャルエネルギーのピークが2つあることが確認される．したがって，その2つのピークの間 (谷の部分) がCO2分子同士の相互作用によるポテンシャルエネルギーをもった分子であると考えられる．

また，設定圧力を大きくすることでCO2分子の数密度が大きくなり，CO2分子のもつポテンシャルエネルギーの範囲は両方向に広くなる傾向がみられた．例えば，設定温度 $T=273 space upright(K)$では設定圧力$P=1 "bar"$で $-13 ~ 4 "kcal/mol"$ の範囲のポテンシャルエネルギーをもっていたが，$P=7 "bar"$では $-15 ~ 5 "kcal/mol"$ の範囲のポテンシャルエネルギーをもっている．

#linebreak()

次に，@fig_pe_range_273K_1bar ～ @fig_pe_range_353K_7bar に設定温度$T= 273, " "298, " "353 space upright(K)$，設定圧力$P=1, space 7 "bar"$の際にGCMCシミュレーションの本計算によって得られたアンサンブルすべてにおけるCO2分子の位置分布を示す．ただし，3次元位置座標はすべて$x y$平面に射影させているため，$z$座標の違いは考慮されていない．

@fig_pe_range_273K_1bar と@fig_pe_range_273K_7bar，@fig_pe_range_298K_1bar と@fig_pe_range_298K_7bar，@fig_pe_range_353K_1bar と@fig_pe_range_353K_7bar をそれぞれ比較すると，低圧時はHKUST-1中の窓およびSケージにCO2分子は集中しているのに対し，高圧時はLケージにも集中していることが分かる．これより，低圧時はSケージに比べてLケージへの吸着がされにくく，高圧にするにつれLケージの吸着量が増えると考えられる．この傾向は$T=298, space 353 space upright(K)$においても同様であった．

@fig_pe_range_273K_1bar ～ @fig_pe_range_353K_7bar をCO2分子数の少ない方から見ていくと，まず最初にSケージにCO2分子が集中したのち，その入口である窓に集中が強まる．その後に $(x,y)=(6,13), space (13,6), space (13, 20), space (20, 13)$ のような箇所でポテンシャルエネルギーの低いCO2分子の集まりが見られる．この部分については@sec_int で再度述べるが，Cu原子とそれに接続するカルボキシ基の近傍である．最後に高圧になるにつれCO2分子の数密度が大きくなると，Lケージにおける密度が他の吸着サイトと同等になる様子が確認できる．このことから，HKUST-1のCO2吸着には吸着サイトごとの優先順位があると考えられ，本研究の結果からは第一吸着サイトがSケージ，第二吸着サイトが窓，第三吸着サイトがCu原子とそれに接続するカルボキシ基の近傍，第四吸着サイトがLケージであると推測される．

@fig_pe_range_273K_1bar ～ @fig_pe_range_353K_7bar のいずれにおいても吸着サイトに存在するCO2分子が低いポテンシャルエネルギーをもっている傾向はみられたが，それら全てが低いポテンシャルエネルギーをもっているわけではなく，吸着サイトごとにその分布の仕方は異なることが分かる．したがって，分子がもつポテンシャルエネルギーは吸着判定および吸着位置特定の完全な指標とはならないと考えられる．

HKUST-1の構造上，@fig_pe_range_273K_1bar ～ @fig_pe_range_353K_7bar から吸着サイトごとの考察は難しいため，@sec_int で$z$座標も考慮した，より詳細な考察を行なう．

#pagebreak()

#img(
  image("Figures/pe_dist_EPM2F_T=273K_phi=0.5.svg", width: 100%),
  caption: [Distribution of potential energy of CO2 molecules and atoms in CO2 at $ " "T=273 " " upright(K) "and" phi.alt=0.50$.],
) <fig_pe_dist_273K>

#linebreak()

#img(
  image("Figures/pe_dist_EPM2F_T=298K_phi=0.75.svg", width: 100%),
  caption: [Distribution of potential energy of CO2 molecules and atoms in CO2 at $ " "T=298 " " upright(K) "and" phi.alt=0.75$.],
) <fig_pe_dist_298K>

#linebreak()

#img(
  image("Figures/pe_dist_EPM2F_T=353K_phi=1.5.svg", width: 100%),
  caption: [Distribution of potential energy of CO2 molecules and atoms in CO2 at $ " "T=353 " " upright(K) "and" phi.alt=1.5$.],
) <fig_pe_dist_353K>

#pagebreak()

#img(
  image("Figures/pe_map_T=273K_phi=0.4_P=1bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules at $ " "T=273 " " upright(K), " " phi.alt=0.40, " and" P=1 "bar"$.],
) <fig_pe_range_273K_1bar>

#linebreak()

#img(
  image("Figures/pe_map_T=273K_phi=0.5_P=7bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules at $ " "T=273 " " upright(K), " " phi.alt=0.50, " and" P=7 "bar"$.],
) <fig_pe_range_273K_7bar>

#pagebreak()

#img(
  image("Figures/pe_map_T=298K_phi=0.75_P=1bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules at $ " "T=298 " " upright(K), " " phi.alt=0.75, " and" P=1 "bar"$.],
) <fig_pe_range_298K_1bar>

#linebreak()

#img(
  image("Figures/pe_map_T=298K_phi=0.75_P=7bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules at $ " "T=298 " " upright(K), " " phi.alt=0.75, " and" P=7 "bar"$.],
) <fig_pe_range_298K_7bar>

#pagebreak()

#img(
  image("Figures/pe_map_T=353K_phi=1.75_P=1bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules at $ " "T=353 " " upright(K), " " phi.alt=1.75, " and" P=1 "bar"$.],
) <fig_pe_range_353K_1bar>

#linebreak()

#img(
  image("Figures/pe_map_T=353K_phi=1.5_P=7bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules at $ " "T=353 " " upright(K), " " phi.alt=1.5, " and" P=7 "bar"$.],
) <fig_pe_range_353K_7bar>

#pagebreak()

=== HKUST-1内原子のポテンシャルエネルギーの分布<sec:hkust-1_pedist>

各設定温度$T=273, " " 298, " " 353 " "upright(K)$におけるGCMCシミュレーションの最終位置を初期状態としてMDシミュレーションを行ない，平衡状態における各HKUST-1内原子1個あたりがもつポテンシャルエネルギーの分布 (@fig_pe_dist_mof_273K ～ @fig_pe_dist_mof_353K) を得た．ここで，どの設定温度$T$についてもO(1)およびO(2)原子の分布はほぼ重なっていることに注意されたい．これは，O(1)とO(2)原子の位置的な対称性やカルボキシ基内のC - O原子間の共鳴構造から妥当な結果であると考えられる．

@fig_pe_dist_mof_273K ～ @fig_pe_dist_mof_353K から，吸着平衡状態においてHKUST-1は温度に関わらずほぼ同じエネルギー状態をもっていることが分かる．これは，設定温度$T=273 ~ 353 space upright(K)$の範囲でHKUST-1はCO2分子の存在がほぼ影響せず，安定な構造を持っているためであると考えられる．また，吸着平衡時のHKUST-1内原子の平均ポテンシャルエネルギーはH，C(3)，C(2)，O，C(1)，Cuの順で小さくなっている．

C(2)，C(3)，H原子の分布に比べてCu，O原子の分布は分散が大きくなっていることから，C(2)，C(3)，H原子はほぼ一定の環境にあるのに対し，CuおよびO原子は様々な環境にあると考えられる．ここで，本研究で用いたHKUST-1に含まれるH原子はすべてベンゼン環内に存在するものであり，CO2分子の存在に関わらず，安定状態であると考えられる．また，H原子に次いでポテンシャルエネルギーの低いC(3)，C(2)原子はベンゼン環中のC原子であり，これらもCO2の存在に関わらず比較的安定な原子と考えられる．以上から，ベンゼン環を構成する原子であってポテンシャルエネルギーが低く安定かつ分散が小さいH，C(3)，C(2)原子に関しては，これらの近傍でCO2分子との吸着は起こりにくいと考えられる．

一方，C(1)原子とO原子はともにカルボキシ基に含まれる原子であり，Cu，C(2)原子はカルボキシ基と接続する原子である．これらの原子が比較的高いポテンシャルエネルギーをもっており，不安定であることはその電気的な極性によるものと考えられる．

したがって，HKUST-1のポテンシャルエネルギーの分布から，ベンゼン環はCO2分子の吸着に関与しにくく，Cu原子およびそれに接続するカルボキシ基の近傍がCO2分子の吸着に貢献すると考えられる．

// 特にCu原子が高いポテンシャルエネルギーをもっていることは，強く束縛されていることを示し，HKUST-1をはじめとするMOFが金属原子を中心に構成されていることを示す．

#linebreak()

#img(
  image("Figures/mof_pe_dist_T=273K_phi=0.5.svg", width: 85%),
  caption: [Distribution of potential energy of atoms in HKUST-1 at $ " "T=273 " " upright(K), " " phi.alt=0.50, " and" P=7 "bar"$.],
) <fig_pe_dist_mof_273K>

#pagebreak()

#img(
  image("Figures/mof_pe_dist_T=298K_phi=0.75.svg", width: 85%),
  caption: [Distribution of potential energy of atoms in HKUST-1 at $ " "T=298 " " upright(K), " " phi.alt=0.75, " and" P=7 "bar"$.],
) <fig_pe_dist_mof_298K>

#linebreak()

#img(
  image("Figures/mof_pe_dist_T=353K_phi=1.5.svg", width: 85%),
  caption: [Distribution of potential energy of atoms in HKUST-1 at $ " "T=353 " " upright(K), " " phi.alt=1.5, " and" P=7 "bar"$.],
) <fig_pe_dist_mof_353K>

#pagebreak()

== 各設定温度・圧力におけるRDFの比較<sec_rdf>

設定温度$T$ごとのHKUST-1内原子とCO2分子内C原子のRDFを各設定圧力$P=1, space 2, space 3, space 4, space 5, space 6, space 7 "bar"$についてそれぞれ@fig_rdf_vs_temp_1bar ～ @fig_rdf_vs_temp_7bar に示す．

@fig_rdf_vs_temp_1bar ～ @fig_rdf_vs_temp_7bar から，特にC，H原子のピークが鋭く立っていることが確認できる．これは，HKUST-1の構造の中で骨格となるC，H原子は全域的に存在するため，第一ピークが強く現れると考えられる．一方，Cu，O原子のRDFにおいて第一ピークが強く現れなかったことは，これらの原子はHKUST-1の構造の中で局所的に存在するものであり，近傍にHKUST-1の骨格となる原子が多く，CO2分子が近づきにくいことが原因であると考えられる．

各原子に対して，温度の変化に対するRDFの形状の変化を確認すると，Cu原子については一貫した特徴は見られなかった．O(1)，O(2)原子についてはどちらも同じ形状となっており，@sec:hkust-1_pedist で述べたように，位置的な対称性と共鳴構造によるものと考えられる．これらの原子については温度の上昇に伴い，第一ピークが高くなっていることが特徴である．C原子についても$P=1 "bar"$のときを除き，温度の上昇に伴って第一ピークが高くなっていることが確認される．特にC(3)原子はC(1)，C(2)原子に比べて第一ピークと第二ピークの距離が近いことが一貫して確認できる．H原子は$P=1 "bar"$のときを除き，温度変化に対してピークの高さはほぼ変化しておらず，第一ピークと第二ピークの間の谷部分が温度上昇に伴って高くなっていることが特徴である．

以上から，温度上昇に伴っていずれかのピークが高くなった原子はO原子，C原子であり，谷部分が大幅に高くなった原子はH原子であった．一般的に流体に対するMOFの吸着量は温度上昇に伴い減少するため，本研究で得られたRDFは直感的には一般論に反するものとなっている．

#linebreak()

#img(
  image("Figures/rdf_vs_temp_P=1bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=1 "bar"$.],
) <fig_rdf_vs_temp_1bar>

#pagebreak()

#img(
  image("Figures/rdf_vs_temp_P=2bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=2 "bar"$.],
) <fig_rdf_vs_temp_2bar>

#linebreak()

#img(
  image("Figures/rdf_vs_temp_P=3bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=3 "bar"$.],
) <fig_rdf_vs_temp_3bar>

#img(
  image("Figures/rdf_vs_temp_P=4bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=4 "bar"$.],
) <fig_rdf_vs_temp_4bar>

#linebreak()

#img(
  image("Figures/rdf_vs_temp_P=5bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=5 "bar"$.],
) <fig_rdf_vs_temp_5bar>

#img(
  image("Figures/rdf_vs_temp_P=6bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=6 "bar"$.],
) <fig_rdf_vs_temp_6bar>

#linebreak()

#img(
  image("Figures/rdf_vs_temp_P=7bar.svg", width: 90%),
  caption: [Radial distribution function between each atom of HKUST-1 and C in CO2 molecules\ for each temperature at $P=7 "bar"$.],
) <fig_rdf_vs_temp_7bar>

== 総合的な考察<sec_int>

本節では@sec_dist，@sec_rdf で得られた結果を基に考察を行なう．@sec_dist1 において，@fig_pe_range_273K_1bar ～ @fig_pe_range_353K_7bar のGCMCシミュレーションで得られたCO2分子の分布について詳細に考察を行なうため，描画するCO2分子の座標に$z$に関する制限を設けて再度分布の様子を確認する．本研究では@fig_dist に示すように$z$方向に系を7つの空間に分割し，それぞれの空間に含まれるCO2分子のみを用いて$x y$平面に対する分布を描画した．ただし，$A=4.5243 space angstrom, space B=4.3054 space angstrom, space C=2.5175 space angstrom, space D=3.6486 space angstrom$である．加えて，HKUST-1の3次元構造を@fig_hkust-1_diag に示す．

#linebreak()

#img(
  image("Figures/dist.svg", width: 65%),
  caption: [Division of the simulation box.],
) <fig_dist>

#img(
  image("Figures/HKUST-1_diag.jpeg", width: 75%),
  caption: [Structure of HKUST-1.],
) <fig_hkust-1_diag>

#pagebreak()

　それぞれの空間を@fig_dist の左側から$S_1, space S_2, space S_3, space S_4, space S_5, space S_6, space S_7$とし，各空間でCO2分子の分布を描画したものをそれぞれ
@fig_dist_S1 ～ @fig_dist_S7 に示す．ただし，アンサンブル全体として最も多いCO2分子数となった設定温度$T=273 space upright(K)$，フガシティ係数$phi.alt=0.50$，設定圧力$P=7 "bar"$のGCMCシミュレーションで得られたデータを使用し，@fig_dist_S1 ～ @fig_dist_S4 については位置関係を分かりやすくするためにHKUST-1の構造を重ねて図示している．

#img(
  image("Figures/co2_dist_S1_T=273K_phi=0.5_P=7bar_modified.svg", width: 75%),
  caption: [Distribution of CO2 molecules in $S_1$.],
) <fig_dist_S1>

#img(
  image("Figures/co2_dist_S2_T=273K_phi=0.5_P=7bar_modified.svg", width: 70%),
  caption: [Distribution of CO2 molecules in $S_2$.],
) <fig_dist_S2>

#pagebreak()

#img(
  image("Figures/co2_dist_S3_T=273K_phi=0.5_P=7bar_modified.svg", width: 70%),
  caption: [Distribution of CO2 molecules in $S_3$.],
) <fig_dist_S3>

#img(
  image("Figures/co2_dist_S4_T=273K_phi=0.5_P=7bar_modified.svg", width: 75%),
  caption: [Distribution of CO2 molecules in $S_4$.],
) <fig_dist_S4>

#pagebreak()

#img(
  image("Figures/co2_dist_S5_T=273K_phi=0.5_P=7bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules in $S_5$.],
) <fig_dist_S5>

#img(
  image("Figures/co2_dist_S6_T=273K_phi=0.5_P=7bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules in $S_6$.],
) <fig_dist_S6>

#pagebreak()

#img(
  image("Figures/co2_dist_S7_T=273K_phi=0.5_P=7bar.svg", width: 75%),
  caption: [Distribution of CO2 molecules in $S_7$.],
) <fig_dist_S7>

#linebreak()

@fig_dist から，$S_1$と$S_7$，$S_2$と$S_6$，$S_3$と$S_5$はそれぞれ同じ構造をもっているため，@fig_dist_S1 ～ @fig_dist_S7 からも分かるように吸着CO2分子の分布もほぼ同じである．したがって，考察にあたっては$S_1$～$S_4$の4つの空間について行なう．

$S_1$について，@fig_dist_S1 のCO2分子が存在していない領域は，HKUST-1内のベンゼン環がある部分である．また，針状にCO2分子が分布している領域は@sec_hkust で示したHKUST-1の窓の部分である．さらに，@sec_dist1 でも述べたが，$(x,y)=(6,13), space (13,6), space (13, 20), space (20, 13)$ 付近でポテンシャルエネルギー的に安定なCO2分子の存在が確認でき，これはCu原子およびそれに接続するカルボキシ基の近傍である．

$S_2$について，@fig_dist_S2 の中心以外の4つの分布が集中している領域はSケージであり，中心および上下左右の分布が集中している領域はLケージである．ここで，Cu原子は$(x,y)=(6,13), space (13,6), space (13, 20), space (20, 13)$ 付近に位置している．Cu原子の周辺にはSケージとLケージの2種類の吸着サイトが存在し，Cu原子からSケージおよびLケージまでの距離はほぼ同じである．この構造は@fig_rdf_vs_temp_7bar のCu原子のRDFと合わせて考えると，$r=4.0 space angstrom$付近から徐々にピークが立ち始め，$r=6.5 space angstrom$付近で最大ピークが現れることに合致する．

$S_3$について，構造は$S_1$とほぼ対称的であるため，$S_1$と同じような分布を示している．$S_1$と異なる点は，$S_3$はLケージの端部における分布を示している点であり，@fig_dist_S3 から，Lケージ内ではベンゼン環から離れた位置に分布の集中をもっていることが確認できる．

$S_4$について，CO2分子が存在しない領域はCu原子およびそれに接続するカルボキシ基内O原子の近傍である．ここで，@fig_dist_S4 で示すように，Cu原子に接続しているO原子の方向にポテンシャルエネルギーの低いCO2分子が集中していることが確認できる．なお，このCO2分子が存在しない領域は直径が約$9.0 space angstrom$であり，Cu原子の直径が$2.56 space angstrom$程度であることを考えると，かなり広い範囲にわたってCO2分子が存在しないことが分かる．

= 結論

#pagebreak()

== 結論

本研究では，GCMCシミュレーションとMDシミュレーションの2つを用いて，代表的なMOFであるHKUST-1に対して気体のCO2を吸着させ，吸着平衡時のエネルギー状態について新たな知見を得ることを目的とした分子シミュレーションを行なった．

まず，GCMCシミュレーションによりHKUST-1に対するCO2の吸着平衡状態を作成した．GCMCシミュレーションの妥当性を確認するために，温度・CO2分子数・試行受理率の推移の調査，およびGCMCシミュレーションによる吸着平衡時のRDFと，その座標情報を初期状態としたMDシミュレーションにおけるRDFの比較を行なった．次に，GCMCシミュレーションで得た吸着平衡時に系内に存在するCO2分子数のアンサンブル平均を用いてCO2吸着量を計算し，圧力$1 ~ 7 "bar"$に対する吸着等温線を作成した．このとき，様々なフガシティ係数を設定し，実験値に近い吸着量を示すものを以降のシミュレーションに用いるフガシティ係数として定めた．

GCMCシミュレーションにより得られた吸着平衡状態におけるCO2分子のエネルギー状態を調査するため，各設定温度$T=273, space 298, space 353 space upright(K)$，各設定圧力$P=1, space 2, space 3, space 4, space 5, space 6, space 7 "bar"$に対するCO2分子1個あたりのポテンシャルエネルギーの分布，およびその吸着平衡状態におけるCO2分子の位置とそのCO2分子がもつポテンシャルエネルギーの大きさの分布を示した．さらに，HKUST-1内原子がもつポテンシャルエネルギーの分布や，HKUST-1内の各原子とCO2分子内C原子間のRDFを解析することで，吸着平衡状態にあるHKUST-1とCO2分子のエネルギー状態を調査した．

また，本研究ではHKUST-1中に存在するCO2分子が吸着しやすい位置 (吸着サイト) としてLケージ (Large Cage) ，Sケージ (Small Cage) ，窓 (window) を考えて構造的な考察を行なった．なお，SケージとはHKUST-1の基礎的な構造であるベンゼン環とCu原子およびそれに接続するカルボキシ基が囲む領域であり，窓とはその入口を指す．Lケージとは主にHKUST-1中のSケージおよび窓を除いた領域から成り，1セル分のHKUST-1の中央に位置する領域である．

以下に本研究を通して得られた知見を示す．
- MOFの気体吸着現象を扱うGCMCシミュレーションにおいて温度のゆらぎを抑えるには，設定圧力を大きくすることなどにより気体分子数を増やすことで，気体分子1個あたりが平均温度に与える影響を小さくすることが有効であると考えられる．また，他にも系の大きさを大きくするなどして気体分子数を増やす方法も考えられる．
- MDシミュレーションにおいて，GCMCシミュレーションで得られた最終位置を使用し，GCMCにおける設定温度と同じ温度で温度制御を一定時間行なったのち，温度制御を解除してミクロカノニカルアンサンブルとすることで両方のシミュレーションにおいて同じような吸着平衡状態を作成できる．したがって，一定時間あたりに得られるアンサンブル数が少ないGCMCシミュレーションに対し，より多くのアンサンブルを得るために，GCMCシミュレーション後の座標データを初期状態としてMDシミュレーションを行なうことは有効である．
- GCMCシミュレーションにおいて，CO2吸着量の実験値に沿ったシミュレーションを行なうためには，各温度，圧力に対して適切なフガシティ係数を設定する必要がある．
- 吸着平衡時のCO2分子のポテンシャルエネルギーの分布は設定温度$T=273, space 298, space 353 space upright(K)$，設定圧力$P=1, space 2, space 3, space 4, space 5, space 6, space 7 "bar"$に対して大きな変化がなかったが，高温低圧条件下ではポテンシャルエネルギーの分布が滑らかにならない傾向があった．これは，CO2分子の数密度が小さくなることに起因すると考えられる．
- HKUST-1内原子とCO2分子内C原子間のRDFにおいて，C，H原子は第一ピークが鋭く現れ，Cu，O原子は第一ピークが鋭く現れなかった原因として，HKUST-1の骨格をなすC，H原子はHKUST-1内に全域的に存在するのに対し，Cu，O原子は局所的にのみ存在し，かつ骨格をなすC，H原子が最近接位置に存在することが原因であると考えられる．
- 設定温度$T=273, space 298, space 353 space upright(K)$のすべてにおいて，低圧時 ($P=1 "bar"$) はSケージに比べてLケージへの吸着がされにくく，高圧 ($P=7 "bar"$) にするにつれLケージの吸着量が増える傾向がある．

- GCMCシミュレーションにおいて，設定温度および設定圧力の変更によるCO2分子数の変化に伴う局所的なCO2分子の数密度の変化から，第一吸着サイトがSケージ，第二吸着サイトが窓，第三吸着サイトがCu原子とそれに接続するカルボキシ基の近傍，第四吸着サイトがLケージであると推測される．
- 吸着サイトに存在するCO2分子が低いポテンシャルエネルギーをもっている傾向はみられたが，CO2分子1個あたりがもつポテンシャルエネルギーは，その分子が吸着状態にあるか，または，どの吸着サイトに存在するかを示すような完全な指標にはならない．
- 吸着平衡時のHKUST-1内原子のポテンシャルエネルギーの分布は設定温度$T=273, space 298, space 353 space upright(K)$やCO2分子数に対してほぼ変化がなかったが，原子の属する構造や官能基を考慮すると，ベンゼン環に属する原子はポテンシャルエネルギーが低いことからCO2分子の吸着に関与しにくく，カルボキシ基に属する原子とそれに接続するCu原子はポテンシャルエネルギーが高いことからCO2分子の吸着に貢献すると考えられる．これは，ベンゼン環近傍にはCO2分子はほぼ分布しておらず，カルボキシ基およびCu原子近傍にCO2分子が集中していたことに一致する．
- Cu原子およびそれに接続するカルボキシ基内のO原子の周辺で吸着状態にあるCO2分子は，最近接のCu原子から半径約$4.5 space angstrom$ほどの大きく離れた場所に位置し，Cu原子を基準としてO原子の方向にポテンシャルエネルギーが低い状態で分布している．この位置はLケージおよびSケージ，窓に属さないが，第三吸着サイトとして機能していると考えられる．

== 今後の課題と展望

本節では，本研究を通して明らかになった問題点や解決できなかった課題，そして今後の展望について述べる．

@sec_pair でHKUST-1内原子とCO2分子内原子との非結合相互作用として，12-6 Lennard-Jonesポテンシャルを用いたことを述べたが，本研究ではそのパラメータ$sigma_(i j)$として@geometric1 を用いた．一般的に用いられる異種原子間相互作用のパラメータ$sigma_(i j)$はLorentz-Berthelot則として知られる@eq:lb であり，@geometric1 と@eq:lb のどちらの式を採用するかを，使用する力場モデルなどとも関連させて議論する必要があると考えられる．
$
  sigma_(i j) = (sigma_(i i) + sigma_(j j )) / 2
$ <eq:lb>

　@sec_adsorption_isotherm でフガシティ係数の決定に関して述べた．本研究ではフガシティ係数を様々な値に変更しながら吸着等温線が実験値に一致するかを試験的に確認したが，実在気体の状態方程式から理論的に導出している研究@Yazaydin2009 もあるため，その方法でも検証することでより正確なシミュレーションが可能になると考えられる．また，@sec_gcmc で述べた化学ポテンシャルとの関係も深く調査する必要がある．

@sec_rdf で各設定温度，設定圧力における，HKUST-1内原子に対するCO2分子内C原子のRDFについて述べたが，H原子のRDFの第一ピーク，第二ピーク間の谷部分をはじめとして温度上昇に伴いピークの高さが高くなる原因を特定するに至らなかった．本研究では1セル分のHKUST-1に対して100個程度のCO2分子を用いてシミュレーションを行なったが，より大きな系を用いることでCO2分子数を増やし，統計的により正確なデータを解析することで原因の特定につながる可能性がある．

本研究ではCO2分子の力場モデルとしてC - O間の結合距離およびO - C - O間の結合角度が固定されていないフレキシブルなモデルであるEPM 2 (flexible) モデルを用いたが，剛体モデルとの比較を行なえなかったためにフレキシブルモデルのメリットおよびデメリットを確認することができなかった．また，CO2分子の吸着状態における結合距離や結合角度，それに伴うポテンシャルエネルギーとHKUST-1内での分布の関係などを調査することによって，吸着時のCO2のエネルギー状態に関してより理解を深められる可能性がある．

#heading(numbering: none)[謝辞] // TODO: 謝辞 // TODO: 縦読み

本研究を行なうにあたり，芝原正彦教授には，研究を行なう環境および機会を与えていただき，ミーティング等において研究内容についてたくさんのご助言を賜りました．心より感謝申し上げます．

藤原邦夫准教授には，研究についての内容だけでなく，進路などについても幾度となく相談させていただき，数多のご助言・ご指導をしてくださいました．加えて，学会資料や本論文の添削，およびコメントなども懇切丁寧にしていただき，ますます学びの多い1年となったことに心より感謝申し上げます．

奥田尚代事務員には，日々のご支援によりきわめて円滑に研究活動を進めることができました．心より感謝申し上げます．

研究生活をともに過ごし，ご指導あるいはご助言を賜った芝原・藤原研究室の先輩，同輩の皆様に深く感謝申し上げます．

#set text(size: 10pt, lang: "en")
#bibliography("references.bib", title: "参考文献", style: "ieee")

//TODO: #heading(level: 1, numbering: none)[付録]

// #pagebreak()

// #heading(level: 2, numbering: none)[A. 化学ポテンシャルについて]

// @sec_gcmc で本研究では化学ポテンシャルを$0 "kcal/mol"$としてシミュレーションを行なったことを述べた．