docker run -t --rm -v $PWD:/home/vivado/project vivado:2018.1 /opt/Xilinx/Vivado/2018.1/bin/vivado -mode tcl -source build.tcl thinpad_top.xpr
cp $PWD/thinpad_top.runs/impl_1/thinpad_top.bit $PWD/thinpad_top.bit
