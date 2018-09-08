! This module consists of 2 functions 'shiftTimeZone' and 'cityTimeZone'.

 module time_zone_module
 
!  ........ Using the module named 'map_module'  

   use map_module 
   implicit none
   
!  ........ Declaration of variables

   integer, parameter :: minutes_in_a_day = 1440 ! Total minutes in a day ( 24 hours * 60 minutes )
   integer, parameter :: interval_length = 30    ! 24 hours divided into 48 intervals of length 30 minutes
   real, parameter    :: time_zone_negative2 = 72.0, time_zone_negative1 = 76.0,time_zone_0 = 82.0,time_zone_positive1 = 88.0
   real,parameter     :: time_zone_positive2=96

!  ........The shiftTimeZone function is used to return the time interval of a new city by shifting 
!  the central time zone to the required city's time zone.

   interface operator ( .shift. )
     module procedure shiftTimeZone
   end interface

 contains

! ---------------------------------------- STARTING OF THE 'shiftTimeZone' FUNCTION ----------------------------
   function shiftTimeZone ( time_interval, timezone) result( actual_interval )

!    ........Declaration of variables.

     integer, intent ( in ) :: time_interval, timezone
     integer                :: actual_interval, ind, no_of_intervals, interval
     
     interval = time_interval - 1
     no_of_intervals = minutes_in_a_day / interval_length
     ind =  mod ( ceiling( ( real( timezone ) / interval_length ) + interval ), no_of_intervals) + 1
     
     if( ind <= 0 ) then
       actual_interval = no_of_intervals - ind
     else
       actual_interval = ind
     endif

   end function shiftTimeZone

!  ---------------------------------------- ENDING OF THE 'shiftTimeZone' FUNCTION ------------------------------

!  ---------------------------------------- STARTING OF THE 'cityTimeZone' FUNCTION -----------------------------
!  ........The cityTimeZone function decides and returns the Time Zone number of a particular city based on the 
!  pre-defined Time Zone divisions.

   integer function cityTimeZone ( city_number ) result( city_timezone )

!	 ........Declaration of variables.

     integer , intent ( in ) :: city_number
     integer                 :: zone
     real                    :: longitude

!	 ........longitude of a city is obtained from the 'getData' function.

     longitude       = getLongitude( city_number )

!	 ........Based on the longitude of a city/locality, its zone is obtained.

     if( longitude <= time_zone_negative2 ) then
       zone = time_zone_negative2
     else if ( longitude > time_zone_negative2 .AND. longitude <= time_zone_negative1 ) then
       zone = time_zone_negative1
     else if ( longitude > time_zone_negative1 .AND. longitude <= time_zone_0 ) then
       zone = time_zone_0
     else if ( longitude > time_zone_0 .AND. longitude <= time_zone_positive1 ) then
       zone = time_zone_positive1 
     else 
       zone = time_zone_positive2
     end if
       city_timezone    = (zone - time_zone_0) * 4

   end function cityTimeZone
!   ---------------------------------------- ENDING OF THE 'cityTimeZone' FUNCTION ----------------------------------------------------------------------------------------

 end module
