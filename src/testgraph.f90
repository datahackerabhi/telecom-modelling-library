
program testgraph
  
  use GraphMod
  use GraphUserInterfaceMod

  implicit none

  type(Graph)                           :: G  
  integer                               :: i,j    
  integer,allocatable,dimension( :, : ) :: AdjMat   
  integer,allocatable,dimension( :, : ) :: IncMat, IncMat1  
  
  print *, "Program to test GraphMod.f90 and GraphUserInterface.f90 "

! ....... read user data
  call readGraphData( G, "../input/GraphInput.dat" )    
	
	print *, " Printing Adjacency Matrix "
	
  call adjacencyMatrix( AdjMat, G )        
  call printMatrix( AdjMat )

	print *, " Printing Incidence Matrix in two different ways "
	
	print *, " Method 1 "
  IncMat = G
  call printMatrix( IncMat )
  
  print *, " Method 2 "
  call incidenceMatrix( IncMat1, G )
  call printMatrix( Incmat1 )
	
	print *, "Graph Modules tested sucessfully "	
	deallocate( G%edges )
	
end program testgraph


