#FC = gfortran-8
FC = gfortran
SRC_DIR = ./src
BUILD_DIR = ./build
BIN_DIR = ./bin
MOD_DIR = ./mod
OUT_DIR = ./output

all: graph network wvnetwork trafficnetwork
	
$(BUILD_DIR)/GraphMod.o: $(SRC_DIR)/GraphMod.f90
	$(FC) -c -o $(BUILD_DIR)/GraphMod.o $(SRC_DIR)/GraphMod.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
$(BUILD_DIR)/GraphUserInterface.o: $(BUILD_DIR)/GraphMod.o
	$(FC) -c -o $(BUILD_DIR)/GraphUserInterface.o $(SRC_DIR)/GraphUserInterface.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
$(BUILD_DIR)/NetworkFlowMod.o: $(BUILD_DIR)/GraphMod.o
	$(FC) -c -o $(BUILD_DIR)/NetworkFlowMod.o $(SRC_DIR)/NetworkFlowMod.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
$(BUILD_DIR)/NetworkUserInterface.o: $(BUILD_DIR)/NetworkFlowMod.o
	$(FC) -c -o $(BUILD_DIR)/NetworkUserInterface.o $(SRC_DIR)/NetworkUserInterface.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	   
$(BUILD_DIR)/NetworkAMPLInterface.o: $(BUILD_DIR)/NetworkFlowMod.o
	$(FC) -c -o $(BUILD_DIR)/NetworkAMPLInterface.o $(SRC_DIR)/NetworkAMPLInterface.f90 -J$(MOD_DIR) -I$(MOD_DIR)

$(BUILD_DIR)/NetworkTrafficModelInterface.o : $(BUILD_DIR)/NetworkFlowMod.o math_model
	$(FC) -c -o $(BUILD_DIR)/NetworkTrafficModelInterface.o $(SRC_DIR)/NetworkTrafficModelInterface.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
$(BUILD_DIR)/WeightedVertexNetworkFlowMod.o: $(BUILD_DIR)/NetworkUserInterface.o 
	$(FC) -c -o $(BUILD_DIR)/WeightedVertexNetworkFlowMod.o $(SRC_DIR)/WeightedVertexNetworkFlowMod.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
$(BUILD_DIR)/WeightedVertexNetworkUserInterface.o: $(BUILD_DIR)/WeightedVertexNetworkFlowMod.o 
	$(FC) -c -o $(BUILD_DIR)/WeightedVertexNetworkUserInterface.o $(SRC_DIR)/WeightedVertexNetworkUserInterface.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
#math_model: $(SRC_DIR)/map_module.f90 $(SRC_DIR)/time_zone_module.f90 $(SRC_DIR)/activity_module.f90 $(SRC_DIR)/affinity_module.f90
#	$(FC) -c -o $(BUILD_DIR)/math_model.o $(SRC_DIR)/map_module.f90 $(SRC_DIR)/time_zone_module.f90 $(SRC_DIR)/activity_module.f90 $(SRC_DIR)/affinity_module.f90 -J$(MOD_DIR) -I$(MOD_DIR)

math_model: affinity_module

affinity_module: activity_module
	$(FC) -c -o $(BUILD_DIR)/affinity_module.o $(SRC_DIR)/affinity_module.f90 -J $(MOD_DIR) -I $(MOD_DIR)

activity_module: time_zone_module
	$(FC) -c -o $(BUILD_DIR)/activity_module.o $(SRC_DIR)/activity_module.f90 -J $(MOD_DIR) -I $(MOD_DIR)

time_zone_module: map_module
	$(FC) -c -o $(BUILD_DIR)/time_zone_module.o $(SRC_DIR)/time_zone_module.f90 -J $(MOD_DIR) -I $(MOD_DIR)

map_module:
	$(FC) -c -o $(BUILD_DIR)/map_module.o $(SRC_DIR)/map_module.f90 -J $(MOD_DIR) -I $(MOD_DIR)

$(BUILD_DIR)/testgraph.o: $(SRC_DIR)/testgraph.f90 $(BUILD_DIR)/GraphMod.o $(BUILD_DIR)/GraphUserInterface.o
	$(FC) -c -o $(BUILD_DIR)/testgraph.o $(SRC_DIR)/testgraph.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
$(BUILD_DIR)/testnetwork.o: $(SRC_DIR)/testnetwork.f90 $(BUILD_DIR)/NetworkFlowMod.o $(BUILD_DIR)/NetworkUserInterface.o $(BUILD_DIR)/NetworkAMPLInterface.o  
	$(FC) -c -o $(BUILD_DIR)/testnetwork.o $(SRC_DIR)/testnetwork.f90 -J$(MOD_DIR) -I$(MOD_DIR)

$(BUILD_DIR)/testtraffic.o: $(SRC_DIR)/testtraffic.f90 $(BUILD_DIR)/NetworkTrafficModelInterface.o $(BUILD_DIR)/NetworkAMPLInterface.o $(BUILD_DIR)/NetworkFlowMod.o
	$(FC) -c -o $(BUILD_DIR)/testtraffic.o $(SRC_DIR)/testtraffic.f90 -J$(MOD_DIR) -I$(MOD_DIR)

$(BUILD_DIR)/testwvnflow.o: $(SRC_DIR)/testwvnflow.f90 $(BUILD_DIR)/WeightedVertexNetworkFlowMod.o $(BUILD_DIR)/WeightedVertexNetworkUserInterface.o $(BUILD_DIR)/NetworkAMPLInterface.o
	$(FC) -c -o $(BUILD_DIR)/testwvnflow.o $(SRC_DIR)/testwvnflow.f90 -J$(MOD_DIR) -I$(MOD_DIR)
	
graph: $(BUILD_DIR)/testgraph.o
	$(FC) -o $(BIN_DIR)/graph $(BUILD_DIR)/testgraph.o $(BUILD_DIR)/GraphMod.o $(BUILD_DIR)/GraphUserInterface.o -J$(MOD_DIR) -I$(MOD_DIR)
		
network: $(BUILD_DIR)/testnetwork.o 
	$(FC) -o $(BIN_DIR)/network  $(BUILD_DIR)/testnetwork.o $(BUILD_DIR)/GraphMod.o $(BUILD_DIR)/GraphUserInterface.o $(BUILD_DIR)/NetworkFlowMod.o  $(BUILD_DIR)/NetworkUserInterface.o $(BUILD_DIR)/NetworkAMPLInterface.o -J$(MOD_DIR) -I$(MOD_DIR)
	
wvnetwork: $(BUILD_DIR)/testwvnflow.o  
	$(FC) -o $(BIN_DIR)/wvnetwork $(BUILD_DIR)/testwvnflow.o $(BUILD_DIR)/GraphMod.o $(BUILD_DIR)/GraphUserInterface.o  $(BUILD_DIR)/NetworkFlowMod.o  $(BUILD_DIR)/NetworkUserInterface.o  $(BUILD_DIR)/NetworkAMPLInterface.o $(BUILD_DIR)/WeightedVertexNetworkFlowMod.o $(BUILD_DIR)/WeightedVertexNetworkUserInterface.o -J$(MOD_DIR) -I$(MOD_DIR)
	
trafficnetwork : $(BUILD_DIR)/testtraffic.o 
	$(FC) -o $(BIN_DIR)/trafficnetwork $(BUILD_DIR)/testtraffic.o $(BUILD_DIR)/GraphMod.o $(BUILD_DIR)/NetworkFlowMod.o $(BUILD_DIR)/NetworkTrafficModelInterface.o $(BUILD_DIR)/NetworkAMPLInterface.o $(BUILD_DIR)/map_module.o $(BUILD_DIR)/time_zone_module.o $(BUILD_DIR)/activity_module.o $(BUILD_DIR)/affinity_module.o -J$(MOD_DIR) -I$(MOD_DIR)
	
	
clean:
	$(RM) $(MOD_DIR)/*.mod 
	$(RM) $(BUILD_DIR)/*.o
	$(RM) $(BIN_DIR)/graph
	$(RM) $(BIN_DIR)/network
	$(RM) $(BIN_DIR)/wvnetwork
	$(RM) $(BIN_DIR)/trafficnetwork
	$(RM) $(OUT_DIR)/AMPLInput.dat

