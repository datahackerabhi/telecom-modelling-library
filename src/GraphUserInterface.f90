module GraphUserinterfaceMod
    
    use GraphMod
    
    implicit none
    
    
    contains
    
!   .......... subroutine to read data from a file and initialize the Graph 
    subroutine readGraphData(G,filename)
     
    		implicit none
    
   		  type( Graph ), intent( out )       :: G  
    		character( len = * ), intent( in ) :: filename
    		integer                            :: ios,i,j,v1,v2,directed
    
		    !open the input file
    		open(unit = 10, file = filename, status = 'old', iostat = ios)
    		
   		  !check for error in opening the file
    		if(ios.ne.0) then
      	    print *,"Error in Opening Graph Input File in GraphUserInterface::readGraphData()"
      		  stop
    		endif
    
    		
    		read( 10, * )  G%n, G%m, directed
    		
    		if ( directed == 1 ) then
      			G%isdirected = .true.
    		else 
      			G%isdirected = .false.
   		  end if
    
  
    		allocate( G%edges( G%m, 2 ) )

    		do i = 1, G%m
        		read( 10, * ) v1, v2
       		 G%edges(i,1) = v1
       		 G%edges(i,2) = v2
    		end do
  
    end subroutine


!   ......... subroutine to pretty-print the given 2-D matrix
    subroutine printMatrix( A ) 
  
  		  implicit none
  		  
    		integer, dimension( :, : ), intent( in ) :: A
    		integer                                  :: i,j
    		integer                                  :: shapeArray(2)
  
 		   shapeArray = shape(A)
  
 		   do i = 1, shapeArray( 1 )
 		       write( *, * ) ( A( i, j ) , j =  1,shapeArray( 2 ) )
 		   end do
 		   
 		   write( *, * )
 		   write( *, * )
  
    end subroutine

end module     
