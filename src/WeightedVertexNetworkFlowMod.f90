module WeightedVertexNetworkFlowMod

		use NetworkFlowMod
		use NetworkUserInterfaceMod
		
		implicit none
		
!   ........ overloading the assignment operator		
		interface assignment ( = )
				module procedure splitNetwork
		end interface
		
!   ......... derived type to hold the Weighted Vertex Network		
		type WeightedVertexNetwork
				type( Network )                      :: N
				integer, allocatable, dimension( : ) :: VertexWeights
		end type
		
		contains
    
!   ......... subroutine to convert a Weighted Vertex Network to a regular Network    
    subroutine splitNetwork(N,W)
    
    		implicit none
    		
    		type( Network ), intent( out )              :: N
    		type( WeightedVertexNetwork ), intent( in ) :: W
    		integer                                     :: i, j
    		
    		! node x mapped to nodes 2*x-1 and 2*x
    		
    		N%G%n = 2*W%N%G%n
    		N%G%m = W%N%G%m + W%N%G%n
    		N%G%isdirected = .true.
    		
    		allocate( N%G%edges( W%N%G%n+W%N%G%m, 2 ) )
    		allocate( N%CostVector( W%N%G%m+W%N%G%n ) )
        allocate( N%CapacityVector( W%N%G%m + W%N%G%n ) )
        
    	  do i = 1, W%N%G%m
    	  		N%G%edges( i, 1 ) = 2*W%N%G%edges( i, 1 )
    	  		N%G%edges( i, 2 ) = 2*W%N%G%edges( i, 2 ) - 1
    	  		N%CostVector( i ) = W%N%CostVector( i )
    	  		N%CapacityVector( i ) = W%N%CapacityVector( i )
    	  end do
    	  
    	  j = 1
    	  
    	  do i = W%N%G%m+1, W%N%G%m+W%N%G%n
    	  		N%G%edges( i, 1 ) = 2*j - 1
    	  		N%G%edges( i, 2 ) = 2*j
    	  		N%CostVector( i ) = W%VertexWeights( j )
    	  		N%CapacityVector( i ) = huge( N%CapacityVector( i ) )
    	  		j = j + 1
    	  end do
    end subroutine
		
!   ........subroutine to set flow data in Network N which has been obtained by splitting a weighted vertex network		
    subroutine setWeightedNetworkSourceDestinationFlow(N,A)
        
        implicit none

        type( Network ), intent( inout )      :: N
        real, intent( in ), dimension( :, : ) :: A
        integer                               :: src,dest,ios,i,numcommodities,shapeArray(2)
        real                                  :: flow
        
        shapeArray = shape( A )
        numcommodities = shapeArray( 2 )
        
        allocate( N%VertexFlow( N%G%n, numcommodities ) )
        allocate( N%FlowVector( N%G%m+N%G%n, numcommodities ) )
        
        N%VertexFlow = A
              
    end subroutine
    
    
end module
    	  
