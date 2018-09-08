program test1

    use NetworkFlowMod
    use NetworkUserInterfaceMod
		use NetworkAMPLInterfaceMod
		
    implicit none

    type(Network)       :: N, B
    integer             :: src, dest, numcommodities, i
    real                :: flow
    real,allocatable    :: A( :, : )
    
    print *, "Program to test NetworkFlowMod.f90, NetworkUserInterfaceMod.f90 and NetworkUserInterfaceMod.f90"
    print *, " "

!   ...... read input data
    call readNetworkData( N, "../input/NetworkInput.dat" )
    
    print *, "Number of Vertices := ", N%G%n
    print *, "Number of Edges := ", N%G%m
		print *, " "
		
		print *, "     Edge No.     Vertex 1    Vertex 2    Cost    Capacity"
		do i = 1, N%G%m
				print *, i, N%G%edges(i,1), N%G%edges(i,2), N%CostVector(i), N%CapacityVector(i)
		end do
		print *, " "
		
		print *, "Reading data regarding the sources, sinks and amount of tele-traffic data from FlowInput.dat"	
!   ..... load user-given Flow data into array A	
    call readSourceDestinationFlowData(A,"../input/FlowInput.dat")
!   ...... use array A to set N%VertexFlow 
    call setSourceDestinationFlow(N,A)
    print *, " "
    
		print *, "Calling subroutine to create input file for AMPL software"
    call printAMPLDataFile("../output/AMPLInput.dat",N)
    print *, " "
    
    print *, "Calling subroutine to convert the created network into a bidirectional Network"
    call bidirectional( B, N)
    print *, " "
    
    print *, "Number of Vertices := ", B%G%n
    print *, "Number of Edges := ", B%G%m
		print *, " "
		
		print *, "      Edge No.     Vertex 1    Vertex 2    Cost    Capacity"
		do i = 1, B%G%m
				print *, i, B%G%edges(i,1), B%G%edges(i,2), B%CostVector(i), B%CapacityVector(i)
		end do
		print *, " "
    
    deallocate(N%G%edges)
    deallocate(N%FlowVector)
    deallocate(N%CapacityVector)
    deallocate(N%CostVector)
    deallocate(N%VertexFlow)
    
    deallocate(B%G%edges)
    deallocate(B%CapacityVector)
    deallocate(B%CostVector)
    deallocate(B%VertexFlow)
    
end program test1

