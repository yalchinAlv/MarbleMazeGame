# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.cache/wt [current_project]
set_property parent.project_path E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo e:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.srcs/sources_1/new/SPI_StateMachine.sv
  E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.srcs/sources_1/new/FrameLoader.sv
  E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.srcs/sources_1/new/MarbleMazeGame.sv
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.srcs/constrs_1/new/constraint.xdc
set_property used_in_implementation false [get_files E:/Vivado_Projects/MarbleMazeGame/MarbleMazeGame.srcs/constrs_1/new/constraint.xdc]


synth_design -top MarbleMazeGame -part xc7a35tcpg236-1


write_checkpoint -force -noxdef MarbleMazeGame.dcp

catch { report_utilization -file MarbleMazeGame_utilization_synth.rpt -pb MarbleMazeGame_utilization_synth.pb }
