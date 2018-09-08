module NetworkUserInterfaceMod
		
		use GraphMod
    use NetworkFlowMod
    
    implicit none
    
    
    contains
    
!   .......... subroutine to load the network data from a file to Network     
    subroutine readNetworkData( N, filename )
        
        implicit none
        
        type( Network ), intent( out )     :: N
        character( len = * ), intent( in ) :: filename
        integer                            :: ios,i,directed
        
        open(unit = 10, file = filename, status = 'old', iostat = ios)
        
        
        if(ios .ne. 0) then
            print *, "Error in Opening File in NetworkUserInterfaceMod::readNetworkData()"
            stop
        endif
        
        read(10,*) N%G%n, N%G%m
        
        N%G%isdirected = .true.
        
        allocate( N%CostVector( N%G%m ) )
        allocate( N%G%edges( N%G%m, 2 ) )
        allocate( N%CapacityVector( N%G%m ) )
        
        do i = 1, N%G%m
            read( 10, * ) N%G%edges( i, 1 ), N%G%edges( i, 2 ), N%CostVector( i ),N%CapacityVector( i ) 
        end do
        
        close( 10 )

    end subroutine
    
!   .......... subroutine to load data regarding flow into the Network    
    subroutine setSourceDestinationFlow_(N,numcommodities,filename)
        
        implicit none

        type( Network ), intent( inout ) :: N
        integer, intent( out )           :: numcommodities
        character( len = * )             :: filename
        integer                          ::src,dest,ios,i
        real                             ::flow
        
        open( unit = 10, file = filename, status='old', iostat=ios )
        
        if(ios .ne. 0) then
        		print *, "Error in opening File. Exit Code: ",ios
        		stop
        end if
        
        read( 10, * ) numcommodities
  
        allocate( N%VertexFlow( N%G%n, numcommodities ) )
        allocate( N%FlowVector( N%G%m, numcommodities ) )
        
        N%FlowVector = 0
        N%VertexFlow = 0
              
        do i = 1, numcommodities
        		read( 10, * ) src, dest, flow
        		N%VertexFlow( src, i ) = -flow
        		N%VertexFlow( dest, i ) = flow
        end do
        
    end subroutine
    
!   ......... subroutine to read data regarding flow into an 2-D array    
    subroutine readSourceDestinationFlowData(A,filename)
    		
    		implicit none
    		
    		real, allocatable, intent( out )   :: A( :, : )
    		character( len = * ), intent( in ) :: filename
    		integer                            :: numcommodities, n, src, dest, ios, i
        real                               :: flow
        
    		open( unit = 10, file = filename, status='old', iostat=ios )
        
        if( ios .ne. 0 ) then
        		print *, "Error in opening File. Exit Code: ", ios
        		stop
        end if
        
        read( 10, * ) n, numcommodities
        
        allocate( A( n, numcommodities ) )
        
        do i = 1, numcommodities
        		read( 10, * ) src, dest, flow
        		A( src, i ) = -flow
        		A( dest, i ) = flow
        end do
        
    end subroutine
    		
!   ......... subroutine to read data regarding flow from the user		
		subroutine uiSourceDestinationFlow_(src,dest,flow)
        
        implicit none
        
        integer, intent( out ) :: src, dest
        real, intent( out )    :: flow
        
        print *, "Enter Source Node, Destination Node and Flow "
        read( *, * ) src, dest, flow
        
    end subroutine
    
    
end module 
