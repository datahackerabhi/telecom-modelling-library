program testtraffic
		
		use NetworkFlowMod
		use NetworkTrafficModelInterfaceMod
		use NetworkAMPLInterfaceMod
		
		
		implicit none
		
		type( Network ) :: N, B
		integer         :: i
		
		print *,"Program to test NetworkTrafficModelInterfaceMod"
		print *," "
		
		print *,"creating a network from file inputs.txt"
		call createNetwork(N,'../input/inputs-small.txt')
		
		print *," Network Description "
		print *, "Number of Vertices := ", N%G%n
    print *, "Number of Edges := ", N%G%m
		print *, " "
		
		print *,"Number of intermediate nodes inserted :=",intermediate_nodes
		print *," "
		
		print *, "     Edge No.     Vertex 1    Vertex 2    Cost    Capacity"
		do i = 1, N%G%m
				print *, i, N%G%edges(i,1), N%G%edges(i,2), N%CostVector(i), N%CapacityVector(i)
		end do
		print *, " "
		
		print *, "Calling subroutine to convert the created network into a bidirectional Network"
		call bidirectional(B, N)
		print *, " "
    
    print *, "Number of Vertices := ", B%G%n
    print *, "Number of Edges := ", B%G%m
		print *, " "
		
		print *, "      Edge No.     Vertex 1    Vertex 2    Cost    Capacity"
		do i = 1, B%G%m
				print *, i, B%G%edges(i,1), B%G%edges(i,2), B%CostVector(i), B%CapacityVector(i)
		end do
		print *, " "
		
		print *, "Calling subroutine to create input file for AMPL software"
		call printAMPLDataFile('../output/AMPLInput.dat',B)

end program
		
