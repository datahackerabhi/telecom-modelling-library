module derived_types
		
		implicit none
		
! .......... derived type to hold Graph Structure
	  type Graph

		    logical                                 :: isdirected  
		    integer                                 :: n                   !no. of vertices
		    integer                                 :: m                   !no. of edges
		    integer, dimension( :, : ), allocatable :: edges 

	  end type Graph

!   ......... Derived Type to hold a Network Structure
    type Network
        
        type( Graph )                        :: G
        real, dimension( :, : ), allocatable :: FlowVector
        real, dimension( : ), allocatable    :: CapacityVector
        real, dimension( : ), allocatable    :: CostVector
        real, dimension( :, : ), allocatable :: VertexFlow
        
    end type
    
!   ......... derived type to hold the Weighted Vertex Network		
		type WeightedVertexNetwork
				type( Network )                      :: N
				integer, allocatable, dimension( : ) :: VertexWeights
		end type


end module
