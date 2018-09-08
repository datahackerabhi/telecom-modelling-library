! This program tests model for two cities/localities.
 program tes

!	........Modules that should be used for the software to work correctly.
   use map_module
   use time_zone_module
   use activity_module
   use affinity_module

!  ........Declaration of variables.
   integer   :: city1, city2, city1_population, city2_population, city1_language, city2_language, city1_Time_Zone, city2_Time_Zone 
   real      :: city1_latitude, city2_latitude, city1_longitude, city2_longitude, distance_between_city1_city2, city1_activity, city2_activity
   real      :: city_activity_product, cities_affinity
   real*8    :: city_population_product, calculated_trafficdensity, final_trafficdensity
   real*8    :: city_population_activity_product
   integer*8 :: no_of_calls

!  ........Giving city numbers as inputs.
   print *, " Please enter city numbers "
   read *, city1, city2

!  ------------------------------------------------------------- data_module test -------------------------------------------------------------------------------------
!  ........ data_module test for city1
   print *, " city1 "
   city1_population = getPopulation( city1 )
   city1_latitude   = getLatitude( city1 )
   city1_longitude  = getLongitude( city1 ) 
   city1_language   = getLanguage( city1 )

!  ........Printing the values related to city1
   print *, "population:", city1_population
   print *, "latitude:", city1_latitude
   print *, "longitude:", city1_longitude
   print *, "language", city1_language

!  ........ data_module test for city2
   print *, " city2 "
   city2_population = getPopulation( city2 )
   city2_latitude   = getLatitude( city2 )
   city2_longitude  = getLongitude( city2 )
   city2_language   = getLanguage( city2 )
   
!  ........Printing the values related to city2
   print *, "population:", city2_population
   print *, "latitude:", city2_latitude
   print *, "longitude:", city2_longitude
   print *, "language", city2_language

!  ---------------------------------------------------- map_module test -----------------------------------------------------------------------------------------------
   distance_between_city1_city2 = distance ( city1, city2 )

!  ........Printing the map_module test results.
   print *, "distance between city1 and city2:", distance_between_city1_city2

!  --------------------------------------------------- time_zone_module test ----------------------------------------------------------------------------------------
   city1_Time_Zone = cityTimeZone ( city1 )
   city2_Time_Zone = cityTimeZone ( city2 )

!  ........Printing the time_zone_module test results.
   print *, "city timezone:", city1_Time_Zone
   print *, "city timezone:", city2_Time_Zone

!  --------------------------------------------------- activity_module test -----------------------------------------------------------------------------------------------
   city1_activity = cityActivity( city1, 30 )
   city2_activity = cityActivity( city2, 30 )
   city_population_product = populationProduct ( city1, city2 )
   city_activity_product = activityProduct( city1, city2, 30 )
   city_population_activity_product = city_population_product * city_activity_product

!  ........Printing activity_module_test results.
   print *, "City activity:", city1_activity
   print *, "City activity:", city2_activity
   print *, "population product:", city_population_product
   print *, "Activity product:", city_activity_product
   print *, "product of popualtion and activity", city_population_activity_product

!  ----------------------------------------------------- affinity_module test -----------------------------------------------------------------------------------------------
   cities_affinity = affinity( city1, city2 )
   calculated_trafficdensity = cities_affinity * city_population_activity_product

!  ........Printing the affinity_module test results.
   print *, "affinity between two cities:", cities_affinity
   print *, "calculated traffic density:",calculated_trafficdensity
   final_trafficdensity = trafficDensity ( city1, city2, 30)
	
!  ........Printing the affinity_module test results.
   print *, "traffic density:", final_trafficdensity
   no_of_calls = ncalls( city1, city2, 30 )   
   print *, " no of calls: ", no_of_calls
        
!  ........Checking whether the calculated and obtained traffic density is equal or not.
   if( calculated_trafficdensity == final_trafficdensity ) then
     print *,"TESTED SUCCESSFULLY!"
   else
     print *, "NOt Succesful"
   endif
 !  call write_input_file( '../input/inputs.txt', 'Rajamahendravaram', 1236900, 78.8, 18.8, 'Rajasthani', 05)
 end program tes
