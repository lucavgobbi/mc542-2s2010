# AluCONTROL
ghdl -a --ieee=synopsys -fexplicit alucontrol.vhd 

# ControlUnit
ghdl -a --ieee=synopsys -fexplicit cu.vhd 

# RF
ghdl -a --ieee=synopsys -fexplicit rf.vhd

# ALU
ghdl -a --ieee=synopsys -fexplicit sum32.vhd
ghdl -a --ieee=synopsys -fexplicit alu.vhd

# MIPS
ghdl -a --ieee=synopsys -fexplicit mips.vhd
ghdl -e --ieee=synopsys -fexplicit mips

