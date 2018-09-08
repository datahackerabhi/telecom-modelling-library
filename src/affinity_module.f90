! This module contains 3 functions affinity(), trafficDensity() and ncalls().
 module affinity_module
   use activity_module

   implicit none

   integer, parameter :: distance_scale = 900
   real, parameter :: density_scale = 6.45684574E-8

!  ........The affinity() function returns the affinity level between 2 cities based on the distance between them and their native languages.
 contains
   
!  ---------------------------------------- STARTING OF THE 'affinity' FUNCTION ----------------------------------------------------------------------------------------
   real function affinity ( city1, city2 ) result( city1_city2_affinity )

!      ........Declaration of variables.
     integer, intent ( in ) :: city1, city2
     real                   :: dist, distance_factor, language_factor
     integer                :: city1_language, city2_language

!      ........The distance between 2 cities is stored in dist by using the 'distance' function.
     dist = distance ( city1, city2 )
     distance_factor = distance_scale / ( distance_scale + dist )           
!      ........The '4' in the 2nd arguments represents the 'column_code' in the 'inputs.txt'(input) file which corresponds to the native language of a city/locality.		
     city1_language = getLanguage( city1 )	
     city2_language = getLanguage( city2 )	

!      ........The language of 2 cities is used as a factor by alloting a particular value called 'language_factor', based on the equivalence of the languages.
     if( city1_language == city2_language) then
       language_factor = 1.0
     else 
       language_factor = 0.5	
     endif

!      ........Based on the above comparisions, affinity value between 2 cities is obtained by the sum of the distance factor and language factor.
     city1_city2_affinity = distance_factor * language_factor
   end function affinity

!    ---------------------------------------- ENDING OF THE 'affinity' FUNCTION -------------

!    ---------------------------------------- STARTING OF THE 'trafficDensity' FUNCTION -----

!    ........The trafficDensity function returns the product of affinity value and population-activity-product between 2 cities.

   real*8 function trafficDensity ( city1, city2, time_interval ) result( traffic_density )

!	   ........Declaration of variables.
     integer, intent ( in ) :: city1, city2, time_interval
     real                   :: affinity_value
     real*8                 :: population_activity_product

!	   ........Affinity value between 2 cities if returned by the affinity function and stored as affinity_value.
     affinity_value = affinity ( city1, city2 ) 
     population_activity_product = populationAndActivityProduct ( city1, city2, time_interval ) 
		
! 	   .........The trafficDensity value is obtained by the product of affinity value and  population-activity-product value between 2 cities.
     traffic_density = affinity_value * population_activity_product

   end function trafficDensity

!   ---------------------------------------- ENDING OF THE 'trafficDensity' FUNCTION ----------------------------------------------------------------------------------------

!   -----------------------------------------STARTING OF THE 'ncalls' FUNCTION-----------------------------------------------------------------------------------------------

!   ---------------------The ncalls function returns the approximate number of phone calls between two cities/localities-----------------------------------------------------

   integer function ncalls( city1, city2, time_interval ) result( no_of_calls )
   
!	   ........Declaration of variables.
     integer, intent( in ) :: city1, city2, time_interval
     real*8                :: traffic_density

!          ........traffic density value returned by the 'trafficDensity' function stored as traffic_density value.
     traffic_density = trafficDensity( city1, city2, time_interval )

!           .............. The approximate number of phone calls between two cities/localities at a given time is obtained by multiplying traffic_density with density_scale.
     no_of_calls = INT( traffic_density * density_scale )

   end function ncalls

 end module affinity_module
