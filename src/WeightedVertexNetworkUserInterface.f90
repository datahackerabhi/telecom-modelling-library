module WeightedVertexNetworkUserInterfaceMod

		use WeightedVertexNetworkFlowMod
		
		
		contains
		
!   ........ subroutine to load data in a file into a WeightedVertexNetwork		
		subroutine readWeightedVertexNetworkData( W, filename )
				
				implicit none
				
				character( len = * ), intent( in )           :: filename
				type( WeightedVertexNetwork ), intent (out ) :: W
        integer                                      :: i,ios
        
        open(unit = 10, file = filename, status = 'old', iostat = ios)
        
        if(ios.ne.0) then
            print *, "Error in Opening File in WeightedVertexNetworkUserInterface::readWeightedVertexNetworkData"
            stop
        endif
        read( 10, * ) W%N%G%n, W%N%G%m
        W%N%G%isdirected = .true.
        
        allocate( W%N%G%edges( W%N%G%m, 2 ) )
        allocate( W%N%CostVector( W%N%G%m ) )
        allocate( W%N%CapacityVector( W%N%G%m ) )   
				allocate( W%VertexWeights( W%N%G%n ) )
				
        do i = 1, W%N%G%m
            read( 10, * ) W%N%G%edges( i, 1 ), W%N%G%edges( i, 2 ), W%N%CostVector( i ), W%N%CapacityVector( i ) 
        end do
        
        do i = 1, W%N%G%n
        		read( 10, *)  W%VertexWeights( i )
        end do
    		
    		close( 10 )
    		
    end subroutine
    
!    ..........subroutine to load data regarding flow into an array A    
    subroutine readWeightedNetworkSourceDestinationFlow(A,filename)
        
        implicit none

        real, intent( out ), allocatable, dimension( :, : ) :: A
        character( len = * ), intent( in )                  ::filename
        integer                                             ::src,dest,ios,i,numcommodities,n
        real                                                ::flow
        
        open( unit = 10, file = filename, status='old', iostat=ios)
        
        if(ios .ne. 0) then
        		print *,"Error in opening File in WeightedVertexNetworkUserInterface:readWVNSourceDestinationFlow() "
        		stop
        end if
        
        read( 10, * )  n, numcommodities
  
        allocate( A( 2*n, numcommodities ) )
        
        A = 0
         
        do i = 1, numcommodities
        		read( 10, * ) src, dest, flow
        		A( 2*src-1 , i ) = -flow
        		A( 2*dest , i ) = flow
        end do
        
    end subroutine


end module
