param m >0;
param n >0;
param numcommodities >0;
 
set edges := {1..m};
set flow_at_nodes := {1..n};
set commodities := {1..numcommodities};

param netvertexflow{flow_at_nodes,commodities} ;
param capacity {edges}>0;
param cost{edges}>0;
param incmat{flow_at_nodes,edges};

var flow {e in edges,c in commodities} >= 0  ;

var totalflow {e in edges} = sum{c in commodities} flow[e,c];

minimize total_cost: sum{e in edges} cost[e]*totalflow[e];

subject to flowconservationconstraint{f in flow_at_nodes,c in commodities}:
	sum{e in edges} incmat[f,e]*flow[e,c] == netvertexflow[f,c];  

subject to capacityconstraint{e in edges}: 
     -capacity[e] <= totalflow[e] <= capacity[e];