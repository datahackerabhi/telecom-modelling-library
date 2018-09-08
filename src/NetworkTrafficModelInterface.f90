module NetworkTrafficModelInterfaceMod
		
		use map_module ! system-level commands were commented out in subroutine write_input_file belonging to map_module
		use affinity_module
		use NetworkFlowMod
		
		implicit none
!   ......... currently the cost and capacity for every node is a fixed arbitrary number		
		integer, parameter :: time_interval = 30, coverage_dist = 5000, intermediate_nodes = 20
		real, parameter    :: cost = 50.0, capacity = 10000000.0
		real, parameter    :: lat_upper_limit = 38.0, lat_lower_limit = 8.0, lon_lower_limit = 68.0, lon_upper_limit = 97.0
   	
		
		contains
		
!   ......... subroutine to initialize a network from Math-Model Input file
		subroutine createNetwork(N,filename)
				
				implicit none
				
				type( Network ), intent( out )     :: N
				character( len = * ), intent( in ) :: filename
				integer                            :: num_cities(1)
				
				N%G%isdirected = .true.
				
				call read_data( filename )  !function definintion in map_module.f90
				
				num_cities = shape( population )	
				N%G%n = num_cities( 1 ) 
				
				call createEdges( N )
				call fillVertexFlow( N )
				call fillCostCapacity( N )
				
		end subroutine
		
!   ......... subroutine to create edges between any cities that are within the coverage_dist
		subroutine createEdges(N)
				
				implicit none
				
				type( Network ), intent( inout )         :: N
				integer                                  :: i, j, ctr
				real, allocatable,dimension( :, : )      :: dist

!			  ..........the actual cities are numbered from 1 to n while the intermediate nodes are appended to the list
				N%G%n = N%G%n + intermediate_nodes
				
				allocate(dist(N%G%n,N%G%n))
				
				ctr = 0
				do i = 1, N%G%n
						do j = i+1, N%G%n
								dist(i,j) = distance_intermediate( i, j, N )
								if ( dist(i,j) < coverage_dist ) then
										ctr = ctr +1
								end if				
					  end do
			  end do
			  
			  N%G%m = ctr

			  allocate( N%G%edges( N%G%m, 2 ) )
			  
			  ctr = 1
			  do i = 1, N%G%n
						do j = i+1, N%G%n
								if ( dist(i,j) < coverage_dist ) then
										N%G%edges( ctr, 1 ) = i
										N%G%edges( ctr, 2 ) = j
										ctr = ctr + 1
								end if				
					  end do
			  end do
	
				deallocate( dist )	
				
		end subroutine
		
!   ......... subroutine to populate the Network with the total amount of flow through each node
		subroutine  fillVertexFlow(N)
		
				implicit none
				
				type( Network ), intent( inout )  :: N
				integer                           :: i, j, k, actual_cities
				
				actual_cities = N%G%n - intermediate_nodes
				
				allocate( N%VertexFlow( N%G%n, actual_cities*( actual_cities - 1 )/2 ) )
				
				N%VertexFlow = 0
				
				k = 1
				do i = 1, actual_cities
						do j = i+1, actual_cities						
								N%VertexFlow( i, k ) = -ncalls( i, j, time_interval )
								N%VertexFlow( j, k ) =  ncalls( i, j, time_interval )
								k = k + 1
						end do
				end do
				
		end subroutine
		
!   ......... subroutine to fill the Network with the cost and capacity of each edge
		subroutine fillCostCapacity(N)
		
				implicit none
				
				type( Network ), intent( inout ) :: N
				integer                          :: i
				
				allocate( N%CostVector( N%G%m ) )
				allocate( N%CapacityVector( N%G%m ) )
				
				do i = 1, N%G%m
						N%CostVector( i ) = cost
						N%CapacityVector( i ) = capacity
				end do
		
		end subroutine
				
!   ........ function to return distance between two cities				
		real function distance_intermediate( city1, city2, N ) result ( city1_city2_distance )
				
				implicit none
				
				integer,intent ( in )         :: city1, city2
				type( Network ), intent( in ) :: N
    		real                          :: deglat1, deglon1, deglat2, deglon2
     		real                          :: a, c, dlat, dlon, lat1, lat2
     		integer												:: actual_cities
				
				actual_cities = N%G%n - intermediate_nodes
				
				if( city1 > actual_cities ) then
						deglat1 = rand()*( lat_upper_limit - lat_lower_limit ) + lat_lower_limit
						deglon1 = rand()*( lon_upper_limit - lon_lower_limit ) + lon_lower_limit
				else 
						deglat1 = getLatitude ( city1 )
		     		deglon1 = getLongitude ( city1 )
		    end if
		    
		    if( city2 > actual_cities ) then
						deglat2 = rand()*( lat_upper_limit - lat_lower_limit ) + lat_lower_limit
						deglon2 = rand()*( lon_upper_limit - lon_lower_limit ) + lon_lower_limit
				else 
						deglat2 = getLatitude ( city2 )
		     		deglon2 = getLongitude ( city2 )
		    end if
     										
				dlat = to_radian ( deglat2 - deglat1 )
     		dlon = to_radian ( deglon2 - deglon1 )
				lat1 = to_radian ( deglat1 )
				lat2 = to_radian ( deglat2 )
								
				a =  ( sin ( dlat/2 ) ) ** 2 + cos ( lat1 ) * cos ( lat2 ) * ( sin ( dlon/2 ) ) ** 2
     		c = 2 * asin ( sqrt ( a ) )
     		city1_city2_distance = radius * c
     		
		end function
				 
				 
end module
		
