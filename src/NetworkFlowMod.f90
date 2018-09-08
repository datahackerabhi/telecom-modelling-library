module NetworkFlowMod

    use GraphMod
    
    implicit none

!   ......... Derived Type to hold a Network Structure
    type Network
        
        type( Graph )                        :: G
        real, dimension( :, : ), allocatable :: FlowVector
        real, dimension( : ), allocatable    :: CapacityVector
        real, dimension( : ), allocatable    :: CostVector
        real, dimension( :, : ), allocatable :: VertexFlow
        
    end type
		
		
		contains
		
		
!   ......... subroutine to set the source, destination and flow of a given Graph
		subroutine setSourceDestinationFlow(N,A)
				
				implicit none
				
				real, intent( in ), dimension( :, : ) :: A
				type( Network ), intent( inout )      :: N
				integer                               :: shapeArray(2)
				
				shapeArray = shape( A )
				
				allocate( N%VertexFlow( shapeArray(1), shapeArray(2) ) )
				allocate( N%FlowVector( N%G%m, shapeArray(2) ) )
				
				N%FlowVector = 0
				N%VertexFlow = A
				
		end subroutine
		
!   ............. subroutine to convert a directed Network to a bidirectional edge
		subroutine bidirectional( BN, N )
				
				implicit none
				
				type( Network ), intent( in )  ::  N
				type( Network ), intent( out ) :: BN
				integer                        :: i,shapeArray(2)
				
				BN%G%n = N%G%n
				BN%G%m = 2*N%G%m
				BN%G%isdirected = .true.
				
				shapeArray = shape( N%VertexFlow )
				
				allocate( BN%G%edges( BN%G%m, 2 ) )
				allocate( BN%CostVector( BN%G%m ) )
				allocate( BN%CapacityVector( BN%G%m ) )
				allocate( BN%VertexFlow( shapeArray(1), shapeArray(2) ) )
				
				
				do i = 1, N%G%m
						BN%G%edges( 2*i - 1, 1 ) = N%G%edges( i, 1 )
						BN%G%edges( 2*i - 1, 2 ) = N%G%edges( i, 2 )
						BN%G%edges( 2*i , 1 ) = N%G%edges( i, 2 )
						BN%G%edges( 2*i , 2 ) = N%G%edges( i, 1 )
						
						BN%CostVector( 2*i - 1 ) = N%CostVector( i )
						BN%CostVector( 2*i ) = N%CostVector( i )
						
						BN%CapacityVector( 2*i - 1 ) = N%CapacityVector( i )
						BN%CapacityVector( 2*i ) = N%CapacityVector( i )						
				end do
			
			BN%VertexFlow = N%VertexFlow
			
		end subroutine
end module
