! This module consists of 2 subroutines and 5 functions
 module map_module

   implicit none

! ........Declaration of variables.
   real, parameter                      :: radius = 6372.8
   integer                              :: nrows, map_read_status
   character                            :: row
   integer,   allocatable, dimension(:) :: language_code
   integer*8, allocatable, dimension(:) :: population
   real,      allocatable, dimension(:) :: latitude, longitude
   character( len = 19) :: input_file = "../input/inputs.txt"

 contains

!  -----------------------------STARTING OF THE  'read_data()' SUBROUTINE ----------------------------
   subroutine read_data(inp_file)

     character( len = * ), intent( in ) :: inp_file 
     integer :: file_status, ok, i
     
!    ........Opening the 'inputs.txt' file to read data.

     open( unit= 10, file = inp_file, status = 'old', action = 'read', iostat = file_status )
	 
!    ........ Checking for the input file exist or I/O errors.

     if( file_status /= 0 ) then
       print *, " map_module :: subroutine :: read_data :: Input file not found in the input folder"
       stop
     else
	 
     read( 10, 5) nrows
     5 format ( T9, I8 )
         
     do i = 1,2
       read( 10, *) row
     end do
         
!    ........ The 'allocate ()' function allocates memory in arrays for the data present in the file.	 
	 
     allocate( population( nrows ), latitude( nrows ), longitude( nrows ), language_code( nrows ), STAT = ok )
	 
     if( ok /= 0 ) then
       print *, "map_module :: subroutine :: read_data :: memory allocation not successful"
       stop
     endif
	 
     read( 10, 20 ) ( population(i), latitude(i), longitude(i), language_code(i), i = 1, nrows )
     20 format ( T33, I8, TR3, F8.4, TR3, F8.4, TR17, I2)
     endif
     close( 10 )
     map_read_status = 1
   end subroutine
!  -----------------------------ENDING OF THE  'read_data()' SUBROUTINE ----------------------------  

!  -----------------------------STARTING OF THE  'getPopulation()' FUNCTION ----------------------------

   integer*8 function getPopulation( city_number ) result( pop )
     integer, intent( in ) :: city_number
     if( map_read_status == 0 ) then
       call read_data( input_file )
     endif
     pop = population( city_number )
   end function getPopulation
   
!  -----------------------------ENDING OF THE  'getPopulation()' FUNCTION ----------------------------
   
!  -----------------------------STARTING OF THE  'getLatitude()' FUNCTION ----------------------------   

   real function getLatitude( city_number ) result( city_latitude )
     integer, intent( in ) :: city_number
     if( map_read_status == 0 ) then
       call read_data( input_file )
     endif
     city_latitude = latitude( city_number )
   end function getLatitude

!  -----------------------------ENDING OF THE  'getLatitude()' FUNCTION ----------------------------      

!  -----------------------------STARTING OF THE  'getLongitude()' FUNCTION ----------------------------   
   real function getLongitude( city_number ) result( city_longitude )
     integer, intent( in ) :: city_number
     if( map_read_status == 0 ) then
       call read_data( input_file )
     endif
     city_longitude = longitude( city_number )
   end function getLongitude

!  -----------------------------ENDING OF THE  'getLongitude()' FUNCTION ----------------------------   

!  -----------------------------STARTING OF THE  'getLanguage()' FUNCTION ----------------------------   

   integer function getLanguage( city_number ) result( city_language_code )
     integer, intent( in ) :: city_number
     if( map_read_status == 0 ) then
       call read_data( input_file )
     endif
     city_language_code = language_code( city_number )
   end function getLanguage

!  -----------------------------ENDING OF THE  'getLanguage()' FUNCTION ----------------------------   

!  ---------------------------------------- STARTING OF THE 'distance' FUNCTION ----------------

!  .........The distance() function calculates and returns the distance between 2 cities using its coordinates.	

   real function distance ( city_number1 , city_number2 ) result( city1_city2_distance )			


!    ........Declaration of requried variables.
     integer,intent ( in ) :: city_number1, city_number2
     real                  :: deglat1, deglon1, deglat2, deglon2
     real                  :: a, c, dlat, dlon, lat1, lat2, rad

!    ........Calling getData() to get the coordinates of the 1st city.
     deglat1 = getLatitude ( city_number1)
     deglon1 = getLongitude ( city_number1)

!    ........Calling getData() to get the coordinates of the 2nd city.
     deglat2 = getLatitude ( city_number2)
     deglon2 = getLongitude ( city_number2)

!    ........Converting coordinates of the city from degree to radians by calling 'to_radians' subroutine.
     dlat = to_radian ( deglat2-deglat1 )
     dlon = to_radian ( deglon2-deglon1 )
     lat1 = to_radian ( deglat1 )
     lat2 = to_radian ( deglat2 )

!    ........Haversine Formula to calculate the distance using latitude and longitude (coordinates)
     a =  ( sin ( dlat/2 ) ) ** 2 + cos ( lat1 ) * cos ( lat2 ) * ( sin ( dlon/2 ) ) ** 2
     c = 2 * asin ( sqrt ( a ) )
     city1_city2_distance = radius * c
   
   end function distance
!    ---------------------------------------- ENDING OF THE 'distance' FUNCTION ------------

!    ---------------------------------------- STARTING OF THE 'to_radian' FUNCTION ------

! 	 .........Function to convert degrees into radians.
   real function to_radian( degree ) result( rad )

!	   ........Declaration of variables.
     real, intent ( in ) :: degree
! 	   .........Exploit intrinsic atan to generate pi/180 runtime constant
     real, parameter      :: deg_to_rad = atan ( 1.0 ) / 45 
     rad = degree * deg_to_rad

   end function to_radian
!    ---------------------------------------- ENDING OF THE 'to_radian' FUNCTION ---------

!    ---------------------------------------- STARTING OF THE 'populationProduct' FUNCTION ----

!    The populationProduct() function sends 2 city numbers as argumentts. 
!    It gets the 2 population values of the 2 cities and returns their product.
	
   real*8 function populationProduct ( city_number1, city_number2 ) result( population_product )	

!	   ........Declaration of variables.
     integer, intent( in ) :: city_number1, city_number2	
     integer*8             :: pop1, pop2
		
!      ........The population of 2 cities is stored as pop1 and pop2.
!      ........The '1' in the 2nd argument represents the column_code, which corresponds to the 'Population' 
!      column in the 'inputs.txt' (input) file.
     pop1 = getPopulation( city_number1 ) 
     pop2 = getPopulation( city_number2 ) 
     population_product = pop1 * pop2 
   end function populationProduct
!    ---------------------------------------- ENDING OF THE 'populationProduct' FUNCTION -------	

!    ---------------------------------------- STARTING OF THE 'write_input_file' SUBROUTINE -------	  

   subroutine write_input_file( inp_file, city_name, pop, lat, lon, lan, lang_code)
    
     character( len = * ), intent ( in ) :: city_name, lan, inp_file
     integer, intent( in ) :: pop
     real, intent( in ) :: lat, lon
     integer, intent( in ) :: lang_code
     integer :: file_status, city_number,res, command_status, system
     if( map_read_status == 0 ) then
       call read_data( inp_file )
     endif
     city_number = nrows + 1
     open( 25, file = inp_file, status = "old", position = "append", action = "write", iostat = file_status )
       if( file_status /= 0) then
         print *, " map_module :: subroutine :: write_input_file :: input file not found "
         stop
       endif
       write( 25, 100) city_number, city_name, pop, lat, lon, lan, lang_code
       100  format( I6, 3X, A20, 3X, I8, 3X, F8.4, 3X, F8.4, 3X, A10, 3X, I2 )
     close( 25 )
	  
     open( 33, file = "../input/input.txt", status = "new", action = "write", iostat = file_status )
       if( file_status /= 0) then
         print *, "map_module :: subroutine :: write_input_file :: input file not found "
         stop
       endif
       write ( 33, 55 ) "nrows", city_number
       55 format( A5,3X,I8 )
     close( 33 )
!     command_status = system( "ex -sc '1d|x' " // inp_file // " && cat " // inp_file //" >> ../input/input.txt && rm " // inp_file // " && mv ../input/input.txt " // inp_file )
!     if( command_status /=0 ) then
!       stop ' map_module :: subroutine :: write_input_file :: system: command error from write method in map_module'
!     endif
   end subroutine write_input_file	
	
!    ---------------------------------------- ENDING OF THE 'write_input_file' SUBROUTINE -------	  
 end module
