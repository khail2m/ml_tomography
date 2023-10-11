#gen_linvel n1=201 n2=1277 h=0.025 vmin=1.5 vmax=3.0 vwater=1.5 tswd=2 swd=../data/congo25m/intpl/info_swd.rsf out=vel_init.rsf

smooth2 n1=50 n2=320 r1=20 r2=20 < pred_marm.bin > pred_marm_sm20.bin
