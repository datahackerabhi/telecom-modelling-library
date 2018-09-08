module NetworkAMPLInterfaceMod
		
		use GraphMod
    use NetworkFlowMod
    
    implicit none
    
    
    contains
    
!   ......... subroutine to print a data file which is to be used as input to AMPL/NEOS    
    subroutine printAMPLDataFile( filename, N )
        
        implicit none
        
        type( Network ), intent( in )      :: N
        character( len = * ), intent( in ) :: filename
        integer                            :: ios,i,j,numcommodities,shapeArray( 2 )
				integer, allocatable               :: FlowConservationConstraintMatrix( :, : )
				
				FlowConservationConstraintMatrix = N%G
				
				shapeArray = shape( N%VertexFlow )
				numcommodities = shapeArray( 2 )
				
        open( unit = 10, file = filename, status = 'new', iostat = ios )

        write ( 10, * ) "param n := ",N%G%n,";"
        write ( 10, * ) "param m := ",N%G%m,";"
        write ( 10, * ) "param numcommodities := ",numcommodities,";"
        
        write ( 10, * ) "param: ","capacity ","cost ",":="
        do i = 1, N%G%m
            write( 10, * ) i, N%CapacityVector(i), N%CostVector(i)
        end do
        write( 10, * ) ";"
        
        write ( 10, * ) "param: ","netvertexflow ",":="
        do i = 1, N%G%n
        		do j = 1, numcommodities
            write(10 , * ) " ",i," ",j," ",N%VertexFlow(i,j)
            end do
        end do
        write( 10 , * ) ";"

        write( 10, * ) "param: ","incmat"," :=" 
        do i = 1, N%G%n
            do j = 1, N%G%m
                write( 10, * ) i," ",j," ",FlowConservationConstraintMatrix(i,j)
            end do
        end do
        write( 10, * ) ";"

        close( 10 )

        print *, "Created Data File for AMPL: AMPLInput.dat"
				
				deallocate( FlowConservationConstraintMatrix )
				
    end subroutine
    
    
end module
