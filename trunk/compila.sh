# RF
ghdl -a --ieee=synopsys -fexplicit rf.vhd
ghdl -e --ieee=synopsys -fexplicit rf

# ALU
ghdl -a --ieee=synopsys -fexplicit sum32.vhd
ghdl -a --ieee=synopsys -fexplicit alu.vhd

# MIPS
ghdl -a --ieee=synopsys -fexplicit mips.vhd
ghdl -e --ieee=synopsys -fexplicit mips

