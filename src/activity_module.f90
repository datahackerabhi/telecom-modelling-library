! This module contains 3 functions called cityActivity(), activityProduct() and populationAndActivityProduct().
 module activity_module
   use time_zone_module
   
   implicit none
   
   integer                         :: no_of_intervals, activity_read_status
   real, allocatable, dimension(:) :: activity_levels
   character( len = 28 ) :: activity_file = "../input/activity_levels.txt"

 contains

!   ---------------------------------------- STARTING OF THE 'cityActivity' FUNCTION ------------

!    .........The cityActivity() function returns the activity level of a city for a particular 
!    time interval from the 'activity_levels.txt' file.
   
   real function cityActivity ( city_number, time_interval ) result( city_activity )
    

!    ........Declaration of variables inside the function.

     integer, intent( in ) :: city_number, time_interval
     integer               :: i, ok, activity_index
     character             :: row
     real                  :: interval
     integer               :: file_status

!    ........Opening the 'activity_levels.txt' file to read interval values.

!    ........ To check if the file data is initialised into arrays or not (activity_read_status == 0 if not initialised).

     if( activity_read_status == 0 ) then
       open ( 10 , file = activity_file , status = 'old' , action = 'read' , iostat = file_status ) 
         if( file_status /= 0 ) then
	   print *, "activity_module :: function :: cityActivity :: error: Input file for activity levels not found in the input folder"
           stop
         else
           read( 10, 30 ) no_of_intervals
           30 format( T14, I4 )
           read( 10, * ) row

!          ........ allocate( ) function allocates memory in arrays for data and also ensures that it is successful.

           allocate( activity_levels( no_of_intervals ), stat = ok )
           if( ok /= 0 ) then
             print *, "activity_module::function::cityActivity::error:memory allocation for activity_levels array unsuccessful"
             stop
           endif
             read( 10, 40 ) ( activity_levels( i ), i = 1, no_of_intervals )
             40 format( F5.3 )
         endif
       close ( 10 )
       activity_read_status = 1
     endif

     activity_index = time_interval.shift.cityTimeZone ( city_number )
     city_activity = activity_levels( activity_index )
		
   end function cityActivity

!   ---------------------------------------- ENDING OF THE 'cityActivity' FUNCTION ----------------------------------------------------------------------------------------------------------	

!   ---------------------------------------- STARTING OF THE 'activityProduct' FUNCTION ----------------------------------------------------------------------------------------------------------

!  ........The activityProduct() function returns the prod-uct of activity levels of 2 cities at a particular time interval.

   real function activityProduct ( city_number1, city_number2, time_interval ) result( activity_product )
     
! 		........Declaration of variables.

     integer, intent( in ) :: city_number1, city_number2, time_interval
     real                  :: city_activity1, city_activity2
		
!       ........The city activity levels of 2 cities are stored in city_activity1 and city_activity2 respectively.

     city_activity1  = cityActivity ( city_number1, time_interval )
     city_activity2  = cityActivity ( city_number2, time_interval )
     activity_product = city_activity1 * city_activity2

   end function activityProduct
!   ---------------------------------------- ENDING OF THE 'activityProduct' FUNCTION ----------------------------------------------------------------------------------------------------------

!   ---------------------------------------- STARTING OF THE 'populationAndActivityProduct' FUNCTION ----------------------------------------------------------------------------------------------------------
!  .........The populationAndActivityProduct() function returns the product of the population and activity levels of 2 cities at a given time interval

   real*8 function populationAndActivityProduct ( city_number1, city_number2, time_interval ) result( population_activity_product )
     
		
!    ........Declaration of variables.

     integer, intent( in ) :: city_number1, city_number2, time_interval
     real                  :: activity_product 
     real*8                :: population_product
		
     activity_product             = activityProduct ( city_number1, city_number2, time_interval )
     population_product           = populationProduct ( city_number1, city_number2 )	
     population_activity_product  = activity_product * population_product

   end function populationAndActivityProduct
!   ---------------------------------------- ENDING OF THE 'populationAndActivityProduct' FUNCTION ----------------------------------------------------------------------------------------------------------

 end module
