module GraphMod
 
	  implicit none
  
! .......... derived type to hold Graph Structure
	  type Graph

		    logical                                 :: isdirected  
		    integer                                 :: n                   !no. of vertices
		    integer                                 :: m                   !no. of edges
		    integer, dimension( :, : ), allocatable :: edges 

	  end type Graph


! .......... overloading the assignment operator with subroutine incidenceMatrix  
	  interface assignment ( = )
	      module procedure incidenceMatrix
	  end interface   

  
	  contains

  
! ........... function to compute the adjacency matrix of the graph
	  function adjacency( G ) result( A )

			  implicit none

	  		type ( Graph ), intent( in )      :: G   
	  		integer, dimension( G%n, G%n )    :: A 
	  		integer                           :: i,j
  
	  		A = 0  
	  		
	  		call confirmNoSelfLoop( G )
	   		
	  		if( G%isdirected .eqv. .false. ) then
				    do i = 1, G%m
    			  		A( G%edges( i, 2 ), G%edges( i, 1 ) ) = 1
    			  		A( G%edges( i, 1 ), G%edges( i, 2 ) ) = 1
    		    end do
  			else
    				do i = 1, G%m
      					A( G%edges( i, 2 ), G%edges( i, 1 ) ) = 1
		  			    A( G%edges( i, 1 ), G%edges( i, 2 ) ) = -1
    				end do
  			end if
  
  	end function


! ............ subroutine to compute the adjacency matrix of the graph
	  subroutine adjacencyMatrix( A, G )
 		
			  implicit none

  			type( Graph ), intent( in )         :: G   
  			integer, allocatable, intent( out ) :: A( :, : )
  			integer                             :: i,j
  
  			allocate( A ( G%n, G%n ) )

  			A = 0  

  			call confirmNoSelfLoop( G )
  
  			if( G%isdirected .eqv. .false. ) then
			    	do i = 1, G%m
		      			A( G%edges( i, 2 ), G%edges( i, 1 ) ) = 1
		      			A( G%edges( i, 1 ), G%edges( i, 2 ) ) = 1
    				end do
  			else
    				do i = 1, G%m
					      A( G%edges( i, 2 ), G%edges( i, 1 ) ) = 1
					      A( G%edges( i, 1 ), G%edges( i, 2 ) ) = -1
				    end do
			  end if
  
	  end subroutine  


!   .......... function to compute the incidence matrix of the of the graph
	  function incidence( G ) result( A )
	  
  
			  implicit none

			  type ( Graph ) , intent( in )   :: G
			  integer, dimension ( G%n, G%m ) :: A  
			  integer                         :: i,j
	
			  A = 0
  
			  call confirmNoSelfLoop( G )
			  
			  if( G%isdirected .eqv. .false. ) then
				    do i = 1, G%m
					      A( G%edges( i, 2 ), i ) = 1
					      A( G%edges( i, 1 ), i ) = 1
				    end do
  			else
    				do i = 1, G%m
   			   			A( G%edges( i, 2 ), i ) = 1
   			   			A( G%edges( i, 1 ), i ) = -1
   					end do
  			end if 
 
	  end function

!   .......... subroutine to compute the incidence matrix of the of the graph
  	subroutine incidenceMatrix( A, G )
  
  			implicit none

  			type( Graph ), intent( in )         :: G  
 				integer, allocatable, intent( out ) :: A( :, : )
  			integer                             :: i,j
  
  			allocate( A( G%n, G%m ) )

  			A = 0
  
  			call confirmNoSelfLoop( G )
 				
  			if( G%isdirected .eqv. .false. ) then
    				do i = 1, G%m
      					A( G%edges( i, 2 ), i ) = 1
      					A( G%edges( i, 1 ), i ) = 1
    				end do
  			else
    				do i = 1, G%m
      					A( G%edges( i, 2 ), i ) = 1
      					A( G%edges( i, 1 ), i ) = -1
    				end do
  			end if 
  
  	end subroutine
    
!   ......... subroutine to confirm that there existed no self loops in the graph.
  	subroutine confirmNoSelfLoop(G)
  
  			type( Graph ), intent( in ) :: G
  			integer                     :: i
  
  			do i = 1, G%m
				    if( G%edges( i, 1 ) == G%edges( i, 2 ) ) then
      					print *, "Self Loop Not Allowed. Exiting ..."
      					stop
    				end if
  			end do
  
 	 end subroutine
 	 
 	 
end module GraphMod

!Note: Self Loop is an edge from a node to itself
