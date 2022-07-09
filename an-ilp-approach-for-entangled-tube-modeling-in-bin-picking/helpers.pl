% Helper predicates (not in mode declarations).

:- include(vectors).

lemma(P):-
	call(P),
	%asserta((P :- !)).
	(
		(clause(P,!), !);
		asserta((P :- !))
	).

% get_node(+Nodes,+NodeID).
get_node(Nodes,NodeID):-
	member(node(NodeID,_,_,_),Nodes).

% is_connected_twice(+ExampleID,+NodeID).
is_connected_twice(ExampleID,NdID):-
	example(ExampleID,_,Edges,_,_,_),
	adj(Edges,NdID,Nb),
	adj(Edges,NdID,Nc),
	Nb < Nc.

% is_not_connected_twice(+ExampleID,+NodeID).
is_not_connected_twice(ExampleID,NdID):-
	\+is_connected_twice(ExampleID,NdID).

% are_connected(+ExampleID,+NodeID1,-NodeID2).
are_connected(ExampleID,NdID1,NdID2):-
	NdID1 =< NdID2,
	lemma(are_connected_mem(ExampleID,NdID1,NdID2)).
are_connected(ExampleID,NdID1,NdID2):-
	NdID1 > NdID2,
	lemma(are_connected_mem(ExampleID,NdID2,NdID1)).	

:- dynamic are_connected_mem/3.
are_connected_mem(ExampleID,NdID1,NdID2):-
	dfs(ExampleID,NdID2,[NdID1],_).

% are_not_connected(+ExampleID,+NodeID1,-NodeID2).
are_not_connected(ExampleID,NdID1,NdID2):-
	\+are_connected(ExampleID,NdID1,NdID2).

% tube_length(+ExampleID,+NodeID,-Len).
tube_length(ExampleID,NdID,Len):-
	tube_length_aux(ExampleID,[NdID],0,Len).

% difference(+A,+B,-D).
difference(A,B,D):-
	D is abs(A - B).

% endpoint_euclid_dist(+ExampleID,+NodeID1,+NodeID2,-Dist).
endpoint_euclid_dist(ExampleID,NdID1,NdID2,D):-
	NdID1 =< NdID2,
	lemma(endpoint_euclid_dist_mem(ExampleID,NdID1,NdID2,D)).
endpoint_euclid_dist(ExampleID,NdID1,NdID2,D):-
	NdID1 > NdID2,
	lemma(endpoint_euclid_dist_mem(ExampleID,NdID2,NdID1,D)).

:- dynamic endpoint_euclid_dist_mem/4.
endpoint_euclid_dist_mem(ExampleID,NdID1,NdID2,D):-
	tube_node(ExampleID,NdID1,X1,Y1,Z1),
	tube_node(ExampleID,NdID2,X2,Y2,Z2),
	Dx is (X1 - X2)*(X1 - X2),
	Dy is (Y1 - Y2)*(Y1 - Y2),
	Dz is (Z1 - Z2)*(Z1 - Z2),
	D is sqrt(Dx + Dy + Dz).
	
% endpoint_angular_dist(+ExampleID,+NodeID1,+NodeID2,-Dist).
endpoint_angular_dist(ExampleID,NdID1,NdID2,D):-
	NdID1 =< NdID2,
	lemma(endpoint_angular_dist_mem(ExampleID,NdID1,NdID2,D)).
endpoint_angular_dist(ExampleID,NdID1,NdID2,D):-
	NdID1 > NdID2,
	lemma(endpoint_angular_dist_mem(ExampleID,NdID2,NdID1,D)).

:- dynamic endpoint_angular_dist_mem/4.
endpoint_angular_dist_mem(ExampleID,NdID1,NdID2,D):-
	tube_node(ExampleID,NdID1,X1,Y1,Z1),
	tube_node(ExampleID,NdID2,X2,Y2,Z2),
	Dx is X2 - X1,
	Dy is Y2 - Y1,
	Dz is Z2 - Z1,
	vec_normaliza([Dx,Dy,Dz],Point2PointVec),
	get_adj_cylinder_dir(ExampleID,NdID1,-1,Dir1),
	get_adj_cylinder_dir(ExampleID,NdID2,1,Dir2),
	vec_dot_product(Dir1,Point2PointVec,Dot1),
	vec_dot_product(Dir2,Point2PointVec,Dot2),
	Angle1 is acos(max(-1.0,min(1.0,Dot1))),
	Angle2 is acos(max(-1.0,min(1.0,Dot2))),
	D is (Angle1 + Angle2) * 180.0 / pi.

% get_adj_cylinder_dir(+ExampleID,+NodeID,+Dir,-DirVector).
% Dir is 1 ou -1
get_adj_cylinder_dir(ExampleID,NodeID,Dir,DirVector):-
	adj(ExampleID,NodeID,AdjNodeID),
	tube_node(ExampleID,NodeID,X1,Y1,Z1),
	tube_node(ExampleID,AdjNodeID,X2,Y2,Z2),
	get_cylinder_dir([X1,Y1,Z1],[X2,Y2,Z2],Dir,DirVector).

% get_cylinder_dir(+Pos1,+Pos2,+Dir,-DirVector).
% Dir is 1 ou -1
get_cylinder_dir([X1,Y1,Z1],[X2,Y2,Z2],Dir,[Dx,Dy,Dz]):-
	Dx1 is Dir*(X2 - X1),
	Dy1 is Dir*(Y2 - Y1),
	Dz1 is Dir*(Z2 - Z1),
	vec_normaliza([Dx1,Dy1,Dz1],[Dx,Dy,Dz]).
	
get_cylinder_2D_polygon([X1,Y1,Z1],[X2,Y2,Z2],Radius,[[P1x,P1y],[P2x,P2y],[P3x,P3y],[P4x,P4y]]):-
	get_cylinder_dir([X1,Y1,Z1],[X2,Y2,Z2],1,DirVector),
	vec_3D_cross_product(DirVector,[0,0,1],[RVx,RVy,_]),
	P1x is X1 + RVx * Radius,
	P1y is Y1 + RVy * Radius,
	P2x is X1 - RVx * Radius,
	P2y is Y1 - RVy * Radius,
	P3x is X2 + RVx * Radius,
	P3y is Y2 + RVy * Radius,
	P4x is X2 - RVx * Radius,
	P4y is Y2 - RVy * Radius.

% dist = Euclidean distance + (max_euclid/max_angular) * angular distance 

% dist(+ExampleID,+NdID1,+NdID2,+Coef,-D)
dist(ExampleID,NdID1,NdID2,Coef,D):-
	NdID1 =< NdID2,
	lemma(dist_mem(ExampleID,NdID1,NdID2,Coef,D)).
dist(ExampleID,NdID1,NdID2,Coef,D):-
	NdID1 > NdID2,
	lemma(dist_mem(ExampleID,NdID2,NdID1,Coef,D)).

:- dynamic dist_mem/5.
dist_mem(ExampleID,NdID1,NdID2,Coef,D):-
	endpoint_euclid_dist(ExampleID,NdID1,NdID2,D1),
	lemma(endpoint_angular_dist_mem(ExampleID,NdID1,NdID2,D2)),
	D is D1 + Coef*D2.

:- dynamic adj/3.

% adj(+ExampleID,+NdID1,-NdID2).
adj(ExampleID,NdID1,NdID2):-
	tube_edge(ExampleID,NdID1,NdID2).
adj(ExampleID,NdID1,NdID2):-
	tube_edge(ExampleID,NdID2,NdID1).

% dfs(+ExampleID,-Dest,+VisitedList,-Path).
dfs(_,Nd,[Nd|T],[Nd|T]).
dfs(ExampleID,Nd,[Na|T],Path):-
	adj(ExampleID,Na,Nb),
	\+member(Nb,[Na|T]),
	dfs(ExampleID,Nd,[Nb,Na|T],Path).

% tube_length_aux(+ExampleID,+VisitedNodes,+Acc,-Len).
tube_length_aux(ExampleID,[Na|T],Acc,Len):-
	adj(ExampleID,Na,Nb),
	\+member(Nb,[Na|T]),
	!,
	endpoint_euclid_dist(ExampleID,Na,Nb,D),
	Acc1 is Acc + D,
	tube_length_aux(ExampleID,[Nb,Na|T],Acc1,Len).
tube_length_aux(_,_,Len,Len).

cylinder_length(ExampleID,NodeID1,Length):-
	lemma(cylinder_length_mem(ExampleID,NodeID1,Length)).
	
:- dynamic cylinder_length_mem/3.
cylinder_length_mem(ExampleID,NodeID1,Length):-
	adj(ExampleID,NodeID1,NodeID2),
	endpoint_euclid_dist(ExampleID,NodeID1,NodeID2,Length).

% to test the helper predicates
example(a,[node(1,0,0,0),node(2,0.2,0,0),node(3,0.4,0,0),node(4,0.6,0,0),node(5,0.8,0,0),node(6,1.0,0,0)],[1-2,3-4,5-6],1,0.0125,1.0).
example(b,[node(1,0,0,0),node(2,0.2,0,0),node(3,0.4,0,0),node(4,0.6,0,0),node(5,0.8,0,0),node(6,1.0,0,0)],[1-2,2-3,3-4,4-5,5-6],1,0.0125,1.0).
example(c,[node(1,0,0,0),node(2,0.1,0,0),node(3,0.2,0.1,0),node(4,0.2,0.3,0)],[1-2,3-4],1,0.0125,0.3).
example(d,[node(1,0,0,0),node(2,0.1,0,0),node(3,0.2,0.1,0),node(4,0.3,0.2,0)],[1-2,3-4],1,0.0125,0.3).
% is_connected_twice(b,2).
% are_connected(b,1,N).
% tube_length(b,1,Len).