program testweightedvertexnetworkflow
		
		use WeightedVertexNetworkFlowMod
		use WeightedVertexNetworkUserInterfaceMod
		use NetworkAMPLInterfaceMod
		
		implicit none
		
		type( WeightedVertexNetwork )      :: W
		type( Network )                    :: N
		integer                            :: i, numcommodities
		real,allocatable,dimension( :, : ) :: A
		
		print *, "Program to test WeightedVertexNetworkFlow Modules"
		print *, " "
		
		print *, " calling subroutine to read Weighted Vertex Network Input data "
		call readWeightedVertexNetworkData( W, '../input/WVNInput.dat' )
		print *, " "
		
		print *, "using overloaded assignment operator to convert a weighted vertex network into a regular network"
		N =  W
		
		print *,"Weighted Network Vertices:=",W%N%G%n
		print *,"Network Vertices:= ",N%G%n
		print *,"Weighted Network Edges:=",W%N%G%m
		print *,"Network Edges:=",N%G%m		
		print *, " "
		
		print *, "Description of weighted vertex network"
		print *, "      Edge No.     Vertex 1    Vertex 2    Cost    Capacity"
		do i = 1,W%N%G%m
				print *,i,W%N%G%edges(i,1),W%N%G%edges(i,2),W%N%CostVector(i),W%N%CapacityVector(i)
		end do
		print*," "
		
		print *, "Description of new network"
		print *, "      Edge No.     Vertex 1    Vertex 2    Cost    Capacity"
		do i = 1,N%G%m
				print *,i,N%G%edges(i,1),N%G%edges(i,2),N%CostVector(i),N%CapacityVector(i)
		end do
		print*," "
		
		print *, "Reading data regarding the sources, sinks and amount of tele-traffic data from FlowInput.dat"
!   ..... read user-given Flow input data into array A
		call readWeightedNetworkSourceDestinationFlow(A,'../input/FlowInput.dat')
!   ...... use array A to set N%VertexFlow() in a Network which has been converted from a weighted vertex network
		call setWeightedNetworkSourceDestinationFlow(N,A)
		
		print *, "Calling subroutine to create input file for AMPL software"
		call printAMPLDataFile('../output/AMPLInput.dat',N)
		
end program
